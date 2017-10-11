var Publish = {
	"minZoom": 0,
	"mapTypeId": "SATELLITE",
	"legend": "Legend",
	"maxZoom": 20,
	"path": ".\/data\/brazil\/",
	"data": {
		"states": {
			"visible": true,
			"download": false,
			"description": "Brazilian states.",
			"transparency": 1,
			"width": 1,
			"order": 1,
			"color": "rgba(255, 255, 0, 1)",
			"id": "states",
			"geom": "MultiPolygon"
		},
		"biomes": {
			"visible": true,
			"download": false,
			"description": "Brazilian Biomes, from IBGE.",
			"transparency": 1,
			"width": 1,
			"select": "name",
			"color": {
				"Amazonia": "rgba(102, 194, 165, 1)",
				"Cerrado": "rgba(141, 160, 203, 1)",
				"Caatinga": "rgba(252, 141, 98, 1)",
				"Mata Atlantica": "rgba(231, 138, 195, 1)",
				"Pampa": "rgba(166, 216, 84, 1)",
				"Pantanal": "rgba(255, 217, 47, 1)"
			},
			"label": {
				"Amazonia": "rgba(102, 194, 165, 1)",
				"Cerrado": "rgba(141, 160, 203, 1)",
				"Mata Atlantica": "rgba(231, 138, 195, 1)",
				"Caatinga": "rgba(252, 141, 98, 1)",
				"Pampa": "rgba(166, 216, 84, 1)",
				"Pantanal": "rgba(255, 217, 47, 1)"
			},
			"id": "biomes",
			"order": 2,
			"geom": "MultiPolygon"
		}
	}
};