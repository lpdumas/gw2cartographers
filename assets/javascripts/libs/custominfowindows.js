CustomInfoWindow = function(marker,opts) {
  this.marker = marker;
  this.gmap = marker.map;
  this.html = opts.html;
  this.htmlElement = null;
  
  this.anchor = opts.anchor || {x:0,y:0};

  this.marginLeft = opts.marginLeft || 0;
  this.marginTop = opts.marginTop || 0;
  
  this.contents = opts.contents;
  this.position = marker.position;
  // console.log(this.position.lat())
  
  this.onCreation = opts.onCreation || function(){};
  this.onShow     = opts.onShow || function(){};
  this.setMap(this.gmap);
};

CustomInfoWindow.prototype = new google.maps.OverlayView();

CustomInfoWindow.prototype.add = function(){
  this.setMap(this.gmap);
}

CustomInfoWindow.prototype.onAdd = function(){
  var panes = this.getPanes();
  
  this.htmlElement = $(panes.overlayLayer).html(this.html);
  this.htmlElement.css('position','relative');
  this.hide()
}

CustomInfoWindow.prototype.draw = function(){
  var overlayProjection = this.getProjection();
  var pos = overlayProjection.fromLatLngToDivPixel(this.position);
  var posX = pos.x;
  var posY = pos.y;
  
  this.htmlElement.css({
    top:posY,
    left:posX,
    zIndex:1000
  });
}

CustomInfoWindow.prototype.remove = function(){
  this.setMap(null);
}
CustomInfoWindow.prototype.onRemove = function(){
  this.htmlElement.remove();
  this.htmlElement = null;
}
CustomInfoWindow.prototype.show = function(){
  console.log(this.htmlElement)
  this.htmlElement.css('visibility','visible');
  this.isVisible = true;
  this.onShow.call(this);
}

CustomInfoWindow.prototype.hide = function(){
  this.htmlElement.css('visibility','hidden');
  this.isVisible = false;
}
