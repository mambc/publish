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

-- @example Implementation of a simple Application using Arapiuns.
-- The data of this application were extracted from Escada et. al (2013) Infraestrutura,
-- Serviços e Conectividade das Comunidades Ribeirinhas do Arapiuns, PA. Relatório técnico, INPE.

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
		icon = "home",
		select = "CMM",
		report = function(cell)
			local mreport = Report{title = cell.CMM}

			mreport:addImage(packageInfo("publish").data.."arapiuns/"..cell.CMM..".jpg")
			mreport:addText("This community has the ID "..cell.ID..".")

			return mreport
		end
	}
}