var Reflux = require('reflux');

var MapActions = Reflux.createActions([
  // Map data actions (floor, icons, etc..)
  "loadMapData",
  "loadMapDataError"
]);

module.exports = MapActions
