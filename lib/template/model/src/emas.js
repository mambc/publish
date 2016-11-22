var Publish = {
	zoom: null,
	minZoom: 0,
	maxZoom: 20,
	mapTypeId: "SATELLITE",
	legend: "Legend",
	path: (function(){
		var data = ".\/data\/emas\/";
		var url = "";
		if(url)
			return data + url + "/";
		return data;
	}()),
	data: {
		"limit": {
			"visible": true,
			"width": 1,
			"border": "rgba(0, 0, 255, 1)",
			"color": "rgba(238, 232, 170, 1)",
			"order": 4,
			"description": "Bounding box of Emas National Park"
		},
		"cells": {
			"color": {
				"1": "rgba(166, 189, 219, 1)",
				"2": "rgba(43, 140, 190, 1)",
				"0": "rgba(236, 231, 242, 1)"
			},
			"select": "river",
			"title": "Emas National Park",
			"description": "Cellular layer",
			"width": 0,
			"visible": false,
			"order": 1
		},
		"firebreak": {
			"visible": false,
			"color": "rgba(0, 0, 0, 1)",
			"width": 1,
			"order": 2
		},
		"river": {
			"visible": false,
			"color": "rgba(0, 0, 255, 1)",
			"width": 1,
			"order": 3
		}
	}
};
