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
		local gis = getPackage("gis")
		local service = "http://www.geoservicos.inde.gov.br:80/geoserver/ows"
		local map = "MPOG:BASE_SPI_pol"

		local projFile = File("wms.tview")
		local baseProject = {
			title = "WMS",
			author = "Carneiro, H.",
			file = projFile,
			clean = true
		}

		local function buildProject()
			projFile:deleteIfExists()
			return gis.Project(clone(baseProject))
		end

		local proj = buildProject()
		gis.Layer{
			project = proj,
			source = "wms",
			name = "wmsLayer",
			service = service,
			map = map
		}

		local wmsDir = Directory("WmsWebApp")
		if wmsDir:exists() then wmsDir:delete() end

		local warning_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {
						boundingbox = "#ffffff"
					},
					color = "#ffffff"
				}
			}
		end
		unitTest:assertWarning(warning_func, "Argument 'color' is unnecessary.")

		local error_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS."
				}
			}
		end
		unitTest:assertError(error_func, "Argument 'label' is mandatory.")

		error_func = function()
			local errorProj = buildProject()
			gis.Layer{
				project = errorProj,
				source = "wms",
				name = "wmsLayer",
				service = service,
				map = map,
				epsg = 5880
			}

			Application{
				project = errorProj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {
						boundingbox = "#ffffff"
					}
				}
			}
		end
		unitTest:assertError(error_func, "Layer 'wmsLayer' must be projected in EPSG:4326, got 'EPSG:5880'.")

		proj = buildProject()
		gis.Layer{
			project = proj,
			source = "wms",
			name = "wmsLayer",
			service = service,
			map = map
		}

		error_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {1, 2, 3}
				}
			}
		end
		unitTest:assertError(error_func, "Argument 'label' of view 'wmsLayer' must be a named table with the description and color.")

		error_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {}
				}
			}
		end
		unitTest:assertError(error_func, "Argument 'label' of view 'wmsLayer' must be a named table with the description and color.")

		error_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {
						boundingbox = "#ffffff"
					},
					download = true
				}
			}
		end
		unitTest:assertError(error_func, "WMS layer 'wmsLayer' does not support download.")

		error_func = function()
			Application{
				project = proj,
				output = wmsDir,
				clean = true,
				simplify = false,
				progress = false,
				wmsLayer = View {
					title = "WMS",
					description = "Loading a view from WMS.",
					label = {
						boundingbox = "#ffffff"
					},
					name = "anoCriacao",
					time = "creation"
				}
			}
		end
		unitTest:assertError(error_func, "Temporal View with mode 'creation' only support OGR data, got 'wms'.")

		projFile:deleteIfExists()
		if wmsDir:exists() then wmsDir:delete() end
	end
}
