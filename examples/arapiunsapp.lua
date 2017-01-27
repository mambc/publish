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

local description = [[
	This report presents the methodology and the initial results obtained at the fieldwork along riverine settlements at
	Arapiuns River, tributary of Tapajós River, municipality of Santarém, Pará state, from June 4 th to 15 th , 2012.
	This research reproduces and extends the data collection accomplished for Tapajós communities in 2009, regarding the
	infrastructure and network relations of riverine human settlements. The main objective was to characterize the
	organization and interdependence between settlements concerning to:infrastructure, health and education services,
	land use, ecosystem services provision and perception of welfare.
	Source: Escada et. al (2013) Infraestrutura, Serviços e Conectividade das Comunidades Ribeirinhas do Arapiuns, PA.
	Relatório Técnico de Atividade de Campo - Projeto UrbisAmazônia e Projeto Cenários para a Amazônia: Uso da terra,
	Biodiversidade e Clima, INPE.
]]

Application{
	project = filePath("arapiuns.tview", "publish"),
	description = description,
	base = "roadmap",
	clean = true,
	output = "ArapiunsWebMap",
	template = {navbar = "darkblue", title = "white"},
	trajectory = View{
		description = "Route on the Arapiuns River.",
		width = 3,
		border = "blue",
		icon = {
			path = "M150 0 L75 200 L225 200 Z",
			transparency = 0.2,
			time = 20
		}
	},
	villages = View{
		download = true,
		description = "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
		select = {"Nome", "UC"},
		icon = {"home", "forest"},
		label = {"Absence Cons. Unit.", "Presence Cons. Unit."},
		report = function(cell)
			local mreport = Report{
				title = cell.Nome,
				author = "Escada et. al (2013)"
			}

			mreport:addImage(packageInfo("publish").data.."arapiuns/"..cell.Nome..".jpg")

			local health, water
			if cell.PSAU > 0 then health = "has" else health = "hasn't" end
			if cell.AGUA > 0 then water  = "has" else water  = "hasn't" end

			mreport:addText(string.format("The community %s health center and %s access to water.", health, water))

			local school = {}
			if cell.ENSINF > 0   then table.insert(school, "Early Childhood Education")     end
			if cell.ENSFUND2 > 0 then table.insert(school, "Elementary School")             end
			if cell.EJA > 0      then table.insert(school, "Education of Young and Adults") end

			if #school > 0 then
				mreport:addText(string.format("The schools offers %s.", table.concat(school, ", ")))
			end

			return mreport
		end
	}
}