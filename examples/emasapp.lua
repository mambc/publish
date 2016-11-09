-- @example Implementation of a simple emas application. It uses the data from a tview file (terralib/emas.tview).
-- There is a layout with the web page properties.
-- Each polygon is drawn using the attribute 'select'.

import("publish")

Application{
	project = filePath("emas.tview", "publish"),
	clean = true,
	output = "EmasWebMap",
	title = "Emas",
	description = "A small example related to a fire spread model.",
	order = {"limit", "river", "firebreak", "cells"},
	river = View{
		color = "blue"
	},
	firebreak = View{
		color = "black"
	},
	limit = View{
		description = "Bounding box of Emas National Park",
		border = "blue",
		color = "goldenrod",
		width = 2,
		visible = true
	},
	cells = View{
		title = "Emas National Park",
		description = "Cellular layer",
		select = "river",
		color = "PuBu",
		width = 0,
		value = {0, 1, 2}
	}
}