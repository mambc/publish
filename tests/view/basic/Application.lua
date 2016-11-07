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
		local emasDir = Directory("viewapp")
		if emasDir:exists() then emasDir:delete() end

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

		local layout = Layout{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		-- Testing Application: project = nil, layers = {firebreak_lin, accumulation_Nov94May00, River_lin, Limit_pol} and package = nil.
		local app = Application{
			layout = layout,
			clean = true,
			progress = false,
			output = emasDir,
			river = View{
				color = "blue",
				layer = filePath("River_lin.shp", "terralib")
			},
			firebreak = View{
				color = "black",
				layer = filePath("firebreak_lin.shp", "terralib")
			},
			limit = View{
				border = "blue",
				color = "goldenrod",
				width = 2,
				visible = true,
				layer = filePath("Limit_pol.shp", "terralib")
			},
			cells = View{
				title = "Emas National Park",
				select = "cover",
				color = "PuBu",
				width = 0,
				value = {0, 1, 2},
				layer = filePath("accumulation_Nov94May00.tif", "terralib")
			}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers) + 1) -- TODO #14. Raster layers are not counted.

		--assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(getn(app.view), getn(appData) + 1) -- TODO #14. Raster layers are not counted.

		if app.output:exists() then app.output:delete() end

		-- Testing Application: project = Project, view = {firebreak, river} and package = nil.
		local emas = filePath("emas.tview", "publish")
		appData = {
			["firebreak.geojson"] = true,
			["river.geojson"] = true
		}

		app = Application{
			project = emas,
			layout = layout,
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
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers) - 2)
		unitTest:assertEquals(getn(app.view), getn(appData))

		--assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)

		if app.output:exists() then app.output:delete() end
	end
}
