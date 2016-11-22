$(function(){
	var map;
	var data = {};
	var $legend = $('#legend');
	var $loader = $('#loader');
	var $description = $('#layer-description');

	function addLegendContent(lengend, color, property, attribute) {
		if(attribute){
			property = property + " " + attribute;
		}

		var $div = $('<div style="height:25px;">')
			.append($('<div class="legend-color-box">').css({backgroundColor: color}))
			.append($('<span>').css("lineHeight", "23px").html(property));
		lengend.append($div);
	}

	function renderLegend(colors, property){
		$legend.empty();
		$('#legend-title').text(" " + Publish.legend);

		if($.type(colors) == "object"){
			$.each(colors, function(attribute, color){
				addLegendContent($legend, color, property, attribute);
			});
		}else{
			addLegendContent($legend, colors, property);
		}
	}

	function setStyle(feature){
		return {
			fillColor: feature.getProperty("color"),
			strokeColor: feature.getProperty("border"),
			strokeWeight: feature.getProperty("width"),
			zIndex: feature.getProperty("order")
		};
	}

	function onClick(event){
		var id = event.target.id;
		var mdata = data[id];
		if(mdata){
			if(mdata.getMap()){
				$legend.empty();
				mdata.setMap(null);
			}else{
				var selected = Publish.data[id];
				var property = selected.select || id;
				var colors = selected.color;

				$description.text(selected.description || "");
				renderLegend(colors, property);
				mdata.setMap(map);
			}
		}else{
			$loader.fadeIn();
			var url = Publish.path + id + ".geojson";
			$.getJSON(url, function(geojson){
				mdata = new google.maps.Data();
				var selected = Publish.data[id];
				var property = selected.select || id;
				var colors = selected.color;
				mdata.addGeoJson(geojson);
				mdata.forEach(function(feature){
					if($.type(colors) == "object"){
						feature.setProperty("color", colors[feature.getProperty(property)]);
					}else {
						feature.setProperty("color", colors);
					}

					feature.setProperty("border", selected.border);
					feature.setProperty("width", selected.width);
					feature.setProperty("order", selected.order);
				});

				mdata.setStyle(setStyle);
				mdata.setMap(map);
				data[id] = mdata;

				renderLegend(colors, property);
			}).always(function() {
				$loader.fadeOut();
			});
		}

		$("i", this).toggleClass("highlight");
	}

	function initialZoom(projects) {
		var $reportLabel = $('#modal-report-label');
		var $reportText = $('#modal-report-text');
		var $reportModal = $('#modal-report');

		var XHRs = [];
		var bounds = new google.maps.LatLngBounds();
		$loader.fadeIn();
		$.each(projects, function(id, selected) {
			var url = Publish.path + id + ".geojson";
			XHRs.push($.getJSON(url, function(geojson){
				var mdata = new google.maps.Data();
				var property = selected.select || id;
				var colors = selected.color;

				mdata.addGeoJson(geojson);
				mdata.forEach(function(feature){
					if($.type(colors) == "object"){
						feature.setProperty("color", colors[feature.getProperty(property)]);
					}else {
						feature.setProperty("color", colors);
					}

					feature.setProperty("border", selected.border);
					feature.setProperty("width", selected.width);
					feature.getGeometry().forEachLatLng(function(coordinate){
						bounds.extend(coordinate);
					});
				});

				mdata.setStyle(setStyle);
				mdata.addListener("click", function(){
					var report = selected.report;
					if(report){
						$reportText.empty();
						$reportLabel.text(report.title);
						$reportText.append(report.html);
						$reportModal.modal('show');
					}
				});

				data[id] = mdata;
				if(selected.visible){
					$description.text(selected.description || "");
					$('#'+id).children('i').toggleClass("highlight");
					mdata.setMap(map);
					renderLegend(colors, property);
				}
			}));
		});

		setTimeout(function () {
			$.when(XHRs).then(function(){
				map.fitBounds(bounds);
				$loader.fadeOut();
			});
		}, 1000);
	}

	function initMap(){
		google.maps.visualRefresh = true;
		var mapOptions = {
			minZoom: Publish.minZoom,
			maxZoom: Publish.maxZoom,
			mapTypeId: google.maps.MapTypeId[Publish.mapTypeId],
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.TOP_RIGHT
			}
		};

		if(Publish.center){
			mapOptions.center = new google.maps.LatLng(Publish.center.lat, Publish.center.long);
		}

		if(Publish.zoom){
			mapOptions.zoom = Publish.zoom;
		}

		var mapElement = document.getElementById("map");
		map = new google.maps.Map(mapElement, mapOptions);
		map.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push($('#footer')[0]);
		$('#layers').find(':button').click(onClick);

		if(!Publish.zoom){
			initialZoom(Publish.data);
		}
	}

	google.maps.event.addDomListener(window, "load", initMap);

	function applyMargins(){
		var leftToggler = $('.mini-submenu-left');
		if(leftToggler.is(':visible')){
			$('#map').find('.ol-zoom')
				.css('margin-left', 0)
				.removeClass('zoom-top-opened-sidebar')
				.addClass('zoom-top-collapsed');
		}else{
			$('#map').find('.ol-zoom')
				.css('margin-left', $('.sidebar-left').width())
				.removeClass('zoom-top-opened-sidebar')
				.removeClass('zoom-top-collapsed');
		}
	}

	function isConstrained(){
		return $('.sidebar').width() == $(window).width();
	}

	function applyInitialUIState(){
		if(isConstrained()){
			$('.sidebar-left .sidebar-body').fadeOut('slide');
			$('.mini-submenu-left').fadeIn();
		}
	}

	$('.sidebar-left .slide-submenu').on('click', function(){
		var thisEl = $(this);
		thisEl.closest('.sidebar-body').fadeOut('slide', function(){
			$('.mini-submenu-left').fadeIn();
			applyMargins();
		});
	});

	$('.mini-submenu-left').on('click', function(){
		var thisEl = $(this);
		$('.sidebar-left .sidebar-body').toggle('slide');
		thisEl.hide();
		applyMargins();
	});

	var $classModalFullscreen = $('.modal-fullscreen');
	$classModalFullscreen.on('show.bs.modal', function () {
		setTimeout(function(){
			$('.modal-backdrop').addClass('modal-backdrop-fullscreen');
			$('#map-modal').append(map.getDiv());
		}, 0);
	});

	$classModalFullscreen.on('hidden.bs.modal', function () {
		$('.modal-backdrop').addClass('modal-backdrop-fullscreen');
		$('#map-canvas').append(map.getDiv());
	});

	$(window).on('resize', applyMargins);
	$('#modal-app-description').modal('show');

	applyInitialUIState();
	applyMargins();
});
