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
	color = function(unitTest)
		local mcolor = color("aqua")

		unitTest:assertType(mcolor, "table")
		unitTest:assertEquals(mcolor[1], 0)
		unitTest:assertEquals(mcolor[2], 255)
		unitTest:assertEquals(mcolor[3], 255)

		mcolor = color("aqua", 3)
		unitTest:assertType(mcolor, "table")
		unitTest:assertEquals(mcolor[1], 0)
		unitTest:assertEquals(mcolor[2], 255)
		unitTest:assertEquals(mcolor[3], 255)

		mcolor = color("Reds")
		unitTest:assertNil(mcolor)

		mcolor = color("Reds", 2)
		local brewer1 = mcolor[1]
		local brewer2 = mcolor[2]
		unitTest:assertType(mcolor, "table")
		unitTest:assertType(brewer1, "table")
		unitTest:assertType(brewer2, "table")
		unitTest:assertEquals(brewer1[1], 254)
		unitTest:assertEquals(brewer1[2], 224)
		unitTest:assertEquals(brewer1[3], 210)
		unitTest:assertEquals(brewer2[1], 222)
		unitTest:assertEquals(brewer2[2], 45)
		unitTest:assertEquals(brewer2[3], 38)
	end
}

