var Publish = {
	"minZoom": 0,
	"data": {
		"villages": {
			"select": [
				"Nome",
				"UC"
			],
			"icon": {
				"options": {
					"0": "./assets/home.png",
					"1": "./assets/forest.png"
				}
			},
			"report": "function",
			"download": true,
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			"id": "villages",
			"width": 1,
			"transparency": 1,
			"geom": "MultiPoint",
			"visible": true,
			"order": 1,
			"label": {
				"Absence of Conservation Unit": "./assets/home.png",
				"Presence of Conservation Unit": "./assets/forest.png"
			}
		},
		"trajectory": {
			"icon": {
				"options": {
					"fillColor": "rgba(0, 0, 0, 1)",
					"path": "M150 0 L75 200 L225 200 Z",
					"strokeWeight": 2,
					"fillOpacity": 0.8
				},
				"time": 100
			},
			"id": "trajectory",
			"download": false,
			"description": "Route on the Arapiuns River.",
			"width": 3,
			"visible": true,
			"geom": "MultiLineString",
			"border": "rgba(255, 0, 0, 1)",
			"order": 2,
			"transparency": 1
		}
	},
	"legend": "Legend",
	"path": ".\/data\/arapiuns\/",
	"mapTypeId": "ROADMAP",
	"maxZoom": 20
};