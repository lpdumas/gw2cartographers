# Plane Guild Wars 2 map
## About
A simple custom google maps for Guildwars 2. More to come!

## Missing fonctionalities

* InfoWindow on marker's click
* More markers types
* Toggling between marker type
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
{"lng" : "19.00499664280239", "lat" : "75.574951171875", "title" : "Ascalonian Catacombs", "desc" : ""}
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