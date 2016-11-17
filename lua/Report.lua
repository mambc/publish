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

Report_ = {
	type_ = "Report",
	addImage = function(self, image, package)
		if type(image) == "string" then
			if package then
				if type(package) == "string" then
					image = packageInfo(package).path.."images/"..image
				else
					incompatibleTypeError(2, "string", package)
				end
			end

			image = File(image)
		end

		mandatoryArgument(1, "File", image)

		if image:exists() then
			local extension = image:extension():lower()
			if belong(extension, {"bmp", "gif", "jpeg", "jpg", "png", "svg"}) then
				table.insert(self.image, image)
			else
				customError("'"..extension.."' is an invalid extension for argument 'image'. Valid extensions ['bmp', 'gif', 'jpeg', 'jpg', 'png', 'svg'].")
			end
		else
			resourceNotFoundError("image", tostring(image))
		end
	end,
	--- Add a line in the report
	-- @usage import("publish")
	-- local report = Report()
	-- report:separator()
	addSeparator = function(self)
		table.insert(self.separator, #self.text + 1)
	end,
	addText = function(self, text)
		mandatoryArgument(1, "string", text)
		table.insert(self.text, text)
	end,
	setTitle = function(self, title)
		mandatoryArgument(1, "string", title)
		self.title = title
	end
}

metaTableReport_ = {
	__index = Report_,
	__tostring = _Gtme.tostring
}

--- Creates a page with data information.
-- @arg data.title An optional string with the name of the title of the report.
-- @arg data.text An optional string with the text to the report.
-- @arg data.image An optional string or File with the image of the report.
function Report(data)
	data = data or {}
	mandatoryArgument(1, "table", data)
	verifyUnnecessaryArguments(data, {"title", "text", "image"})
	optionalTableArgument(data, "title", "string")

	local mdata = {title = data.title, text = {}, image = {}, separator = {}}
	setmetatable(mdata, metaTableReport_)

	if data.text then
		mdata:addText(data.text)
	end

	if data.image then
		mdata:addImage(data.image)
	end

	return mdata
end
