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
	Layout = function(unitTest)
		local data = {
			title = "Testing Layout",
			description = "Base test",
			base = {"roadmap", "satellite", "hybrid", "terrain"},
			zoom = 10,
			minZoom = 5,
			maxZoom = 17,
			center = {lat = -23.179017, long = -45.889188}
		}

		local layout = Layout{
			title = data.title,
			description = data.description,
			zoom = data.zoom,
			minZoom = data.minZoom,
			maxZoom = data.maxZoom,
			center = data.center
		}

		unitTest:assertType(layout, "Layout")
		unitTest:assertEquals(layout.title, data.title)
		unitTest:assertEquals(layout.description, data.description)
		unitTest:assertEquals(layout.base, data.base[1])
		unitTest:assertEquals(layout.zoom, data.zoom)
		unitTest:assertEquals(layout.minZoom, data.minZoom)
		unitTest:assertEquals(layout.maxZoom, data.maxZoom)
		unitTest:assertEquals(layout.center.lat, data.center.lat)
		unitTest:assertEquals(layout.center.long, data.center.long)

		layout = Layout{
			base = data.base[2],
			center = data.center
		}

		unitTest:assertType(layout, "Layout")
		unitTest:assertEquals(layout.title, "Default")
		unitTest:assertEquals(layout.description, "")
		unitTest:assertEquals(layout.base, data.base[2])
		unitTest:assertEquals(layout.zoom, 12)
		unitTest:assertEquals(layout.minZoom, 0)
		unitTest:assertEquals(layout.maxZoom, 20)

		layout = Layout{
			base = data.base[3],
			center = data.center
		}

		unitTest:assertType(layout, "Layout")
		unitTest:assertEquals(layout.base, data.base[3])

		layout = Layout{
			base = data.base[4],
			center = data.center
		}

		unitTest:assertType(layout, "Layout")
		unitTest:assertEquals(layout.base, data.base[4])
	end,
	__tostring = function(unitTest)
		local layout = Layout{
			title = "Testing tostring",
			description = "Base test",
			base = "satellite",
			zoom = 10,
			minZoom = 5,
			maxZoom = 17,
			center = {lat = -23.179017, long = -45.889188}
		}

		unitTest:assertEquals(tostring(layout), [[base         string [satellite]
center       named table of size 2
description  string [Base test]
maxZoom      number [17]
minZoom      number [5]
title        string [Testing tostring]
zoom         number [10]
]])
	end
}
