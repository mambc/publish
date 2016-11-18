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
	--- Add a new image to the report.
	-- @arg image A mandatory string or File with the image of the report.
	-- @arg package An optional string with the name of the package.
	-- @usage import("publish")
	-- local report = Report()
	-- report:addImage("urbis_2010_real.PNG", "publish")
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
				self.image[self.nextIdx_] = image
			else
				customError("'"..extension.."' is an invalid extension for argument 'image'. Valid extensions ['bmp', 'gif', 'jpeg', 'jpg', 'png', 'svg'].")
			end
		else
			resourceNotFoundError("image", tostring(image))
		end
	end,
	--- Add a line in the report.
	-- @usage import("publish")
	-- local report = Report()
	-- report:addSeparator()
	addSeparator = function(self)
		self.separator[self.nextIdx_] = true
	end,
	--- Add a new text to the report.
	-- @arg text A mandatory string with the text to the report.
	-- @usage import("publish")
	-- local report = Report()
	-- report:addText("My text")
	addText = function(self, text)
		mandatoryArgument(1, "string", text)
		self.text[self.nextIdx_] = text
	end,
	--- Return the report created.
	-- @usage import("publish")
	-- local report = Report()
	-- report:addText("My text")
	-- report:get()
	get = function(self)
		local template = {}
		for i = 1, self.nextIdx_ - 1 do
			table.insert(template, {text = self.text[i], separator = self.separator[i], image = self.image[i]})
		end

		return template
	end,
	--- Set the title of the report.
	-- @arg title A mandatory string with the name of the title of the report.
	-- @usage import("publish")
	-- local report = Report()
	-- report:setTitle("My title")
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
-- @usage import("publish")
-- local report = Report()
-- report:setTitle("Social Classes 2010 Real")
-- report:addImage("urbis_2010_real.PNG", "publish")
-- report:addText("This is the main endogenous variable of the model.")
function Report(data)
	data = data or {}
	mandatoryArgument(1, "table", data)
	verifyUnnecessaryArguments(data, {"title", "text", "image"})
	optionalTableArgument(data, "title", "string")

	local mdata = {nextIdx_ = 1, title = data.title, text = {}, image = {}, separator = {}}
	local metaTableIdxs = {
		__newindex = function(self, k, v)
			if v and not rawget(self, k) then
				mdata.nextIdx_ = mdata.nextIdx_ + 1
			end

			rawset(self, k, v)
		end
	}

	setmetatable(mdata.text, metaTableIdxs)
	setmetatable(mdata.image, metaTableIdxs)
	setmetatable(mdata.separator, metaTableIdxs)
	setmetatable(mdata, metaTableReport_)

	if data.image then
		mdata:addImage(data.image)
	end

	if data.text then
		mdata:addText(data.text)
	end

	return mdata
end
