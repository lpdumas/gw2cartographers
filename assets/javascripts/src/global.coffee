App = {}
App.opacity = false
App.pointerEvents = false
App.localStorageAvailable = (()->
  if window['localStorage']?
    return true
  else
    return false
)()

html = document.documentElement
attToCheck = ["pointerEvents", "opacity"]
for att in attToCheck 
  if html.style[att]?
    $(html).addClass(att)
    App[att] = true
  else
    $(html).addClass("no-#{att}") 
###
# class ModalBox {{{
###
class Modalbox
  constructor: () ->
    @modal   = $('<div class="modal"><div class="padding"></div></div>')
    @overlay = $('<span class="overlay"></span>')
    $('body').append(@modal)
    $('body').append(@overlay)
    
    @overlay.bind('click', @close)
    
  open: ()->
    @modal.addClass('visible')
    @overlay.addClass('visible')
    
  close: (callback) =>
    callback = if _.isFunction(callback) then callback else ()->
    @modal.addClass('fadding')
    @overlay.addClass('fadding')
    t = setTimeout(()=>
      @modal.removeClass('visible fadding')
      @overlay.removeClass('visible fadding')
      callback()
    , 150)
  
  setContent: (content) ->
    @modal.find('.padding').html(content)
    
###
#}}} 
###

###
# class Confirmbox {{{
###
class Confirmbox extends Modalbox
  constructor: (template) ->
    super
    @modal.addClass('confirm-box')
    @template = template
    @overlay.unbind('click')
  
  initConfirmation: (contentString, callback)->
    confirmMessage = { confirmMessage : contentString}
    confirmBoxContent = $(@template(confirmMessage))
    acceptBtn = confirmBoxContent.find('#accept')
    deniedBtn = confirmBoxContent.find('#denied')
    @modal.find('.padding').html(confirmBoxContent)
    
    acceptBtn.bind('click', ()=>
      callback(yes)
      @close()
    )
    deniedBtn.bind('click', ()=>
      callback(no)
      @close()
    )
    
    @open();
###
#}}} 
###

###
# classCustomMap {{{
###
class CustomMap
  constructor: (id)->
    @localStorageKey  = "gw2c_markers_config_01"
    
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
    @mapOptions    = $('#edition-tools a')
    # @defaultLat = 15.919073517982465
    @defaultLat = 26.765230565697536
    # @defaultLng = 18.28125
    @defaultLng = -36.32080078125
    
    @defaultCat = "explore"
    window.LANG = "en"
    @areaSummaryBoxes = []
    
    @canRemoveMarker  = false
    @draggableMarker  = false
    @visibleMarkers   = true
    @canToggleMarkers = true
    @currentOpenedInfoWindow = false
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

    $.get('assets/javascripts/templates/confirmBox._', (e)=>
      template = _.template(e);
      @confirmBox = new Confirmbox(template)
    
      @handleLocalStorageLoad(()=>
        @addMenuIcons(()=>
          @addTools = $('.menu-marker a.add')
          @addTools.each((index, target)=>
            $(target).bind('click', @handleAddTool)
          )
        )
        
        google.maps.event.addListener(@map, 'zoom_changed', (e)=>
            zoomLevel = @map.getZoom()
            if zoomLevel == 4
              @canToggleMarkers = false
              @hideMarkersOptionsMenu()
              @setAllMarkersVisibility(false)
              @setAreasInformationVisibility(true)
              if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
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
              if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        )
    
        #marker
        @gMarker = {}

        @editInfoWindowTemplate = ""
        $.get('assets/javascripts/templates/customInfoWindow._', (e)=>
          @editInfoWindowTemplate = _.template(e)
          
          @test = 0 
          @countTotalMarker()
          @setAllMarkers(()=>
            console.log "finish"
          )
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
          $('#destroy').bind('click', @destroyLocalStorage)
          $('#send').bind('click', @sendMapForApproval)

    
          @exportWindow.find('.close').click(()=>
            @exportWindow.hide()
          )
        )
      )
    )
    
  handleLocalStorageLoad: (callback)->
    if App.localStorageAvailable and @getConfigFromLocalStorage()
      confirmMessage = "I have detected data stored locally, Do you want to load it?"
      @confirmBox.initConfirmation(confirmMessage, (e)=>
        if e
          @MarkersConfig = @getConfigFromLocalStorage()
        else
            @MarkersConfig = Markers
        callback()
      )
    else
      @MarkersConfig = Markers
      callback()
    
  getConfigFromLocalStorage: () ->
    json = localStorage.getItem(@localStorageKey)
    return JSON.parse(json)
  
  addMarker:(markerInfo, otherInfo, isNew, defaultValue, callBack)->
    
    createInfoWindow = (marker) =>
      templateInfo = 
        id : marker.__gm_id
        title: marker["title"]
        desc: marker["desc"]
        wikiLink  : marker["wikiLink"]
        type  : marker.type
        lat   : marker.position.lat()
        lng   : marker.position.lng()
    
      editInfoWindowContent = @editInfoWindowTemplate(templateInfo)
      marker["infoWindow"] = new CustomInfoWindow(marker, editInfoWindowContent,
        onClose : () =>
          @currentOpenedInfoWindow = null
        onOpen  : (infoWindow) =>
          @currentOpenedInfoWindow = infoWindow
        onSave  : (newInfo)=>
          @updateMarkerInfos(newInfo)
        deleteCalled : (marker)=>
          @removeMarker(marker.__gm_id, markersType, markersCat)
        moveCalled : (marker) =>
          if marker.getDraggable()
            marker.setDraggable(false)
            marker.setCursor("pointer")
          else
            marker.setDraggable(true)
            marker.setCursor("move")
        template : @editInfoWindowTemplate
      )
      
    iconsize = 32;
    iconmid = iconsize / 2;
    iconPath = Metadata.icons_path + otherInfo.icon
    markersType = otherInfo.markersType
    markersCat = otherInfo.markersCat
    
    image = new google.maps.MarkerImage(iconPath, null, null, new google.maps.Point(iconmid,iconmid), new google.maps.Size(iconsize, iconsize));
    isMarkerDraggable = if markerInfo.draggable? then markerInfo.draggable else false

    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lat, markerInfo.lng)
      map: @map
      icon: image
      visible: if markersCat is @defaultCat || isNew? then yes else no
      draggable: isMarkerDraggable
      cursor : if isMarkerDraggable then "move" else "pointer"
      title: markerInfo["data_translation"][window.LANG]["title"]
      animation: if isNew? then google.maps.Animation.DROP else no
    )

    if not defaultValue?
      marker["title"] = markerInfo["data_translation"][window.LANG]["title"]
      marker["desc"] = markerInfo["data_translation"][window.LANG]["desc"]
      marker["wikiLink"] = markerInfo["data_translation"][window.LANG]["wikiLink"]
    else
      marker["title"] = defaultValue[window.LANG]["title"]
      marker["desc"] = defaultValue[window.LANG]["desc"]
      marker["wikiLink"] = defaultValue[window.LANG]["wikiLink"]
      
    marker["type"]  = markersType
    marker["cat"]  = markersCat
    
    if markerInfo.lat.toString() is @getStartLat() and markerInfo.lng.toString() is @getStartLng()
      if not marker["infoWindow"]?
        createInfoWindow(marker)
        marker["infoWindow"].open()
      else
        marker["infoWindow"].open()
        
    google.maps.event.addListener(marker, 'dragend', (e)=>
      @saveToLocalStorage()
      if marker["infoWindow"]?
        marker["infoWindow"].updatePos()
    )

    google.maps.event.addListener(marker, 'click', (e)=>
      if marker["infoWindow"]?
        if @currentOpenedInfoWindow is marker["infoWindow"]
          @currentOpenedInfoWindow.close()
          
        else
          if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
          marker["infoWindow"].open()
      else  
        createInfoWindow(marker)
        if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        marker["infoWindow"].open()
    )
    
    markerType["markers"].push(marker) for markerType in @gMarker[markersCat]["marker_types"] when markerType.slug is markersType
    callBack()
  
  countTotalMarker:()->
    for markersCat, markersObjects of @MarkersConfig
      for markerTypeObject, key in markersObjects.marker_types
        for marker in markerTypeObject.markers
          @test++
          
  setAllMarkers: (callback) ->
    addCount = 0
    myCallBack = ()=>
      addCount++
      if addCount is @test
        callback()
    for markersCat, markersObjects of @MarkersConfig
      if not @gMarker[markersCat]?
        @gMarker[markersCat] = {}
        @gMarker[markersCat]["data_translation"] = markersObjects.data_translation
        @gMarker[markersCat]["marker_types"] = []
        
      for markerTypeObject, key in markersObjects.marker_types
        newmarkerTypeObject = {}
        newmarkerTypeObject["slug"] = markerTypeObject.slug
        newmarkerTypeObject["data_translation"] = markerTypeObject.data_translation
        newmarkerTypeObject["markers"] = []
        @gMarker[markersCat]["marker_types"].push(newmarkerTypeObject)
        
        otherInfo = 
          markersCat : markersCat
          markersType : markerTypeObject.slug
          icon       : markerTypeObject.icon
        
        defaultValue = null
        if markerTypeObject["data_translation"][window.LANG]["title"]? and markerTypeObject["data_translation"][window.LANG]["desc"]?
          defaultValue = markerTypeObject["data_translation"]
        
        # Passing false here so that the addmarker method won't threat this marker
        # has a new one (user added)
        @addMarker(marker, otherInfo, false, defaultValue, myCallBack) for marker in markerTypeObject.markers

  setAllMarkersVisibility:(isVisible)->
    for cat, markersObjects of @MarkersConfig
      @setMarkersVisibilityByType(isVisible, markerTypeObject.slug, cat) for markerTypeObject in markersObjects.marker_types when not $("[data-type='#{markerTypeObject.slug}']").hasClass('off')

  setMarkersVisibilityByType:(isVisible, type, cat)->
    for markerTypeObject in @gMarker[cat]["marker_types"] when markerTypeObject.slug is type
      marker.setVisible(isVisible) for marker in markerTypeObject.markers

  
  setMarkersVisibilityByCat:(isVisible, cat)->
    for markerTypeObject in @gMarker[cat]["marker_types"]
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

  destroyLocalStorage: (e) =>
    confirmMessage = "This action will destroy you local change to the map. Are you sure you want to proceed?"
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e and @getConfigFromLocalStorage()
        localStorage.removeItem(@localStorageKey);
        window.location = "/"
    )
  sendMapForApproval: (e) =>
    this_ = $(e.currentTarget)
    ajaxUrl = this_.attr('data-ajaxUrl')
    modal = new Modalbox()
    modal.setContent('<img class="loading" src="/assets/images/loading-black.gif">')
    confirmMessage = "Are you ready to send your map for approval?"
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      modal.open()
      
      # request = $.ajax(
      #   url: ajaxUrl
      #   type: "GET"
      #   dataType: "json"
      #   data: @handleExport()
      #   )
      # 
      # request.done((response) =>
      #   modal.close(()=>
      #     modal.setContent('<h1>Thank you!</h1>')
      #     modal.open()
      #   )
      # )
      # 
      # request.fail((jqXHR, textStatus)=>
      #   console.log 'fail'
      # )
      
      # Simulating ajax call latency
      t = setTimeout(()=>
        modal.close(()=>
          msg = """
          <h1>Thank you!</h1>
          <p>A team of dedicated grawls will sort that out.</p>
          """
          modal.setContent(msg)
          modal.open()
        )
        
      , 500)
    )
    
  handleExport:(e)=>
    exportMarkerObject = {}
    for markersCat, markersObjects of @gMarker
      if not exportMarkerObject[markersCat]?
        exportMarkerObject[markersCat] = {}
        console.log markersObjects
        exportMarkerObject[markersCat]["data_translation"] = markersObjects["data_translation"]
        exportMarkerObject[markersCat]["marker_types"] = []
        
      for markerTypeObject, key in markersObjects.marker_types
        newmarkerTypeObject = {}
        newmarkerTypeObject["data_translation"] = markerTypeObject["data_translation"]
        newmarkerTypeObject["slug"] = markerTypeObject.slug
        newmarkerTypeObject["markers"] = []
        exportMarkerObject[markersCat]["marker_types"].push(newmarkerTypeObject)
        for marker in markerTypeObject.markers
          nm = 
            "lng" : marker.getPosition().lng()
            "lat" : marker.getPosition().lat()
            "title" : marker.title
            "desc"  : marker.desc
            "wikiLink"  : marker.wikiLink
          exportMarkerObject[markersCat]["marker_types"][key]["markers"].push(nm)

    jsonString = JSON.stringify(exportMarkerObject)
    return jsonString
    # @exportWindow.find('.content').html(jsonString)
    # @exportWindow.show();
    
  handleAddTool: (e)=>
    this_      = $(e.currentTarget)
    parent     = this_.closest('.type-menu-item')
    markerLink = parent.find('.marker-type-link')
    markerType = markerLink.attr('data-type')
    markerCat  = markerLink.attr('data-cat')
    icon       = markerLink.attr('data-icon')
    coord      = @map.getCenter()
    otherInfo =
      markerCat : markerCat
      markerType : markerType
      icon : icon
    
    newMarkerInfo =
      desc      : ""
      title     : ""
      lat       : coord.lat()
      lng       : coord.lng()
      wikiLink  : ""
      draggable : true
    @addMarker(newMarkerInfo, otherInfo, true)
    
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
    
  removeMarkerFromType:(mType, mCat)->
    confirmMessage = "Delete all «#{mType}» markers on the map?"
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e
        for markerType, typeKey in @gMarker[mCat]["marker_types"] when markerType.slug is mType
          for marker, markerKey in markerType.markers
            marker.setMap(null)
            @gMarker[mCat]["marker_types"][typeKey]['markers'] = _.reject(markerType.markers, (m)=>
              return m == marker
            )
            @saveToLocalStorage()
    )
  
  removeMarker:(id, mType, mCat)->
    confirmMessage = "Are you sure you want to delete this marker?"
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e
        for markerType, typeKey in @gMarker[mCat]["marker_types"] when markerType.slug is mType
          for marker, markerKey in markerType.markers when marker.__gm_id is id
            if marker.infoWindow?
              marker.infoWindow.setMap(null)
            marker.setMap(null)
            @gMarker[mCat]["marker_types"][typeKey]['markers'] = _.reject(markerType.markers, (m) =>
              return m == marker
              # return m.__gm_id == id
            )
            @saveToLocalStorage()
            return true
    )
  
  updateMarkerInfos: (newInfo)->
    for markerType, typeKey in @gMarker[newInfo.cat]["marker_types"] when markerType.slug is newInfo.type
      for marker, markerKey in markerType.markers when marker.__gm_id is newInfo.id
        marker.desc = newInfo.desc
        marker.title = newInfo.title
        marker.wikiLink = newInfo.wikiLink
        @saveToLocalStorage()
        return
        
  
  saveToLocalStorage: ()->
    # Save new exported JSON to local storage if it is supported
    if App.localStorageAvailable
      json = @handleExport()
      localStorage.setItem(@localStorageKey, json);

  
  setDraggableMarker:(val)->
    unDrag = (marker)->
      marker.setDraggable(false)
      marker.setCursor('pointer')
      
    for type, markersObjects of @gMarker
      for markerTypeObject, key in markersObjects.marker_types
        unDrag(marker) for marker in markerTypeObject.markers
        
  toggleMarkerList: (e)=>
    this_ = $(e.currentTarget)
    @markerList.toggleClass('active')
    this_.toggleClass('active')
    if this_.hasClass('active')
      @removeMarkerLink.removeClass('active')
      @optionsBox.removeClass('red')
      @canRemoveMarker = false

  getMarkerByCoordinates:(lat, lng)->
    for markersCat, markersObjects of @MarkersConfig
      for markerTypeObject, key in markersObjects.marker_types
        return marker for marker in markerTypeObject.markers when marker.lat is lat and marker.lng is lng
    return false  
      
  turnOfMenuIconsFromCat:(markerCat)->
    menu = $(".menu-item[data-markerCat='#{markerCat}']")
    menu.find('.group-toggling').addClass('off')
    menu.find('.trigger').addClass('off')
  
  addMenuIcons:(callback)->
    markersOptions = $.get('assets/javascripts/templates/markersOptions._', (e)=>
      template = _.template(e);
      html = $(template(@MarkersConfig))
      
      # Binding click on marker icon in markers option list
      html.find(".trigger").bind 'click', (e) =>
        item           = $(e.currentTarget)
        myGroupTrigger = item.closest(".menu-marker").find('.group-toggling')
        markerType     = item.attr('data-type')
        markerCat      = item.attr('data-cat')

        if @canToggleMarkers
          if item.hasClass('off')
            @setMarkersVisibilityByType(true, markerType, markerCat)
            item.removeClass('off')
            myGroupTrigger.removeClass('off')
          else
            @setMarkersVisibilityByType(false, markerType, markerCat)
            item.addClass('off')
      
      html.find('.group-toggling').bind 'click', (e)=>
        this_ = $(e.currentTarget)
        menuItem = this_.closest('.menu-item')
        markerCat = menuItem.attr('data-markerCat')
        if this_.hasClass('off')
          this_.removeClass('off')
          @setMarkersVisibilityByCat(on, markerCat)
          menuItem.find('.trigger').removeClass('off')
        else
          this_.addClass('off')
          @setMarkersVisibilityByCat(off, markerCat)
          menuItem.find('.trigger').addClass('off')
            
      @markersOptionsMenu.find('.padding').prepend(html)
      callback()
      @turnOfMenuIconsFromCat(markerCat) for markerCat of @MarkersConfig when markerCat isnt @defaultCat
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

###
# class CustomInfoWindow {{{
###
class CustomInfoWindow
  constructor: (marker, content, opts) ->
    @content = content
    @marker  = marker
    @template = opts.template
    @map     = marker.map
    wrap = """
    <div class="customInfoWindow">
      <a href="javascript:" title="Close" class="close button"></a>
        <div class="padding"></div>
    </div>
    """
    @wrap = $(wrap)
    @closeBtn = @wrap.find('.close')
    @setMap(@map)
    @isVisible = false
    @onClose   = opts.onClose
    @onOpen    = opts.onOpen
    @onSave    = opts.onSave
    @deleteCalled = opts.deleteCalled
    @moveCalled = opts.moveCalled
    @closeBtn.bind('click', @close)

  CustomInfoWindow:: = new google.maps.OverlayView()
  
  
  onAdd:()->
      @wrap.find('.padding').append(@content)
      @wrap.css(
        display: "block"
        position: "absolute"
      )
      panes = @getPanes()
      panes.overlayMouseTarget.appendChild(@wrap[0])
      @iWidth = @wrap.outerWidth()
      @iHeight = @wrap.outerHeight()
      
      @bindButton()
      # @open()
  bindButton: () ->
    @wrap.find('button').bind('click', @handleSave)
    @wrap.find('.iw-options-list .button').bind('click', @toggleSection)
    
  onRemove :() ->
    # console.log @wrap.parent()
    @wrap[0].parentNode.removeChild(@wrap[0])
    @wrap = null
    
  draw: () ->
    cancelHandler = (e)=>
        e.cancelBubble = true
        if e.stopPropagation
          e.stopPropagation()
    
    overlayProjection = @getProjection()
    pos = overlayProjection.fromLatLngToDivPixel(@marker.position)
    @wrap.css(
      left: pos.x + 30
      top: pos.y - 80
    )
    
    events = ['mousedown', 'touchstart', 'touchend', 'touchmove', 'contextmenu', 'click', 'dblclick', 'mousewheel', 'DOMMouseScroll']
    @listeners = []
    for event in events
      @listeners.push(google.maps.event.addDomListener(@wrap[0], event, cancelHandler);)
    
  close:()=>
    if @wrap
      @onClose(this)
      @isVisible = false
      @wrap.css(
        display : "none"
      )
  open:()=>
    if @wrap
      @panMap()
      @onOpen(this)
      @isVisible = true
      @wrap.css(
        display : "block"
      )
  
  updatePos: ()->
    overlayProjection = @getProjection()
    pos = overlayProjection.fromLatLngToDivPixel(@marker.position)

    shareInput = @wrap.find('[name="share-link"]') 
    val = shareInput.val()
    newVal = val.split("?")[0] + "?lat=" + @marker.position.lat() + "&lng=" + @marker.position.lng()
    shareInput.val(newVal)

    @wrap.css(
      left: pos.x + 30
      top: pos.y - 80
    )
    
  toggleSection: (e) =>
    this_ = $(e.currentTarget)
    action = this_.attr('data-action')
    defaultTab = @wrap.find('.marker-desc')
    activeTab = @wrap.find('.toggling-tab.active') 
    targetTab = $("[data-target='#{action}']")

    switch action
      when "move", "share", "edit"
        @wrap.find('.iw-options-list .button').removeClass('active')
        if targetTab.attr("data-target") is activeTab.attr("data-target")
          targetTab.removeClass('active')
          defaultTab.addClass('active')
        else
          this_.addClass('active')
          activeTab.removeClass('active')
          targetTab.addClass('active')
          defaultTab.removeClass('active')
      when "delete"
        @deleteCalled(@marker)
      
    if action is "move"
      @moveCalled(@marker)

  handleSave: (e) =>
    this_ = $(e.currentTarget)
    form = @wrap.find('.edit-form')
    newTitle = @wrap.find('[name="marker-title"]').val()
    newDesc = @wrap.find('[name="marker-description"]').val()
    newWikiLink = @wrap.find('[name="marker-wiki"]').val()
    form.removeClass('active')
    newInfo = 
      id    : @marker.__gm_id
      title : newTitle
      desc  : newDesc
      wikiLink : newWikiLink
      type : @marker.type
      cat  : @marker.cat
      lat  : @marker.position.lat()
      lng  : @marker.position.lng()
    @wrap.find('.padding').html(@template(newInfo))
    @bindButton()
    @wrap.find('.edit').removeClass('active')
    @onSave(newInfo)
  
  panMap: () -> 
    @map.panTo(new google.maps.LatLng(@marker.position.lat(), @marker.position.lng()));

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
