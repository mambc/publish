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
		local emasDir = Directory("view-alternative-app")
		if emasDir:exists() then emasDir:delete() end

		local error_func = function()
			Application{
				title = "Emas",
				description = "Creates a database that can be used by the example fire-spread of base package.",
				zoom = 14,
				center = {lat = -18.106389, long = -52.927778},
				project = filePath("emas.tview", "terralib"),
				clean = true,
				output = emasDir,
				cover = View{
					color = "green"
				}
			}
		end
		unitTest:assertError(error_func, "Publish cannot export yet raster layer 'cover'.")

		error_func = function()
			Application{
				title = "Emas",
				description = "Creates a database that can be used by the example fire-spread of base package.",
				zoom = 14,
				center = {lat = -18.106389, long = -52.927778},
				project = filePath("emas.tview", "terralib"),
				clean = true,
				output = emasDir,
				order = 1,
				cover = View{
					color = "green"
				}
			}
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("order", "table", 1))

		error_func = function()
			Application{
				title = "Emas",
				description = "Creates a database that can be used by the example fire-spread of base package.",
				zoom = 14,
				center = {lat = -18.106389, long = -52.927778},
				project = filePath("emas.tview", "publish"),
				clean = true,
				output = emasDir,
				order = {1},
				cover = View{
					color = "green"
				}
			}
		end
		unitTest:assertError(error_func, "All elements of 'order' must be a string. View '1' (1) got 'number'.")

		error_func = function()
			Application{
				title = "Emas",
				description = "Creates a database that can be used by the example fire-spread of base package.",
				zoom = 14,
				center = {lat = -18.106389, long = -52.927778},
				project = filePath("emas.tview", "publish"),
				clean = true,
				output = emasDir,
				order = {"cover", "cells"},
				cover = View{
					color = "green"
				}
			}
		end
		unitTest:assertError(error_func, "Argument 'order' must be a table with size greater > 0 and <= '1', got '2'.")

		error_func = function()
			Application{
				title = "Emas",
				description = "Creates a database that can be used by the example fire-spread of base package.",
				zoom = 14,
				center = {lat = -18.106389, long = -52.927778},
				project = filePath("emas.tview", "publish"),
				clean = true,
				output = emasDir,
				order = {"cove"},
				cover = View{
					color = "green"
				}
			}
		end
		unitTest:assertError(error_func, "View 'cove' in argument 'order' (1) does not exist.")
		if emasDir:exists() then emasDir:delete() end

		local arapiunsDir = Directory("ArapiunsWebMap")
		if arapiunsDir:exists() then arapiunsDir:delete() end

		error_func = function()
			Application{
				project = filePath("arapiuns.tview", "publish"),
				base = "roadmap",
				clean = true,
				output = arapiunsDir,
				villages = View{
					description = "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
					icon = {
						path = "M-20,0a20,20 0 1,0 40,0a20,20 0 1,0 -40,0",
						color = "red",
						transparency = 0.6
					},
					report = function() return 1 end
				}
			}
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("select"))

		error_func = function()
			Application{
				project = filePath("arapiuns.tview", "publish"),
				base = "roadmap",
				clean = true,
				output = arapiunsDir,
				villages = View{
					description = "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
					select = "Nome",
					icon = {
						path = "M-20,0a20,20 0 1,0 40,0a20,20 0 1,0 -40,0",
						color = "red",
						transparency = 0.6
					},
					report = function() return 1 end
				}
			}
		end
		unitTest:assertError(error_func, "Argument report of View 'villages' must be a function that returns a Report, got number.")

		if arapiunsDir:exists() then arapiunsDir:delete() end

		error_func = function()
			Application{
				project = filePath("emas.tview", "publish"),
				base = "roadmap",
				clean = true,
				output = emasDir,
				limit = View{
					icon = {path = "M-20,0a20,20 0 1,0 40,0a20,20 0 1,0 -40,0"}
				}
			}
		end
		unitTest:assertError(error_func, "Argument 'icon' of View must be used only with the following geometries: 'Point', 'MultiPoint', 'LineString' and 'MultiLineString'.")

		if emasDir:exists() then emasDir:delete() end
	end
}
