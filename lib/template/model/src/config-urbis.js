var Publish = {
	"minZoom": 0,
	"path": ".\/data\/urbis\/",
	"data": {
		"real": {
			"width": 0,
			"select": "classe",
			"visible": false,
			"report": "table",
			"color": {
				"1": "rgba(255, 0, 0, 1)",
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)"
			},
			"title": "Social Classes 2010",
			"label": {
				"Condition C": "rgba(255, 0, 0, 1)",
				"Condition B": "rgba(255, 165, 0, 1)",
				"Condition A": "rgba(255, 255, 0, 1)"
			},
			"geom": "MultiPolygon",
			"group": "SocialClasses",
			"id": "real",
			"transparency": 1,
			"description": "This is the main endogenous variable of the model. It was obtained from a classification that categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
			"download": false,
			"order": 3
		},
		"limit": {
			"width": 1,
			"transparency": 1,
			"visible": true,
			"report": "table",
			"geom": "MultiPolygon",
			"color": "rgba(218, 165, 32, 1)",
			"id": "limit",
			"download": false,
			"description": "Bounding box of Caraguatatuba.",
			"group": "Border",
			"order": 4
		},
		"use": {
			"width": 0,
			"select": "uso",
			"visible": true,
			"report": "table",
			"color": {
				"1": "rgba(254, 235, 226, 1)",
				"2": "rgba(251, 180, 185, 1)",
				"3": "rgba(247, 104, 161, 1)",
				"4": "rgba(197, 27, 138, 1)",
				"5": "rgba(122, 1, 119, 1)"
			},
			"title": "Occupational Classes 2010",
			"label": {
				"0.200001 - 0.350000": "rgba(251, 180, 185, 1)",
				"0.350001 - 0.500000": "rgba(247, 104, 161, 1)",
				"0.500001 - 0.700000": "rgba(197, 27, 138, 1)",
				"0.000000 - 0.200000": "rgba(254, 235, 226, 1)",
				"0.700001 - 0.930000": "rgba(122, 1, 119, 1)"
			},
			"geom": "MultiPolygon",
			"group": "OccupationalClasses",
			"id": "use",
			"transparency": 1,
			"description": "The occupational class describes the percentage of houses and apartments inside such areas that have occasional use. The dwelling is typically used in summer vacations and holidays.",
			"download": false,
			"order": 1
		},
		"regions": {
			"width": 1,
			"select": "name",
			"visible": false,
			"report": "table",
			"label": {
				"South": "rgba(141, 160, 203, 1)",
				"North": "rgba(102, 194, 165, 1)",
				"Central": "rgba(252, 141, 98, 1)"
			},
			"color": {
				"1": "rgba(102, 194, 165, 1)",
				"2": "rgba(252, 141, 98, 1)",
				"3": "rgba(141, 160, 203, 1)"
			},
			"geom": "MultiPolygon",
			"transparency": 1,
			"id": "regions",
			"download": false,
			"description": "Regions of Caraguatatuba.",
			"group": "Border",
			"order": 2
		},
		"baseline": {
			"width": 0,
			"select": "classe",
			"visible": true,
			"report": "table",
			"color": {
				"1": "rgba(255, 0, 0, 1)",
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)"
			},
			"title": "Social Classes 2025",
			"label": {
				"Condition C": "rgba(255, 0, 0, 1)",
				"Condition B": "rgba(255, 165, 0, 1)",
				"Condition A": "rgba(255, 255, 0, 1)"
			},
			"geom": "MultiPolygon",
			"group": "SocialClasses",
			"id": "baseline",
			"transparency": 1,
			"description": "The base scenario considers the zoning proposed by the new master plan of Caraguatatuba.",
			"download": false,
			"order": 5
		}
	},
	"maxZoom": 20,
	"legend": "Legend",
	"group": {
		"Border": "limit",
		"SocialClasses": "baseline",
		"OccupationalClasses": "use"
	},
	"mapTypeId": "SATELLITE"
};