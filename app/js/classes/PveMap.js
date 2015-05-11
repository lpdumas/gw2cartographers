var MapDataStore    = require('./../stores/MapDataStore');
var RegionOverlay = require('./RegionOverlay');

function unproject(coord, map) {
  return map.unproject(coord, map.getMaxZoom());
}

class PveMap {
  constructor(domElement) {
    var map = this.map = L.map(domElement, {
      minZoom: 0,
      maxZoom: 7,
      crs: L.CRS.Simple,
      layers: [L.tileLayer("https://tiles.guildwars2.com/1/1/{z}/{x}/{y}.jpg", {
          minZoom: 0,
          maxZoom: 7,
          continuousWorld: true
        })
      ],
      attributionControl: false,
    }).setView([0, 0], 0);

    var southWest = unproject([0, 32768], map);
    var northEast = unproject([32768, 0], map);

    map.setMaxBounds(new L.LatLngBounds(southWest, northEast));
    map.fitWorld();

    // Listener
    MapDataStore.listen(this.mapDataLoaded);
  }

  mapDataLoaded(data) {
    console.log('inside pveMap class', data);
  }
}

module.exports = PveMap