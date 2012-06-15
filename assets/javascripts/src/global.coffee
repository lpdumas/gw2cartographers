class CustomMap
  constructor: (id)->
    @blankTilePath = 'tiles/00empty.jpg'
    @iconsPath     = 'assets/images/icons/32x32'
    @maxZoom       = 7
    @lngContainer = $('#long')
    @latContainer = $('#lat')
    @gMapOptions   = 
      center: new google.maps.LatLng(25.760319754713887, -35.6396484375)
      zoom: 6
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
    
    # overlay = new google.maps.OverlayView()
    # overlay.draw = ()->
    # overlay.setMap(@map)
    
    # Events
    google.maps.event.addListener(@map, 'mousemove', (e)=>
      @lngContainer.html e.latLng.lng()
      @latContainer.html e.latLng.lat()
    )
    google.maps.event.addListener(@map, 'click', (e)=>
      alert "#{e.latLng.lat()}, #{e.latLng.lng()}"
    )
    
    #marker
    @heartsMarker = []
    @setHearts()
  addMarkers:(markerInfo, img)->
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lng, markerInfo.lat)
      map: @map
      icon: img
      draggable: true
      title: "#{markerInfo.title}"
    )
    @heartsMarker.push marker
  
  setHearts:()->
      @addMarkers(heart, "#{@iconsPath}/heart.png") for heart in Markers.Hearts
    
$ ()->
  myCustomMap = new CustomMap('#map')