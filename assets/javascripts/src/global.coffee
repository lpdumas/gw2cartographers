class CustomMap
  constructor: (id)->
    @blankTilePath = 'tiles/00empty.jpg'
    @iconsPath     = 'assets/images/icons/32x32'
    @maxZoom       = 7
    # HTML element
    @lngContainer     = $('#long')
    @latContainer     = $('#lat')
    @devModInput      = $('#dev-mod')
    @optionsBox       = $('#options-box')
    @addMarkerLink    = $('#add-marker')
    @removeMarkerLink = $('#remove-marker')
    @markerList       = $('#marker-list')
    @exportBtn        = $('#export')
    @exportWindow     = $('#export-windows')
    
    @canRemoveMarker = false
    @draggableMarker = false
    @visibleMarkers   = true
    @gMapOptions   = 
      center: new google.maps.LatLng(25.760319754713887, -35.6396484375)
      zoom: 6
      minZoom: 4
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

    @addMenuIcons()
    
    # Events
    google.maps.event.addListener(@map, 'mousemove', (e)=>
      @lngContainer.html e.latLng.lng()
      @latContainer.html e.latLng.lat()
    )
    
    google.maps.event.addListener(@map, 'zoom_changed', (e)=>
        zoomLevel = @map.getZoom()
        if zoomLevel == 4
            @setAllMarkersVisibility(false);
        else if zoomLevel > 4
            @setAllMarkersVisibility(true);
    )
    
    @devModInput.bind('click', @handleDevMod)
    
    #marker
    @gMarker = {}

    @setAllMarkers()

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
    @removeMarkerLink.bind('click', @handleMarkerRemovalTool)
    @exportBtn.bind('click', @handleExport)
    
    @exportWindow.find('.close').click(()=>
      @exportWindow.hide()
    )
    
  addMarker:(markerInfo, type)->
    iconsize = 32;
    iconmid = iconsize / 2;
    image = new google.maps.MarkerImage(@getIconURLByType(type), null, null,new google.maps.Point(iconmid,iconmid), new google.maps.Size(iconsize, iconsize));
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lng, markerInfo.lat)
      map: @map
      icon: image
      draggable: @draggableMarker
      cursor : if @draggableMarker then "move" else "pointer"
      title: "#{markerInfo.title}"
    )
    infoWindow = new google.maps.InfoWindow(
      content  : if "#{markerInfo.desc}" == "" then "More info comming soon" else "#{markerInfo.desc}"
      maxWidth : 200
    )
    
    marker["title"] = "#{markerInfo.title}"
    marker["desc"]  = "#{markerInfo.desc}"
    marker["infoWindow"] = infoWindow
    
    google.maps.event.addListener(marker, 'dragend', (e)=>
      console.log "#{e.latLng.lat()}, #{e.latLng.lng()}"
    )
    google.maps.event.addListener(marker, 'click', (e)=>
      if @canRemoveMarker && @draggableMarker
        @removeMarker(marker.__gm_id)
      else
        if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        marker.infoWindow.open(@map, marker)
        @currentOpenedInfoWindow = marker.infoWindow
    )

    if !@gMarker[type]
      @gMarker[type] = []
    
    @gMarker[type].push(marker)

  setAllMarkers:()->
    for type, markerArray of Markers
      @addMarker(marker, type) for marker in markerArray
    
  getIconURLByType:(type)->
    return icon.url for icon in Resources.Icons when icon.id is type

  setAllMarkersVisibility:(isVisible)->
    for type of Markers
      if !$("[data-type='#{type}']").hasClass('hidden')
        @setMarkersVisibilityByType(isVisible, type) 

  setMarkersVisibilityByType:(isVisible, type)->
    marker.setVisible(isVisible) for marker in @gMarker[type]

  handleDevMod:(e)=>
    this_ = $(e.currentTarget)
    if this_.prop('checked')
      @setDraggableMarker(true)
      @optionsBox.addClass('active')
    else
      @setDraggableMarker(false)
      @optionsBox.removeClass('active')
      @markerList.removeClass('active')
      @addMarkerLink.removeClass('active')

  handleMarkerRemovalTool:(e)=>
    if @removeMarkerLink.hasClass('active')
      @removeMarkerLink.removeClass('active')
      @optionsBox.removeClass('red')
      @canRemoveMarker = false
    else
      @removeMarkerLink.addClass('active')
      @optionsBox.addClass('red')
      @canRemoveMarker = true
      @markerList.removeClass('active')
      @addMarkerLink.removeClass('active')
    
  handleExport:(e)=>
    markerObject = {}
    for markersId, markers of @gMarker
      if !markerObject[markersId]
        markerObject[markersId] = []
      for marker in markers
        nm = 
          "lng" : marker.getPosition().lng()
          "lat" : marker.getPosition().lat()
          "title" : marker.title
          "desc"  : marker.desc
        markerObject[markersId].push(nm)
    
    jsonString = JSON.stringify(markerObject)
    @exportWindow.find('.content').html(jsonString)
    @exportWindow.show();
    
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

  hideAllMarker:()->
    for markersId, markers of @gMarker
      for marker in markers
        marker.setVisible(false)
    
  showAllMarker:()->
    for markersId, markers of @gMarker
      for marker in markers
        marker.setVisible(true)
        
  toggleMarkerList: (e)=>
    this_ = $(e.currentTarget)
    @markerList.toggleClass('active')
    this_.toggleClass('active')
    if this_.hasClass('active')
      @removeMarkerLink.removeClass('active')
      @optionsBox.removeClass('red')
      @canRemoveMarker = false

  addMenuIcons:()->
    for icon in Resources.Icons
      li = $("<li></li>")
      img = $("<img>", {src: icon.url, alt: icon.id})
      li.append(img)
      li.attr('data-type', icon.id)
      li.bind 'click', (e)=>
        item = e.currentTarget
        if item.getAttribute('class') == 'hidden'
          @setMarkersVisibilityByType(true, item.getAttribute('data-type'))
          e.currentTarget.setAttribute('class', '')
        else
          @setMarkersVisibilityByType(false, item.getAttribute('data-type'))
          e.currentTarget.setAttribute('class', 'hidden')
      $('#menu-marker ul').append(li)
    
$ ()->
  myCustomMap = new CustomMap('#map')
  $('#notice').click(()->
    $(this).hide()
  )
