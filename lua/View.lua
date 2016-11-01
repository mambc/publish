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

local function getRGB(arg, mcolor, classes)
	local ctype = type(mcolor)
	if ctype == "string" then
		verifyColor(mcolor, classes)
		mcolor = color(mcolor, classes)
	elseif ctype ~= "table" then
		incompatibleTypeError(arg, "string or table", mcolor)
	end

	return mcolor
end

View_ = {
	type_ = "View"
}

metaTableView_ = {
	__index = View_,
	__tostring = _Gtme.tostring
}

--- View is an object that contains the information of the data to be visualized, such as the values and colors.
-- One Application is composed by a set of Views.
-- @arg data.select An optional string with the name of the attribute to be visualized.
-- @arg data.value An optional table with the possible values for the selected attributes. This argument is mandatory when using color.
-- @arg data.visible An optional boolean whether the layer is visible. Defaults to true.
-- @arg data.width An optional argument with the stroke width in pixels. 
-- @arg data.border An optional string or table with the stroke color. Colors can be described as strings using
-- a color name, an RGB value (Ex. {0, 0, 0}), or a HEX value (see https://www.w3.org/wiki/CSS/Properties/color/keywords).
-- @arg data.color An optional table with the colors for the attributes. Colors can be described as strings using
-- a color name, an RGB value, a HEX value, or even as a string with a ColorBrewer format (see http://colorbrewer2.org/).
-- The colors available and the maximum number of slices for each of them are:
-- @tabular color
-- Name & Max \
-- Accent, Dark, Set2 & 7 \
-- Pastel2, Set1 & 8 \
-- Pastel1 & 9 \
-- PRGn, RdYlGn, Spectral & 10 \
-- BrBG, Paired, PiYG, PuOr, RdBu, RdGy, RdYlBu, Set3 & 11 \
-- BuGn, BuPu, OrRd, PuBu & 19 \
-- Blues, GnBu, Greens, Greys, Oranges, PuBuGn, PuRd, Purples, RdPu, Reds, YlGn, YlGnBu, YlOrBr, YlOrRd & 20 \
-- @usage import("publish")
-- local view = View{
--     title = "Emas National Park",
-- 	   description = "A small example related to a fire spread model.",
-- 	   border = "blue",
--     width = 2,
-- 	   color = "PuBu",
-- 	   visible = false,
-- 	   select = "river",
-- 	   value = {0, 1, 2}
-- }
--
-- print(vardump(view))
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

		data.color = getRGB("color", data.color, classes)
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
		local rgba = getRGB("border", data.border)

		verifyColor(rgba, nil, 1, "border")

		local a = rgba[4] or 1
		data.border = string.format("rgba(%d, %d, %d, %g)", rgba[1], rgba[2], rgba[3], a)
	end

	setmetatable(data, metaTableView_)
	return data
end
