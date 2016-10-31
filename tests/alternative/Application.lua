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
		local emas = filePath("emas.tview", "terralib")
		local emasDir = Directory("EmasWebMap")

		local layout = Layout{
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		local error_func = function()
			Application()
		end
		unitTest:assertError(error_func, tableArgumentMsg())

		error_func = function()
			Application(1)
		end
		unitTest:assertError(error_func, namedArgumentsMsg())

		error_func = function()
			Application{
				arg = "void",
				clean = true,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				project = emas,
				layout = layout,
				output = emasDir
			}
		end
		unitTest:assertError(error_func, unnecessaryArgumentMsg("arg"))

		error_func = function()
			Application{
				package = "base",
				clean = true,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				progress = false,
				layout = layout,
				output = emasDir
			}
		end
		unitTest:assertError(error_func, "Package 'base' does not have any project.")

		local data = {
			layout = layout,
			clean = true,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir
		}

		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'project', 'layers' or 'package' is mandatory to publish your data.")

		data.project = emas
		data.value = nil
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("value"))

		data.value = {0, 1, 2}
		data.select = nil
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("select"))

		data.select = "river"
		data.color = nil
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' is mandatory to publish your data.")

		data.color = "BuGn"
		data.clean = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("clean", "boolean", 1))

		data.clean = true
		data.progress = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("progress", "boolean", 1))

		data.progress = false
		data.legend = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("legend", "string", 1))

		data.legend = "River values"
		data.layers = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("layers", "table", 1))

		data.layers = nil
		data.output = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("output", "Directory", 1))

		data.output = emasDir
		data.project = File("myproject.tview")
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Project '"..data.project.."' was not found.")

		data.project = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("project", "Project", 1))

		data.project = emas
		data.color = 123456
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("color", "string or table", 123456))

		data.color = "#afafah"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' (#afafah) is not a valid hex color.")

		data.color = "Redss"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' (Redss) is not a valid color name.")

		data.color = {"Reds", "Blues", "PuRd"}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "The number of data classes is mandatory for 'Reds' in ColorBrewer.")

		data.color = {1, 1, 1}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Each parameter of color must be a string or table, got 'number'.")

		data.color = {{-1, 1, 1}, {256, 255, 255}, {1, 1, 1, 2}}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Element '#1' in color '#1' must be an integer between 0 and 255, got -1.")

		data.color = {{0, 0, 0}, {1, 1, 1}, {255, 255, 255, 2}}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "The alpha parameter of color '#3' should be a number between 0.0 (fully transparent) and 1.0 (fully opaque), got 2.")

		data.color = {{0, 0, 0, 0.5}, {1, 1, 1, 1}, {255, 255, 255, 1.00001}}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "The alpha parameter of color '#3' should be a number between 0.0 (fully transparent) and 1.0 (fully opaque), got 1.00001.")

		data.color = {"#edf8fb", "#b2e2e2"}
		data.value = {}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'value' must be a table with size greater than 0, got 0.")

		data.value = {0, 1, 2}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "The number of colors (2) must be equal to number of data classes (3).")

		data.color = "BuGn"
		data.select = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("select", "string", 1))

		data.select = "river"
		data.loading = "square"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "'square' is an invalid value for argument 'loading'. Do you mean 'squares'?")

		data.loading = "x"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "'x' is an invalid value for argument 'loading'. It must be a string from the"
			.." set ['balls', 'box', 'default', 'ellipsis', 'hourglass', 'poi', 'reload', 'ring', 'ring-alt', 'ripple',"
			.." 'rolling', 'spin', 'squares', 'triangle', 'wheel'].")

		data.loading = "squares"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Publish cannot export yet raster layer 'cover'")

		data.layers = {"cover"}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Publish cannot export yet raster layer 'cover'")
	end
}

