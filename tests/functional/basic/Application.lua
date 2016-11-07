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
	__tostring = function(unitTest)
		local emas = filePath("emas.tview", "publish")
		local emasDir = Directory("functional-tostring")

		local layout = Layout{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		if emasDir:exists() then emasDir:delete() end

		local app = Application{
			project = tostring(emas),
			layout = layout,
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		unitTest:assertType(app, "Application")
		unitTest:assertEquals(app.clean, true)
		unitTest:assertEquals(app.progress, false)
		unitTest:assertEquals(tostring(app), [[assets      Directory
clean       boolean [true]
datasource  Directory
layout      Layout
legend      string [Legend]
loading     string [default.gif]
output      Directory
progress    boolean [false]
project     Project
view        named table of size 4
]])

		if emasDir:exists() then emasDir:delete() end
	end
}
