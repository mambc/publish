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

local function verifyRange(value, min, max, errorMsg)
	if value < min or value > max then
		customError(errorMsg)
	end
end

Layout_ = {
	type_ = "Layout"
}

metaTableLayout_ = {
	__index = Layout_,
	__tostring = _Gtme.tostring
}

--- Creates a layout to be applying in the web map. This Layout allow users to change map properties, such as Zoom and Basemaps.
-- @arg data.title A string with the application's title.
-- The title will be placed at the center top of the application page.
-- @arg data.description A string with the application's description.
-- It will be shown as a box that is shown in the beginning of the application and can be closed.
-- @arg data.base A string with the base map, that can be "roadmap", "satellite", "hybrid", or "terrain". The default value is roadmap.
-- @arg data.zoom A number with the initial zoom, ranging from 0 to 20. The default value is 12.
-- @arg data.minZoom A number with the minimum zoom allowed. The default value is 0.
-- @arg data.maxZoom A number with the maximum zoom allowed. The default value is 20.
-- @arg data.center A mandatory named table with two values, lat and long,
-- describing the initial central point of the application.
-- @usage import("publish")
--
-- layout = Layout{
--     title = "INPE",
--     description = "Satellite image of São José dos Campos.",
--     base = "satellite",
--     zoom = 17,
--     center = {lat = -23.179017, long = -45.889188}
-- }
--
-- print(layout)
function Layout(data)
	verifyNamedTable(data)
	mandatoryTableArgument(data, "center", "table") -- TODO #8
	verifyNamedTable(data.center)
	mandatoryTableArgument(data.center, "lat", "number")
	mandatoryTableArgument(data.center, "long", "number")
	verifyUnnecessaryArguments(data.center, {"lat", "long"})

	verifyUnnecessaryArguments(data, {"title", "description", "base", "zoom", "minZoom", "maxZoom", "center"})

	defaultTableValue(data, "title", "Default")
	defaultTableValue(data, "description", "")
	defaultTableValue(data, "base", "roadmap")
	defaultTableValue(data, "zoom", 12) -- TODO #7
	defaultTableValue(data, "minZoom", 0)
	defaultTableValue(data, "maxZoom", 20)

	if not belong(data.base, {"roadmap", "satellite", "hybrid", "terrain"}) then
		customError("Basemap '"..data.base.."' is not supported.")
	end

	verifyRange(data.zoom, 0, 20, "Argument 'zoom' must be a number >= 0 and <= 20, got '"..data.zoom.."'.")
	verifyRange(data.minZoom, 0, 20, "Argument 'minZoom' must be a number >= 0 and <= 20, got '"..data.minZoom.."'.")
	verifyRange(data.maxZoom, 0, 20, "Argument 'maxZoom' must be a number >= 0 and <= 20, got '"..data.maxZoom.."'.")

	if data.minZoom > data.maxZoom then
		customError("Argument 'minZoom' ("..data.minZoom..") should be less than 'maxZoom' ("..data.maxZoom..").")
	end

	verifyRange(data.center.lat, -90, 90, "Center 'lat' must be a number >= -90 and <= 90, got '"..data.center.lat.."'.")
	verifyRange(data.center.long, -180, 180, "Center 'long' must be a number >= -180 and <= 180, got '"..data.center.long.."'.")

	setmetatable(data, metaTableLayout_)
	return data
end

