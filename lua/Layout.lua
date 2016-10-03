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

function Layout(data)
	verifyNamedTable(data)
	mandatoryTableArgument(data, "center", "table") -- TODO #8
	mandatoryTableArgument(data.center, "lat", "number")
	mandatoryTableArgument(data.center, "long", "number")

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
		customError("Argument 'minZoom' should be less than 'maxZoom' ("..data.maxZoom..").")
	end

	verifyRange(data.center.lat, -90, 90, "Center 'lat' must be a number >= -90 and <= 90, got '"..data.center.lat.."'.")
	verifyRange(data.center.long, -180, 180, "Center 'long' must be a number >= -180 and <= 180, got '"..data.center.long.."'.")

	setmetatable(data, metaTableLayout_)
	return data
end

