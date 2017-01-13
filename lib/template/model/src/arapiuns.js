var Publish = {
	"maxZoom": 20,
	"path": ".\/data\/arapiuns\/",
	"minZoom": 0,
	"mapTypeId": "ROADMAP",
	"legend": "Legend",
	"data": {
		"beginning": {
			"order": 3,
			"width": 3,
			"transparency": 0,
			"border": "rgba(0, 0, 205, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"color": "rgba(0, 0, 205, 1)"
		},
		"ending": {
			"order": 2,
			"width": 3,
			"transparency": 0,
			"border": "rgba(255, 0, 0, 1)",
			"description": "Route on the Arapiuns River.",
			"visible": true,
			"color": "rgba(255, 0, 0, 1)"
		},
		"villages": {
			"order": 1,
			"width": 1,
			"transparency": 0,
			"visible": true,
			"select": "CMM",
			"description": "Riverine settlements corresponded to Indian tribes, villages, and communities that are inserted into public lands.",
			"geom": "Point",
			"icon": ".\/assets\/home.png"
		}
	}
};