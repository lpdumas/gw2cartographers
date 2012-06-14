class CustomMap
  constructor: (id)->
    @blankTilePath = 'tiles/_empty.jpg'
    @maxZoom       = 7
    @gMapOptions   = 
      center: new google.maps.LatLng(0, 0)
      zoom: 2
      minZoom: 0
      maxZoom: @maxZoom
      streetViewControl: false
      mapTypeControl: false
      mapTypeControlOptions:
        mapTypeIds: ["custom", google.maps.MapTypeId.ROADMAP]
    
    @customMapType = new google.maps.ImageMapType(
      getTileUrl : (coord, zoom)=>
        normalizedCoord = coord
        if normalizedCoord && (normalizedCoord.x < Math.pow(2, zoom)) && (normalizedCoord.x > -1) && (normalizedCoord.y < Math.pow(2, zoom)) && (normalizedCoord.y > -1)
          path = 'tiles/' + zoom + '_' + normalizedCoord.x + '_' + normalizedCoord.y + '.jpg'
        else 
          return @blankTilePath
      tileSize: new google.maps.Size(256, 256)
      maxZoom: @maxZoom
      name: 'GW2 Map'
    )
    
    @map = new google.maps.Map($(id)[0], @gMapOptions)
    @map.mapTypes.set('custom', @customMapType)
    @map.setMapTypeId('custom')
    
    overlay = new google.maps.OverlayView()
    # overlay.draw = ()->
    # overlay.setMap(@map)

    @longContainer = $('#long')
    @latContainer = $('#lat')
    
    google.maps.event.addListener(@map, 'mousemove', (e)=>
      @longContainer.html e.latLng.lng()
      @latContainer.html e.latLng.lat()
    )    
$ ()->
  myCustomMap = new CustomMap('#map')