var Publish = {
	"path": "./",
	"mapTypeId": "SATELLITE"
	"legend": "Legend",
	"minZoom": 0,
	"maxZoom": 20,
	"zoom": {
		"xTile": 256,
		"yTile": 256,
		"latFraction": 0.00056345599241015
		"longFraction": 0.00059580787037038,
	},
	"center": {
		"lat": -23.647988372093
		"long": -45.369995096154,
	},
	"title": "Social Classes 2010",
	"description": "This is the main endogenous variable of the model. It was obtained from a classification that categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
	"id": "classes"
	"select": "classe",
	"time": "snapshot",
	"timeline": [
		2010
	],
	"data": {
		"classes": {
			"download": false,
			"width": 0,
			"name": [
				"classes_2010"
			],
			"scenario": {
				"lessgrowth": {
					"name": [
						"classes_lessgrowth_2025"
					],
					"timeline": [
						2025
					]
				},
				"baseline": {
					"name": [
						"classes_baseline_2025"
					],
					"timeline": [
						2025
					]
				},
				"plusgrowth": {
					"name": [
						"classes_plusgrowth_2025"
					],
					"timeline": [
						2025
					]
				}
			},
			"color": {
				"1": "rgba(255, 0, 0, 1)",
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)"
			},
			"label": {
				"Condition A": "rgba(255, 255, 0, 1)",
				"Condition C": "rgba(255, 0, 0, 1)",
				"Condition B": "rgba(255, 165, 0, 1)"
			},
			"order": 1,
			"decimal": 5,
			"transparency": 1,
			"visible": true,
			"geom": "MultiPolygon",
		}
	}
};