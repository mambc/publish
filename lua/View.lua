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

View_ = {
	type_ = "View"
}

metaTableView_ = {
	__index = View_,
	__tostring = _Gtme.tostring
}

function View(data)
	verifyNamedTable(data)
	optionalTableArgument(data, "title", "string")
	optionalTableArgument(data, "description", "string")
	optionalTableArgument(data, "value", "table")
	optionalTableArgument(data, "select", "string")

	defaultTableValue(data, "width", 0)
	defaultTableValue(data, "visible", true)

	verifyUnnecessaryArguments(data, {"title", "description", "border", "width", "color", "visible", "select", "value"})

	if data.color then
		mandatoryTableArgument(data, "value", "table")

		local classes = #data.value
		if classes <= 0 then
			customError("Argument 'value' must be a table with size greater than 0, got "..classes..".")
		end

		local ctype = type(data.color)
		if ctype == "string" then
			verifyColor(data.color, classes)
			data.color = color(data.color, classes)
		elseif ctype ~= "table" then
			incompatibleTypeError("color", "string or table", data.color)
		end

		local nColors = #data.color
		if classes ~= nColors then
			customError("The number of colors ("..nColors..") must be equal to number of data classes ("..classes..").")
		end

		local colors = {}
		for i = 1, classes do
			local rgba = data.color[i]
			verifyColor(rgba, nil, i)

			if type(rgba) == "table" then
				local a = rgba[4] or 1
				rgba = {
					property = data.value[i],
					rgba = string.format("rgba(%d, %d, %d, %g)", rgba[1], rgba[2], rgba[3], a)
				}
			end

			table.insert(colors, rgba)
		end

		data.color = colors
	end

	if data.border then
		local btype = type(data.border)
		if btype == "string" then
			verifyColor(data.border)
			data.border = color(data.border)
		elseif btype ~= "table" then
			incompatibleTypeError("border", "string or table", data.border)
		end

		local nColors = #data.border
		if nColors == 0 then
			customError("Argument 'border' must be a table with RGB, got an empty table.")
		end

		verifyColor(data.border, nil, 1)
	end

	setmetatable(data, metaTableView_)
	return data
end
