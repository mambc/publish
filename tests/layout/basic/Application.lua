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
		local emasDir = Directory("layout-basic-app")
		if emasDir:exists() then emasDir:delete() end

		local app = Application{
			project = filePath("emas.tview", "publish"),
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			title = "Testing Application Functional",
			description = "Basic Test"
		}

		unitTest:assertType(app, "Application")
		unitTest:assertEquals(app.title, "Testing Application Functional")
		unitTest:assertEquals(app.description, "Basic Test")
		unitTest:assertEquals(app.base, "satellite")
		unitTest:assertEquals(app.minZoom, 0)
		unitTest:assertEquals(app.maxZoom, 20)
		unitTest:assertNil(app.zoom)
		unitTest:assertNil(app.center)

		if emasDir:exists() then emasDir:delete() end

		app = Application{
			project = filePath("emas.tview", "publish"),
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			title = "Testing Application Functional",
			description = "Basic Test",
			base = "roadmap",
			zoom = 10,
			minZoom = 5,
			maxZoom = 17,
			center = {lat = -23.179017, long = -45.889188}
		}

		unitTest:assertType(app, "Application")
		unitTest:assertEquals(app.title, "Testing Application Functional")
		unitTest:assertEquals(app.description, "Basic Test")
		unitTest:assertEquals(app.base, "roadmap")
		unitTest:assertEquals(app.zoom, 10)
		unitTest:assertEquals(app.minZoom, 5)
		unitTest:assertEquals(app.maxZoom, 17)
		unitTest:assertEquals(app.center.lat, -23.179017)
		unitTest:assertEquals(app.center.long, -45.889188)
		unitTest:assertEquals(app.template.navbar, "#1ea789")
		unitTest:assertEquals(app.template.title, "white")

		if emasDir:exists() then emasDir:delete() end

		app = Application{
			project = filePath("emas.tview", "publish"),
			output = emasDir,
			template = {navbar = "#034871", title = "#F63B4C"},
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.template, "table")
		unitTest:assertEquals(app.template.navbar, "#034871")
		unitTest:assertEquals(app.template.title, "#F63B4C")

		if emasDir:exists() then emasDir:delete() end

		app = Application{
			project = filePath("emas.tview", "publish"),
			output = emasDir,
			template = {navbar = {3, 72, 113}, title = {246, 59, 76}},
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.template, "table")
		unitTest:assertEquals(app.template.navbar, "rgba(3, 72, 113, 1)")
		unitTest:assertEquals(app.template.title, "rgba(246, 59, 76, 1)")

		if emasDir:exists() then emasDir:delete() end

		app = Application{
			project = filePath("emas.tview", "publish"),
			output = emasDir,
			template = {navbar = "dodgerblue", title = "brown"},
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false
		}

		unitTest:assertType(app, "Application")
		unitTest:assertType(app.template, "table")
		unitTest:assertEquals(app.template.navbar, "dodgerblue")
		unitTest:assertEquals(app.template.title, "brown")

		if emasDir:exists() then emasDir:delete() end
	end
}
