# CONSTANT
window.LANG = "en"

##################
#--CARTOGRAPHER--
###############{{{
Cartographer.initiate = ()->
  @router = new Cartographer.router()
  console.log "loading map"
Cartographer.switchLang = (lang)->
  if window.LANG isnt lang
    console.log "switching lang to #{lang}"
    window.LANG = lang

Cartographer.highlighMarker = (coord)->
  console.log "highlighting marker at #{coord.lat}, #{coord.lgn}"
# }}}

#################
#----ROUTER------
##############{{{
Cartographer.router = Backbone.Router.extend(
  routes: {}
    # ":lang" : "handleLang"
    # ":lang/lat/:lat/lgn/:lgn" : "handleCoord"

  initialize: ()->
    routes = [
      [ /^(en|fr)*\/*$/, 'handleLang', this.handleLang ]
      [ /^(en|fr)*\/lat\/([0-9.]+)\/lgn\/([0-9.]+)\/*$/, 'handleCoord', this.handleLangWithParams ]
    ]
    _.each(routes, (route)=>
      this.route.apply(this,route)
    )
    
    Backbone.history.start()
    
  handleLang: (lang)->
    Cartographer.switchLang(lang)
      
  handleCoord: (lang, lat, lgn)->
    @handleLang(lang)
    Cartographer.highlighMarker(
      lat : lat
      lgn : lgn
    )
) 
# }}}

$ ()->
  Cartographer.initiate()