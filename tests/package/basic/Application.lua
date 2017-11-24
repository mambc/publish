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
		local caragua = filePath("caragua.tview", "publish")
		local arapiuns = filePath("arapiuns.tview", "publish")
		local brazil = filePath("brazil.tview", "publish")
		local sp = filePath("sp.tview", "publish")
		local tmpdir = Directory{tmp = true}

		os.execute("mv \""..caragua.."\" \""..tmpdir.."\"")
		os.execute("mv \""..arapiuns.."\" \""..tmpdir.."\"")
		os.execute("mv \""..brazil.."\" \""..tmpdir.."\"")
		os.execute("mv \""..sp.."\" \""..tmpdir.."\"")
		caragua = File(tmpdir..caragua:name())
		arapiuns = File(tmpdir..arapiuns:name())
		brazil = File(tmpdir..brazil:name())
		sp = File(tmpdir..sp:name())

		local emasDir = Directory("package-basic-app-onetview")
		if emasDir:exists() then emasDir:delete() end

		local appRoot = {
			["index.html"] = true,
			["config.js"] = true,
			["jquery-3.1.1.min.js"] = true,
			["publish.min.css"] = true,
			["publish.min.js"] = true,
			["default.gif"] = true,
			["package.min.js"] = true,
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

		-- Testing Application: project = nil, package = "gis" with 1 tview.
		local app = Application{
			package = "publish",
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			simplify = false,
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
		unitTest:assert(app.clean)
		unitTest:assert(not app.progress)
		unitTest:assertEquals(getn(app.view), getn(app.project.layers)) -- TODO #14. Raster layers are not counted.

		assertFiles(app.output, appRoot)

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = nil, package = "gis".
		emasDir = Directory("package-basic-app-manytview")
		if emasDir:exists() then emasDir:delete() end

		local mcustomWarning = customWarning --TODO #14. Raster layers stops with an error.
		customWarning = function() end

		app = Application{
			package = "publish",
			project = {emas = "limit", arapiuns = "trajectory"},
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			simplify = false,
			output = emasDir,
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.clean)
		unitTest:assert(not app.progress)

		unitTest:assertType(app.project, "Project")

		--  It was a table in a previous version, because it is using more than a project. Verify it.

		--unitTest:assertEquals(getn(app.project), 3) -- SKIP
		--unitTest:assertEquals(app.project[1].project, "amazonia") -- SKIP
		--unitTest:assertEquals(app.project[2].project, "cabecadeboi") -- SKIP
		--unitTest:assertEquals(app.project[3].project, "emas") -- SKIP
		--unitTest:assertEquals(app.project[1].layer, "limit") -- SKIP
		--unitTest:assertEquals(app.project[2].layer, "box") -- SKIP
		--unitTest:assertEquals(app.project[3].layer, "limit") -- SKIP

		--assertFiles(app.output, appRoot) -- SKIP FIXME allow running this again
		assertFiles(app.assets, appRoot)

		if emasDir:exists() then emasDir:delete() end
		customWarning = mcustomWarning

		os.execute("mv \""..caragua.."\" \""..packageInfo("publish").data.."\"")
		os.execute("mv \""..arapiuns.."\" \""..packageInfo("publish").data.."\"")
		os.execute("mv \""..brazil.."\" \""..packageInfo("publish").data.."\"")
		os.execute("mv \""..sp.."\" \""..packageInfo("publish").data.."\"")
		tmpdir:delete()
	end
}
