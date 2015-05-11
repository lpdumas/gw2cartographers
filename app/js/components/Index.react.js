var React       = require('react');
var L           = require('leaflet');

var Actions     = require('./../actions/actions');

var RegionOverlay = require('./../classes/RegionOverlay');
var PveMap = require('./../classes/PveMap');

var Index = React.createClass({
  componentDidMount: function() {
    // Listeneners
    // MapStore.listen(this.onFloorLoaded);

    this.map = new PveMap(this.getDOMNode());
    // Actions
    Actions.loadMapData();
  },

  onFloorLoaded: function(data) {
  },
  componentWillUnmount: function() {
    this.map = null;
  },
  render: function() {
    return (
        <div className='map'></div>
    );
  }
});
module.exports = Index;

