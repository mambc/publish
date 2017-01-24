var Publish = {
	"maxZoom": 20,
	"path": ".\/data\/arapiuns\/",
	"minZoom": 0,
	"mapTypeId": "ROADMAP",
	"legend": "Legend",
	"data": {
		"beginning": {
			"id":"beginning",
			"order": 3,
			"width": 3,
			"transparency": 1,
			"border": "rgba(0, 0, 205, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"geom": "MultiLineString",
			"icon": {
				"time": 200,
				"options": {
					"path": "M 100 100 L 300 100 L 200 300 Z",
					"fillOpacity": 0.8,
					"fillColor": "rgba(0, 0, 0, 1)",
					"strokeWeight": 2
				}
			}
		},
		"ending": {
			"id":"ending",
			"order": 2,
			"width": 3,
			"transparency": 1,
			"border": "rgba(255, 0, 0, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"geom": "MultiLineString",
			"icon": {
				"time": 200,
				"options": {
					"path": "M 100 100 L 300 100 L 200 300 Z",
					"fillOpacity": 0.8,
					"fillColor": "rgba(0, 0, 0, 1)",
					"strokeWeight": 2
				}
			}
		},
		"villages": {
			"id":"villages",
			"order": 1,
			"width": 1,
			"transparency": 1,
			"visible": true,
			"select": "CMM",
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			"geom": "Point",
			"icon": {
				"options":".\/assets\/home.png"
			},
			"download": true
		}
	}
};