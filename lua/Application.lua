-------------------------------------------------------------------------------------------
-- TerraME - a software platform for multiple scale spatially-explicit dynamic modeling.
-- Copyright (C) 2001-2016 INPE and TerraLAB/UFOP -- www.terrame.org

-- This code is part of the TerraME framework.
-- This framework is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.

-- You should have received a copy of the GNU Lesser General Public
-- License along with this library.

-- The authors reassure the license terms regarding the warranties.
-- They specifically disclaim any warranties, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular purpose.
-- The framework provided hereunder is on an "as is" basis, and the authors have no
-- obligation to provide maintenance, support, updates, enhancements, or modifications.
-- In no event shall INPE and TerraLAB / UFOP be held liable to any party for direct,
-- indirect, special, incidental, or consequential damages arising out of the use
-- of this software and its documentation.
--
-------------------------------------------------------------------------------------------

-- Lustache is an implementation of the mustache template system in Lua (http://mustache.github.io/).
-- Copyright Lustache (https://github.com/Olivine-Labs/lustache).
local lustache = require "lustache"

-- JSON (Javascript Object Notation - http://www.json.org) encoding / decoding module for Lua.
-- Copyright json4lua (https://github.com/craigmj/json4lua).
local json = require "json"

local gis = getPackage("gis")

local templateDir = Directory(packageInfo("publish").path.."/lib/template")
local Templates = {}
local ViewModel = {}

local SourceType = {
	OGR = "OGR",
	GDAL = "GDAL",
	POSTGIS = "POSTGIS"
}

local SourceTypeMapper = {
	shp = SourceType.OGR,
	geojson = SourceType.OGR,
	tif = SourceType.GDAL,
	nc = SourceType.GDAL,
	asc = SourceType.GDAL,
	postgis = SourceType.POSTGIS
}

local printNormal = print
local printInfo = function (value)
	if sessionInfo().color then
		printNormal("\027[00;34m"..tostring(value).."\027[00m")
	else
		printNormal(value)
	end
end

local function clone(tab, ignore)
	local isTable = isTable
	local copy = {}
	for k, v in pairs(tab) do
		if not (ignore and ignore[k]) then
			if isTable(v) then
				copy[k] = clone(v, ignore)
			else
				copy[k] = v
			end
		end
	end

	return copy
end

local function registerApplicationModel(data)
	mandatoryTableArgument(data, "output", "string")
	verifyNamedTable(data.model)

	table.insert(ViewModel, data)
end

local function exportReportImages(data, report)
	local reports = report:get()
	forEachElement(reports, function(_, rp)
		if not rp.image then return end

		local img = rp.image:name()
		if not data.images then
			data.images = data.output -- Directory(data.output.."images")
			if not data.images:exists() then
				data.images:create() -- SKIP
			end
		end

		if not isFile(data.images..img) then
			printNormal("Copying image '"..img.."'")
			os.execute("cp \""..tostring(rp.image).."\" \""..data.images.."\"")
		end

		rp.image = img
	end)

	return reports
end

local function createDirectoryStructure(data)
	printInfo("Creating directory structure")
	if data.clean == true and data.output:exists() then
		data.output:delete()
	end

	if not data.output:exists() then
		data.output:create()
	end

	data.datasource = data.output -- Directory(data.output.."data")
	if not data.datasource:exists() then
		data.datasource:create()
	end

	data.assets = data.output -- Directory(data.output.."assets")
	if not data.assets:exists() then
		data.assets:create() -- SKIP
	end

	local depends = {"model/dist/publish.min.css", "model/dist/publish.min.js", "model/src/assets/jquery-3.1.1.min.js", "loader/"..data.loading}
	if data.package then
		table.insert(depends, "model/dist/package.min.js")
	end

	if data.logo then
		table.insert(depends, data.logo)
	end

	forEachElement(depends, function(_, file)
		printNormal("Copying dependency '"..file.."'")
		local filepath = templateDir..file
		if type(file) == "File" then
			filepath = file
		end

		os.execute("cp \""..filepath.."\" \""..data.assets.."\"")
	end)

	if data.report then
		data.report = {title = data.report.title, author = data.report.author, reports = exportReportImages(data, data.report)}
	end
end

local function isValidSource(source)
	local typeMapped = SourceTypeMapper[source]
	return typeMapped == SourceType.OGR or typeMapped == SourceType.POSTGIS or typeMapped == SourceType.GDAL
end

local function getReducedNames(properties, select)
		local map = {}
		if select then
			local set = {}
			local step = 1
			local names = getNames(properties)
			for _, name in ipairs(names) do
				if belong(name, select) then
					local char = name:lower():sub(step, step)
					local prefix = (set[char] or 0) + step

					set[char] = prefix
					if step == prefix then
						prefix = ""
					end

					map[name] = char..prefix
				end
			end
		end

		return map
end

local function reduceCoordinates(coordinates, decimalFormat)
	for idx, coordinate in ipairs(coordinates) do
		if type(coordinate) == "table" then
			reduceCoordinates(coordinate, decimalFormat)
		else
			coordinates[idx] = tonumber(string.format(decimalFormat, coordinate))
		end
	end
end


local function getPropertiesWithReducedNames(propertiesMap, properties, select)
	local newProperties = {}
	if select then
		for property, value in pairs(properties) do
			local prop = propertiesMap[property]
			if prop then
				newProperties[prop] = value
			end
		end
	end

	return newProperties
end


local function uglify(file, decimal, select)
	local fopen = file:open()
	local jsonData = json.decode(fopen:read("*all"))
	file:close()

	if select and type(select) == "string" then
		select = {select}
	end

	local decimalFormat = "%."..string.format("%sf", decimal)
	local propertiesMap
	for _, feature in ipairs(jsonData.features) do
		local properties = feature.properties
		local coordinates = feature.geometry.coordinates

		if not propertiesMap then
			propertiesMap = getReducedNames(properties, select)
		end

		feature.properties = getPropertiesWithReducedNames(propertiesMap, properties, select)
		reduceCoordinates(coordinates, decimalFormat)
	end

	return propertiesMap, json.encode(jsonData)
end

local function minify(strJson)
	local empty = ""
	local pattern = "[%s\r\n]+"
	return strJson:gsub(pattern, empty)
end

local function simplify(jsonPath, decimal, select)
	local file = File(jsonPath)
	local properties, strJson = uglify(file, decimal, select)
	strJson = minify(strJson)

	file = File(jsonPath)
	file:writeLine(strJson)
	file:close()

	return properties
end

local function setBoundsExtent(bounds, layer)
	local box = layer:box()
	if box.xMax > bounds.xMax then
		bounds.xMax = box.xMax
	end

	if box.xMin < bounds.xMin then
		bounds.xMin = box.xMin
	end

	if box.yMax > bounds.yMax then
		bounds.yMax = box.yMax
	end

	if box.yMin < bounds.yMin then
		bounds.yMin = box.yMin
	end
end

local function getZoomLevelFraction(bounds)
	local pi = math.pi
	local function latRad(lat)
		local sin = math.sin(lat * pi / 180)
		local radX2 = math.log((1 + sin) / (1 - sin)) / 2
		return math.max(math.min(radX2, pi), -pi) / 2
	end

	local ne = {lat = bounds.yMax, lng = bounds.xMax}
	local sw = {lat = bounds.yMin, lng = bounds.xMin}

	local latFraction = (latRad(ne.lat) - latRad(sw.lat)) / pi
	local lngFraction = (ne.lng - sw.lng) / 360
	return {
		xTile = 256,
		yTile = 256,
		latFraction = latFraction,
		longFraction = lngFraction
	}
end

local function exportBounds(data)
	local bounds = data.bounds

	if not data.center then
		data.center = {
			lat = (bounds.yMin + bounds.yMax) / 2,
			long = (bounds.xMin + bounds.xMax) / 2
		}
	end

	if not data.zoom then
		data.zoom = getZoomLevelFraction(bounds)
	end

	data.bounds = nil
end

local function layerPreProcessing(data)
	if not (data.center and data.zoom) then
		local huge = math.huge
		data.bounds = {xMax = -huge, xMin = huge, yMax = -huge, yMin = huge}
	end
end

local function layerPostProcessing(data, layer, jsonPath, isRaster)
	local mview = data.view[layer.name]
	if isRaster then
		mview.select = "value"
--		if mview.colorOriginal then
--			mview.color = mview.colorOriginal
--			mview.colorOriginal = nil
--		end
	end

	if data.simplify then
		printInfo("Simplifying layer'"..layer.name.."'")
		local properties = simplify(jsonPath, mview.decimal, mview.select)
		mview.properties = properties
	end

	if data.bounds then
		setBoundsExtent(data.bounds, layer)
	end
end

local function exportLayers(data, sof)
	layerPreProcessing(data)

	local mproj = {}
	local defaultEPSG = 4326
	local hasRaster = false
	gis.forEachLayer(data.project, function(layer, idx)
		local name = layer.name
		if (sof and not sof(layer, idx)) or not data.view[name] then
			return
		end

		local filePathWithoutExtension = data.datasource..name
		local jsonPath = filePathWithoutExtension..".geojson"
		local exportArgs = {file = jsonPath, epsg = defaultEPSG, overwrite = true }
		local isRaster = false

		printNormal("Exporting layer '"..name.."'")

		local layerExported
		if SourceTypeMapper[layer.source] == SourceType.GDAL then
			if layer.epsg == defaultEPSG then
				layer:polygonize{file = jsonPath, overwrite = true}
				layerExported = layer
			else
				local vectorPath = File(filePathWithoutExtension..".shp")
				layer:polygonize{file = vectorPath, overwrite = true}

				local tempFileProj = File(filePathWithoutExtension..".tview")
				local tempProj = gis.Project{file = tempFileProj}
				local tmpLayer = gis.Layer{
					project = tempProj,
					name = name,
					file = vectorPath
				}

				tmpLayer:export(exportArgs)
				layerExported = tmpLayer

				vectorPath:deleteIfExists()
				tempFileProj:deleteIfExists()
			end

			isRaster = true
			if not hasRaster then hasRaster = true end
		else
			layer:export(exportArgs)
			layerExported = layer
		end

		layerPostProcessing(data, layerExported, jsonPath, isRaster)
		mproj[name] = jsonPath
	end)

	if hasRaster then
		mproj.file = Directory{tmp = true}..data.project.title..".tview"
		mproj.clean = true
		data.project = gis.Project(mproj)
	end
end

local function loadViewValue(data, name, view)
	local mview = clone(view, {type_ = true, value = true, width = true, transparency = true, visible = true,
		report = true, download = true, decimal = true})
	mview.value = {}
	mview.report = view.report

	if view.width ~= 1 then
		mview.width = view.width
	end

	if view.transparency ~= 0 then
		mview.transparency = view.transparency
	end

	if view.visible == false then
		mview.visible = false
	end

	if view.download == true then
		mview.download = true
	end

	if view.decimal ~= 5 then
		mview.decimal = view.decimal
	end

	local select = view.select[2] or view.select

	do
		local set = {}
		local tlib = gis.TerraLib{}
		local dset = tlib.getDataSet(data.project, name)
		for i = 0, #dset do
			for k, v in pairs(dset[i]) do
				if k == select and not set[v] then
					if mview.slices and type(v) ~= "number" then
						customError("Selected element should be number, got "..type(v).." in row "..(i + 1)..".")
					end

					set[v] = true
				end
			end
		end

		local huge = math.huge
		local min = huge
		local max = -huge
		for v in pairs(set) do
			if mview.slices then
				if mview.min == nil or mview.max == nil then
					if min > v then
						min = v
					elseif max < v then
						max = v
					end
				end

				if mview.min and mview.min > v then
					customWarning("Value "..v.." out of range [min: "..mview.min.."] and will not be drawn.")
				end

				if mview.max and mview.max < v then
					customWarning("Value "..v.." out of range [max: "..mview.max.."] and will not be drawn.")
				end
			end

			table.insert(mview.value, v)
		end

		if mview.slices and mview.min == nil then mview.min = min end
		if mview.slices and mview.max == nil then mview.max = max end
	end

	table.sort(mview.value)
	data.view[name] = View(mview)
end

local function loadViews(data)
	local views = {}
	local groups = {}
	local nViews = 0
	local nGroups = 0
	local nGroupViews = 0
	forEachElement(data, function(idx, mview, mtype)
		if mtype == "View" then
			views[idx] = mview
			nViews = nViews + 1
			data[idx] = nil
		elseif mtype == "List" then
			nGroups = nGroups + 1

			forEachOrderedElement(mview.views, function(vname, iview)
				iview.group = idx
				if not groups[idx] then
					groups[idx] = vname
				else
					iview.visible = false
				end

				views[vname] = iview
				nGroupViews = nGroupViews + 1
				data[idx] = nil
			end)
		end
	end)

	if nGroups > 0 and nViews > 0 then
		if data.output:exists() then data.output:delete() end
		customError("The application must be created using only 'List', got "..nViews.." View(s).")
	end

	if nGroups > 0 then
		data.group = groups
		nViews = nGroupViews
	end

	data.view = views
	return nViews
end

local function loadLayers(data)
	local nView = loadViews(data)

	verifyUnnecessaryArguments(data, {"project", "package", "output", "clean", "legend", "progress", "loading", "key",
		"title", "description", "base", "zoom", "minZoom", "maxZoom", "center", "assets", "datasource", "view", "template",
		"border", "color", "select", "value", "visible", "width", "order", "report", "images", "group", "logo",
		"simplify", "fontSize"})

	if nView > 0 then
		if data.project then
			printInfo("Loading layers from '"..data.project.file:name().."'")
			exportLayers(data)
		else
			mandatoryTableArgument(data, "title", "string")

			printInfo("Loading layers from path")
			local tmpDir = Directory{tmp = true}
			local mproj = {
				file = tmpDir..data.title..".tview",
				clean = true
			}

			local nLayers = 0
			forEachElement(data.view, function(name, view)
				if view.layer and view.layer:exists() then
					if isValidSource(view.layer:extension()) then
						mproj[name] = tostring(view.layer)
					else
						data.view[name] = nil
					end

					nLayers = nLayers + 1
				end
			end)

			if nLayers == 0 then
				if data.output:exists() then data.output:delete() end
				customError("Application 'view' does not have any Layer.")
			end

			data.project = gis.Project(mproj)
			exportLayers(data)
		end
	else
		if data.project then
			printInfo("Loading layers from '"..data.project.file:name().."'")
			local mview = {}
			forEachElement(data, function(idx, value)
				if belong(idx, {"border", "color", "description", "select", "title", "value", "visible", "width"}) then
					mview[idx] = value
					if not (idx == "title" or idx == "description") then
						data[idx] = nil
					end
				end
			end)

			exportLayers(data, function(layer)
				data.view[layer.name] = View(clone(mview))
				nView = nView + 1
				return true
			end)
		else
			if data.output:exists() then data.output:delete() end
			customError("Argument 'project', 'package' or a View with argument 'layer' is mandatory to publish your data.")
		end
	end

	forEachElement(data.view, function(name, view)
		if not (view.color and not view.value and view.select) then return end
		loadViewValue(data, name, view)
	end)

	if data.order then
		local orderSize = #data.order
		if orderSize == 0 or orderSize > nView then
			if data.output:exists() then data.output:delete() end
			customError("Argument 'order' must be a table with size greater > 0 and <= '"..nView.."', got '"..orderSize.."'.")
		end

		forEachElement(data.order, function(order, layer, mtype)
			if mtype == "string" then
				local view = data.view[layer]
				if view then
					view.order = nView
					nView = nView - 1
				else
					if data.output:exists() then data.output:delete() end
					customError("View '"..layer.."' in argument 'order' ("..order..") does not exist.")
				end
			else
				if data.output:exists() then data.output:delete() end
				customError("All elements of 'order' must be a string. View '"..layer.."' ("..order..") got '"..mtype.."'.")
			end
		end)

		if nView > 0 then
			forEachOrderedElement(data.view, function(_, view)
				if not view.order then
					view.order = nView
					nView = nView - 1
				end
			end)
		end
	else
		forEachOrderedElement(data.view, function(_, view)
			view.order = nView
			nView = nView - 1
		end)
	end
end

local function processingView(data, layers, reports, name, view)
	view.id = name
	view.transparency = 1 - view.transparency
	local viewLabel = view.title
	if viewLabel == nil or viewLabel == "" then
		viewLabel = _Gtme.stringToLabel(name)
	end

	table.insert(layers, {
		order = view.order,
		layer = name,
		label = viewLabel
	})

	local dset
	do
		local tlib = gis.TerraLib{}
		dset = tlib.getDataSet(data.project, name)
		for i = 0, #dset do
			if view.geom then break end

			local geom = dset[i]["OGR_GEOMETRY"] or dset[i]["geom"]
			if geom then
				local subType = tlib.castGeomToSubtype(geom)
				view.geom = subType:getGeometryType()
			end
		end
	end

	if view.report then
		if type(view.report) == "Report" then
			table.insert(reports, {title = view.report.title, author = view.report.author, layer = view.report.layer, reports = exportReportImages(data, view.report)})
		else
			for i = 0, #dset do
				local cell = Cell(dset[i])
				local report = view.report(cell)
				if type(report) ~= "Report" then
					if data.output:exists() then data.output:delete() end
					customError("Argument report of View '"..name.."' must be a function that returns a Report, got "..type(report)..".")
				end

				local select = cell[view.select[1] or view.select]
				if select and type(select) == "string" then
					select = select:gsub("%s+", "")
				end

				table.insert(reports, {title = report.title, author = report.author, layer = name, select = select, reports = exportReportImages(data, report)})
			end
		end
	elseif data.report then
		local report = clone(data.report)
		report.layer = name
		table.insert(reports, report)
	end

	if view.icon then
		if not belong(view.geom, {"Point", "MultiPoint", "LineString", "MultiLineString"}) then
			if data.output:exists() then data.output:delete() end
			customError("Argument 'icon' of View must be used only with the following geometries: 'Point', 'MultiPoint', 'LineString' and 'MultiLineString'.")
		end

		local icon = {}
		local itype = type(view.icon)
		if itype == "string" then
			if (view.geom == "LineString" or view.geom == "MultiLineString") and not view.icon:match("[0-9]") then
				if data.output:exists() then data.output:delete() end
				customError("Argument 'icon' must be expressed using SVG path notation in Views with geometry: LineString and MultiLineString.")
			end

			view.icon = view.icon..".png"
			icon.path = view.icon
			os.execute("cp \""..templateDir.."markers/"..view.icon.."\" \""..data.assets.."\"")
		else
			if #view.icon > 0 then
				icon.options = {}
				local set = {}
				local label = view.label or {}
				local col = view.select[2] or view.select
				local nProp = 0
				for i = 0, #dset do
					local prop = dset[i][col]
					if not prop then
						if data.output:exists() then data.output:delete() end
						customError("Column '"..col.."' does not exist in View '"..name.."'.")
					end

					if not set[prop] then
						set[prop] = true
						nProp = nProp + 1
					end
				end

				local markers = view.icon
				local nMarkers = #markers
				if nProp ~= nMarkers then
					if data.output:exists() then data.output:delete() end
					customError("The number of 'icon:makers' ("..nMarkers..") must be equal to number of unique values in property '"..col.."' ("..nProp..") in View '"..name.."'.")
				end

				local ics = {
					airport = true,
					animal = true,
					bigcity = true,
					bus = true,
					car = true,
					caution = true,
					cycling = true,
					database = true,
					desert = true,
					diving = true,
					fillingstation = true,
					finish = true,
					fire = true,
					firstaid = true,
					fishing = true,
					flag = true,
					forest = true,
					harbor = true,
					helicopter = true,
					home = true,
					horseriding = true,
					hospital = true,
					lake = true,
					motorbike = true,
					mountains = true,
					radio = true,
					restaurant = true,
					river = true,
					road = true,
					shipwreck = true,
					thunderstorm = true
				}

				local properties = {}
				for prop in pairs(set) do
					table.insert(properties, prop)
				end

				table.sort(properties)

				local ltmp = {}
				local copy = {}
				for i, prop in pairs(properties) do
					local strprop = tostring(prop)
					local marker = tostring(markers[i])

					if not ics[marker] then
						switchInvalidArgument("icon:marker", marker, ics)
					end

					local mlabel = label[i]
					if not mlabel then
						mlabel = col.." "..strprop
					elseif type(mlabel) ~= "string" then
						incompatibleTypeError("label", "string", mlabel)
					end

					marker = marker..".png"
					copy[marker] = true

					ltmp[mlabel] = marker
					icon.options[strprop] = marker
				end

				for el in pairs(copy) do
					os.execute("cp \""..templateDir.."markers/"..el.."\" \""..data.assets.."\"")
				end

				view.label = ltmp
			else
				view.icon.transparency = 1 - view.icon.transparency
				icon.options = {
					path = view.icon.path,
					fillColor = view.icon.color,
					fillOpacity = view.icon.transparency,
					strokeWeight = 2
				}

				icon.time = 1000 / (200 / view.icon.time)
			end
		end

		view.icon = icon
	elseif view.geom == "LineString" or view.geom == "MultiLineString" then
		view.icon = {}
		view.icon.options = {
			path = "M150 0 L75 200 L225 200 Z",
			fillColor = "rgba(0, 0, 0, 1)",
			fillOpacity = 0.8,
			strokeWeight = 2
		}

		view.icon.time = 25
	end

	if view.download then
		local layer = gis.Layer{project = data.project, name = name}
		local source = layer.source
		if isValidSource(source) then
			local tmp = Directory(name)
			local file = File(layer.file)
			local _, filename = file:split()
			local zip = File(name..".zip")

			tmp:create()
			layer:export{file = tmp..filename..".shp", overwrite = true }
			os.execute("zip -qr \""..zip.."\" "..tmp:name())
			if tmp:exists() then tmp:delete() end

			if zip:exists() then
				printNormal("Data '"..filename.."' successfully zipped")
				os.execute("cp \""..zip.."\" \""..data.datasource.."\"")
			end

			zip:deleteIfExists()
		end
	end
end

local function createApplicationGroup(data, groups, layers)
	local mgroups = {}
	forEachElement(layers, function(_, el)
		local view = data.view[el.layer]
		if not mgroups[view.group] then
			mgroups[view.group] = {}
		end

		table.insert(mgroups[view.group], el)
	end)

	forEachElement(mgroups, function(gp, mlayers)
		table.insert(groups, {group = gp, lblGroup = _Gtme.stringToLabel(gp), layers = mlayers})
	end)

	table.sort (groups, function(k1, k2)
		return k1.group < k2.group
	end)
end

local function createApplicationProjects(data, proj)
	printInfo("Loading Template")
	local path = "./"
	local index = "index.html"
	local config = "config.js"

	if proj then
		index = proj..".html" -- SKIP
		config = proj..".js" -- SKIP
		path = path..proj.."/" -- SKIP
	end

	if data.logo then
		data.logo = data.logo:name()
	end

	local layers = {}
	local reports = {}
	for name, value in pairs(data.view) do
		processingView(data, layers, reports, name, value)
	end

	table.sort (layers, function(k1, k2)
		return k1.order > k2.order
	end)

	local groups = {}
	if data.group then
		createApplicationGroup(data, groups, layers)
	end

	local mview = clone(data.view, {type_ = true, value = true})
	forEachElement(mview, function(_, mdata)
		if mdata.report then
			mdata.report = type(mdata.report)
		elseif data.report then
			mdata.report = type(data.report)
		end

		if mdata.select and data.simplify then
			if type(mdata.select) == "string" then
				mdata.select = mdata.properties[mdata.select]
			else
				local select = {}
				for _, property in ipairs(mdata.select) do
					table.insert(select, mdata.properties[property])
				end

				mdata.select = select
			end

			mdata.properties = nil
		end
	end)

	if data.bounds then
		exportBounds(data)
	end

	registerApplicationModel {
		output = config,
		model = {
			center = data.center,
			zoom = data.zoom,
			minZoom = data.minZoom,
			maxZoom = data.maxZoom,
			mapTypeId = data.base:upper(),
			legend = data.legend,
			data = mview,
			path = path,
			group = data.group,
			fontSize = data.fontSize
		}
	}

	registerApplicationModel {
		input = templateDir.."template.mustache",
		output = index,
		model = {
			config = config,
			title = data.title,
			description = data.description,
			layers = layers,
			loading = data.loading,
			report = reports,
			key = data.key,
			navbarColor = data.template.navbar,
			titleColor = data.template.title,
			groups = groups,
			logo = data.logo
		}
	}
end

local function createApplicationHome(data)
	printInfo("Loading Home Page")
	local index = "index.html"
	local config = "config.js"

	local layers = {}
	for _, mproj in pairs(data.project) do
		layers[mproj.project] = mproj.layer -- SKIP
	end

	registerApplicationModel { -- SKIP
		output = config, -- SKIP
		model = { -- SKIP
			center = data.center, -- SKIP
			zoom = data.zoom, -- SKIP
			minZoom = data.minZoom, -- SKIP
			maxZoom = data.maxZoom, -- SKIP
			mapTypeId = data.base:upper(), -- SKIP
			legend = data.legend, -- SKIP
			data = layers -- SKIP
		}
	}

	registerApplicationModel { -- SKIP
		input = templateDir.."package.mustache", -- SKIP
		output = index, -- SKIP
		model = { -- SKIP
			config = config, -- SKIP
			package = data.package.package, -- SKIP
			description = data.package.content, -- SKIP
			projects = data.project, -- SKIP
			loading = data.loading, -- SKIP
			key = data.key, -- SKIP
			navbarColor = data.template.navbar, -- SKIP
			titleColor = data.template.title -- SKIP
		}
	}
end

local function exportTemplates(data)
	forEachElement(ViewModel, function(_, mfile)
		printNormal("Creating file '"..mfile.output.."'")
		local model
		local fwrite = File(data.output..mfile.output)

		if mfile.input then
			local template = Templates[mfile.input]
			if not template then
				local fopen = File(mfile.input):open()
				Templates[mfile.input] = fopen:read("*all")
				fopen:close()

				template = Templates[mfile.input]
			end

			model = lustache:render(template, mfile.model)
		else
			model = "var Publish = "..json.encode(mfile.model)..";"
		end

		fwrite:writeLine(model)
		fwrite:close()
	end)
end

Application_ = {
	type_ = "Application"
}

metaTableApplication_ = {
	__index = Application_,
	__tostring = _Gtme.tostring
}

--- Creates a web page to visualize the published data.
-- @arg data.clean An optional boolean value indicating if the output directory could be automatically removed. The default value is false.
-- @arg data.legend An optional value with the layers legend. The default value is 'Legend'.
-- @arg data.output A mandatory base::Directory or directory name where the output will be stored.
-- @arg data.package An optional string with the package name. Uses automatically the .tview files of the package to create the application.
-- @arg data.progress An optional boolean value indicating if the progress should be shown. The default value is true.
-- @arg data.simplify An optional boolean value indicating if the data should be simplified. The default value is true.
-- @arg data.project An optional gis::Project or string with the path to a .tview file.
-- @arg data.report An option Report with data information.
-- @arg data.title An optional string with the application's title. The title will be placed at the left top of the application page.
-- If Application is created from gis::Project the default value is project title.
-- @arg data.description An optional string with the application's description. It will be shown as a box that is shown in the beginning of the application and can be closed.
-- @arg data.base An optional string with the base map, that can be "roadmap", "satellite", "hybrid", or "terrain". The default value is "satellite".
-- @arg data.zoom An optional number with the initial zoom, ranging from 0 to 20. The default value is the center of the bounding box containing all geometries.
-- @arg data.minZoom An optional number with the minimum zoom allowed. The default value is 0.
-- @arg data.maxZoom An optional number with the maximum zoom allowed. The default value is 20.
-- @arg data.center An optional named table with two values, lat and long,
-- describing the initial central point of the application.
-- @arg data.logo An optional string with the logo file path. The logo is an image and the supported extensions are:
-- 'bmp', 'gif', 'jpeg', 'jpg', 'png', 'svg'.
-- @arg data.loading An optional string with the name of loading icon. The loading available are: "balls",
-- "box", "default", "ellipsis", "hourglass", "poi", "reload", "ring", "ringAlt", "ripple", "rolling", "spin",
-- "squares", "triangle", "wheel" (see http://loading.io/). The default value is "default".
-- @arg data.key An optional string with 39 characters describing the Google Maps key (see https://developers.google.com/maps/documentation/javascript/get-api-key).
-- The Google Maps API key monitors your Application's usage in the Google API Console.
-- This parameter is compulsory when the Application has at least 25,000 map loads per day, or when the Application will be installed on a server.
-- @arg data.template An optional named table with two string elements called navbar and
-- title to describe colors for the navigation bar and for the background of the upper part of the application, respectively.
-- @arg data.fontSize An optional number with the font size.
-- @usage import("publish")
--
-- local emas = filePath("emas.tview", "publish")
-- local emasDir = Directory("EmasWebMap")
--
-- local app = Application{
--     project = emas,
--     clean = true,
--     simplify = false,
--     select = "river",
--     color = "BuGn",
--     value = {0, 1, 2},
--     progress = false,
--     output = emasDir
-- }
--
-- print(app)
-- if emasDir:exists() then emasDir:delete() end
function Application(data)
	verifyNamedTable(data)

	optionalTableArgument(data, "value", "table")
	optionalTableArgument(data, "select", "string")
	optionalTableArgument(data, "center", "table")
	optionalTableArgument(data, "zoom", "number")
	optionalTableArgument(data, "order", "table")
	optionalTableArgument(data, "report", "Report")
	optionalTableArgument(data, "key", "string")
	optionalTableArgument(data, "template", "table")
	optionalTableArgument(data, "logo", "string")
	optionalTableArgument(data, "fontSize", "number")

	defaultTableValue(data, "clean", false)
	defaultTableValue(data, "progress", true)
	defaultTableValue(data, "simplify", true)
	defaultTableValue(data, "legend", "Legend")
	defaultTableValue(data, "loading", "default")
	defaultTableValue(data, "base", "satellite")
	defaultTableValue(data, "minZoom", 0)
	defaultTableValue(data, "maxZoom", 20)

	if type(data.output) == "string" then
		data.output = Directory(data.output)
	end

	mandatoryTableArgument(data, "output", "Directory")

	if data.center then
		verifyNamedTable(data.center)
		mandatoryTableArgument(data.center, "lat", "number")
		mandatoryTableArgument(data.center, "long", "number")
		verifyUnnecessaryArguments(data.center, {"lat", "long"})

		if data.center.lat < -90 or data.center.lat > 90 then
			customError("Center 'lat' must be a number >= -90 and <= 90, got '"..data.center.lat.."'.")
		end

		if data.center.long < -180 or data.center.long > 180 then
			customError("Center 'long' must be a number >= -180 and <= 180, got '"..data.center.long.."'.")
		end
	end

	if not belong(data.base, {"roadmap", "satellite", "hybrid", "terrain"}) then
		customError("Basemap '"..data.base.."' is not supported.")
	end

	if data.zoom and (data.zoom < 0 or data.zoom > 20) then
		customError("Argument 'zoom' must be a number >= 0 and <= 20, got '"..data.zoom.."'.")
	end

	if data.minZoom and (data.minZoom < 0 or data.minZoom > 20) then
		customError("Argument 'minZoom' must be a number >= 0 and <= 20, got '"..data.minZoom.."'.")
	end

	if data.maxZoom and (data.maxZoom < 0 or data.maxZoom > 20) then
		customError("Argument 'maxZoom' must be a number >= 0 and <= 20, got '"..data.maxZoom.."'.")
	end

	if data.minZoom > data.maxZoom then
		customError("Argument 'minZoom' ("..data.minZoom..") should be less than 'maxZoom' ("..data.maxZoom..").")
	end

	local icons = {
		balls = true,
		box = true,
		default = true,
		ellipsis = true,
		hourglass= true,
		poi = true,
		reload = true,
		ring = true,
		ringAlt = true,
		ripple = true,
		rolling = true,
		spin = true,
		squares = true,
		triangle = true,
		wheel = true
	}

	if not icons[data.loading] then
		switchInvalidArgument("loading", data.loading, icons)
	end

	data.loading = data.loading..".gif"

	if data.logo then
		data.logo = File(data.logo)
		if not data.logo:exists() then
			customError("Logo '"..data.logo.."' does not exist.")
		end

		local extension = data.logo:extension():lower()
		if not belong(extension, {"bmp", "gif", "jpeg", "jpg", "png", "svg"}) then
			customError("'"..extension.."' is an invalid extension for argument 'logo'. Valid extensions ['bmp', 'gif', 'jpeg', 'jpg', 'png', 'svg'].")
		end
	end

	if data.key then
		local len = data.key:len()
		if len ~= 39 then
			customError("Argument 'key' must be a string with size equals to 39, got "..len..".")
		end
	end

	if data.template then
		verifyNamedTable(data.template)
		verifyUnnecessaryArguments(data.template, {"navbar", "title"})

		if data.template.navbar then
			data.template.navbar = color{navbar = data.template.navbar}
		else
			customError("Argument 'template' should contain the field 'navbar'.")
		end

		if data.template.title then
			data.template.title = color{title = data.template.title}
		else
			customError("Argument 'template' should contain the field 'title'.")
		end
	else
		data.template = {navbar = "#1ea789", title = "white"}
	end

	if data.fontSize and data.fontSize <= 0 then
		customError("Argument 'fontSize' must be a number greater than 0, got "..data.fontSize..".")
	end

	if not data.progress then
		printNormal = function() end
		printInfo = function() end
	end

	if data.package then
		mandatoryTableArgument(data, "package", "string")
		optionalTableArgument(data, "project", "table")
		data.package = packageInfo(data.package)
		defaultTableValue(data, "title", data.package.package)

		printInfo("Creating application for package '"..data.package.package.."'")
		local nProj = 0
		local projects = {}
		forEachFile(data.package.data, function(file)
			if file:extension() == "tview" then
				local proj, bbox
				local _, name = file:split()
				if data.project then
					bbox = data.project[name]
					if not bbox then
						return
					end

					local mtype = type(bbox)
					verify(mtype == "string", "Each element of 'project' must be a string, '"..name.."' got type '"..mtype.."'.")
				end

				proj = gis.Project{file = file}
				if bbox then
					local abstractLayer = proj.layers[bbox]
					verify(abstractLayer, "Layer '"..bbox.."' does not exist in project '".. file .."'.")

					local layer = gis.Layer{project = proj, name = abstractLayer:getTitle()}
					local typeMapped = SourceTypeMapper[layer.source]
					verify(typeMapped == SourceType.OGR or typeMapped == SourceType.POSTGIS, "Layer '"..bbox.."' must be OGR or POSTGIS, got '"..typeMapped.."'.")

					data.project[name] = nil
					table.insert(data.project, {project = name, layer = bbox})
				end

				projects[name] = proj
				nProj = nProj + 1
			end
		end)

		if nProj == 0 then
			if data.output:exists() then data.output:delete() end
			customError("Package '"..data.package.package.."' does not have any project.")
		else
			createDirectoryStructure(data)

			if nProj == 1 then
				forEachElement(projects, function(_, proj)
					data.project = proj
					return false
				end)

				loadLayers(data)
				createApplicationProjects(data)
			else
				forEachElement(projects, function(fname, proj)
					local datasource = Directory(data.datasource..fname)
					if not datasource:exists() then -- SKIP
						datasource:create() -- SKIP
					end

					local mdata = {project = proj, datasource = datasource}
					forEachElement(data, function(idx, value)
						if idx == "datasource" then -- SKIP
							return
						elseif idx == "project" then
							idx = "projects" -- SKIP
						end

						mdata[idx] = value -- SKIP
					end)

					loadLayers(mdata) -- SKIP
					createApplicationProjects(mdata, fname) -- SKIP
				end)

				createApplicationHome(data) -- SKIP
			end

			exportTemplates(data)
		end
	else
		if data.project then
			local ptype = type(data.project)
			if ptype == "string" then
				data.project = File(data.project)
				ptype = type(data.project)
			end

			if ptype == "File" then
				if data.project:exists() then
					data.project = gis.Project{file = data.project}
				else
					customError("Project '"..data.project.."' was not found.")
				end
			end

			mandatoryTableArgument(data, "project", "Project")
		end

		createDirectoryStructure(data)
		loadLayers(data)

		defaultTableValue(data, "title", data.project.title)

		createApplicationProjects(data)
		exportTemplates(data)
	end

	setmetatable(data, metaTableApplication_)
	printInfo("Summing up, application '"..data.title.."' was successfully created.")

	return data
end
