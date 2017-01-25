var Publish = {
	"path": ".\/data\/arapiuns\/",
	"maxZoom": 20,
	"data": {
		"villages": {
			"transparency": 1,
			"geom": "MultiPoint",
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			"icon": {
				"path": ".\/assets\/home.png"
			},
			"order": 1,
			"id": "villages",
			"width": 1,
			"select": "Nome",
			"download": true,
			"visible": true
		},
		"trajectory": {
			"transparency": 1,
			"geom": "MultiLineString",
			"description": "Route on the Arapiuns River.",
			"icon": {
				"time": 100.0,
				"options": {
					"fillOpacity": 0.8,
					"strokeWeight": 2,
					"fillColor": "rgba(0, 0, 0, 1)",
					"path": "M150 0 L75 200 L225 200 Z"
				}
			},
			"order": 2,
			"border": "rgba(255, 0, 0, 1)",
			"id": "trajectory",
			"width": 3,
			"download": false,
			"visible": true
		}
	},
	"mapTypeId": "ROADMAP",
	"minZoom": 0,
	"legend": "Legend"
};