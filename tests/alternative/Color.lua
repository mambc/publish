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
		local error_func = function()
			color("Reds", 1)
		end
		unitTest:assertError(error_func, "Argument classes must be >= 2 and <= 20, got '1'.")

		error_func = function()
			color("Reds", 21)
		end
		unitTest:assertError(error_func, "Argument classes must be >= 2 and <= 20, got '21'.")

		error_func = function()
			color("Reds", 2.5)
		end
		unitTest:assertError(error_func, "Argument classes must be an integer, got '2.5'.")
	end,
	verifyColor = function(unitTest)
		local error_func = function()
			verifyColor()
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("data"))

		error_func = function()
			verifyColor(1)
		end
		unitTest:assertError(error_func, "Each parameter of color must be a string or table, got 'number'.")

		error_func = function()
			verifyColor("123456")
		end
		unitTest:assertError(error_func, "Argument '123456' is not a valid color name.")

		error_func = function()
			verifyColor("#afafah")
		end
		unitTest:assertError(error_func, "Argument '#afafah' is not a valid hex color.")

		error_func = function()
			verifyColor("#123abce")
		end
		unitTest:assertError(error_func,"Argument '#123abce' is not a valid hex color.")

		error_func = function()
			verifyColor("aFaE3f")
		end
		unitTest:assertError(error_func, "Argument 'aFaE3f' is not a valid color name.")

		error_func = function()
			verifyColor("F00")
		end
		unitTest:assertError(error_func, "Argument 'F00' is not a valid color name.")

		error_func = function()
			verifyColor("#afaf")
		end
		unitTest:assertError(error_func, "Argument '#afaf' is not a valid hex color.")

		error_func = function()
			verifyColor("#F0h")
		end
		unitTest:assertError(error_func, "Argument '#F0h' is not a valid hex color.")

		error_func = function()
			verifyColor("Redss")
		end
		unitTest:assertError(error_func, "Argument 'Redss' is not a valid color name.")

		error_func = function()
			verifyColor("Dark", 10)
		end
		unitTest:assertError(error_func, "The number of data classes '10' not exist for color 'Dark' in ColorBrewer.")

		error_func = function()
			verifyColor("Dark")
		end
		unitTest:assertError(error_func, "The number of data classes is mandatory for 'Dark' in ColorBrewer.")

		error_func = function()
			verifyColor{1.5, 1, 1}
		end
		unitTest:assertError(error_func, "Element '1' must be an integer, got '1.5'.")

		error_func = function()
			verifyColor{-1, 1, 1}
		end
		unitTest:assertError(error_func, "Element '1' must be an integer between 0 and 255, got '-1'.")

		error_func = function()
			verifyColor{256, 255, 255}
		end
		unitTest:assertError(error_func, "Element '1' must be an integer between 0 and 255, got '256'.")

		error_func = function()
			verifyColor{1, 1, 1, 2}
		end
		unitTest:assertError(error_func, "The alpha parameter is a number between 0.0 (fully transparent) and 1.0 (fully opaque), got '2'.")

		error_func = function()
			verifyColor{1, 1, 1, 1, 1, 1}
		end
		unitTest:assertError(error_func, "Color must be a table with 3 or 4 arguments (red, green, blue and alpha), got '6'.")
	end
}

