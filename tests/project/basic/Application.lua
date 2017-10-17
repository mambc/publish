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
		local gis = getPackage("gis")
		local emas = filePath("emas.tview", "publish")
		local emasDir = Directory("project-basic-app")

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = tview, package = nil.
		local app = Application{
			project = emas,
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.project, "Project")
		unitTest:assertType(app.output, "Directory")
		unitTest:assert(app.output:exists())
		unitTest:assert(app.clean)
		unitTest:assert(not app.progress)
		unitTest:assertEquals(app.title, "Emas database")
		-- unitTest:assertEquals(app.description, "A small example related to a fire spread model.") -- SKIP TODO Terrame/#1534
		unitTest:assertEquals(getn(app.view), getn(app.project.layers)) -- TODO #14. Raster layers are not counted.

		if emasDir:exists() then emasDir:delete() end

		-- Testing Application: project = Project, package = nil.
		local fname = File("emas-test.tview")
		fname:deleteIfExists()

		emas = gis.Project{
			file = tostring(fname),
			clean = true,
			author = "Carneiro, H.",
			title = "Emas database",
			firebreak = filePath("emas-firebreak.shp", "gis"),
			river = filePath("emas-river.shp", "gis"),
			limit = filePath("emas-limit.shp", "gis")
		}

		emasDir = "project-basic-app-stroutput"
		app = Application{
			project = emas,
			clean = true,
			select = "river",
			color = {"#e5f5f9", "#99d8c9", "#2ca25f"},
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
		unitTest:assert(app.clean)
		unitTest:assert(not app.progress)
		unitTest:assertEquals(app.title, "Emas")
		unitTest:assertEquals(app.description, "Creates a database that can be used by the example fire-spread of base package.")
		unitTest:assertEquals(getn(app.view), getn(app.project.layers)) -- TODO #14. Raster layers are not counted.

		fname:deleteIfExists()
		emasDir = Directory(emasDir)
		if emasDir:exists() then emasDir:delete() end
	end
}
