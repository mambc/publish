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
		local emasDir = Directory("package-basic-app-onetview")
		if emasDir:exists() then emasDir:delete() end

		local appRoot = {
			["index.html"] = true,
			["config.js"] = true
		}

		local appAssets = {
			["jquery-3.1.1.min.js"] = true,
			["publish.min.css"] = true,
			["publish.min.js"] = true,
			["default.gif"] = true,
			["package.min.js"] = true
		}

		local appData = {
			["cells.geojson"] = true,
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

		-- Testing Application: project = nil, package = "terralib" with 1 tview.
		local app = Application{
			package = "publish",
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers)) -- TODO #14. Raster layers are not counted.

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)
		assertFiles(app.datasource, appData)
		unitTest:assertEquals(getn(app.view), getn(appData))

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = nil, package = "terralib".
		emasDir = Directory("package-basic-app-manytview")
		if emasDir:exists() then emasDir:delete() end

		appRoot = {
			["index.html"] = true,
			["config.js"] = true,
			["cabecadeboi.html"] = true,
			["cabecadeboi.js"] = true,
			["emas.html"] = true,
			["emas.js"] = true,
			["fillCellExample.html"] = true,
			["fillCellExample.js"] = true
		}

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

		local mcustomWarning = customWarning --TODO #14. Raster layers stops with an error.
		customWarning = function() end

		app = Application{
			package = "terralib",
			project = {cabecadeboi = "box", emas = "limit", fillCellExample = "Setores"},
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.output, "Directory")
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)

		unitTest:assertType(app.project, "table")
		unitTest:assertEquals(getn(app.project), 3)
		unitTest:assertEquals(app.project[1].project, "cabecadeboi")
		unitTest:assertEquals(app.project[2].project, "emas")
		unitTest:assertEquals(app.project[3].project, "fillCellExample")
		unitTest:assertEquals(app.project[1].layer, "box")
		unitTest:assertEquals(app.project[2].layer, "limit")
		unitTest:assertEquals(app.project[3].layer, "Setores")

		assertFiles(app.output, appRoot)
		assertFiles(app.assets, appAssets)

		local countDir = 0
		local countFile = 0
		forEachDirectory(app.datasource, function(dir)
			local data = appData[dir:name()]
			forEachFile(dir, function(file)
				unitTest:assert(data[file:name()])
				countFile = countFile + 1
			end)

			countDir = countDir + 1
			unitTest:assertType(data, "table")
		end)

		unitTest:assertEquals(countDir, 3)
		unitTest:assertEquals(countFile, 9)

		if emasDir:exists() then emasDir:delete() end
		customWarning = mcustomWarning
	end
}
