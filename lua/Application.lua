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
-- Copyright Luastache (https://github.com/Olivine-Labs/lustache).
local function loadLuastache()
	local curr = Directory(currentDir())
	Directory(packageInfo("publish").path.."/lua/layout/lustache"):setCurrentDir()

	local lib = require "lustache"
	curr:setCurrentDir()

	return lib
end

local lustache = loadLuastache()

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

local function createDirectoryStructure(data)
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

	local layoutDir = Directory(packageInfo("publish").path.."/lua/layout")
	local depends = {"publish.css", "publish.js"}

	forEachElement(depends, function(_, file)
		os.execute("cp \"".. layoutDir ..file.."\" \""..data.output.."\"")
	end)
end

local function createWebPage(data)
	local fopen = File(packageInfo("publish").path.."/lua/layout/template.mustache"):open()
	local template = fopen:read("*all")
	fopen:close()

	local page = File(data.output.."index.html")
	page:write(lustache:render(template, data.layout))
	page:close()
end

local function exportData(data, sof)
	terralib.forEachLayer(data.project, function(layer, idx)
		if sof and not sof(layer, idx) then
			return
		end

		if SourceTypeMapper[layer.source] == "OGR" or SourceTypeMapper[layer.source] == "POSTGIS" then
			layer:export(data.datasource..layer.name..".geojson", true)
		end
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
-- @arg data.project A Project or string with the path to a .tview file.
-- @arg data.layers A table of strings with the layers to be exported. As default, it will export all the available layers.
-- @arg data.output A mandatory Directory or directory name where the output will be stored.
-- @arg data.clean A boolean value indicating if the output directory could be automatically removed. The default value is false.
-- @arg data.layout A mandatory Layout.
-- @usage import("publish")
-- local emas = filePath("emas.tview", "terralib")
-- local emasDir = Directory("EmasWebMap")
--
-- local layout = Layout{
--     title = "Emas",
--     description = "Creates a database that can be used by the example fire-spread of base package.",
--     base = "satellite",
--     zoom = 14,
--     center = {lat = -18.106389, long = -52.927778}
-- }
--
-- local app = Application{
--     project = emas,
--     layout = layout,
--     clean = true,
--     output = emasDir
-- }
--
-- print(app)
-- if emasDir:exists() then emasDir:delete() end
function Application(data)
	verifyNamedTable(data)
	verify(data.project or data.layers, "Argument 'project' or 'layers' is mandatory to publish your data.")
	optionalTableArgument(data, "layers", "table")
	defaultTableValue(data, "clean", false)
	verifyUnnecessaryArguments(data, {"project", "layers", "output", "clean", "layout"})

	if type(data.output) == "string" then
		data.output = Directory(data.output)
	end

	mandatoryTableArgument(data, "output", "Directory")

	if data.project then
		if type(data.project) == "string" then
			if File(data.project):exists() then
				data.project = terralib.Project{
					file = data.project
				}
			else
				customError("Project '"..data.project.."' was not found.")
			end
		end

		mandatoryTableArgument(data, "project", "Project")
	end

	createDirectoryStructure(data)

	if data.project and not data.layers then
		data.layers = {}
		exportData(data, function(layer)
			table.insert(data.layers, layer.file)
			return true
		end)
	elseif data.project and data.layers then
		exportData(data, function(layer)
			return belong(layer.name, data.layers)
		end)
	else
		local mproj = {
			file = data.layout.title..".tview",
			clean = true
		}

		forEachElement(data.layers, function(_, file)
			file = File(file)
			if file:exists() then
				mproj[file:name()] = tostring(file)
			end
		end)

		data.project = terralib.Project(mproj)
		exportData(data)

		File(data.project.file):deleteIfExists()
	end

	createWebPage(data)

	setmetatable(data, metaTableApplication_)
	return data
end