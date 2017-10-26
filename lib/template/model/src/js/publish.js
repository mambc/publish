$(function () {
	var map, menu;
	var data = {};
	var layersName = {};
	var $legend = $('#legend');
	var $loader = $('#loader');
	var $loaderMessage =$('#loader-message');
	var $loaderMessageText =$('#loader-message-text');
	var $description = $('#layer-description');
	var $properties = $('#properties');
	var $legends = $('#legends');
	var $descriptionTitle = $('#description-title');
	var $legendTitle = $('#legend-title');
	var $downloadTitle = $('#download-title');
	var $panelDownload = $('#panel-download');
	var $leftToggler = $('.mini-submenu-left');
	var $sidebar = $('.sidebar');
	var $sidebarLeftBody = $('.sidebar-left .sidebar-body');
	var $sidebarLeftSubmenu = $('.sidebar-left .slide-submenu');
	var $modalDescription = $('#modal-app-description');
	var $modalCompletedDescription = $("#modal-completed-description");
	var $modalTitleDescription = $("#modal-title-description");
	var $infoDescription = $("#info-description");
	var $map = $('#map');
	var $more = $('#more');

	function addLegendContent(lengend, color, label) {
		var $div = $('<div style="height:25px;">');
		if (color.endsWith(".png")) {
			$div.append($('<div class="legend-img-box">').css('background-image', 'url(' + color + ')'));
		} else {
			$div.append($('<div class="legend-color-box">').css({backgroundColor: color}));
		}

		$div.append($('<span>').css("lineHeight", "23px").html(label));
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
		var sentences = selected.description.split('.');
		var firstSentence = sentences[0] ? sentences[0] + "." : "";
		
		var navBar = $(".navbar").height() + 40;
		
		var proportionLayer = ((($('#map').height()-navBar)*40)/100);
		var proportion = ((($('#map').height()-navBar)*20)/100);
		
		if ($("#layers").height() < proportionLayer)
			proportion = ((($('#map').height()-navBar)*30)/100);
				
		$("#layers").css('max-height', proportionLayer);
		$("#properties").css('max-height',proportion);
		$("#legends").css('max-height',proportion);
		
		if ((sentences.length-1) > 1)
			$("#more").show();
		else
			$("#more").hide();
		
		$descriptionTitle.text(" " + title);
		$description.text(firstSentence || "");
		
		$modalTitleDescription.text(" " + title);
		$infoDescription.text(selected.description || "");
		
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
		var type = selected.geom || feature.getGeometry().getType();
		var select = getSelect(selected, 1);

		if (selected.icon && (type === "Point" || type === "MultiPoint")) {
			var icon = selected.icon.options[feature.getProperty(select)];
			if (!icon) {
				icon = selected.icon.path;
			}

			feature.setProperty("icon", icon);
		} else {
			var property = select || selected.id;
			var colors = selected.color;

			if ($.type(colors) === "object") {
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
		if (selected.report) {
			gdata.addListener("click", function (event) {
				if (selected.report === "function") {
					var select = event.feature.getProperty(getSelect(selected, 0));
					if ($.type(select) === "string") {
						select = select.replace(/\s/g, "");
					}

					$('#modal-report-' + id + select).modal('show');
				} else {
					$('#modal-report-' + id).modal('show');
				}
			});
		}

		data[id] = gdata;
	}

	function changePolylineLayer(id, path, time) {
		$.each(path, function (_, pol) {
			if (pol.getVisible()) {
				removePolyline(id, pol);
			} else {
				drawPolyline(id, pol, time);
				changeMenu(id, $properties.hasClass("in"), $legends.hasClass("in"));
			}
		});
	}

	function isLineString(element) {
		return element.geom === "LineString";
	}

	function isMultiLineString(element) {
		return element.geom === "MultiLineString";
	}

	function isLineStringOrMultiLineString(element) {
		return isLineString(element) || isMultiLineString(element);
	}

	function loadData(layer, selected) {
		var url = Publish.path + layer + ".geojson";
		return $.getJSON(url, function (geojson) {
			var mdata = new google.maps.Data();
			mdata.addGeoJson(geojson);

			if (isLineStringOrMultiLineString(selected)) {
				setPolylineProperties(mdata, selected);
			} else {
				setDataProperties(mdata, selected);
				mdata.setMap(map);
				setCheckbox(layer, true);
			}
		});
	}

	function changeLayer(id) {
		var mdata = data[id];
		var selected = Publish.data[id];
		if (mdata) {
			if (isLineStringOrMultiLineString(selected)) {
				var time = selected.icon.time;
				if (isLineString(selected)) {
					changePolylineLayer(selected.id, mdata, time);
				} else {
					$.each(mdata, function (_, path) {
						changePolylineLayer(selected.id, path, time);
					});
				}
			} else {
				if (mdata.getMap()) {
					mdata.setMap(null);
					setCheckbox(id, false);
				} else {
					mdata.setMap(map);
					setCheckbox(id, true);
					changeMenu(id, $properties.hasClass("in"), $legends.hasClass("in"));
				}
			}
		} else {
			enableLoaderMessage();
			$loaderMessageText.empty();
			addLoaderMessage(id, 1, 1);
			loadData(id, selected).done(function () {
				changeMenu(id, $properties.hasClass("in"), $legends.hasClass("in"));
			}).always(function () {
				disableLoaderMessage();
			});
		}
	}

	function disableMenu($propertiesHasClass, $legendsHasClass) {
		menu = null;
		$legend.empty();
		$description.empty();
		$descriptionTitle.text(" Description");
		$panelDownload.hide();
		$("button").removeClass("button-selected");
		
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
		
		$("button").removeClass("button-selected");
		$("#"+ id).addClass('button-selected');
	}

	function onLayersClick(event) {
		var id = event.target.id;
		if (id) {
			var $propertiesHasClass = $properties.hasClass("in");
			var $legendsHasClass = $legends.hasClass("in");
			if (menu === id) {
				disableMenu($propertiesHasClass, $legendsHasClass);
			} else {
				changeMenu(id, $propertiesHasClass, $legendsHasClass);
			}
		} else {
			id = event.target.name;
			if (!id) return;

			var groups = Publish.group;
			if (groups) {
				var group = Publish.data[id].group;
				var active = groups[group];
				if (!active) {
					groups[group] = id;
					changeLayer(id);
				} else {
					changeLayer(active);
					if (active === id) {
						groups[group] = null;
					} else {
						groups[group] = id;
						changeLayer(id);
					}
				}
			} else {
				changeLayer(id);
			}
		}
	}

	function animatedLine(id, polyline, interval) {
		var counter = 0;
		var func = setInterval(function () {
			counter = (counter + 1) % 200;
			var arrows = polyline.get('icons');
			arrows[0].offset = (counter / 2) + '%';
			polyline.set('icons', arrows);
		}, interval);

		if (!window.intervals) {
			window.intervals = {};
		}

		if (!window.intervals[id]) {
			window.intervals[id] = [];
		}

		window.intervals[id].push(func);
	}

	function createPolyline(selected, line) {
		var options = selected.icon.options;
		var path = [];

		line.forEachLatLng(function (latLong) {
			path.push(latLong);
		});

		var symbol = {
			path: options.path,
			anchor: new google.maps.Point(175, 175),
			scale: 0.1,
			fillColor: options.fillColor,
			fillOpacity: options.fillOpacity,
			strokeWeight: options.strokeWeight
		};

		var lineOptions = {
			path: path,
			icons: [{icon: symbol}],
			strokeWeight: selected.width,
			strokeColor: selected.border || selected.color,
			strokeOpacity: selected.transparency
		};

		return new google.maps.Polyline(lineOptions);
	}

	function drawPolyline(id, polyline, interval) {
		polyline.setMap(map);
		polyline.setVisible(true);
		animatedLine(id, polyline, interval);
	}

	function removePolyline(id, polyline) {
		polyline.setMap(null);
		polyline.setVisible(false);

		if (window.intervals) {
			$.each(window.intervals[id], function (_, func) {
				clearInterval(func);
			});
		}
	}

	function setPolylineProperties(gdata, selected) {
		var path = [];
		var visible = selected.visible;
		var time = selected.icon.time;
		gdata.forEach(function (feature) {
			var geom = feature.getGeometry();
			if (isLineString(selected)) {
				var pol = createPolyline(selected, geom);
				path.push(pol);
				if (visible) drawPolyline(selected.id, pol, time);
			} else if (isMultiLineString(selected)) {
				var points = [];
				$.each(geom.getArray(), function (_, line) {
					var pol = createPolyline(selected, line);
					points.push(pol);
					if (visible) drawPolyline(selected.id, pol, time);
				});

				path.push(points);
			}
		});

		data[selected.id] = path;
		if (visible) setCheckbox(selected.id, true);
	}

	function setDataProperties(gdata, selected) {
		gdata.forEach(function (feature) {
			setFeatureProperties(feature, selected);
		});

		setFeatureStyle(gdata, selected);
	}

	function getLoadMessage(id, actual, total) {
		return "Loading" + layersName[id] + " (" + actual + "/" + total + ")";
	}

	function addLoaderMessage(id, actual, total) {
		var message = getLoadMessage(id, actual, total);
		$loaderMessageText.text(message);
	}

	function enableLoaderMessage() {
		$loader.fadeIn();
		$loaderMessage.css('z-index', 10000000);
	}

	function disableLoaderMessage() {
		$loader.fadeOut();
		$loaderMessageText.empty();
		$loaderMessage.css('z-index', -1);
	}

	function getInitialZoom(zoom, zoomMax) {
		if ($.type(zoom) === "number") {
			return zoom;
		}

		function getZoom(mapPx, worldPx, fraction) {
			return Math.floor(Math.log(mapPx / worldPx / fraction) / Math.LN2);
		}

		var latZoom = getZoom($map.height(), zoom.yTile, zoom.latFraction);
		var longZoom = getZoom($map.width(), zoom.xTile, zoom.longFraction);
		return Math.min(latZoom, longZoom, zoomMax);
	}

	function loadInitialData(dataset) {
		var XHRs = [];
		var actual = 0;
		var total = Object.keys(dataset).length;

		enableLoaderMessage();
		$.each(dataset, function (id, selected) {
			initLabel(selected);
			if (!selected.visible) {
				return true;
			}

			actual += 1;
			$loaderMessageText.empty();
			addLoaderMessage(id, actual, total);
			XHRs.push(loadData(id, selected));
		});

		$.when.apply($, XHRs).always(function () {
			disableLoaderMessage();
		});
	}

	function initMap() {
		google.maps.visualRefresh = true;
		var mapOptions = {
			center: new google.maps.LatLng(Publish.center.lat, Publish.center.long),
			zoom: getInitialZoom(Publish.zoom, Publish.maxZoom),
			minZoom: Publish.minZoom,
			maxZoom: Publish.maxZoom,
			mapTypeId: google.maps.MapTypeId[Publish.mapTypeId],
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
				position: google.maps.ControlPosition.TOP_RIGHT
			}
		};

		map = new google.maps.Map($map[0], mapOptions);
		map.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push($('#footer')[0]);
		startMenu();

		google.maps.event.addListenerOnce(map, "idle", function () {
			loadInitialData(Publish.data);
		});
	}

	google.maps.event.addDomListener(window, "load", initMap);

	function startMenu() {
		var $panelLayers = $('#layers');
		var $layers = $panelLayers.find(':button');
		$layers.each(function (_, btn) {
			layersName[btn.id] = btn.innerText;
		});

		$layers.click(onLayersClick);
		$descriptionTitle.prop('disabled', true);
		$legendTitle.prop('disabled', true);
		$panelDownload.hide();
	}

	function applyMargins() {
		if ($leftToggler.is(':visible')) {
			$map.find('.ol-zoom')
				.css('margin-left', 0)
				.removeClass('zoom-top-opened-sidebar')
				.addClass('zoom-top-collapsed');
		} else {
			var $sidebarLeft = $('.sidebar-left');
			$map.find('.ol-zoom')
				.css('margin-left', $sidebarLeft.width())
				.removeClass('zoom-top-opened-sidebar')
				.removeClass('zoom-top-collapsed');
		}

		if ($('#logo')) {
			var navDefaultHeight = 50;
			var navHeight = $('.navbar').height() - navDefaultHeight;
			$('body').css('padding-top', navHeight);
			$leftToggler.css('margin-top', navHeight);
		}
	}

	function isConstrained() {
		return $sidebar.width() === $(window).width();
	}

	function applyInitialUIState() {
		if (isConstrained()) {
			$sidebarLeftBody.fadeOut('slide');
			$leftToggler.fadeIn();
		}
	}

	function initLabel(selected) {
		if (!selected.label) {
			selected.label = {};
			selected.label[selected.id] = selected.color || selected.border;
		}
	}

	function setCheckbox(id, value) {
		$('#' + id).children('input').prop('checked', value);
	}

	function getSelect(selected, idx) {
		if ($.type(selected.select) === "array") {
			return selected.select[idx];
		}

		return selected.select;
	}

	$sidebarLeftSubmenu.on('click', function () {
		var thisEl = $(this);
		thisEl.closest('.sidebar-body').fadeOut('slide', function () {
			$leftToggler.fadeIn();
			applyMargins();
		});
	});

	$leftToggler.on('click', function () {
		var thisEl = $(this);
		$sidebarLeftBody.toggle('slide');
		thisEl.hide();
		applyMargins();
	});

	$more.on('click', function () {
		$modalCompletedDescription.modal('show') ;
	});

	$(window).on('resize', applyMargins);
	$modalDescription.modal('show');

	applyInitialUIState();
	applyMargins();
});
