# Publish
## Overview
This is a [TerraME](http://terrame.org) package that allows one to export the outputs of different Model scenarios to a web server.

## License
Publish is distributed under the GNU Lesser General Public License as published by the Free Software Foundation. See [publish-license-lgpl-3.0.txt](https://github.com/pedro-andrade-inpe/publish/blob/master/license.txt) for details. 

## Example

```lua
import("publish")

local layout = Layout{
	title = "Emas",
	description = "Creates a database that can be used by the example fire-spread of base package.",
	base = "satellite",
	zoom = 10,
	center = {lat = -18.106389, long = -52.927778}
}

Application{
	project = filePath("emas.tview", "terralib"),
	layout = layout,
	clean = true,
	select = "river",
	color = "PuBu",
	value = {0, 1, 2},
	output = Directory("EmasWebMap")
}
```
You can see the result in [Emas](https://rawgit.com/hguerra/publish/master/examples/EmasWebMap/index.html).

## Reporting Bugs
If you have found a bug, open an entry in the [issues](https://github.com/pedro-andrade-inpe/publish/issues).
