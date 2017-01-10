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
		unitTest:assertError(error_func, "Argument 'border' must be a table with 3 or 4 arguments (red, green, blue and alpha), got 0.")

		error_func = function()
			View{width = "mwidth"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("width", "number", "mwidth"))

		error_func = function()
			View{width = 1}
		end
		unitTest:assertError(error_func, defaultValueMsg("width", 1))

		error_func = function()
			View{value = {1, 2, 3}, color = {"red", "orange", "yellow"}}
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("select"))

		error_func = function()
			View{value = {0, 1, 2}, color = 1, select = "river"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("color", "string or table", 1))

		error_func = function()
			View{value = {0, 1, 2}, color = {}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' must be a table with 3 or 4 arguments (red, green, blue and alpha), got 0.")

		error_func = function()
			View{value = {0, 1, 2}, color = {"red", "orange", "yellow"}, select = "classe", label = {}}
		end
		unitTest:assertError(error_func, "Argument 'label' must be a table of strings with size greater than 0, got 0.")

		error_func = function()
			View{value = {0, 1, 2}, color = {"red", "orange", "yellow"}, select = "classe", label = {1}}
		end
		unitTest:assertError(error_func, "The number of labels (1) must be equal to number of data classes (3).")

		error_func = function()
			View{value = {0, 1, 2}, color = {"red", "orange", "yellow"}, select = "classe", label = {"Condition C", true, 2}}
		end
		unitTest:assertError(error_func, "Argument 'label' must be a table of strings, element 2 (true) got boolean.")

		error_func = function()
			View{value = {0, 1, 2}, color = "mcolor", select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' (mcolor) does not exist in ColorBrewer. Please run 'terrame -package publish -showdoc' for more details.")

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
			View{value = "mvalue", select = "river"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("value", "table", "mvalue"))

		error_func = function()
			View{report = "myreport"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("report", "Report", "myreport"))

		error_func = function()
			View{border = "PuBu"}
		end
		unitTest:assertError(error_func, "Argument 'border' (PuBu) is not a valid color name. Please run 'terrame -package publish -showdoc' for more details.")

		error_func = function()
			View{color = "red", value = {}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'value' must be a table with size greater than 0, got 0.")

		error_func = function()
			View{color = {"#afafah", "#afafah", "#afafah"}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' (#afafah) is not a valid hex color. Please run 'terrame -package publish -showdoc' for more details.")

		error_func = function()
			View{color = "Redss", value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' (Redss) does not exist in ColorBrewer. Please run 'terrame -package publish -showdoc' for more details.")

		error_func = function()
			View{color = {"Reds", "Blues", "PuRd"}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' (Reds) is not a valid color name. Please run 'terrame -package publish -showdoc' for more details.")

		error_func = function()
			View{color = {"Reds", "Blues", "PuRd"}}
		end
		unitTest:assertError(error_func, "Argument 'color' (Reds) is not a valid color name. Please run 'terrame -package publish -showdoc' for more details.")

		error_func = function()
			View{color = {true, true, true}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "Argument 'color' has an invalid description for color in position '#1'. It should be a string, number or table, got boolean.")

		error_func = function()
			View{color = {{-1, 1, 1}, {256, 255, 255}, {1, 1, 1, 2}}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "Element '#1' in color '#1' must be an integer between 0 and 255, got -1.")

		error_func = function()
			View{color = {{0, 0, 0}, {1, 1, 1}, {255, 255, 255, 2}}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "The alpha parameter of color '#3' should be a number between 0.0 (fully transparent) and 1.0 (fully opaque), got 2.")

		error_func = function()
			View{color = {{0, 0, 0, 0.5}, {1, 1, 1, 1}, {255, 255, 255, 1.00001}}, value = {1, 2, 3}, select = "river"}
		end
		unitTest:assertError(error_func, "The alpha parameter of color '#3' should be a number between 0.0 (fully transparent) and 1.0 (fully opaque), got 1.00001.")

		error_func = function()
			View{color = {"red", "blue"}, value = {1}, select = "river"}
		end
		unitTest:assertError(error_func, "The number of colors (2) must be equal to number of data classes (1).")

		error_func = function()
			View{color = "red", transparency = "a"}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("transparency", "number", "a"))

		error_func = function()
			View{color = "red", transparency = 0}
		end
		unitTest:assertError(error_func, defaultValueMsg("transparency", 0))

		error_func = function()
			View{color = "red", transparency = -1}
		end
		unitTest:assertError(error_func, "Argument 'transparency' should be a number between 0.0 (fully opaque) and 1.0 (fully transparent), got -1.")

		error_func = function()
			View{color = "red", transparency = 1.1}
		end
		unitTest:assertError(error_func, "Argument 'transparency' should be a number between 0.0 (fully opaque) and 1.0 (fully transparent), got 1.1.")
	end
}
