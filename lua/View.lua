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

local function getRGB(mcolor, classes, argument)
	local ctype = type(mcolor)
	if ctype == "string" then
		verifyColor(mcolor, classes)
		mcolor = color(mcolor, classes)
	elseif ctype ~= "table" then
		argument = argument or "color"
		incompatibleTypeError(argument, "string or table", mcolor)
	end

	return mcolor
end

local function getStrColor(rgb, pos, argument)
	verifyColor(rgb, nil, pos, argument)

	if type(rgb) == "string" then
		return rgb
	end

	local a = rgb[4] or 1
	return string.format("rgba(%d, %d, %d, %g)", rgb[1], rgb[2], rgb[3], a)
end

View_ = {
	type_ = "View"
}

metaTableView_ = {
	__index = View_,
	__tostring = _Gtme.tostring
}

--- View is an object that contains the information of the data to be visualized.
-- One Application is composed by a set of Views.
-- @arg data.select An optional string with the name of the attribute to be visualized.
-- @arg data.value An optional table with the possible values for the selected attributes. This argument is mandatory when using color.
-- @arg data.visible An optional boolean whether the layer is visible. Defaults to true.
-- @arg data.width An optional argument with the stroke width in pixels.
-- @arg data.border An optional string or table with the stroke color. Colors can be described as strings using
-- a color name, an RGB value (Ex. {0, 0, 0}), or a HEX value (see https://www.w3.org/wiki/CSS/Properties/color/keywords).
-- @arg data.color An optional table with the colors for the attributes. Colors can be described as strings using
-- a color name, an RGB value, a HEX value, or even as a string with a ColorBrewer format (see http://www.colorbrewer2.org).
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
--
-- local view = View{
--     title = "Emas National Park",
--     description = "A small example related to a fire spread model.",
--     border = "blue",
--     width = 2,
--     color = "PuBu",
--     select = "river",
--     value = {0, 1, 2}
-- }
--
-- print(vardump(view))
function View(data)
	verifyNamedTable(data)
	optionalTableArgument(data, "title", "string")
	optionalTableArgument(data, "description", "string")
	optionalTableArgument(data, "value", "table")
	optionalTableArgument(data, "select", "string")
	optionalTableArgument(data, "report", "Report")

	defaultTableValue(data, "width", 1)
	defaultTableValue(data, "visible", false)

	verifyUnnecessaryArguments(data, {"title", "description", "border", "width", "color", "visible", "select", "value", "layer", "report"})

	if data.color then
		if data.value then
			local classes = #data.value
			if classes <= 0 then
				customError("Argument 'value' must be a table with size greater than 0, got "..classes..".")
			end

			local color = getRGB(data.color, classes)
			local nColors = #color
			if classes ~= nColors then
				customError("The number of colors ("..nColors..") must be equal to number of data classes ("..classes..").")
			end

			local colors = {}
			for i = 1, classes do
				local rgb = color[i]
				colors[tostring(data.value[i])] = getStrColor(rgb, i)
			end

			data.color = colors
		else
			local rgb = getRGB(data.color)
			data.color = getStrColor(rgb, 1)
		end
	end

	if data.border then
		local rgb = getRGB(data.border, nil, "border")
		data.border = getStrColor(rgb, 1, "border")
	end

	if data.layer then
		if type(data.layer) == "string" then
			data.layer = File(data.layer)
		end

		mandatoryTableArgument(data, "layer", "File")
	end

	if data.report then
		local rp = data.report:get()
		data.report = {title = data.report.title, reports = rp}
	end

	setmetatable(data, metaTableView_)
	return data
end
