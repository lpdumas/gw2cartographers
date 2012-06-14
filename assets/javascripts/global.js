// Generated by CoffeeScript 1.3.1
(function() {
  var CustomMap;

  CustomMap = (function() {

    CustomMap.name = 'CustomMap';

    function CustomMap(id) {
      var overlay,
        _this = this;
      this.repeatOnXAxis = false;
      this.blankTilePath = 'tiles/_empty.jpg';
      this.maxZoom = 7;
      this.gMapOptions = {
        center: new google.maps.LatLng(0, 0),
        zoom: 2,
        minZoom: 0,
        maxZoom: this.maxZoom,
        streetViewControl: false,
        mapTypeControl: false,
        mapTypeControlOptions: {
          mapTypeIds: ["custom", google.maps.MapTypeId.ROADMAP]
        }
      };
      this.customMapType = new google.maps.ImageMapType({
        getTileUrl: function(coord, zoom) {
          var normalizedCoord;
          normalizedCoord = _this.getNormalizedCoord(coord, zoom);
          if (normalizedCoord && (normalizedCoord.x < Math.pow(2, zoom)) && (normalizedCoord.x > -1) && (normalizedCoord.y < Math.pow(2, zoom)) && (normalizedCoord.y > -1)) {
            console.log("test");
            return 'tiles/' + zoom + '_' + normalizedCoord.x + '_' + normalizedCoord.y + '.jpg';
          } else {
            return _this.blankTilePath;
          }
        },
        tileSize: new google.maps.Size(256, 256),
        maxZoom: this.maxZoom,
        name: 'GW2 Map'
      });
      console.log($(id)[0]);
      this.map = new google.maps.Map($(id)[0], this.gMapOptions);
      this.map.mapTypes.set('custom', this.customMapType);
      this.map.setMapTypeId('custom');
      overlay = new google.maps.OverlayView();
      overlay.draw = function() {};
      overlay.setMap(this.map);
      this.longContainer = $('#long');
      this.latContainer = $('#lat');
      google.maps.event.addListener(this.map, 'mousemove', function(e) {
        _this.longContainer.html(e.latLng.lng());
        return _this.latContainer.html(e.latLng.lat());
      });
    }

    CustomMap.prototype.getNormalizedCoord = function(coord, zoom) {
      var tileRange, x, y;
      if (!this.repeatOnXAxis) {
        return coord;
      }
      y = coord.y;
      x = coord.x;
      tileRange = 1 << zoom;
      if (y < 0 || y >= tileRange) {
        return null;
      }
      if (x < 0 || x >= tileRange) {
        x = (x % tileRange + tileRange) % tileRange;
      }
      return {
        x: x,
        y: y
      };
    };

    return CustomMap;

  })();

  $(function() {
    var myCustomMap;
    return myCustomMap = new CustomMap('#map');
  });

}).call(this);
