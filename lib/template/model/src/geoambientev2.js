var geoambiente = geoambiente || {};
geoambiente.maps = {};

/** @global */
geoambiente.layers = geoambiente.layers || [];
geoambiente.events = geoambiente.events || {};

/** @global */
geoambiente.features = geoambiente.features || [];
geoambiente.services = geoambiente.services || [];
geoambiente.idx = geoambiente.idx || -1;
geoambiente.infowindow = geoambiente.infowindow || {};

/** @global */
geoambiente.proxy = geoambiente.proxy || 'proxy.ashx';

//types
geoambiente.servicesTypes = geoambiente.servicesTypes || {};
geoambiente.servicesTypes.Wms = "WmsLayer";
geoambiente.servicesTypes.Tiled = "TiledLayer";

/**
 * WmsLayer responsavel por conectar em servicos WMS
 * @author Mateus Pontes & Danilo Palomo
 * @requires module:google.maps
 * @version 2.0.0
 * @namespace
 * @constructs WmsLayer
 * @param {Object} options - Parametros de entrada:
 * @property {google.maps}  options.map  - Instancia obrigatoria do Google Maps
 * @property {string}  options.url  - Url do servico do WMS
 * @property {string}  options.bbox  - Ao usar o bbox o servico respondera somente pelo bbox informado e nao mais pelo mapa instanciado 
 * @property {string}  options.layer  - Layer do servico WMS
 * @property {boolean}  options.tiled  - Por default eh FALSE
 * @property {string}  options.format  - Formato da imagem do WMS por default eh image/png
 * @property {string}  options.url_optional  - Informa outros parametros da URL do servico
 * @property {number}  options.opacity  - Transparencia da camada (0 ate 1)
 * @property {Object}  options.infowindow  - Objeto responsavel por informar a URL do servico de GetFeatureInfo
 * @property {String}  options.infowindow.url  - Url do servico GetFeatureInfo
 * @property {boolean}  options.visibility  - Informa se a camada sera carregada no mapa de forma visivel ou nao, por default eh TRUE
 * @returns {WmsLayer}
 * @example
 * //exemplo da chamada da API (carregando um servico)
 * var solo = new geoambiente.maps.WmsLayer({
      url: 'http://<server:port>/geoserver/wms',
      layer: '<layers>',      
      map: map //map -> instancia do google maps
    });

//exemplo da chamada da API (carregando um servico com infowindow)
var solo = new geoambiente.maps.WmsLayer({
      url: 'http://<server:port>/geoserver/wms',
      layer: '<layers>',  
      infowindow: {url: 'http://<server:port>/geoserver/wms'},
      map: map //map -> instancia do google maps
});

//exemplo da chamada da API (carregando um servico nao visivel)
var solo = new geoambiente.maps.WmsLayer({
      url: 'http://<server:port>/geoserver/wms',
      layer: '<layers>',  
      visibility: false,
      map: map //map -> instancia do google maps
});
 */
geoambiente.maps.WmsLayer = function (options) {

    if ($ == null) {
        throw Error('geoambiente.maps.WmsLayer jQuery is not declared.');
    }

    if (options == null) {
        throw Error('geoambiente.maps.WmsLayer parameters declared.');
    }

    if (options.map == null) {
        throw Error('geoambiente.maps.WmsLayer google maps instance not declared.');
    }
    
    var _settings = {        
        map: null,    
        url: null,
        bbox: null,
        suppressinfowindows: false,
        layer: null,
        transparent: true,
        filter: null,
        tiled: true,
        format: 'image/png',
        url_optional: '',
        opacity: 0.8,
        infowindow: {},
        visibility: true
    };

    $.extend(_settings, options);

    this.layerId = _settings.layer;
    this.layerKey = _generateHexString();

    /**
     * @private     
     */
    function _getWmsUrl() {
        return _settings.url;
    }

    function _getMap() {
        return _settings.map;
    }

    function _getVisibility() {
        return _settings.visibility;
    }

    function _setVisibility(opt) {
        _settings.visibility = opt;
    }

    this.loadLayer = function () {
        this.geoLayer =
                      new google.maps.ImageMapType(
                               {
                                   getTileUrl:
                                function (coord, zoom) {

                                    var s = Math.pow(2, zoom);
                                    var twidth = 256;
                                    var theight = 256;
									
									if (coord.x < 0 || coord.y < 0) return;
									if (coord.x >= (1 << zoom) || coord.y >= (1 << zoom)) return;
									
									
									// Calculo BBox para o gridset EPSG:900913
									initialResolution = 2 * Math.PI * 6378137 / 256;  // == 156543.0339
									originShift = 2 * Math.PI * 6378137 / 2.0; // == 20037508.34
									res = initialResolution / Math.pow(2, zoom);
						
									var tileTMS = new google.maps.Point();
									tileTMS.x = coord.x;
									tileTMS.y = ((1 << zoom) - coord.y - 1); // TMS
									
									var bbox =  (tileTMS.x*256 * res - originShift) + "," + (tileTMS.y*256 * res - originShift) +
									"," + ((tileTMS.x+1)*256 * res - originShift) + "," + ((tileTMS.y+1)*256 * res - originShift);

                                    //base WMS URL
                                    var url = _settings.url + "?";

                                    url += "&service=WMS";           //WMS service
                                    url += "&version=" + '1.1.1';         //WMS version 
                                    url += "&request=GetMap";        //WMS operation
                                    url += "&layers=" + _settings.layer; //WMS layers to draw
                                    url += "&format=" + _settings.format;      //image format
                                    url += "&tiled=" + _settings.tiled;      //image format
                                    url += "&TRANSPARENT=" + _settings.transparent;      //only draw areas where we have data
                                    url += "&srs=EPSG:900913";         //projection WGS84
                                    url += "&bbox=" + bbox;          //set bounding box for tile

                                    if (_settings.url_optional != '')
                                        url += "&" + _settings.url_optional + "&"

                                    url += "&width=256";             //tile size used by google
                                    url += "&height=256";

                                    return url;                 //return WMS URL for the tile  
                                },
                                   tileSize: new google.maps.Size(256, 256),
                                   opacity: _settings.opacity,
                                   isPng: true
                               });

        this.geoLayer.name = _settings.layer;
        this.geoLayer.settings = _settings;

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        if (index == -1)
            geoambiente.layers.push(this.geoLayer);

        index = $.inArray(this.geoLayer, geoambiente.layers);

        if (_settings.visibility)
        	_settings.map.overlayMapTypes.setAt(index, this.geoLayer);
        else
        	_settings.map.overlayMapTypes.setAt(index, null);

        if (jQuery.isEmptyObject(geoambiente.events)) {
            geoambiente.events = google.maps.event.addListener(map, 'click', function (evt) {
                geoambiente.infowindowExecute(evt);
            });
        }
    }

    this.loadLayer();
    this.context = this;

    /**
     * Metodo responsavel pela URL do servico instanciado WmsLayer.getWmsUrl()     
     * @return {string} Url do servico
     * @example
     * //retorna a Url do servico WMS
     * wmsLayer.getWmsUrl();
     */
    this.getWmsUrl = function () {
        return _getWmsUrl();
    },

    /**
     * Metodo responsavel por informar se a layer esta visivel ou nao no mapa WmsLayer.getVisibility()     
     * @return {boolean} Informa se a layer esta visivel ou nao no mapa (true = sim, false = no)
     * @example
     * //Informa se a layer esta visivel ou nao no mapa
     * wmsLayer.getVisibility();
     */
    this.getVisibility = function () {
        return _getVisibility();
    }

    /**
     * Retorna a instancia do mapa instanciado WmsLayer.getMap()     
     * @return {google.maps} Retorna a instancia do Google Maps
     * @example
     * //Retorna a instancia do Google Maps
     * wmsLayer.getMap();
     */
    this.getMap = function () {
        return _getMap();
    }

    /**
     * Metodo responsavel por deixar uma camada visivel ou nao WmsLayer.setMap(layer)     
     * @param {google.maps | null} options - Parametros de entrada (deixar layer visivel informar a instancia do Mapa ou invisivel passar null)     
     * @example
     * //Layer visivel
     * wmsLayer.setMap(map);
     *
     * //Layer oculta
     * wmsLayer.setMap(null);
     */
    this.setMap = function (layer) {

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        if (layer == null) {
        	_settings.map.overlayMapTypes.setAt(index, null);
            _setVisibility(false);
        }
        else {
        	_settings.map.overlayMapTypes.setAt(index, this.geoLayer);
            _setVisibility(true);
        }
    },

    this.destroy = function () {

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        _settings.map.overlayMapTypes.removeAt(index);
        geoambiente.layers.splice(index, 1);
    }

     /**
     * Metodo responsavel por ordenar as camadas instanciadas no mapa WmsLayer.reorder(new_index)     
     * @param {integer} options - Parametros de entrada (deixar layer visivel informar a instancia do Mapa ou invisivel passar null)     
     * @example
     * 
     * var solo = new geoambiente.maps.WmsLayer({
          url: 'http://130.211.121.219:8080/geoserver/teste/wms',
          layer: 'teste:Areas_Risco_Areal',      
          map: map //map -> instancia do google maps
       });

    var pontos = new geoambiente.maps.WmsLayer({
          url: 'http://130.211.121.219:8080/geoserver/teste/wms',
          layer: 'teste:PontosDeRisco',      
          map: map //map -> instancia do google maps
    });

       solo.reorder(0); //ordena a instancia do solo para o ultimo nivel.
     */
    this.reorder = function (new_index) {
        var old_index = $.inArray(this.geoLayer, geoambiente.layers);

        if (new_index >= geoambiente.layers.length) {
            var k = new_index - geoambiente.layers.length;
            while ((k--) + 1) {
                geoambiente.layers.push(undefined);
            }
        }

        geoambiente.layers.splice(new_index, 0, geoambiente.layers.splice(old_index, 1)[0]);

        _settings.map.overlayMapTypes.clear();

        for (var key in geoambiente.layers) {            
            if (geoambiente.layers[key].settings.visibility) {
            	_settings.map.overlayMapTypes.setAt(key, geoambiente.layers[key]);
            }
        }
    }
};

/**
 * TiledLayer responsavel por acessar diretamente as imagens do servidor
 * @requires module:google.maps
 * @namespace
 * @constructs TiledLayer
 * @param {Object} options - Parametros de entrada:
 * @property {google.maps}  options.map  - Instancia obrigatoria do Google Maps
 * @property {string}  options.url  - Url do servico do WMS  
 * @property {string}  options.formatImage  - Formato da imagem do WMS por default eh png 
 * @property {number}  options.opacity  - Transparencia da camada (0 ate 1)
 * @property {Object}  options.infowindow  - Objeto responsavel por informar a URL do servico de GetFeatureInfo
 * @property {String}  options.infowindow.url  - Url do servico GetFeatureInfo 
 * @returns {TiledLayer}
 * @example
 * //exemplo da chamada da API (carregando um servico)
 * var layer = new geoambiente.maps.GwcLayer({
      url: 'http://130.211.170.236:8583/geoserver/gwc/service/gmaps',
      layer: 'cetesb:COMGAS_Rede_Completa',
      visibility: false,
      map: map
    })
 */
geoambiente.maps.TiledLayer = function (options) {
    if ($ == null) {
        throw Error('geoambiente.maps.WmsLayer jQuery is not declared.');
    }

    if (options == null) {
        throw Error('geoambiente.maps.WmsLayer parameters declared.');
    }

    if (options.map == null) {
        throw Error('geoambiente.maps.WmsLayer google maps instance not declared.');
    }

    var _settings = {
        map: null,
        url: null,
        formatImage: 'png',
        infowindow: {}
    };

    $.extend(_settings, options);

    this.layerKey = _generateHexString();

    // privates functions
    function _getWmsUrl() {
        return _settings.url;
    }

    function _getMap() {
        return _settings.map;
    }

    function _getVisibility() {
        return _settings.visibility;
    }

    function _setVisibility(opt) {
        _settings.visibility = opt;
    }

    function getNormalizedCoord(coord, zoom) {
        var y = coord.y;
        var x = coord.x;

        // tile range in one direction range is dependent on zoom level
        // 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc
        var tileRange = 1 << zoom;

        // don't repeat across y-axis (vertically)
        if (y < 0 || y >= tileRange) {
            return null;
        }

        // repeat across x-axis
        if (x < 0 || x >= tileRange) {
            x = (x % tileRange + tileRange) % tileRange;
        }

        return {
            x: x,
            y: y
        };
    }

    this.loadLayer = function () {
        this.geoLayer =
                      new google.maps.ImageMapType(
                               {
                                   getTileUrl:
                                function (coord, zoom) {


                                    var s = Math.pow(2, zoom);
                                    var twidth = 256;
                                    var theight = 256;

                                    var dim = Math.pow(2, zoom);

                                    var normalizedCoord = getNormalizedCoord(coord, zoom);
                                    var bound = Math.pow(2, zoom);

                                    var z = zoom;
                                    var x = normalizedCoord.x;
                                    var y = (bound - normalizedCoord.y - 1);

                                    //base WMS URL
                                    var url = _settings.url + "/" + z + "/" + x + "/" + y + "." + _settings.formatImage;
                                    return url;
                                },
                                   tileSize: new google.maps.Size(256, 256),
                                   isPng: true
                               });

        this.geoLayer.settings = _settings;

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        if (index == -1)
            geoambiente.layers.push(this.geoLayer);

        index = $.inArray(this.geoLayer, geoambiente.layers);

        _settings.map.overlayMapTypes.setAt(index, this.geoLayer);
    }

    this.loadLayer();
    this.context = this;

    this.getVisibility = function () {
        return _getVisibility();
    }

    this.setMap = function (layer) {

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        if (layer == null) {
        	_settings.map.overlayMapTypes.setAt(index, null);
            _setVisibility(false);
        }
        else {
        	_settings.map.overlayMapTypes.setAt(index, this.geoLayer);
            _setVisibility(true);
        }
    }

    this.destroy = function () {

        var index = $.inArray(this.geoLayer, geoambiente.layers);

        _settings.map.overlayMapTypes.removeAt(index);
        geoambiente.layers.splice(index, 1);
    }
};

geoambiente.infowindowExecute = function (evt) {
    var layers = geoambiente.layers.filter(function (x) { return !jQuery.isEmptyObject(x.settings.infowindow) });
    var urls = [];
    geoambiente.features = [];
    __evt = evt;

    $.each(layers, function (key, value) {
        var index = $.inArray(value.settings.infowindow.url, urls);

        if (index == -1)
            urls.push(value.settings.infowindow.url);
    });

    geoambiente.services = [];
    $.each(urls, function (key, value) {
        var j = layers.filter(function (x) { return x.settings.infowindow.url == value });
        geoambiente.services.push({
            url: value,
            layers: j.map(function (x) { return x.settings.layer }).join(",")
        })
    });

    if ($.isEmptyObject(geoambiente.services))
        return;

    geoambiente.idx = 0;
    geoambiente.getFeature(__evt);
}

geoambiente.getFeature = function (evt) {

    if (geoambiente.idx > (geoambiente.services.length - 1)) {
        if (geoambiente.features.length > 0)
            _openInfoWindow();

        return;
    }

    var service = geoambiente.services[geoambiente.idx];

    var bbox = map.getBounds().toUrlValue().split(',')[1] + ',' +
                  map.getBounds().toUrlValue().split(',')[0] + ',' +
                  map.getBounds().toUrlValue().split(',')[3] + ',' +
                  map.getBounds().toUrlValue().split(',')[2];

    var url = service.url + "?"; //_overlayer.overlayer.Fonte + "?";

    url += "&SERVICE=WMS"; //WMS layers to draw
    url += "&REQUEST=GetFeatureInfo";           //WMS service    
    url += "&BBOX=" + bbox;        //WMS operation                
    url += "&INFO_FORMAT=application/json";               //use default style
    url += "&QUERY_LAYERS=" + service.layers;      //image format
    url += "&LAYERS=" + service.layers;
    url += "&FEATURE_COUNT=10";      //image format       
    url += "&WIDTH=" + $(map.getDiv()).width();
    url += "&HEIGHT=" + $(map.getDiv()).height();
    url += "&FORMAT=image/png"; // + elemento.srid;         //projection WGS84
    url += "&STYLES=";          //set bounding box for tile    
    url += "&SRS=EPSG:4326";
    url += "&VERSION=1.1.1";
    url += "&x=" + parseInt(evt.pixel.x);
    url += "&y=" + parseInt(evt.pixel.y);

    var param = url;

    $.post(geoambiente.proxy,
    {
        url: param
    },
    function (data, status) {
        $.each(data.features, function (key, value) {
            geoambiente.features.push(value);
        });

        geoambiente.idx++;
        geoambiente.getFeature(__evt);
    });
}

function _openInfoWindow() {
    __idx = 0;

    if ($.isEmptyObject(geoambiente.infowindow)) {
        geoambiente.infowindow = new google.maps.InfoWindow({
            minWidth: 400,
            maxWidth: 400
        });
    }

    geoambiente.infowindow.setContent(_getContent());
    geoambiente.infowindow.open(map);
    geoambiente.infowindow.setPosition(__evt.latLng);
}

function _getContent() {
    var feature = geoambiente.features[__idx];

    var divContent = "<div id='divContent'>";

    divContent += "<center><b>" + feature.id + "</b></div>";

    for (var key in feature.properties) {
        divContent += "<br><b>" + key + ":</b> " + feature.properties[key];
    }

    divContent += "</div>";

    if (geoambiente.features.length > 1) {
        divContent += "<br><br><br>";

        divContent += "<div id='divPagination'>";

        if (__idx > 0)
            divContent += "<a href='javascript:;' onclick='_previous();'>Anterior</a> ";

        if (__idx < (geoambiente.features.length - 1))
            divContent += "<a href='javascript:;' onclick='_next();'>Pr&oacute;ximo</a> ";

        divContent += "</div>";
    }

    return divContent;
}

function _next() {
    __idx = (__idx == geoambiente.features.length - 1) ? 0 : (__idx + 1);

    geoambiente.infowindow.setContent(_getContent());
}

function _previous() {
    __idx = (__idx === 0) ? (geoambiente.features.length - 1) : (__idx - 1);

    geoambiente.infowindow.setContent(_getContent());
}

function _generateHexString() {
    var length = 10;
    var ret = "";
    while (ret.length < length) {
        ret += Math.random().toString(16).substring(2);
    }
    return ret.substring(0, length);
}

