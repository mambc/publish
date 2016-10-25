var Publish = {
	center: {lat: -18.106389, long: -52.927778 },
	zoom: 10,
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
		limit: ["river", { 0: "rgba(236, 231, 242, 1)",1: "rgba(166, 189, 219, 1)",2: "rgba(43, 140, 190, 1)", }],
		cells: ["river", { 0: "rgba(236, 231, 242, 1)",1: "rgba(166, 189, 219, 1)",2: "rgba(43, 140, 190, 1)", }],
		firebreak: ["river", { 0: "rgba(236, 231, 242, 1)",1: "rgba(166, 189, 219, 1)",2: "rgba(43, 140, 190, 1)", }],
		river: ["river", { 0: "rgba(236, 231, 242, 1)",1: "rgba(166, 189, 219, 1)",2: "rgba(43, 140, 190, 1)", }],
		cover: ["river", { 0: "rgba(236, 231, 242, 1)",1: "rgba(166, 189, 219, 1)",2: "rgba(43, 140, 190, 1)", }],
	}
};