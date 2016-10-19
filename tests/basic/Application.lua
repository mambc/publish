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

return {
	Application = function(unitTest)
		local terralib = getPackage("terralib")
		local emas = filePath("emas.tview", "terralib")
		local emasDir = Directory("EmasWebMap")

		local appRoot = {
			["assets"] = true,
			["data"] = true,
			["index.html"] = true,
			["config.js"] = true
		}

		local appAssets = {
			["colorbrewer.min.js"] = true,
			["publish.css"] = true,
			["publish.js"] = true
		}

		local appData = {
			["cells.geojson"] = true,
			["firebreak.geojson"] = true,
			["limit.geojson"] = true,
			["river.geojson"] = true
		}

		local function assertFiles(dir, files)
			local list = dir:list()
			forEachElement(list, function(_, file)
				unitTest:assert(files[file])
			end)

			unitTest:assertEquals(#list, getn(files))
		end

		local layout = Layout{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			base = "satellite",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		-- Testing Application: project = tview, layers = nil and package = nil.
		local app = Application{
			project = emas,
			layout = layout,
			clean = true,
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers))

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		-- Testing Application: project = Project, layers = nil and package = nil.
		local fname = File("emas-test.tview")
		fname:deleteIfExists()

		appData = {
			["firebreak.geojson"] = true,
			["limit.geojson"] = true,
			["river.geojson"] = true
		}

		emasDir = "EmasWebMap"
		emas = terralib.Project{
			file = tostring(fname),
			clean = true,
			author = "Carneiro, H.",
			title = "Emas database",
			firebreak = filePath("firebreak_lin.shp", "terralib"),
			cover = filePath("accumulation_Nov94May00.tif", "terralib"),
			river = filePath("River_lin.shp", "terralib"),
			limit = filePath("Limit_pol.shp", "terralib")
		}

		app = Application{
			project = emas,
			layout = layout,
			clean = true,
			color = {"#e5f5f9", "#99d8c9", "#2ca25f", "#e5f5f9", "#99d8c9", "#2ca25f"},
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers))

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		-- Testing Application: project = Project, layers = {firebreak, cover, river} and package = nil.
		appData = {
			["firebreak.geojson"] = true,
			["river.geojson"] = true
		}

		local layers = {"firebreak", "cover", "river"}
		app = Application{
			project = emas,
			layers = layers,
			layout = layout,
			clean = true,
			color = {{229, 245, 249}, {153, 216, 201}, {44, 162, 95}},
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers) - 1)

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		-- Testing Application: project = Project, layers = {firebreak_lin, accumulation_Nov94May00, River_lin} and package = nil.
		layers = {
			filePath("firebreak_lin.shp", "terralib"),
			filePath("accumulation_Nov94May00.tif", "terralib"),
			filePath("River_lin.shp", "terralib")
		}

		app = Application{
			project = emas,
			layers = layers,
			layout = layout,
			clean = true,
			color = {"aliceblue", "darkseagreen", "forestgreen"},
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers) - 1)

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		-- Testing Application: project = nil, layers = {firebreak_lin, accumulation_Nov94May00, River_lin, Limit_pol} and package = nil.
		appData = {
			["firebreak_lin.geojson"] = true,
			["Limit_pol.geojson"] = true,
			["River_lin.geojson"] = true
		}

		table.insert(layers, filePath("Limit_pol.shp", "terralib"))
		app = Application{
			layers = layers,
			layout = layout,
			clean = true,
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.layers, "table")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers))

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		if app.output:exists() then app.output:delete() end

		-- Testing Application: project = nil, layers = nil and package = "terralib" with 1 tview.
		appData = {
			["cells.geojson"] = true,
			["firebreak.geojson"] = true,
			["limit.geojson"] = true,
			["river.geojson"] = true
		}

		app = Application{
			package = "publish",
			layout = layout,
			clean = true,
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = "terralib-onetview"
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.layers, "table")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(#app.color, #app.value)
		unitTest:assertEquals(#app.layers, getn(app.project.layers))

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(#app.layers, getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		if app.output:exists() then app.output:delete() end
		fname:deleteIfExists()

		-- Testing Application: project = nil, layers = nil and package = "terralib".
		appData = {
			["cabecadeboi"] = {
				["box.geojson"] = true,
				["cells.geojson"] = true
			},
			["emas"] = {
				["cells.geojson"] = true,
				["firebreak.geojson"] = true,
				["limit.geojson"] = true,
				["river.geojson"] = true
			},
			["fillCellExample"] = {
				["Localidades.geojson"] = true,
				["Rodovias.geojson"] = true,
				["Setores.geojson"] = true
			}
		}

		app = Application{
			package = "terralib",
			layout = layout,
			clean = true,
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = "terralib-manytview"
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.output, "Directory")
		unitTest:assertNil(app.layers)
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)

		assertFiles(app.assets, appAssets)

		local countDir = 0
		local countFile = 0
		forEachElement(app.datasource:list(), function(_, dir)
			local data = appData[dir]
			forEachFile(app.datasource..dir, function(file)
				unitTest:assert(data[file])
				countFile = countFile + 1
			end)

			countDir = countDir + 1
			unitTest:assertType(data, "table")
		end)

		unitTest:assertEquals(countDir, 3)
		unitTest:assertEquals(countFile, 9)
		if app.output:exists() then app.output:delete() end
	end,
	__tostring = function(unitTest)
		local emas = filePath("emas.tview", "terralib")
		local emasDir = Directory("EmasWebMap")

		local layout = Layout{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			base = "satellite",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		local app = Application{
			project = emas,
			layout = layout,
			clean = true,
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(tostring(app), [[assets      Directory
classes     number [3]
clean       boolean [true]
color       vector of size 3
datasource  Directory
layers      vector of size 5
layout      Layout
legend      string [Legend]
output      Directory
progress    boolean [false]
project     Project
value       vector of size 3
]])

		if emasDir:exists() then emasDir:delete() end
	end
}

