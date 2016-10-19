var Publish = {
	center: {lat: -18.106389, long: -52.927778 },
	zoom: 10,
	minZoom: 0,
	maxZoom: 20,
	mapTypeId: "SATELLITE",
	path: (function(){
		var data = "./data/";
		var url = "";
		if(url)
			return data + url + "/";
		return data;
	}()),
	data: {
		limit: ["river", { 0: "rgba(229, 245, 249, 1)",1: "rgba(153, 216, 201, 1)",2: "rgba(44, 162, 95, 1)", }],
		firebreak: ["river", { 0: "rgba(229, 245, 249, 1)",1: "rgba(153, 216, 201, 1)",2: "rgba(44, 162, 95, 1)", }],
		river: ["river", { 0: "rgba(229, 245, 249, 1)",1: "rgba(153, 216, 201, 1)",2: "rgba(44, 162, 95, 1)", }],
		cover: ["river", { 0: "rgba(229, 245, 249, 1)",1: "rgba(153, 216, 201, 1)",2: "rgba(44, 162, 95, 1)", }],
		cells: ["river", { 0: "rgba(229, 245, 249, 1)",1: "rgba(153, 216, 201, 1)",2: "rgba(44, 162, 95, 1)", }],
	}
};