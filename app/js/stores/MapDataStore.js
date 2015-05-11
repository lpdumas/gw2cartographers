var Reflux  = require('reflux');
var actions = require('./../actions/actions');

var MapDataStore = Reflux.createStore({
    init: function() {
        this._floor = [];
        this.listenTo(actions.loadMapData, this.loadMapData);
    },
    loadMapData: function() {
      $.get("https://api.guildwars2.com/v1/map_floor.json?continent_id=1&floor=1")
        .done( this.onloadMapData )
        .fail( this.onloadMapDataError );
    },

    onloadMapData: function(data) {
      this._floor = data
      this.trigger(this._floor);
    },

    onloadMapDataError: function(data) {
      console.log('error', data);
    },

    getFloorObject: function() {
      return this._floor
    }
});

module.exports = MapDataStore