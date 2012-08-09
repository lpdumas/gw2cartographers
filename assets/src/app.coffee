window.Cartographer = {}

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
    if lang? and (lang is "fr" or lang is "en")
      Cartographer.switchLang(lang)
    else
      this.navigate("fr", {trigger : true})
      
  handleCoord: (lang, lat, lgn)->
    @handleLang(lang)
    Cartographer.highlighMarker(
      lat : lat
      lgn : lgn
    )
) 

Cartographer.initiate = ()->
  @cartographerRouter = new Cartographer.router()

Cartographer.switchLang = (lang)->
  console.log "switching lang to #{lang}"

Cartographer.highlighMarker = (coord)->
  console.log "highlighting marker at #{coord.lat}, #{coord.lgn}"

$ ()->
  
  Cartographer.initiate()