var React  = require('react');
var Router = require('react-router');
var Index  = require('./components/Index.react');
var Contact  = require('./components/Contact.react');
var { Route, DefaultRoute, RouteHandler, Link } = Router;

var ReactApp = React.createClass({

  getInitialState: function() {
    return { foo: 'Bar' };
  },

  componentDidMount: function() {
    console.log('componentDidMount');
  },

  componentWillUnmount: function() {
    console.log('componentWillUnMount');
  },

  /**
   * @return {object}
   */
  render: function() {

    return (
      <RouteHandler />
    );
  },

});

var routes = (
  <Route name="gw2map" path="/" handler={ReactApp}>
    <DefaultRoute name="index" handler={Index}/>
    <Route name="contact" handler={Contact}/>
  </Route>
);

Router.run(routes, function (Handler, state) {
  React.render(<Handler />,document.getElementById('gw2-map'));
})


module.exports = ReactApp;
