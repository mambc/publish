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
	Report = function(unitTest)
		local report = Report()
		unitTest:assertType(report, "Report")
		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(#report.image, 0)

		local image = packageInfo("publish").path.."images/urbis_2010_real.PNG"
		report = Report{
			title = "My Report",
			text = "Some text",
			image = image
		}

		unitTest:assertType(report, "Report")
		unitTest:assertEquals(report.title, "My Report")
		unitTest:assertEquals(report.text[1], "Some text")
		unitTest:assertEquals(tostring(report.image[1]), image)
	end,
	addImage = function(unitTest)
		local report = Report()

		unitTest:assertType(report, "Report")
		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(#report.image, 0)

		report:addImage("urbis_2010_real.PNG", "publish")

		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(#report.image, 1)
		unitTest:assertEquals(tostring(report.image[1]), packageInfo("publish").path.."images/urbis_2010_real.PNG")
	end,
	addSeparator = function(unitTest)
		local report = Report()

		unitTest:assertType(report, "Report")
		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(#report.image, 0)
		unitTest:assertEquals(#report.separator, 0)

		report:addSeparator()

		unitTest:assertEquals(#report.separator, 1)
		unitTest:assertEquals(report.separator[1], 1)

		report:addText("My text 1")
		report:addText("My text 2")
		report:addSeparator()

		unitTest:assertEquals(#report.separator, 2)
		unitTest:assertEquals(#report.text, 2)
		unitTest:assertEquals(report.separator[1], 1)
		unitTest:assertEquals(report.separator[2], 3)
	end,
	addText = function(unitTest)
		local report = Report()
		local text = "This is the main endogenous variable of the model."

		unitTest:assertType(report, "Report")
		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(#report.image, 0)

		report:addText(text)

		unitTest:assertEquals(#report.text, 1)
		unitTest:assertEquals(#report.image, 0)
		unitTest:assertEquals(report.text[1], text)
	end,
	setTitle = function(unitTest)
		local report = Report()

		unitTest:assertType(report, "Report")
		unitTest:assertNil(report.title)
		unitTest:assertEquals(#report.text, 0)

		report:setTitle("My title")

		unitTest:assertEquals(#report.text, 0)
		unitTest:assertEquals(report.title, "My title")
	end,
	__tostring = function(unitTest)
		local report = Report{
			title = "My Report",
			text = "Some text",
			image = packageInfo("publish").path.."images/urbis_2010_real.PNG"
		}

		unitTest:assertType(report, "Report")
		unitTest:assertEquals(tostring(report), [[image      vector of size 1
separator  vector of size 0
text       vector of size 1
title      string [My Report]
]])
	end
}
