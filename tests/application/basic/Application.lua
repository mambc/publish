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
		local emasDir = Directory("view-basic-app")

		local appRoot = {
			["index.html"] = true,
			["config.js"] = true
		}

		local appAssets = {
			["jquery-3.1.1.min.js"] = true,
			["publish.min.css"] = true,
			["publish.min.js"] = true,
			["default.gif"] = true
		}

		local appData = {
			["firebreak.geojson"] = true,
			["limit.geojson"] = true,
			["river.geojson"] = true
		}

		local function assertFiles(dir, files)
			local count = 0
			forEachFile(dir, function(file)
				unitTest:assert(files[file:name()])

				count = count + 1
			end)

			unitTest:assertEquals(count, getn(files))
		end

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = nil, layers = {firebreak_lin, accumulation_Nov94May00, River_lin, Limit_pol} and package = nil.
		local app = Application{
			title = "app",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778},
			clean = true,
			progress = false,
			output = emasDir,
			order = {"cells", "river", "firebreak", "limit"},
			river = View{
				color = "blue",
				layer = filePath("emas-river.shp", "terralib")
			},
			firebreak = View{
				color = "black",
				layer = filePath("emas-firebreak.shp", "terralib")
			},
			limit = View{
				border = "blue",
				color = "goldenrod",
				width = 2,
				visible = true,
				layer = filePath("emas-limit.shp", "terralib")
			},
			cells = View{
				title = "Emas National Park",
				select = "cover",
				color = "PuBu",
				width = 0,
				value = {0, 1, 2},
				layer = filePath("emas-accumulation.tif", "terralib")
			}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers) + 1) -- TODO #14. Raster layers are not counted.
		unitTest:assertEquals(getn(app.view), getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		unitTest:assertEquals(app.view.river.width, 1)
		unitTest:assertEquals(app.view.limit.width, 2)

		unitTest:assertEquals(app.view.river.visible, false)
		unitTest:assertEquals(app.view.limit.visible, true)

		unitTest:assertType(app.view.cells.color, "table")
		unitTest:assertEquals(app.view.cells.select, "cover")
		unitTest:assertEquals(app.view.cells.title, "Emas National Park")
		unitTest:assertEquals(app.view.cells.color["0"], "rgba(236, 231, 242, 1)")
		unitTest:assertEquals(app.view.cells.color["1"], "rgba(166, 189, 219, 1)")
		unitTest:assertEquals(app.view.cells.color["2"], "rgba(43, 140, 190, 1)")

		unitTest:assertEquals(app.view.cells.order, 4)
		unitTest:assertEquals(app.view.river.order, 3)
		unitTest:assertEquals(app.view.firebreak.order, 2)
		unitTest:assertEquals(app.view.limit.order, 1)

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = Project, view = {firebreak, river} and package = nil.
		appData = {
			["firebreak.geojson"] = true,
			["river.geojson"] = true
		}

		app = Application{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778},
			project = filePath("emas.tview", "publish"),
			clean = true,
			progress = false,
			output = emasDir,
			order = {"river"},
			river = View{
				color = "blue"
			},
			firebreak = View{
				color = "black"
			}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers) - 2)
		unitTest:assertEquals(getn(app.view), getn(appData))

		unitTest:assertEquals(app.view.river.order, 2)
		unitTest:assertEquals(app.view.firebreak.order, 1)

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)

		if emasDir:exists() then emasDir:delete() end

		app = Application{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			project = filePath("emas.tview", "publish"),
			clean = true,
			progress = false,
			output = emasDir,
			river = View{
				color = "blue"
			},
			firebreak = View{
				color = "black"
			}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(getn(app.view), getn(app.project.layers) - 2)

		unitTest:assertEquals(app.view.firebreak.order, 2)
		unitTest:assertEquals(app.view.river.order, 1)

		app = Application{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			project = filePath("emas.tview", "publish"),
			clean = true,
			progress = false,
			output = emasDir,
		}

		unitTest:assertEquals(app.view.cells.order, 4)
		unitTest:assertEquals(app.view.firebreak.order, 3)
		unitTest:assertEquals(app.view.limit.order, 2)
		unitTest:assertEquals(app.view.river.order, 1)

		if emasDir:exists() then emasDir:delete() end
	end
}
