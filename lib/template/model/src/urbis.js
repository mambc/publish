var Publish = {
	"path": ".\/data\/urbis\/",
	"minZoom": 0,
	"maxZoom": 20,
	"mapTypeId": "SATELLITE",
	"legend": "Legend",
	"group": {
		"OccupationalClasses": "use",
		"Limit": "limit",
		"SocialClasses": "real"
	},
	"data": {
		"limit": {
			"id": "limit",
			"geom": "MultiPolygon",
			"visible": true,
			"color": "rgba(218, 165, 32, 1)",
			"description": "Bounding box of Caraguatatuba.",
			"download": false,
			"order": 4,
			"width": 1,
			"transparency": 1,
			"group": "Limit"
		},
		"regions": {
			"id": "regions",
			"geom": "MultiPolygon",
			"visible": false,
			"color": {
				"2": "rgba(252, 141, 98, 1)",
				"3": "rgba(141, 160, 203, 1)",
				"1": "rgba(102, 194, 165, 1)"
			},
			"description": "Regions of Caraguatatuba.",
			"width": 1,
			"download": false,
			"label": {
				"name 2": "rgba(252, 141, 98, 1)",
				"name 3": "rgba(141, 160, 203, 1)",
				"name 1": "rgba(102, 194, 165, 1)"
			},
			"order": 2,
			"select": "name",
			"transparency": 1,
			"group": "Limit"
		},
		"baseline": {
			"id": "baseline",
			"geom": "MultiPolygon",
			"visible": false,
			"color": {
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)",
				"1": "rgba(255, 0, 0, 1)"
			},
			"description": "The base scenario considers the zoning proposed by the new master plan of Caraguatatuba.",
			"title": "Social Classes 2025",
			"width": 0,
			"download": false,
			"label": {
				"classe 2": "rgba(255, 165, 0, 1)",
				"classe 3": "rgba(255, 255, 0, 1)",
				"classe 1": "rgba(255, 0, 0, 1)"
			},
			"order": 5,
			"select": "classe",
			"transparency": 1,
			"group": "SocialClasses"
		},
		"real": {
			"id": "real",
			"geom": "MultiPolygon",
			"visible": true,
			"color": {
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)",
				"1": "rgba(255, 0, 0, 1)"
			},
			"description": "This is the main endogenous variable of the model. It was obtained from a classification that categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
			"title": "Social Classes 2010",
			"width": 0,
			"download": false,
			"label": {
				"classe 2": "rgba(255, 165, 0, 1)",
				"classe 3": "rgba(255, 255, 0, 1)",
				"classe 1": "rgba(255, 0, 0, 1)"
			},
			"order": 3,
			"select": "classe",
			"transparency": 1,
			"group": "SocialClasses"
		},
		"use": {
			"id": "use",
			"geom": "MultiPolygon",
			"visible": true,
			"color": {
				"4": "rgba(197, 27, 138, 1)",
				"5": "rgba(122, 1, 119, 1)",
				"2": "rgba(251, 180, 185, 1)",
				"3": "rgba(247, 104, 161, 1)",
				"1": "rgba(254, 235, 226, 1)"
			},
			"description": "The occupational class describes the percentage of houses and apartments inside such areas that have occasional use. The dwelling is typically used in summer vacations and holidays.",
			"title": "Occupational Classes 2010",
			"width": 0,
			"download": false,
			"label": {
				"uso 3": "rgba(247, 104, 161, 1)",
				"uso 5": "rgba(122, 1, 119, 1)",
				"uso 2": "rgba(251, 180, 185, 1)",
				"uso 4": "rgba(197, 27, 138, 1)",
				"uso 1": "rgba(254, 235, 226, 1)"
			},
			"order": 1,
			"select": "uso",
			"transparency": 1,
			"group": "OccupationalClasses"
		}
	}
};