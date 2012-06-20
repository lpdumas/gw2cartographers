markersOptionsMenu = $('#markers-options')
MapApp = {
  toggleMarkersOptionsMenu: () ->
    markersOptionsMenu.toggleClass('active')
  hideMarkersOptionsMenu: () ->
    markersOptionsMenu.addClass('off')
  showMarkersOptionsMenu: () ->
    markersOptionsMenu.removeClass('off')
}
    
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
    
    @defaultLat = 25.760319754713887
    @defaultLng = -35.6396484375
    
    @areaSummaryBoxes = []
    
    @canRemoveMarker  = false
    @draggableMarker  = false
    @visibleMarkers   = true
    @canToggleMarkers = true
    @gMapOptions   = 
      center: new google.maps.LatLng(@getStartLat(), @getStartLng())
      zoom: 6
      minZoom: 3
      maxZoom: @maxZoom
      streetViewControl: false
      mapTypeControl: false
      mapTypeControlOptions:
        mapTypeIds: ["custom", google.maps.MapTypeId.ROADMAP]

      panControl: false
      zoomControl: true
      zoomControlOptions:
        position: google.maps.ControlPosition.LEFT_CENTER
        zoomControlStyle: google.maps.ZoomControlStyle.SMALL
        
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
    
    # Events
    google.maps.event.addListener(@map, 'click', (e)=>
      console.log "Long: #{e.latLng.lng()}, Lat: #{e.latLng.lat()}"
    )
    
    google.maps.event.addListener(@map, 'zoom_changed', (e)=>
        zoomLevel = @map.getZoom()
        if zoomLevel == 4
          @canToggleMarkers = false
          MapApp.hideMarkersOptionsMenu()
          @setAllMarkersVisibility(false)
          @setAreasInformationVisibility(true)
        else if zoomLevel > 4
          @canToggleMarkers = true
          MapApp.showMarkersOptionsMenu()
          @setAllMarkersVisibility(true)
          @setAreasInformationVisibility(false)
        else if zoomLevel < 4
          @canToggleMarkers = false
          MapApp.hideMarkersOptionsMenu()
          @setAllMarkersVisibility(false)
          @setAreasInformationVisibility(false)
    )

    @devModInput.bind('click', @handleDevMod)
    
    #marker
    @gMarker = {}

    @setAllMarkers()
    @initializeAreaSummaryBoxes()

    @markerList.find('span').bind('click', (e)=>
      this_      = $(e.currentTarget)
      markerType = this_.attr('data-type')
      coord       = @map.getCenter()
      markerinfo = 
        "lng" : coord.lng()
        "lat" : coord.lat()
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
      position: new google.maps.LatLng(markerInfo.lat, markerInfo.lng)
      map: @map
      icon: image
      draggable: @draggableMarker
      cursor : if @draggableMarker then "move" else "pointer"
      title: "#{markerInfo.title}"
    )
    
    permalink = '<p class="marker-permalink"><a href="?lat=' + markerInfo.lat+ '&lng=' + markerInfo.lng + '">Permalink</a></p>'
    infoWindow = new google.maps.InfoWindow(
      content  : (if "#{markerInfo.desc}" == "" then "More info comming soon" else "#{markerInfo.desc}") + "<p>" + permalink + "</p>"
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
    return Resources.Icons[icon].url for icon of Resources.Icons when icon is type

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
    
  getStartLat:()->
    params = extractUrlParams()
    if(params['lat']?)
        params['lat']
    else
        @defaultLat
    
  getStartLng:()->
      params = extractUrlParams()
      if(params['lng']?)
          params['lng']
      else
          @defaultLng
    
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
    for type, icon of Resources.Icons
      li = $("<li></li>")
      img = $("<img>", {src: icon.url, alt: type})
      li.append(img)
      li.attr('data-type', type)
      li.bind 'click', (e)=>
        item = e.currentTarget
        console.log @canToggleMarkers
        if @canToggleMarkers
          if item.getAttribute('class') == 'hidden'
            @setMarkersVisibilityByType(true, item.getAttribute('data-type'))
            e.currentTarget.setAttribute('class', '')
          else
            @setMarkersVisibilityByType(false, item.getAttribute('data-type'))
            e.currentTarget.setAttribute('class', 'hidden')
      $('#menu-marker ul').append(li)
      
  initializeAreaSummaryBoxes:()->
    for area of Areas
        @areaSummaryBoxes[area] = new AreaSummary(@map, Areas[area])
        
  setAreasInformationVisibility:(isVisible)->
    for box in @areaSummaryBoxes
        box.setVisible(isVisible)
      
class AreaSummary
    constructor:(map, area)->
        swBound = new google.maps.LatLng(area.swLat, area.swLng)
        neBound = new google.maps.LatLng(area.neLat, area.neLng)
        @bounds_ = new google.maps.LatLngBounds(swBound, neBound)
        @area_ = area
        @div_ = null
        @height_ = 80
        @width_ = 150
        
        @setMap(map)
    
    
    AreaSummary:: = new google.maps.OverlayView();
    
    onAdd:()->        
        div = $('<div class="area-summary-overlay"></div>')

        title = $('<p class="area-summary-title"></p>')
        if(@area_.rangeLvl != "")
            rangeLvl = "<span class='lvl-range'>(#{@area_.rangeLvl})</span>"
        else
            div.addClass('city')
            rangeLvl = ""
        
        title.html("<span class='area-title'>#{@area_.name}</span>#{rangeLvl}")
        div.append(title)
        
        ul = $('<ul class="area-summary-list"></ul>')
        
        for type of @area_.summary
            if(@area_.summary[type] > 0)
                li = $('<li></li>')
                img = $('<img class="area-summary-icons">')
                img.attr('src', Resources.Icons[type].url)
                img.attr('alt', Resources.Icons[type].label)
                img.attr('width', "15px")
                img.attr('height', "15px")
                li.append(img)
                li.append(@area_.summary[type])
                # li.append(img, li.firstChild)
                ul.append(li)

        div.append(ul)        
        
        @div_ = div[0]
        panes = @getPanes()
        panes.overlayImage.appendChild(@div_)
        @setVisible(false)
        
    draw:()->
      overlayProjection = @getProjection()
      sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
      ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

      div = this.div_;
      div.style.left = sw.x + ((ne.x - sw.x) - @width_) / 2 + 'px';
      div.style.top = ne.y + ((sw.y - ne.y) - @height_) / 2 + 'px';
    
    setVisible:(isVisible)->
        if @div_
            if isVisible is true
                @div_.style.visibility = "visible"
            else
                @div_.style.visibility = "hidden"
                
extractUrlParams = ()->
    parameters = location.search.substring(1).split('&')
    f = []
    for element in parameters
        x = element.split('=')
        f[x[0]]=x[1]
    f
    
$ ()->
  myCustomMap = new CustomMap('#map')
  markersOptionsMenuToggle = $('#options-toggle strong')
  markersOptionsMenuToggle.click( () ->
    MapApp.toggleMarkersOptionsMenu()
  )
