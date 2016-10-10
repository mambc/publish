$(function(){
	var map;
	var data = {};

	function setColorProperty(feature){
		$.each(Publish["data"], function (id, data){
			$.each(data, function (property, values){
				var classes = (values.length < 3) ? 3 : values.length;
				var value = feature.getProperty(property);
				feature.setProperty("color", colorbrewer[Publish.color][classes][value]);
			})
		})
	}

	function setStyle(feature){
		return{
			fillColor: feature.getProperty("color"),
			strokeWeight: 1
		};
	}

	function onClick(event){
		var id = event.target.id;
		if(data[id]){
			map.data.forEach(function(feature) {
				map.data.remove(feature)
			});

			delete data[id];
		}else{
			var url = "./data/" + id + ".geojson";
			$.getJSON(url, function(geojson){
				data[id] = map.data.addGeoJson(geojson);
				map.data.forEach(setColorProperty);
				map.data.setStyle(setStyle);
			});
		}
	}

	function initMap(){
		google.maps.visualRefresh = true;
		var mapOptions = {
			center: new google.maps.LatLng(Publish.center.lat, Publish.center.long),
			zoom: Publish.zoom,
			minZoom: Publish.minZoom,
			maxZoom: Publish.maxZoom,
			mapTypeId: google.maps.MapTypeId[Publish.mapTypeId],
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.TOP_RIGHT
			}
		};

		var mapElement = document.getElementById('map');
		map = new google.maps.Map(mapElement, mapOptions);

		$("#layers").find(":button").click(onClick);
	}

	google.maps.event.addDomListener(window, 'load', initMap);

	function applyMargins(){
		var leftToggler = $(".mini-submenu-left");
		if (leftToggler.is(":visible")) {
		 	$("#map").find(".ol-zoom")
			.css("margin-left", 0)
			.removeClass("zoom-top-opened-sidebar")
			.addClass("zoom-top-collapsed");
		} else {
			$("#map").find(".ol-zoom")
			.css("margin-left", $(".sidebar-left").width())
			.removeClass("zoom-top-opened-sidebar")
			.removeClass("zoom-top-collapsed");
		}
	}

	function isConstrained(){
		return $(".sidebar").width() == $(window).width();
	}

	function applyInitialUIState(){
		if (isConstrained()){
			$(".sidebar-left .sidebar-body").fadeOut('slide');
			$('.mini-submenu-left').fadeIn();
		}
	}

	$('.sidebar-left .slide-submenu').on('click',function(){
		var thisEl = $(this);
		thisEl.closest('.sidebar-body').fadeOut('slide',function(){
			$('.mini-submenu-left').fadeIn();
			applyMargins();
		});
	});

	$('.mini-submenu-left').on('click',function(){
		var thisEl = $(this);
		$('.sidebar-left .sidebar-body').toggle('slide');
		thisEl.hide();
		applyMargins();
	});

	$(window).on("resize", applyMargins);

	applyInitialUIState();
	applyMargins();
});