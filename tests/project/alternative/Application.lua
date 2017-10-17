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
		local emasDir = Directory("project-alternative-app")
		local proj = File("myproject.tview")

		if emasDir:exists() then emasDir:delete() end
		proj:deleteIfExists()

		local error_func = function()
			Application{
				project = proj,
				clean = true,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				progress = false,
				simplify = false,
				output = emasDir
			}
		end
		unitTest:assertError(error_func, "Project '"..proj.."' was not found.")

		error_func = function()
			Application{
				project = 1,
				clean = true,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				progress = false,
				simplify = false,
				output = emasDir
			}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("project", "Project", 1))

		local gis = getPackage("gis")

		local project = gis.Project{
			file = "emas.tview",
			clean = true,
			firebreak = filePath("emas-firebreak.shp", "gis"),
			river = filePath("emas-river.shp", "gis"),
			limit = filePath("emas-limit.shp", "gis")
		}

		gis.Layer{
			project = project,
			name = "cover",
			file = filePath("emas-accumulation.tif", "gis"),
			epsg = 29192
		}

		error_func = function()
			Application{
				project = "emas.tview",
				clean = true,
				select = "river",
				color = "BuGn",
				value = {0, 1, 2},
				progress = false,
				simplify = false,
				output = emasDir
			}
		end
		unitTest:assertError(error_func, "Publish cannot export yet raster layer 'cover'.")
		if emasDir:exists() then emasDir:delete() end
		File("emas.tview"):deleteIfExists()
	end
}
