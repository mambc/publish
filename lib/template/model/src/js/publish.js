$(function () {
	var map;
	var data = {};
	var layers = [];
	var layersName = {};
	var menu;
	var $legend = $('#legend');
	var $loader = $('#loader');
	var $description = $('#layer-description');
	var $properties = $('#properties');
	var $legends = $('#legends');
	var $descriptionTitle = $('#description-title');
	var $legendTitle = $('#legend-title');
	var $downloadTitle = $('#download-title');
	var $panelDownload = $('#panel-download');

	function addLegendContent(lengend, color, label) {
		var $div = $('<div style="height:25px;">')
			.append($('<div class="legend-color-box">').css({backgroundColor: color}))
			.append($('<span>').css("lineHeight", "23px").html(label));
		lengend.append($div);
	}

	function renderLegend(label) {
		$legend.empty();
		$legendTitle.text(" " + Publish.legend);

		var keys = [];
		$.each(label, function (text) {
			keys.push(text);
		});

		keys.sort();
		$.each(keys, function (_, text) {
			var color = label[text];
			addLegendContent($legend, color, text);
		});
	}

	function refreshMenu(selected, layer) {
		var label = selected.label;
		var title = layer || "Description";
		$descriptionTitle.text(" " + title);
		$description.text(selected.description || "");
		renderLegend(label);
	}

	function setStyle(feature) {
		return {
			fillColor: feature.getProperty("color"),
			strokeColor: feature.getProperty("border"),
			strokeWeight: feature.getProperty("width"),
			zIndex: feature.getProperty("order"),
			icon: feature.getProperty("icon")
		};
	}

	function setFeatureProperties(feature, selected, geom) {
		geom = geom || feature.getGeometry();
		var type = selected.geom || geom.getType();

		if(selected.icon && (type === "Point" || type === "MultiPoint")) {
			feature.setProperty("icon", selected.icon.options);
		} else {
			var property = selected.select || selected.id;
			var colors = selected.color;

			if ($.type(colors) == "object") {
				feature.setProperty("color", colors[feature.getProperty(property)]);
			} else {
				feature.setProperty("color", colors);
			}

			feature.setProperty("border", selected.border);
			feature.setProperty("width", selected.width);
		}

		feature.setProperty("order", selected.order);
		return geom;
	}

	function setFeatureStyle(gdata, selected) {
		var id = selected.id;
		gdata.setStyle(setStyle);
		gdata.addListener("click", function (event) {
			if (selected.geom && (selected.geom === "Point" || selected.geom === "MultiPoint")) {
				var select = event.feature.getProperty(selected.select);
				if ($.type(select) == "string") {
					select = select.replace(/\s/g, "-");
				}

				$('#modal-report-' + id + select).modal('show');
			} else {
				$('#modal-report-' + id).modal('show');
			}
		});

		data[id] = gdata;
	}

	function changeLayer(id) {
		var mdata = data[id];
		if (mdata) {
			if (mdata.getMap()) {
				mdata.setMap(null);
				setCheckbox(id, false);
			} else {
				mdata.setMap(map);
				setCheckbox(id, true);
				changeMenu(id, $properties.hasClass("in"), $legends.hasClass("in"));
			}
		} else {
			$loader.fadeIn();
			var url = Publish.path + id + ".geojson";
			$.getJSON(url, function (geojson) {
				mdata = new google.maps.Data();
				var selected = Publish.data[id];
				initLabel(selected);

				mdata.addGeoJson(geojson);
				setDataProperties(mdata, selected);
				mdata.setMap(map);

				setCheckbox(id, true);
				changeMenu(id, $properties.hasClass("in"), $legends.hasClass("in"));
			}).always(function () {
				$loader.fadeOut();
			});
		}

		return id;
	}

	function disableMenu($propertiesHasClass, $legendsHasClass) {
		menu = null;
		$legend.empty();
		$description.empty();
		$descriptionTitle.text(" Description");
		$panelDownload.hide();

		if ($propertiesHasClass) {
			$descriptionTitle.click();
			$descriptionTitle.prop('disabled', true);
		}

		if ($legendsHasClass) {
			$legendTitle.click();
			$legendTitle.prop('disabled', true);
		}
	}

	function changeMenu(id, $propertiesHasClass, $legendsHasClass) {
		menu = id;
		var selected = Publish.data[id];
		refreshMenu(selected, layersName[id]);

		if (!$propertiesHasClass) {
			$descriptionTitle.prop('disabled', false);
			$descriptionTitle.click();
		}

		if (!$legendsHasClass) {
			$legendTitle.prop('disabled', false);
			$legendTitle.click();
		}

		if (selected.download) {
			var filename = id + ".zip";
			$downloadTitle.prop('href', Publish.path + filename);
			$downloadTitle.prop('download', filename);
			$panelDownload.show();
		} else {
			$panelDownload.hide();
		}
	}

	function onClick(event) {
		var id = event.target.id;
		if (id) {
			var $propertiesHasClass = $properties.hasClass("in");
			var $legendsHasClass = $legends.hasClass("in");
			if (menu === id) {
				disableMenu($propertiesHasClass, $legendsHasClass);
			} else {
				changeMenu(id, $propertiesHasClass, $legendsHasClass);
			}
		} else if(event.target.name) {
			changeLayer(event.target.name);
		}
	}

	function animatedLine(polyline, interval) {
		var counter = 0;
		window.setInterval(function() {
			counter = (counter + 1) % 200;
			var arrows = polyline.get('icons');
			arrows[0].offset = (counter / 2) + '%';
			polyline.set('icons', arrows);
		}, interval);
	}

	function createPolyline(selected, line) {
		var options = selected.icon.options;
		var path = [];

		line.forEachLatLng(function (latLong) {
			path.push(latLong);
		});

		var symbol = {
			path : options.path,
			anchor: new google.maps.Point(175,175),
			scale: 0.1,
			fillColor: options.fillColor,
			fillOpacity: options.fillOpacity,
			strokeWeight: options.strokeWeight
		};

		var lineOptions = {
			path: path,
			icons: [{icon: symbol}],
			strokeWeight: 3,
			strokeColor: selected.border,
			strokeOpacity: selected.transparency
		};

		return new google.maps.Polyline(lineOptions);
	}

	function drawPolyline(polyline, interval) {
		polyline.setMap(map);
		animatedLine(polyline, interval);
	}

	function setPolylineProperties(gdata, selected) {
		gdata.forEach(function (feature) {
			var geom = feature.getGeometry();
			if(selected.geom == "LineString") {
				drawPolyline(createPolyline(selected, geom), selected.icon.time);
			} else if (selected.geom == "MultiLineString") {
				$.each(geom.getArray(), function (_, line) {
					drawPolyline(createPolyline(selected, line), selected.icon.time);
				});
			}
		});
	}

	function setDataProperties(gdata, selected, _sof_) {
		gdata.forEach(function (feature) {
			var geom = feature.getGeometry();
			setFeatureProperties(feature, selected, geom);
			if(_sof_) _sof_(geom);
		});

		setFeatureStyle(gdata, selected);
	}

	function initialZoom(dataset) {
		var XHRs = [];
		var bounds = new google.maps.LatLngBounds();
		$loader.fadeIn();
		$.each(dataset, function (id, selected) {
			initLabel(selected);

			var url = Publish.path + id + ".geojson";
			XHRs.push($.getJSON(url, function (geojson) {
				var mdata = new google.maps.Data();
				mdata.addGeoJson(geojson);

				if (selected.geom === "LineString" || selected.geom === "MultiLineString") {
					setPolylineProperties(mdata, selected);
				} else {
					setDataProperties(mdata, selected, function (geom) {
						geom.forEachLatLng(function (coordinate) {
							bounds.extend(coordinate);
						});
					});

					if (selected.visible) {
						mdata.setMap(map);
						setCheckbox(selected.id, true);
					}
				}
			}));
		});

		$.when.apply($, XHRs).done(function () {
			map.fitBounds(bounds);
		}).always(function () {
			$loader.fadeOut();
		});
	}

	function startMenu() {
		var $layers = $('#layers').find(':button');
		$layers.each(function (_, btn) {
			layersName[btn.id] = btn.innerText;
		});

		$layers.click(onClick);
		$descriptionTitle.prop('disabled', true);
		$legendTitle.prop('disabled', true);
		$panelDownload.hide();
	}

	function initMap() {
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

		if (Publish.center) {
			mapOptions.center = new google.maps.LatLng(Publish.center.lat, Publish.center.long);
		}

		if (Publish.zoom) {
			mapOptions.zoom = Publish.zoom;
		}

		var mapElement = document.getElementById("map");
		map = new google.maps.Map(mapElement, mapOptions);
		map.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push($('#footer')[0]);

		if (!Publish.zoom) {
			google.maps.event.addListenerOnce(map, "idle", function () {
				initialZoom(Publish.data);
			});
		}

		startMenu();
	}

	google.maps.event.addDomListener(window, "load", initMap);

	function applyMargins() {
		var leftToggler = $('.mini-submenu-left');
		if (leftToggler.is(':visible')) {
			$('#map').find('.ol-zoom')
				.css('margin-left', 0)
				.removeClass('zoom-top-opened-sidebar')
				.addClass('zoom-top-collapsed');
		} else {
			$('#map').find('.ol-zoom')
				.css('margin-left', $('.sidebar-left').width())
				.removeClass('zoom-top-opened-sidebar')
				.removeClass('zoom-top-collapsed');
		}
	}

	function isConstrained() {
		return $('.sidebar').width() == $(window).width();
	}

	function applyInitialUIState() {
		if (isConstrained()) {
			$('.sidebar-left .sidebar-body').fadeOut('slide');
			$('.mini-submenu-left').fadeIn();
		}
	}

	function initLabel(selected) {
		if (!selected.label) {
			selected.label = {};
			selected.label[selected.id] = selected.color;
		}
	}

	function setCheckbox(id, value) {
		$('#' + id).children('input').prop('checked', value);
	}

	$('.sidebar-left .slide-submenu').on('click', function () {
		var thisEl = $(this);
		thisEl.closest('.sidebar-body').fadeOut('slide', function () {
			$('.mini-submenu-left').fadeIn();
			applyMargins();
		});
	});

	$('.mini-submenu-left').on('click', function () {
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
