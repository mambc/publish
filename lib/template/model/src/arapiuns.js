var Publish = {
	"maxZoom": 20,
	"path": ".\/data\/arapiuns\/",
	"minZoom": 0,
	"legend": "Legend",
	"data": {
		"beginning": {
			"order": 3,
			"width": 3,
			"transparency": 0,
			"border": "rgba(255, 165, 0, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"color": "rgba(255, 165, 0, 1)"
		},
		"ending": {
			"order": 2,
			"width": 3,
			"transparency": 0,
			"border": "rgba(255, 165, 0, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"color": "rgba(255, 165, 0, 1)"
		},
		"villages": {
			"order": 1,
			"width": 1,
			"transparency": 0,
			"visible": true,
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			// "icon": ".\/assets\/home.png"
			"icon": {
				path: "M-20,0a20,20 0 1,0 40,0a20,20 0 1,0 -40,0",
				fillColor: '#FF0000',
				fillOpacity: .6,
				strokeWeight: 0
			}
		}
	},
	"mapTypeId": "ROADMAP"
};