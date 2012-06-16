class CustomMap
  constructor: (id)->
    @blankTilePath = 'tiles/00empty.jpg'
    @iconsPath     = 'assets/images/icons/32x32'
    @maxZoom       = 7
    @lngContainer  = $('#long')
    @latContainer  = $('#lat')
    @devModInput   = $('#dev-mod')
    @optionsBox    = $('#options-box')
    @addMarkerLink = $('#add-marker')
    @markerList    = $('#marker-list')
    @canRemoveMarker = false
    @draggableMarker = false
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
    # google.maps.event.addListener(@map, 'click', (e)=>
      # alert "#{e.latLng.lat()}, #{e.latLng.lng()}"
    # )
    
    @devModInput.bind('click', @handleDevMod)
    
    #marker
    @gMarker = 
      "hearts" : []
      "waypoints" : []
      "poi" : []
      "skillpoints" : []
      
    @setHearts()
    @setWaypoints()
    @setPOI()
    @setSkillPoints()

    @markerList.find('span').bind('click', (e)=>
      this_      = $(e.currentTarget)
      markerType = this_.attr('data-type')
      coord       = @map.getCenter()
      markerinfo = 
        "lng" : coord.lat()
        "lat" : coord.lng()
        "title" : "--"
      img        = "#{@iconsPath}/#{markerType}.png"
      @addMarkers(markerinfo, img, markerType)
    )
    
    # UI
    @addMarkerLink.bind('click', @toggleMarkerList)
  
  addMarkers:(markerInfo, img, type)->
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lng, markerInfo.lat)
      map: @map
      icon: img
      draggable: @draggableMarker
      title: "#{markerInfo.title}"
    )
    
    google.maps.event.addListener(marker, 'dragend', (e)=>
      console.log "#{e.latLng.lat()}, #{e.latLng.lng()}"
    )
    google.maps.event.addListener(marker, 'click', (e)=>
      if @canRemoveMarker && @draggableMarker
        @removeMarker(marker.__gm_id)
      else
        console.log "opening info window"
    )
    @gMarker[type].push(marker)
  
  setHearts:()->
      @addMarkers(heart, "#{@iconsPath}/hearts.png","hearts") for heart in Markers.Hearts
  
  setWaypoints:()->
    @addMarkers(waypoint, "#{@iconsPath}/waypoints.png", "waypoints") for waypoint in Markers.Wayppoints

  setPOI:()->
    @addMarkers(poi, "#{@iconsPath}/poi.png", "poi") for poi in Markers.POI
    
  setSkillPoints:()->
    @addMarkers(skillPoint, "#{@iconsPath}/skillpoints.png", "skillpoints") for skillPoint in Markers.SkillPoints    
  
  handleDevMod:(e)=>
    this_ = $(e.currentTarget)
    if this_.prop('checked')
      @setDraggableMarker(true)
      @optionsBox.addClass('active')
    else
      @setDraggableMarker(false)
      @optionsBox.removeClass('active')

  removeMarker:(id)->
    for markersId, markers of @gMarker
      @gMarker[markersId] = _.reject(markers, (m)=>
        return m.__gm_id == id
      )
      for marker in markers
        if marker.__gm_id == id
          marker.setMap(null)
  
  setDraggableMarker:(val)->
    @draggableMarker = val
    for markersId, markers of @gMarker
      for marker in markers
        marker.setDraggable(val)
        if val
          marker.setCursor('move')
        else
          marker.setCursor('pointer')
          
  toggleMarkerList: (e)=>
    this_ = $(e.currentTarget)
    @markerList.toggleClass('active')
    this_.toggleClass('active')
    
$ ()->
  myCustomMap = new CustomMap('#map')