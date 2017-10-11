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
		local emas = filePath("emas.tview", "publish")
		local emasDir = Directory("functional-alternative-tostring")

		if emasDir:exists() then emasDir:delete() end

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
				simplify = false,
				progress = false,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				project = emas,
				output = emasDir
			}
		end
		unitTest:assertWarning(error_func, unnecessaryArgumentMsg("arg"))

		if emasDir:exists() then emasDir:delete() end

		local data = {
			clean = true,
			simplify = false,
			select = "river",
			color = "BuGn",
			value = {0, 1, 2},
			progress = false,
			output = emasDir,
			title = "Emas",
			description = "Creates a database that can be used by the example fire-spread of base package.",
			zoom = 14,
			center = {lat = -18.106389, long = -52.927778}
		}

		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'project', 'package' or a View with argument 'layer' is mandatory to publish your data.")

		data.project = emas
		data.key = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("key", "string", 1))

		data.key = "AIzaSyCFXMRJlfDoDK7H"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'key' must be a string with size equals to 39, got 20.")

		data.key = nil
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
		data.output = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("output", "Directory", 1))

		data.output = emasDir
		data.color = 123456
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("color", "string or table", 123456))

		data.color = {"#afafah", "#afafah", "#afafah"}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' (#afafah) is not a valid hex color. Please run 'terrame -package publish -showdoc' for more details.")

		data.color = "Redss"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' (Redss) does not exist in ColorBrewer. Please run 'terrame -package publish -showdoc' for more details.")

		data.color = {"Reds", "Blues", "PuRd"}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' (Reds) is not a valid color name. Please run 'terrame -package publish -showdoc' for more details.")

		data.color = {true, true, true}
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'color' has an invalid description for color in position '#1'. It should be a string, number or table, got boolean.")

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

		data.loading = "xx"
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, "'xx' is an invalid value for argument 'loading'. It must be a string from the"
			.." set ['balls', 'box', 'default', 'ellipsis', 'hourglass', 'poi', 'reload', 'ring', 'ringAlt', 'ripple',"
			.." 'rolling', 'spin', 'squares', 'triangle', 'wheel'].")

		if emasDir:exists() then emasDir:delete() end

		local caraguaDir = Directory("CaraguaWebMap")
		if caraguaDir:exists() then caraguaDir:delete() end

		error_func = function()
			Application{
				project = filePath("caragua.tview", "publish"),
				clean = true,
				simplify = false,
				progress = false,
				output = caraguaDir,
				Limit = List{
					limit = View{
						color = "goldenrod",
					},
					regions = View{
						select = "name",
						color = "Set2"
					}
				},
				real = View{
					title = "Social Classes 2010",
					select = "classe",
					color = {"red", "orange", "yellow"},
					label = {"Condition C", "Condition B", "Condition A"}
				}
			}
		end
		unitTest:assertError(error_func, "The application must be created using only 'List', got 1 View(s).")

		if caraguaDir:exists() then caraguaDir:delete() end

		data.loading = nil
		data.simplify = 1
		error_func = function()
			Application(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("simplify", "boolean", 1))
		if emasDir:exists() then emasDir:delete() end

		local arapiunsDir = Directory("ArapiunsWebMap")
		if arapiunsDir:exists() then arapiunsDir:delete() end

		local file = File("arapiuns-test.tview")
		file:deleteIfExists()

		local warning_func = function()
			local gis = getPackage("gis")
			local proj = gis.Project{
				title = "The riverine settlements at Arapiuns (PA)",
				author = "Carneiro, H.",
				file = file,
				clean = true,
				villages = filePath("AllCmmTab_210316OK.shp", "publish")
			}

			Application{
				project = proj,
				output = arapiunsDir,
				simplify = true,
				villages = View{
					description = "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
				}
			}
		end
		unitTest:assertWarning(warning_func, defaultValueMsg("simplify", true))
		if arapiunsDir:exists() then arapiunsDir:delete() end
		file:deleteIfExists()
	end
}
