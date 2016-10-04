$(function(){
	function applyMargins() {
		var leftToggler = $(".mini-submenu-left");
		if (leftToggler.is(":visible")) {
		  $("#map .ol-zoom")
			.css("margin-left", 0)
			.removeClass("zoom-top-opened-sidebar")
			.addClass("zoom-top-collapsed");
		} else {
		  $("#map .ol-zoom")
			.css("margin-left", $(".sidebar-left").width())
			.removeClass("zoom-top-opened-sidebar")
			.removeClass("zoom-top-collapsed");
		}
	}

	function isConstrained() {
		return $(".sidebar").width() == $(window).width();
	}

	function applyInitialUIState() {
		if (isConstrained()) {
		  $(".sidebar-left .sidebar-body").fadeOut('slide');
		  $('.mini-submenu-left').fadeIn();
		}
	}

	$('.sidebar-left .slide-submenu').on('click',function() {
	  var thisEl = $(this);
	  thisEl.closest('.sidebar-body').fadeOut('slide',function(){
		$('.mini-submenu-left').fadeIn();
		applyMargins();
	  });
	});

	$('.mini-submenu-left').on('click',function() {
	  var thisEl = $(this);
	  $('.sidebar-left .sidebar-body').toggle('slide');
	  thisEl.hide();
	  applyMargins();
	});

	$(window).on("resize", applyMargins);
	var map;
	function initMap () {
		//Enabling new cartography and themes
		google.maps.visualRefresh = true;

		//Setting starting options of map
		var mapOptions = {
			  center: new google.maps.LatLng(-23.1791, -45.8872),
			  zoom: 10,
			  mapTypeId: google.maps.MapTypeId.ROADMAP,
			  mapTypeControl: true,
			  mapTypeControlOptions: {
			  	style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
       			position: google.maps.ControlPosition.TOP_RIGHT
			}
		};

		//Getting map DOM element
		var mapElement = document.getElementById('map');

		//Creating a map with DOM element which is just obtained
		map = new google.maps.Map(mapElement, mapOptions);
	}

	google.maps.event.addDomListener(window, 'load', initMap);

	applyInitialUIState();
	applyMargins();
});