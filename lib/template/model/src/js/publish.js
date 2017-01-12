$(function(){
	var map;
	var data = {};
	var layers = [];
	var $legend = $('#legend');
	var $loader = $('#loader');
	var $description = $('#layer-description');

	function addLegendContent(lengend, color, label) {
		var $div = $('<div style="height:25px;">')
			.append($('<div class="legend-color-box">').css({backgroundColor: color}))
			.append($('<span>').css("lineHeight", "23px").html(label));
		lengend.append($div);
	}

	function renderLegend(label) {
		$legend.empty();
		$('#legend-title').text(" " + Publish.legend);

		var keys = [];
		$.each(label, function (text) {
			keys.push(text);
		});

		keys.sort();
		$.each(keys, function(_, text){
			var color = label[text];
			addLegendContent($legend, color, text);
		});
	}

	function refreshMenu(selected) {
		var label = selected.label;
		$description.text(selected.description || "");
		renderLegend(label);
	}

	function setStyle(feature){
		return {
			fillColor: feature.getProperty("color"),
			strokeColor: feature.getProperty("border"),
			strokeWeight: feature.getProperty("width"),
			zIndex: feature.getProperty("order"),
			icon: feature.getProperty("icon")
		};
	}

	function onClick(event){
		var id = event.target.id;
		var mdata = data[id];
		if(mdata){
			if(mdata.getMap()){
				mdata.setMap(null);
				var index = layers.indexOf(id);
				if(index >= 0){
					layers.splice(index, 1);
					var len = layers.length;

					if(len > 0){
						refreshMenu(Publish.data[layers[len - 1]]);
					}else{
						$legend.empty();
						$description.empty();
						if ($('#properties').hasClass("in")) {
							$('#description-title').click();
						}

						if ($('#legends').hasClass("in")) {
							$('#legend-title').click();
						}
					}
				}
			}else{
				refreshMenu(Publish.data[id]);
				mdata.setMap(map);
				layers.push(id);

				if(!$('#properties').hasClass("in")){
					$('#description-title').click();
				}

				if(!$('#legends').hasClass("in")){
					$('#legend-title').click();
				}
			}
		}else{
			$loader.fadeIn();
			var url = Publish.path + id + ".geojson";
			$.getJSON(url, function(geojson){
				mdata = new google.maps.Data();
				var selected = Publish.data[id];
				var property = selected.select || id;
				var colors = selected.color;
				initLabel(selected, id);

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

				refreshMenu(selected);
				layers.push(id);
			}).always(function() {
				$loader.fadeOut();
			});
		}

		$("i", this).toggleClass("highlight");
	}

	function initialZoom($layers) {
		var XHRs = [];
		var bounds = new google.maps.LatLngBounds();
		$loader.fadeIn();
		$layers.each(function(_, el) {
			var id = el.id;
			var selected = Publish.data[id];
			initLabel(selected, id);

			var url = Publish.path + id + ".geojson";
			XHRs.push($.getJSON(url, function(geojson){
				var mdata = new google.maps.Data();
				var property = selected.select || id;
				var colors = selected.color;

				mdata.addGeoJson(geojson);
				mdata.forEach(function(feature){
					var geom = feature.getGeometry();
					var type = geom.getType();
					if(type === "Point" || type === "MultiPoint"){
						feature.setProperty("icon", selected.icon);
					}else{
						if($.type(colors) == "object"){
							feature.setProperty("color", colors[feature.getProperty(property)]);
						}else{
							feature.setProperty("color", colors);
						}

						feature.setProperty("border", selected.border);
						feature.setProperty("width", selected.width);
					}

					geom.forEachLatLng(function(coordinate){
						bounds.extend(coordinate);
					});
				});

				mdata.setStyle(setStyle);
				mdata.addListener("click", function(event){
					if(selected.geom && (selected.geom === "Point" || selected.geom === "MultiPoint")){
						var select = event.feature.getProperty(selected.select);
						if($.type(select) == "string"){
							select = select.replace(/\s/g, "-");
						}

						$('#modal-report-' + id + select).modal('show');
					}else{
						$('#modal-report-' + id).modal('show');
					}
				});

				data[id] = mdata;
				if(selected.visible){
					$('#' + id).children('i').toggleClass("highlight");
					mdata.setMap(map);
					layers.push(id);
				}
			}));
		});

		$.when.apply($, XHRs).done(function() {
			map.fitBounds(bounds);

			var id = layers[0];
			if(id){
				refreshMenu(Publish.data[id]);
			}
		}).always(function() {
			$loader.fadeOut();
		});
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

		$layers = $('#layers').find(':button');
		$layers.click(onClick);

		if(!Publish.zoom){
			google.maps.event.addListenerOnce(map, "idle", function(){
				initialZoom($layers);
			});
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

	function initLabel(selected, id) {
		if (!selected.label) {
			selected.label = {};
			selected.label[id] = selected.color;
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

	$(window).on('resize', applyMargins);
	$('#modal-app-description').modal('show');

	applyInitialUIState();
	applyMargins();
});
