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

local report = Report{
    title = "URBIS-Caraguá",
    author = "Feitosa et. al (2014)"
}

report:addHeading("Social Classes 2010")
report:addImage("urbis_2010_real.PNG", "publish")
report:addText("This is the main endogenous variable of the model. It was obtained from a classification that categorizes the social conditions of households in Caraguatatuba on \"condition A\" (best), \"B\" or \"C\". This classification was carried out through satellite imagery interpretation and a cluster analysis (k-means method) on a set of indicators build from census data of income, education, dependency ratio, householder gender, and occupation condition of households. More details on this classification were presented in Feitosa et al. (2012) Vulnerabilidade e Modelos de Simulação como Estratégias Mediadoras: contribuição ao debate das mudanças climáticas e ambientais.")

report:addSeparator()

report:addHeading("Occupational Classes (IBGE, 2010)")
report:addImage("urbis_uso_2010.PNG", "publish")
report:addText("The occupational class describes the percentage of houses and apartments inside such areas that have occasional use. The dwelling is typically used in summer vacations and holidays.")

report:addSeparator()

report:addHeading("Social Classes 2025")
report:addImage("urbis_simulation_2025_baseline.PNG", "publish")
report:addText("The base scenario considers the zoning proposed by the new master plan of Caraguatatuba. This scenario shows how the new master plan consolidates existing patterns and trends, not being able to force significant changes in relation to the risk distribution observed in 2010.")

Application{
    project = filePath("caragua.tview", "publish"),
    clean = true,
    output = "CaraguaWebMap",
    report = report,
    limit = View{
        description = "Bounding box of Caraguatatuba.",
        color = "goldenrod",
        visible = true
    },
    regions = View{
        description = "Regions of Caraguatatuba.",
        select = "name",
        color = "Set2"
    },
    real = View{
        title = "Social Classes 2010",
        description = "This is the main endogenous variable of the model. It was obtained from a classification that "
                .."categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
        width = 0,
        select = "classe",
        color = {"red", "orange", "yellow"}
    },
    use = View{
        title = "Occupational Classes 2010",
        description = "The occupational class describes the percentage of houses and apartments inside such areas that "
                .."have occasional use. The dwelling is typically used in summer vacations and holidays.",
        width = 0,
        select = "uso",
        color = "RdPu"
    },
    baseline = View{
        title = "Social Classes 2025",
        description = "The base scenario considers the zoning proposed by the new master plan of Caraguatatuba.",
        width = 0,
        select = "classe",
        color = {"red", "orange", "yellow"}
    }
}
```
You can see the result in [Caragua](https://rawgit.com/hguerra/publish/master/examples/CaraguaWebMap/index.html).

```lua
import("publish")

local report = Report{
    title = "The riverine settlements at Arapiuns (PA)",
    author = "Escada et. al (2013)"
}

report:addText([[This report presents the methodology and the initial results obtained at the fieldwork along riverine
    settlements at Arapiuns River, tributary of Tapajós River, municipality of Santarém, Pará state, from June 4 th to 15 th , 2012.
    This research reproduces and extends the data collection accomplished for Tapajós communities in 2009, regarding the infrastructure
    and network relations of riverine human settlements.]])

report:addText([[The main objective was to characterize the organization and interdependence between settlements concerning to:
    infrastructure, health and education services, land use, ecosystem services provision and perception of welfare. We covered
    approximately 300 km, navigating in a motor boat along the riverbanks of Arapiuns River and its tributaries Aruã and Maró Rivers.]])

report:addText([[Based on a semi-structured questionnaire, we interviewed key informants in 49 localities. Riverine settlements
    corresponded to Indian tribes, villages, and communities that are inserted into public lands: Terra Indígena do Maró, Resex Tapajós-Arapiuns,
    Projeto de Assentamento Extrativista Lago Grande and Gleba Nova Olinda.]])

report:addText([[In general, the settlements lack basic infrastructure and depend on the city of Santarém for urban services.
    There are primary schools in most of the localities, but only a few secondary schools, requiring population displacement between
    settlements. Population also needs to displace in the territory to access health centers, doctors and hospitals. Since such
    settlements occupy public lands, the land tenure and land use are restricted by specific rules. Cattle ranching and agriculture are
    mainly for subsistence and they take place in small areas of forest regrowth. Cassava flour production, handcraft, and fishery are
    the main activities for income generation.]])

report:addText([[In places where the population has other sources of income, either from official social benefits or activities
    like handcraft and tourism, flour production is lower. Handcraft work produces mainly manioc processing tools, and its sustainability
    dependents on the market and trade activity established. Fishery is more important for subsistence than for income generation, and
    its production varies seasonally: when it diminishes during wintertime, riverine population has to look after other protein sources.
    Extractive products from vegetal and animal origins have great importance for inhabitants' consumption, low value for income generation
    and it is carried out without any forest management.]])

report:addText([[Welfare indicators varies from regular to satisfactory, and the interviewees declared positive perception of security,
    housing, participation in the decision-making, leisure activities, festivities, solidarity and equitable division of tasks between men and women.
    The most frequent demands are for health and education services, water supply, followed by access to electric energy, telephony, Internet, and
    institutional support to implement new activities for income generation. After this preliminary report, the collected data will be organized in a
    geographical database to analyze settlements networks.Integrating these data with information collected from previous fieldworks will contribute to
    better understand the role of settlement networks as part of urban tissue in the southwest of Pará state.]])

Application{
    project = filePath("arapiuns.tview", "publish"),
    base = "roadmap",
    clean = true,
    output = "ArapiunsWebMap",
    report = report,
    template = {navbar = "#00587A", title = "#FFFFFF"},
    beginning = View{
        description = "Route on the Arapiuns River.",
        width = 3,
        color = "orange",
        border = "orange"
    },
    ending = View{
        description = "Route on the Arapiuns River.",
        width = 3,
        color = "orange",
        border = "orange"
    },
    villages = View{
        description = "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
    }
}
```
You can see the result in [Arapiuns](https://rawgit.com/hguerra/publish/master/examples/ArapiunsWebMap/index.html).

## Reporting Bugs
If you have found a bug, open an entry in the [issues](https://github.com/TerraME/publish/issues).

## Code Status
<b> Current status of Publish package </b>

| check | doc | test |
|---|---|---|---|
[<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-code-analysis-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-code-analysis-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-doc-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-doc-linux-ubuntu-14.04/lastBuild/consoleFull) | [<img src="http://www.dpi.inpe.br/jenkins/buildStatus/icon?job=terrame-ci-publish-unittest-linux-ubuntu-14.04">](http://www.dpi.inpe.br/jenkins/job/terrame-ci-publish-unittest-linux-ubuntu-14.04/lastBuild/consoleFull)|
