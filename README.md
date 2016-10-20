# Publish
## Overview
This is a TerraME package that allows one to export the outputs of different Model scenarios to a web server.

## TerraME
TerraME is a programming environment for spatial dynamical modelling. It supports cellular automata, agent-based models, and network models running in 2D cell spaces. TerraME provides an interface to TerraLib geographical database, allowing models direct access to geospatial data. Its modelling language has in-built functions that makes it easier to develop multi-scale and multi-paradigm models for environmental applications. For full documentation visit the [TerraME Home Page](http://terrame.org) and [TerraME Wiki Page](https://github.com/TerraME/terrame/wiki).

## License
Publish is distributed under the GNU Lesser General Public License as published by the Free Software Foundation. See [publish-license-lgpl-3.0.txt](https://github.com/pedro-andrade-inpe/publish/blob/master/license.txt) for details. 

## Usage

### Running Tests
The code below shows an example of the command to test TerraME publish package using a config file named test.lua

```lua
-- test.lua
lines = true
```

```bash
$> terrame -package publish -test test.lua
```

### Documentation
The complete documentation is available via `-showdoc` command line:
```bash
$> terrame -package publish -showdoc
```

### Examples

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
