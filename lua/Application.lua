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

local printNormal = print
local printInfo = function (value)
	if sessionInfo().color then
		printNormal("\027[00;34m"..tostring(value).."\027[00m")
	else
		printNormal(value)
	end
end

-- Lustache is an implementation of the mustache template system in Lua (http://mustache.github.io/).
-- Copyright Lustache (https://github.com/Olivine-Labs/lustache).
local lustache = require "lustache"

local terralib = getPackage("terralib")

local SourceTypeMapper = {
	shp = "OGR",
	geojson = "OGR",
	tif = "GDAL",
	nc = "GDAL",
	asc = "GDAL",
	postgis = "POSTGIS",
	access = "ADO"
}

local Templates = {}
local templateDir = Directory(packageInfo("publish").path.."/template")

local ViewModel = {}
local function registerApplicationModel(data)
	mandatoryTableArgument(data, "input", "string")
	mandatoryTableArgument(data, "output", "string")
	verifyNamedTable(data.model)

	table.insert(ViewModel, data)
end

local function createDirectoryStructure(data)
	printInfo("Creating directory structure")
	if data.clean == true and data.output:exists() then
		data.output:delete()
	end

	if not data.output:exists() then
		data.output:create()
	end

	data.datasource = Directory(data.output.."data")
	if not data.datasource:exists() then
		data.datasource:create()
	end

	data.assets = Directory(data.output.."assets")
	if not data.assets:exists() then
		data.assets:create()
	end

	local depends = {"publish.css", "publish.js", "jquery-3.1.1.min.js", "loader/"..data.loading}
	if data.package then
		table.insert(depends, "package.js")
	end

	forEachElement(depends, function(_, file)
		printNormal("Copying dependency '"..file.."'")
		os.execute("cp \""..templateDir..file.."\" \""..data.assets.."\"")
	end)
end

local function isValidSource(source)
	return SourceTypeMapper[source] == "OGR" or SourceTypeMapper[source] == "POSTGIS"
end

local function exportLayers(data, sof)
	terralib.forEachLayer(data.project, function(layer, idx)
		if sof and not sof(layer, idx) then
			return
		end

		printNormal("Exporting layer '"..layer.name.."'")
		layer:export{
			file = data.datasource..layer.name..".geojson",
			srid = 4326,
			overwrite = true
		}
	end)
end

local function loadLayers(data)
	if data.project and not data.layers then
		printInfo("Loading layers from '"..data.project.file.."'")
		data.layers = {}
		exportLayers(data, function(layer)
			if not isValidSource(layer.source) then
				customWarning("Publish cannot export yet raster layer '"..layer.name.."'")
				return false
			end

			table.insert(data.layers, layer.name)
			return true
		end)
	elseif data.project and data.layers then
		printInfo("Loading layers from '"..data.project.file.."'")
		exportLayers(data, function(layer)
			local found = false
			forEachElement(data.layers, function(idx, mvalue)
				mvalue = tostring(mvalue)
				if mvalue == layer.name or mvalue == layer.file then
					if isValidSource(layer.source) then
						found = true
					else
						data.layers[idx] = nil
						customWarning("Publish cannot export yet raster layer '"..layer.name.."'")
					end

					return false
				end
			end)
			return found
		end)
	else
		printInfo("Loading layers from path")
		local mproj = {
			file = data.layout.title..".tview",
			clean = true
		}

		forEachElement(data.layers, function(_, file)
			if file:exists() and isValidSource(file:extension()) then
				local _, name = file:split()
				mproj[name] = tostring(file)
			end
		end)

		data.project = terralib.Project(mproj)
		exportLayers(data)

		data.project.file:deleteIfExists()
	end
end

local function createApplicationProjects(data, proj)
	printInfo("Loading Template")
	local index = "index.html"
	local config = "config.js"
	if proj then
		index = proj ..".html"
		config = proj ..".js"
	else
		proj = ""
	end

	registerApplicationModel {
		input = templateDir.."config.mustache",
		output = config,
		model = {
			center = data.layout.center,
			zoom = data.layout.zoom or "null",
			minZoom = data.layout.minZoom,
			maxZoom = data.layout.maxZoom,
			base = data.layout.base:upper(),
			path = proj,
			color = data.view.color,
			select = data.view.select,
			layers = data.layers,
			legend = data.legend,
			quotes = function(text, render)
				return "\""..render(text).."\""
			end
		}
	}

	registerApplicationModel {
		input = templateDir.."template.mustache",
		output = index,
		model = {
			config = config,
			title = data.layout.title,
			description = data.layout.description,
			layers = data.layers,
			loading = data.loading
		}
	}
end

local function createApplicationHome(data)
	printInfo("Loading Home Page")
	local index = "index.html"
	local config = "config.js"

	registerApplicationModel {
		input = templateDir.."pkgconfig.mustache",
		output = config,
		model = {
			center = data.layout.center,
			zoom = data.layout.zoom or "null",
			minZoom = data.layout.minZoom,
			maxZoom = data.layout.maxZoom,
			base = data.layout.base:upper(),
			legend = data.legend,
			projects = data.project,
			quotes = function(text, render)
				return "\""..render(text).."\""
			end
		}
	}

	registerApplicationModel {
		input = templateDir.."package.mustache",
		output = index,
		model = {
			config = config,
			package = data.package.package,
			description = data.package.content,
			projects = data.project,
			loading = data.loading
		}
	}
end

local function exportTemplates(data)
	forEachElement(ViewModel, function(_, mfile)
		local template = Templates[mfile.input]
		if not template then
			local fopen = File(mfile.input):open()
			Templates[mfile.input] = fopen:read("*all")
			fopen:close()

			template = Templates[mfile.input]
		end

		printNormal("Creating file '"..mfile.output.."'")
		local fwrite = File(data.output..mfile.output)
		fwrite:write(lustache:render(template, mfile.model))
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
-- @arg data.clean A boolean value indicating if the output directory could be automatically removed. The default value is false.
-- @arg data.layers A table of strings with the layers to be exported. As default, it will export all the available layers.
-- @arg data.layout A mandatory Layout.
-- @arg data.legend A string value with the layers legend. The default value is project title.
-- @arg data.output A mandatory base::Directory or directory name where the output will be stored.
-- @arg data.package A string with the package name. Uses automatically the .tview files of the package to create the application.
-- @arg data.progress A boolean value indicating if the progress should be shown. The default value is true.
-- @arg data.project A terralib::Project or string with the path to a .tview file.
-- @arg data.loading A optional string with the name of loading icon. The loading available are: "balls",
-- "box", "default", "ellipsis", "hourglass", "poi", "reload", "ring", "ringAlt", "ripple", "rolling", "spin",
-- "squares", "triangle", "wheel" (see http://loading.io/).
-- @usage import("publish")
-- local emas = filePath("emas.tview", "terralib")
-- local emasDir = Directory("EmasWebMap")
--
-- local layout = Layout{
--     title = "Emas",
--     description = "Creates a database that can be used by the example fire-spread of base package.",
--     zoom = 14,
--     center = {lat = -18.106389, long = -52.927778}
-- }
--
-- local app = Application{
--     project = emas,
--     layout = layout,
--     clean = true,
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
	verify(data.project or data.layers or data.package, "Argument 'project', 'layers' or 'package' is mandatory to publish your data.")
	verify(data.color, "Argument 'color' is mandatory to publish your data.")
	mandatoryTableArgument(data, "value", "table")
	mandatoryTableArgument(data, "select", "string")
	optionalTableArgument(data, "layout", "Layout")
	optionalTableArgument(data, "layers", "table")
	defaultTableValue(data, "clean", false)
	defaultTableValue(data, "progress", true)
	defaultTableValue(data, "legend", "Legend")
	defaultTableValue(data, "loading", "default")

	if type(data.output) == "string" then
		data.output = Directory(data.output)
	end

	mandatoryTableArgument(data, "output", "Directory")

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

	local view = {}
	forEachElement(data, function(_, mview)
		if type(mview) == "View" then
			table.insert(view, view)
		end
	end)

	if #view == 0 then
		local mview = {}
		forEachElement(data, function(idx, value)
			if belong(idx, {"border", "color", "description", "select", "title", "value", "visible", "width"}) then
				mview[idx] = value
				data[idx] = nil
			end
		end)

		view = View(mview)
	end

	verifyUnnecessaryArguments(data, {"project", "layers", "output", "clean", "layout", "legend", "progress", "package", "loading"})

	data.view = view

	if not data.progress then
		printNormal = function() end
		printInfo = function() end
	end

	if data.package then
		mandatoryTableArgument(data, "package", "string")
		optionalTableArgument(data, "project", "table")
		verify(not data.layers, unnecessaryArgumentMsg("layers"))
		data.package = packageInfo(data.package)
		data.layout = data.layout or Layout{title = data.package.package}

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

				proj = terralib.Project{file = file}
				if bbox then
					local abstractLayer = proj.layers[bbox]
					verify(abstractLayer, "Layer '"..bbox.."' does not exist in project '".. file .."'.")

					local layer = terralib.Layer{project = proj, name = abstractLayer:getTitle() }
					local source = layer.source
					verify(isValidSource(source), "Layer '"..bbox.."' must be OGR or POSTGIS, got '"..SourceTypeMapper[source].."'.")

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
					if not datasource:exists() then
						datasource:create()
					end

					local mdata = {project = proj, datasource = datasource}
					forEachElement(data, function(idx, value)
						if idx == "datasource" then
							return
						elseif idx == "project" then
							idx = "projects"
						end

						mdata[idx] = value
					end)

					loadLayers(mdata)
					createApplicationProjects(mdata, fname)
				end)

				createApplicationHome(data)
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
					data.project = terralib.Project{file = data.project}
				else
					customError("Project '"..data.project.."' was not found.")
				end
			end

			mandatoryTableArgument(data, "project", "Project")
		end

		data.layout = data.layout or Layout{title = data.project.file:name()}

		createDirectoryStructure(data)
		loadLayers(data)
		createApplicationProjects(data)
		exportTemplates(data)
	end

	setmetatable(data, metaTableApplication_)
	printInfo("Summing up, application '"..data.layout.title.."' was successfully created.")

	return data
end
