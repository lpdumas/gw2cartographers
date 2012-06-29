###
# classCustomMap {{{
###
class CustomMap
  constructor: (id)->
    @blankTilePath = 'tiles/00empty.jpg'
    @iconsPath     = 'assets/images/icons/32x32'
    @maxZoom       = 7
    @appState      = "read"
    # HTML element
    @html             = $('html')
    @lngContainer     = $('#long')
    @latContainer     = $('#lat')
    @devModInput      = $('#dev-mod')
    @optionsBox       = $('#options-box')
    @addMarkerLink    = $('#add-marker')
    @removeMarkerLink = $('#remove-marker')
    @markerList       = $('#marker-list')
    @exportBtn        = $('#export')
    @exportWindow     = $('#export-windows')
    @markersOptionsMenu = $('#markers-options')
    @editionsTools    = $('#edition-tools a')
    
    @defaultLat = 25.760319754713887
    @defaultLng = -35.6396484375
    @defaultCat = "generic"
    
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
    google.maps.event.addListener(@map, 'click', (e)=>
      console.log '{"lat" : "'+e.latLng.lat()+'", "lng" : "'+e.latLng.lng()+'", "title" : "", "desc" : ""},'
    )
    
    google.maps.event.addListener(@map, 'zoom_changed', (e)=>
        zoomLevel = @map.getZoom()
        if zoomLevel == 4
          @canToggleMarkers = false
          @hideMarkersOptionsMenu()
          @setAllMarkersVisibility(false)
          @setAreasInformationVisibility(true)
        else if zoomLevel > 4
          @canToggleMarkers = true
          @showMarkersOptionsMenu()
          @setAllMarkersVisibility(true)
          @setAreasInformationVisibility(false)
        else if zoomLevel < 4
          @canToggleMarkers = false
          @hideMarkersOptionsMenu()
          @setAllMarkersVisibility(false)
          @setAreasInformationVisibility(false)
    )
    
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
    @editionsTools.bind('click', @handleEdition)
    
    @exportWindow.find('.close').click(()=>
      @exportWindow.hide()
    )
    
  addMarker:(markerInfo, markersType, markersCat)->
    iconsize = 32;
    iconmid = iconsize / 2;
    image = new google.maps.MarkerImage(@getIconURLByType(markersType, markersCat), null, null,new google.maps.Point(iconmid,iconmid), new google.maps.Size(iconsize, iconsize));
    isMarkerDraggable = if markerInfo.draggable? then markerInfo.draggable else false
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lat, markerInfo.lng)
      map: @map
      icon: image
      visible: if markersCat is @defaultCat then yes else no
      draggable: isMarkerDraggable
      cursor : if isMarkerDraggable then "move" else "pointer"
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
    
    markerThatMatchUrl = @getMarkerByCoordinates(@getStartLat(), @getStartLng())
    if (markerThatMatchUrl == markerInfo)
        marker.infoWindow.open(@map, marker)
        @currentOpenedInfoWindow = marker.infoWindow
    
    google.maps.event.addListener(marker, 'dragend', (e)=>
      console.log '{"lat" : "'+ e.latLng.lat() +'", "lng" : "'+ e.latLng.lng() +'", "title" : "", "desc" : ""},'
    )
    google.maps.event.addListener(marker, 'click', (e)=>
      switch @appState
        when "remove"
          @removeMarker(marker.__gm_id, markersType, markersCat)
        else
          if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
          marker.infoWindow.open(@map, marker)
          @currentOpenedInfoWindow = marker.infoWindow
    )
    
    markerType["markers"].push(marker) for markerType in @gMarker[markersCat]["markerGroup"] when markerType.slug is markersType

  setAllMarkers:()->
    for markersCat, markersObjects of Markers
      if not @gMarker[markersCat]?
        @gMarker[markersCat] = {}
        @gMarker[markersCat]["name"] = markersObjects.name
        @gMarker[markersCat]["markerGroup"] = []
        
      for markerTypeObject, key in markersObjects.markerGroup
        newmarkerTypeObject = {}
        newmarkerTypeObject["name"] = markerTypeObject.name
        newmarkerTypeObject["slug"] = markerTypeObject.slug
        newmarkerTypeObject["markers"] = []
        @gMarker[markersCat]["markerGroup"].push(newmarkerTypeObject)
        
        @addMarker(marker, markerTypeObject.slug, markersCat) for marker in markerTypeObject.markers
    
  getIconURLByType:(type, markersCat)->
    return Resources.Icons[markersCat][icon].url for icon of Resources.Icons[markersCat] when icon is type

  setAllMarkersVisibility:(isVisible)->
    for cat, markersObjects of Markers
      @setMarkersVisibilityByType(isVisible, markerTypeObject.slug, cat) for markerTypeObject in markersObjects.markerGroup when not $("[data-type='#{markerTypeObject.slug}']").hasClass('off')

  setMarkersVisibilityByType:(isVisible, type, cat)->
    for markerTypeObject in @gMarker[cat]["markerGroup"] when markerTypeObject.slug is type
      marker.setVisible(isVisible) for marker in markerTypeObject.markers

  
  setMarkersVisibilityByCat:(isVisible, cat)->
    for markerTypeObject in @gMarker[cat]["markerGroup"]
      marker.setVisible(isVisible) for marker in markerTypeObject.markers

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
    exportMarkerObject = {}
    for markersCat, markersObjects of @gMarker
      if not exportMarkerObject[markersCat]?
        exportMarkerObject[markersCat] = {}
        exportMarkerObject[markersCat]["name"] = markersObjects.name
        exportMarkerObject[markersCat]["markerGroup"] = []
        
      for markerTypeObject, key in markersObjects.markerGroup
        newmarkerTypeObject = {}
        newmarkerTypeObject["name"] = markerTypeObject.name
        newmarkerTypeObject["slug"] = markerTypeObject.slug
        newmarkerTypeObject["markers"] = []
        exportMarkerObject[markersCat]["markerGroup"].push(newmarkerTypeObject)
        for marker in markerTypeObject.markers
          nm = 
            "lng" : marker.getPosition().lng()
            "lat" : marker.getPosition().lat()
            "title" : marker.title
            "desc"  : marker.desc
          exportMarkerObject[markersCat]["markerGroup"][key]["markers"].push(nm)

    jsonString = JSON.stringify(exportMarkerObject)
    @exportWindow.find('.content').html(jsonString)
    @exportWindow.show();
    
  handleEdition:(e)=>
    this_ = $(e.currentTarget)
    $(elements).removeClass('active') for elements in @editionsTools when elements isnt e.currentTarget
    this_.toggleClass('active')
    @html.removeClass('add remove move send')
    @appState = "read"
    if this_.hasClass('active')
      @appState = this_.attr('id')
      @html.addClass(this_.attr('id'))
    
  getStartLat:()->
    params = extractUrlParams()
    if params['lat']?
        params['lat']
    else
        @defaultLat
    
  getStartLng:()->
      params = extractUrlParams()
      if params['lng']?
          params['lng']
      else
          @defaultLng
    
  removeMarker:(id, type, cat)->
    for markerType, typeKey in @gMarker[cat]["markerGroup"] when markerType.slug is type
      for marker, markerKey in markerType.markers when marker.__gm_id is id
        marker.setMap(null)
        @gMarker[cat]["markerGroup"][typeKey]['markers'] = _.reject(markerType.markers, (m)=>
          return m.__gm_id == id
        )
  
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
    if this_.hasClass('active')
      @removeMarkerLink.removeClass('active')
      @optionsBox.removeClass('red')
      @canRemoveMarker = false

  getMarkerByCoordinates:(lat, lng)->
    for type, markersObjects of Markers
      for markerTypeObject, key in markersObjects.markerGroup
        return marker for marker in markerTypeObject.markers when marker.lat is lat and marker.lng is lng
    return false
  
  turnOfMenuIconsFromCat:(markerCat)->
    menu = $(".menu-marker[data-markerCat='#{markerCat}']")
    menu.find('.group-toggling').addClass('off')
    menu.find('.trigger').addClass('off')
  
  addMenuIcons:()->
    markersOptions = $.get('assets/javascripts/templates/markersOptions._', (e)=>
      template = _.template(e);
      html = $(template(Resources))
      
      # Binding click on marker icon in markers option list
      html.find(".trigger").bind 'click', (e) =>
        item           = $(e.currentTarget)
        myGroupTrigger = item.closest(".menu-marker").find('.group-toggling')
        
        # Binding different action to the click considering @appState
        # read   -> Toggle on/off marker on map
        # add    -> Add a draggable marker on center of map
        # remove -> Delete all marker from clicked marker type
        switch @appState
          when "read"
            if @canToggleMarkers
              if item.hasClass('off')
                @setMarkersVisibilityByType(true, item.attr('data-type'), item.attr('data-cat'))
                item.removeClass('off')
                console.log myGroupTrigger
                myGroupTrigger.removeClass('off')
              else
                @setMarkersVisibilityByType(false, item.attr('data-type'), item.attr('data-cat'))
                item.addClass('off')
          when "add"
            type      = item.attr('data-type')
            cat       = item.attr('data-cat')
            coord     = @map.getCenter()
            newMarkerInfo =
              desc      : ""
              title     : ""
              lat       : coord.lat()
              lng       : coord.lng()
              draggable : true
            @addMarker(newMarkerInfo, type, cat)
      
      html.find('.group-toggling').bind 'click', (e)=>
        this_ = $(e.currentTarget)
        parent = this_.closest('.menu-marker')
        markerCat = parent.attr('data-markerCat')
        if this_.hasClass('off')
          this_.removeClass('off')
          @setMarkersVisibilityByCat(on, markerCat)
          parent.find('.trigger').removeClass('off')
        else
          this_.addClass('off')
          @setMarkersVisibilityByCat(off, markerCat)
          parent.find('.trigger').addClass('off')
            
      @markersOptionsMenu.find('.padding').prepend(html)
      @turnOfMenuIconsFromCat(markerCat) for markerCat of Markers when markerCat isnt @defaultCat
    )
      
  initializeAreaSummaryBoxes:()->
    for area of Areas
        @areaSummaryBoxes[area] = new AreaSummary(@map, Areas[area])
        
  setAreasInformationVisibility:(isVisible)->
    for box in @areaSummaryBoxes
        box.setVisible(isVisible)
  toggleMarkersOptionsMenu: () ->
    @markersOptionsMenu.toggleClass('active')
  hideMarkersOptionsMenu: () ->
    @markersOptionsMenu.addClass('off')
  showMarkersOptionsMenu: () ->
    @markersOptionsMenu.removeClass('off')

###
# }}}
###
 
###
# class AreaSummary {{{
###
class AreaSummary
    constructor:(map, area)->
        swBound = new google.maps.LatLng(area.swLat, area.swLng)
        neBound = new google.maps.LatLng(area.neLat, area.neLng)
        @bounds_ = new google.maps.LatLngBounds(swBound, neBound)
        @area_ = area
        @div_ = null
        @height_ = 80
        @width_ = 150
        @template = ""
        $.get('assets/javascripts/templates/areasSummary._', (e)=>
          @template = _.template(e)
          @setMap(map)
        )
    
    AreaSummary:: = new google.maps.OverlayView();
    
    onAdd:()->
        content = @template(@area_)
        @div_ = $(content)[0]
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
###
# }}}
###                

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
    myCustomMap.toggleMarkersOptionsMenu()
  )