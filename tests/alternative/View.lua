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
	View = function(unitTest)
		local error_func = function()
			View()
		end
		unitTest:assertError(error_func, tableArgumentMsg())

		error_func = function()
			View(1)
		end
		unitTest:assertError(error_func, namedArgumentsMsg())

		error_func = function()
			View{1, 2, 3}
		end
		unitTest:assertError(error_func, "All elements of the argument must be named.")

		error_func = function()
			View{arg = "void"}
		end
		unitTest:assertError(error_func, unnecessaryArgumentMsg("arg"))

		error_func = function()
			View{title = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("title", "string", 1))

		error_func = function()
			View{description = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("description", "string", 1))

		error_func = function()
			View{border = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("border", "string or table", 1))

		error_func = function()
			View{border = {}}
		end
		unitTest:assertError(error_func, "Argument 'border' must be a table with RGB, got an empty table.")

		error_func = function()
			View{width = "mwidth"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("width", "number", "mwidth"))

		error_func = function()
			View{width = 0}
		end
		unitTest:assertError(error_func, defaultValueMsg("width", 0))

		error_func = function()
			View{value = {0, 1, 2}, color = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("color", "string or table", 1))

		error_func = function()
			View{value = {0, 1, 2}, color = {}}
		end
		unitTest:assertError(error_func, "The number of colors (0) must be equal to number of data classes (3).")

		error_func = function()
			View{value = {0, 1, 2}, color = "mcolor"}
		end
		unitTest:assertError(error_func, "Argument 'color' (mcolor) is not a valid color name.")

		error_func = function()
			View{visible = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("visible", "boolean", 1))

		error_func = function()
			View{visible = true}
		end
		unitTest:assertError(error_func, defaultValueMsg("visible", true))

		error_func = function()
			View{select = 1}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("select", "string", 1))

		error_func = function()
			View{value = "mvalue"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("value", "table", "mvalue"))

		error_func = function()
			View{color = "red", value = {}}
		end
		unitTest:assertError(error_func, "Argument 'value' must be a table with size greater than 0, got 0.")
	end
}
