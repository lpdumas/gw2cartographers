# Plane Guild Wars 2 map
## About
A simple custom google maps for Guildwars 2. More to come!

## Missing fonctionalities

* Working on a crowd sourcing solution
* More markers types
* Dynamic events chain: Toggling between different chains live on the map.
* URL sharing
* iFrame embeding

I can't think of anything else right now. Waiting suggestions.

## Wanna help ?
Do you want to contribute to the project by adding new markers or fixing the existing ones ? Follow these steps !
* First get https://github.com/jsilvestre/gw2cartographers/blob/master/assets/javascripts/config.js

### Adding a new marker
* Find the section you want. For example, to add a "heart" marker find the Markers.hearts section.
* Add a line the relevant section. Make sure the marker you are going to add does not already exist.
```javascript
{"lat" : "19.00499664280239", "lng" : "75.574951171875", "title" : "Ascalonian Catacombs", "desc" : ""}
```
* The "lng" and "lat" attributes must be filled thanks to the application. "title" and "desc" are self-explanatory.

### Adding a new marker type
* You can add a line to the Resources.Icons section following what already exist. Make sure the marker you want to add doesn't exist already.
* You will find a list of image for the markers in https://github.com/jsilvestre/gw2cartographers/tree/master/assets/images/icons/32x32.
* For example, you could add the asura's gates.
```javascript
"asuras_gates" : {"label" : "Asuras's Gates", "url" : Resources.Paths.icons + "asuraGate.png"}
```
The first part of the line is the identifier: only lowercased letters and underscores (_) here.

* Then add the new section at the end of the file.
```javascript
Markers.identifier = []
```
Where identifier is the you used previously.

### A big thank you to
http://bramus.github.com/photoshop-google-maps-tile-cutter/example/

### Copyrights and term of use

gw2cartographers.com is an open source project created for non-commercial use. Arenanet's [term of use](http://www.guildwars2.com/en/media/asset-kit/terms-of-use.html)

© 2011 ArenaNet, Inc. All rights reserved. NCsoft, the interlocking NC logo, ArenaNet, Arena.net, Guild Wars, Guild Wars Factions, Factions, Guild Wars Nightfall, Nightfall, Guild Wars: Eye of the North, Guild Wars Eye of the North, Eye of the North, Guild Wars 2, and all associated logos and designs are trademarks or registered trademarks of NCsoft Corporation. All other trademarks are the property of their respective owners.