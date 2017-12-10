var Publish = {
	"path": "./",
	"center": {
		"lat": -6.3843245731981,
		"long": -58.945574
	},
	"mapTypeId": "TERRAIN",
	"maxZoom": 20,
	"zoom": {
		"yTile": 256,
		"longFraction": 0.083512061111111,
		"latFraction": 0.065626224426708,
		"xTile": 256
	},
	"minZoom": 0,
	"data": {
		"prodes": {
			"id": "prodes",
			"download": false,
			"order": 1,
			"width": 1,
			"url": "http://35.198.39.192/geoserver/wms",
			"time": "snapshot",
			"description": "Monitoring of the Amazon Rainforest by Satellite.",
			"decimal": 5,
			"geom": "WMS",
			"scenario": [],
			"title": "Prodes",
			"color": [
				"#FF0000"
			],
			"transparency": 1,
			"timeline": [
				2000,
				2005,
				2010,
				2015
			],
			"visible": true,
			"label": {
				"Prodes": "#FF0000"
			},
			"name": [
				"amazon:prodes_2000",
				"amazon:prodes_2005",
				"amazon:prodes_2010",
				"amazon:prodes_2015"
			]
		}
	},
	"legend": "Legend"
};