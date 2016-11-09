# Publish
## Overview
This is a [TerraME](http://terrame.org) package that allows one to export the outputs of different Model scenarios to a web server.

## License
Publish is distributed under the GNU Lesser General Public License as published by the Free Software Foundation. See [publish-license-lgpl-3.0.txt](https://github.com/pedro-andrade-inpe/publish/blob/master/license.txt) for details. 

## Example
```lua
import("publish")

Application{
    project = filePath("emas.tview", "publish"),
    clean = true,
    output = "EmasWebMap",
    title = "Emas",
    description = "A small example related to a fire spread model.",
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

## Reporting Bugs
If you have found a bug, open an entry in the [issues](https://github.com/pedro-andrade-inpe/publish/issues).

## Code Status
<b> Current status of Publish package </b>

| check | doc | test |
|---|---|---|---|
[<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-code-analysis-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-code-analysis-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-doc-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-doc-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-unittest-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-unittest-linux-ubuntu-14.04/lastBuild/consoleFull)|
