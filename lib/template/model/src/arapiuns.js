var Publish = {
	"path": ".\/data\/arapiuns\/",
	"minZoom": 0,
	"maxZoom": 20,
	"mapTypeId": "ROADMAP",
	"legend": "Legend",
	"data": {
		"villages": {
			"transparency": 1,
			"geom": "MultiPoint",
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			"order": 1,
			"id": "villages",
			"width": 1,
			"download": true,
			"visible": true,
			"select": ["Nome", "UC"],
			"icon": {
				"options": {
					"1": ".\/assets\/forest.png",
					"0": ".\/assets\/home.png"
				}
			},
			"label": {
				"Presence Cons. Unit.": ".\/assets\/forest.png",
				"Absence Cons. Unit.": ".\/assets\/home.png"
			}
		},
		"trajectory": {
			"transparency": 1,
			"geom": "MultiLineString",
			"description": "Route on the Arapiuns River.",
			"order": 2,
			"border": "rgba(255, 0, 0, 1)",
			"id": "trajectory",
			"width": 3,
			"download": false,
			"visible": true,
			"icon": {
				"time": 100.0,
				"options": {
					"fillOpacity": 0.8,
					"strokeWeight": 2,
					"fillColor": "rgba(0, 0, 0, 1)",
					"path": "M150 0 L75 200 L225 200 Z"
				}
			}
		}
	}
};