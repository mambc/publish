var Publish = {
	"path": "./\data\/scenario\/",
	"mapTypeId": "SATELLITE",
	"legend": "Legend",
	"minZoom": 0,
	"maxZoom": 20,
	"zoom": {
		"xTile": 256,
		"yTile": 256,
		"latFraction": 0.00056345599241015,
		"longFraction": 0.00059580787037038
	},
	"center": {
		"lat": -23.647988372093,
		"long": -45.369995096154
	},

	"data": {
		"classes": {
			"select": "classe",
			"time": "snapshot",
			"name": [
				"classes_2010"
			],
			"timeline": [
				2010
			],
			"scenario": {
				"plusgrowth": {
					"name": [
						"classes_plusgrowth_2025"
					],
					"timeline": [
						2025
					]
				},
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
				}
			},
			"download": false,
			"decimal": 5,
			"width": 0,
			"label": {
				"Condition B": "rgba(255, 165, 0, 1)",
				"Condition A": "rgba(255, 255, 0, 1)",
				"Condition C": "rgba(255, 0, 0, 1)"
			},
			"color": {
				"1": "rgba(255, 0, 0, 1)",
				"2": "rgba(255, 165, 0, 1)",
				"3": "rgba(255, 255, 0, 1)"
			},
			"order": 1,
			"transparency": 1,
			"visible": true,
			"title": "Social Classes 2010",
			"description": "This is the main endogenous variable of the model. It was obtained from a classification that categorizes the social conditions of households in Caraguatatuba on 'condition A' (best), 'B' or 'C''.",
			"id": "classes",
			"geom": "MultiPolygon"
		}
	}
};