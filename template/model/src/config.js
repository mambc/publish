var Publish = {
	zoom: null,
	minZoom: 0,
	maxZoom: 20,
	mapTypeId: "SATELLITE",
	legend: "Legend",
	path: (function(){
		var data = "./data/";
		var url = "";
		if(url)
			return data + url + "/";
		return data;
	}()),
	data: {
		"limit": {
			"visible": false,
			"width": 2,
			"border": "rgba(0, 0, 255, 1)"
		},
		"cells": {
			"color": {
				"1": "rgba(166, 189, 219, 1)",
				"2": "rgba(43, 140, 190, 1)",
				"0": "rgba(236, 231, 242, 1)"
			},
			"select": "river",
			"title": "Emas National Park",
			"width": 0,
			"visible": true
		},
		"firebreak": {
			"visible": true,
			"color": "rgba(0, 0, 0, 1)",
			"width": 0
		},
		"river": {
			"visible": true,
			"color": "rgba(0, 0, 255, 1)",
			"width": 0
		}
	}
};
