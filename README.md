# Publish
## Overview
This is a [TerraME](http://terrame.org) package that allows one to export the outputs of different Model scenarios to a web server.

## License
Publish is distributed under the GNU Lesser General Public License as published by the Free Software Foundation. See [publish-license-lgpl-3.0.txt](https://github.com/pedro-andrade-inpe/publish/blob/master/license.txt) for details.

## Instructions
Publish currently supports only shapefiles in the <b>“EPSG:4326”</b> projection (i.e. GCS_WGS_1984). Make sure it all your data are in this format.

## Example
```lua
import("publish")

Application{
    project = filePath("emas.tview", "publish"),
    clean = true,
    output = "EmasWebMap",
    order = {"limit", "river"},
    river = View{
        color = "blue"
    },
    firebreak = View{
        color = "black"
    },
    limit = View{
        border = "blue",
        color = "goldenrod",
        width = 2,
        visible = true
    },
    cells = View{
        title = "Emas National Park",
        select = "river",
        color = "PuBu",
        width = 0,
        value = {0, 1, 2}
    }
}
```
You can see the result in [Emas](https://rawgit.com/hguerra/publish/master/examples/EmasWebMap/index.html).

```lua
import("publish")

Application{
    project = filePath("urbis.tview", "publish"),
    clean = true,
    output = "CaraguaWebMap",
    limit = View{
        description = "Bounding box of Caraguatatuba.",
        color = "goldenrod",
        visible = true
    },
    regions = View{
        description = "Regions of Caraguatatuba.",
        select = "name",
        color = "Set2",
        value = {1, 2, 3}
    },
    real = View{
        title = "Social Classes 2010",
        description = "This is the main endogenous variable of the model. It was obtained from a classification that "
                    .."categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
        width = 0,
        select = "classe",
        color = {"red", "orange", "yellow"},
        value = {1, 2, 3}
    },
    use = View{
        title = "Occupational Classes 2010",
        description = "The occupational class describes the percentage of houses and apartments inside such areas that "
                    .."have occasional use. The dwelling is typically used in summer vacations and holidays.",
        width = 0,
        select = "uso",
        color = {{255, 204, 255}, {242, 160, 241}, {230, 117, 228}, {214, 71, 212}, {199, 0, 199}},
        value = {1, 2, 3, 4, 5}
    },
    baseline = View{
        title = "Social Classes 2025",
        description = "The base scenario considers the zoning proposed by the new master plan of Caraguatatuba.",
        width = 0,
        select = "classe",
        color = {"red", "orange", "yellow"},
        value = {1, 2, 3}
    }
}
```
You can see the result in [URBIS-Caraguá](https://rawgit.com/hguerra/publish/master/examples/CaraguaWebMap/index.html).

## Reporting Bugs
If you have found a bug, open an entry in the [issues](https://github.com/pedro-andrade-inpe/publish/issues).

## Code Status
<b> Current status of Publish package </b>

| check | doc | test |
|---|---|---|---|
[<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-code-analysis-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-code-analysis-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-doc-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-doc-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-unittest-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-unittest-linux-ubuntu-14.04/lastBuild/consoleFull)|
