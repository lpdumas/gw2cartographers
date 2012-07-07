Resources.Paths = {
    "icons" : "assets/images/icons/32x32/"
}

Resources.Icons = {
  "explore" : {
    "hearts" : {"label" : "Hearts", "url" : Resources.Paths.icons + "hearts.png"},
    "waypoints" : {"label" : "Waypoints", "url" : Resources.Paths.icons + "waypoints.png"},
    "skillpoints" : {"label" : "Skill points", "url" : Resources.Paths.icons + "skillpoints.png"},
    "poi" : {"label" : "Points of interest", "url" : Resources.Paths.icons + "poi.png"},
    "dungeons": {"label" : "Dungeons", "url" : Resources.Paths.icons + "dungeon.png"},
    "asurasgates" : {"label" : "Asura gates", "url" : Resources.Paths.icons + "asuraGate.png"},
    "scouts" : {"label" : "Scouts", "url" : Resources.Paths.icons + "scout.png"},
    "jumpingpuzzles" : {"label" : "Jumping puzzles", "url" : Resources.Paths.icons + "puzzle.png"}
  }
  ,
  "train" : {
    "rangerSkillBooks" : {"label" : "Ranger training", "url" : Resources.Paths.icons + "skillBookRanger.png"},
    "necroSkillBooks" : {"label" : "Necromancer training", "url" : Resources.Paths.icons + "skillBookNecro.png"},
    "warriorSkillBooks" : {"label" : "Warrior training", "url" : Resources.Paths.icons + "skillBookWarrior.png"},
    "guardianSkillBooks" : {"label" : "Guardian training", "url" : Resources.Paths.icons + "skillBookGuardian.png"},
    "mesmerSkillBooks" : {"label" : "Mesmer training", "url" : Resources.Paths.icons + "skillBookMesmer.png"},
    "eleSkillBooks" : {"label" : "Elementalist training", "url" : Resources.Paths.icons + "skillBookEle.png"},
    "engiSkillBooks" : {"label" : "Engineer training", "url" : Resources.Paths.icons + "skillBookEngi.png"},
    "thiefSkillBooks" : {"label" : "Thief training", "url" : Resources.Paths.icons + "skillBookThief.png"}
  }
}
//{{{
Areas = [
{ name : "Divinity's Reach", rangeLvl : "",
     summary : {
         "hearts" : 0,
         "waypoints" : 13,
         "skillpoints" : 0,
         "poi" : 20,
         "dungeons" : 0 
     },
     "neLat" : "43.19591001164034", "neLng" : "-31.519775390625", "swLat" : "33.44977658311853", "swLng" : "-45.955810546875"
 },
 { name : "Queensdale",  rangeLvl : "1 - 17",
     summary : {
         "hearts" : 17,
         "waypoints" : 16,
         "skillpoints" : 7,
         "poi" : 21,
         "dungeons" : 1
     },
     "neLat" : "33.38558626887102", "neLng" : "-23.8623046875", "swLat" : "18.406654713919085", "swLng" : "-48.27392578125"
 },
 { name : "Kessex Hills",  rangeLvl : "15 - 25",
     summary : {
         "hearts" : 14,
         "waypoints" : 18,
         "skillpoints" : 5,
         "poi" : 16,
         "dungeons" : 0
     },
     "neLat" : "18.36495262653919", "neLng" : "-23.5546875", "swLat" : "4.598327203100929", "swLng" : "-51.17431640625"
 },
 { name : "Gendarran Fields",  rangeLvl : "25 - 35",
     summary : {
         "hearts" : 11,
         "waypoints" : 22,
         "skillpoints" : 7,
         "poi" : 15,
         "dungeons" : 0
     },
     "neLat" : "29.765834552626156", "neLng" : "5.685546875", "swLat" : "17.576565709783402", "swLng" : "-22.88427734375"
 },
 { name : "Black Citadel",  rangeLvl : "",
     summary : {
         "hearts" : 0,
         "waypoints" : 12,
         "skillpoints" : 0,
         "poi" : 18,
         "dungeons" : 0
     },
     "neLat" : "20.786930592570368", "neLng" : "57.94189453125", "swLat" : "11.081384602413175", "swLng" : "47.900390625"
 },
 { name : "Plains of Ashford",  rangeLvl : "1 - 15",
     summary : {
         "hearts" : 16,
         "waypoints" : 18,
         "skillpoints" : 5,
         "poi" : 26,
         "dungeons" : 1
     },
     "neLat" : "21.764601405744017", "neLng" : "85.682373046875", "swLat" : "7.983077720238533", "swLng" : "58.73291015625 "
 },
 { name : "Diessa Plateau",  rangeLvl : "15 - 25",
     summary : {
         "hearts" : 15,
         "waypoints" : 19,
         "skillpoints" : 8,
         "poi" : 21,
         "dungeons" : 0
     },
     "neLat" : "35.54116627999818", "neLng" : "71.47705078125", "swLat" : "21.463293441899314", "swLng" : "47.373046875"
 },
 { name : "Hoelbrak",  rangeLvl : "",
     summary : {
         "hearts" : 0,
         "waypoints" : 14,
         "skillpoints" : 0,
         "poi" : 24,
         "dungeons" : 0
     },
     "neLat" : "22.907803451058495", "neLng" : "34.4970703125", "swLat" : "12.747516274952828", "swLng" : "21.280517578125 "
 },
 { name : "Wayfarer Foothills",  rangeLvl : "1 - 15",
     summary : {
         "hearts" : 16,
         "waypoints" : 17,
         "skillpoints" : 8,
         "poi" : 18,
         "dungeons" : 0
     },
     "neLat" : "34.768691457552755", "neLng" : "46.5380859375", "swLat" : "20.97873309555621", "swLng" : "35.41748046875"
 },
 { name : "Snowden Drifts",  rangeLvl : "15 - 25",
     summary : {
         "hearts" : 13,
         "waypoints" : 18,
         "skillpoints" : 6,
         "poi" : 20,
         "dungeons" : 0
     },
     "neLat" : "35.89795019335764", "neLng" : "34.4970703125", "swLat" : "23.95613633396941", "swLng" : "6.61376953125 "
 },
 { name : "Lion's Arch",  rangeLvl : "",
     summary : {
         "hearts" : 0,
         "waypoints" : 13,
         "skillpoints" : 0,
         "poi" : 20,
         "dungeons" : 0
     },
     "neLat" : "17.025272685376905", "neLng" : "5.526123046875", "swLat" : "6.263804863758637", "swLng" : "-10.099023437500023"
 }
]
//}}}
Markers.train = {
  name : "Train",
  markerGroup : [{
    name : "Rangers",
    slug : "rangerSkillBooks",
    markers : []
  },
  {
    name : "Necromancer",
    slug : "necroSkillBooks",
    markers : []
  },
  {
    name : "Warrior",
    slug : "warriorSkillBooks",
    markers : []
  },
  {
    name : "Guardian",
    slug : "guardianSkillBooks",
    markers : []
  },
  {
    name : "Mesmer",
    slug : "mesmerSkillBooks",
    markers : []
  },
  {
    name : "Elementalist",
    slug : "eleSkillBooks",
    markers : []
  },
  {
    name : "Engineer",
    slug : "engiSkillBooks",
    markers : []
  },
  {
    name : "Thief",
    slug : "thiefSkillBooks",
    markers : []
  }
  ]
}

Markers.explore = {
  name : "Explore",
  markerGroup : [{
    name : "Hearts",
    slug : "hearts",
    markers : [
      //Queensdale
      {"lat" : "29.19053283229458", "lng" : "-44.384765625", "title" : "Help Farmer Diah", "desc" : "Help Diah by watering corn, stomping wurm mounds, feeding cattle, and defending the fields.", "wikiLink" : ""},
      {"lat" : "29.439597566602927", "lng" : "-46.636962890625", "title" : "Help Farmer George", "desc" : "Make the area around the pumping station safe for Farmer George.", "wikiLink" : ""},
      {"lat" : "31.5129958574547", "lng" : "-46.549072265625", "title" : "Help Farmer Eda", "desc" : "Eda could use some help in her orchard, especially with the spider infestation.", "wikiLink" : ""},
      {"lat" : "28.832746799225906", "lng" : "-37.430419921875", "title" : "Assist the Seraph at Shaemoor Garrison", "desc" : "Drive back centaur forces and secure remaining farmlands.", "wikiLink" : ""},
      {"lat" : "20.889607510404392", "lng" : "-27.0703125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "23.2312509238978", "lng" : "-31.44287109375", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "26.20473426710763", "lng" : "-30.0146484375", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "22.014360653103232", "lng" : "-38.14453125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "21.156238366109456", "lng" : "-41.68212890625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "25.254632619749476", "lng" : "-37.880859375", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "28.950475674848033", "lng" : "-34.4091796875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "30.477082932837707", "lng" : "-29.90478515625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "27.809927780908378", "lng" : "-26.3232421875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "31.13760327002129", "lng" : "-25.59814453125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "32.29641979896909", "lng" : "-27.44384765625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
    
      //Plains of Ashford
      {"lat" : "18.760712758499654", "lng" : "61.36962890625", "title" : "1", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "17.780074126643353", "lng" : "62.55615234375", "title" : "2", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "19.197053439464952", "lng" : "63.52294921875", "title" : "3", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "19.9423691895421", "lng" : "65.1708984375", "title" : "4", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "16.22522362192416", "lng" : "67.3681640625", "title" : "5", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "16.140815555276113", "lng" : "62.99560546875", "title" : "6", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "19.508020154916856", "lng" : "73.58642578125", "title" : "8", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "16.246319993438792", "lng" : "71.96044921875", "title" : "9", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "20.704738720055598", "lng" : "79.541015625", "title" : "10", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "14.4240404443548", "lng" : "82.41943359375", "title" : "11", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "12.715367628772212", "lng" : "79.03564453125", "title" : "12", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "9.784851250750693", "lng" : "76.904296875", "title" : "13", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "11.813588069771376", "lng" : "70.51025390625", "title" : "14", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "12.307802336622958", "lng" : "61.259765625", "title" : "16", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
    
    //Gendarran Fields
      {"lat" : "19.777042202226067", "lng" : "-19.86328125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "22.482106236077787", "lng" : "-17.99560546875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "22.988738160960843", "lng" : "-13.20556640625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "20.478481600090667", "lng" : "-7.03125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "23.99628979062852", "lng" : "-7.3388671875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "26.53939432901716", "lng" : "-18.28125", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "25.115445397062043", "lng" : "-3.779296875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "22.68498414287222", "lng" : "-1.77978515625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "26.500072915744475", "lng" : "2.17529296875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "23.574056966642782", "lng" : "3.603515625", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
      {"lat" : "21.115249309963882", "lng" : "3.4716796875", "title" : "", "desc" : "", "wikiLink" : "", "wikiLink" : ""},
    
    //Snowden Drifts
      {"lat" : "31.438037173124567", "lng" : "31.552734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.525670426175928", "lng" : "27.26806640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.609549797190944", "lng" : "26.3232421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.98102014898158", "lng" : "25.0927734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.091882620021885", "lng" : "18.52294921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.552800413453646", "lng" : "13.16162109375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.514949045177808", "lng" : "8.701171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.830899063394483", "lng" : "10.87646484375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.29437116258826", "lng" : "12.85400390625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.07564844563063", "lng" : "13.798828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.537129399080044", "lng" : "31.46484375", "title" : "", "desc" : "", "wikiLink" : ""},
    
    //Kessex Hills
      {"lat" : "6.762806474971493", "lng" : "-29.77294921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.026594842489587", "lng" : "-32.23388671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.21762535319959", "lng" : "-35.52978515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.982749041623862", "lng" : "-40.14404296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.383109216353283", "lng" : "-42.86865234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.196000424383586", "lng" : "-47.724609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "4.97056012793202", "lng" : "-46.77978515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.37285060179588", "lng" : "-48.0322265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.26741410165705", "lng" : "-43.79150390625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.972442010578405", "lng" : "-34.87060546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.697086445411754", "lng" : "-33.3984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.57012785265944", "lng" : "-26.69677734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.82191551596887", "lng" : "-29.94873046875", "title" : "", "desc" : "", "wikiLink" : ""},
    
    //Diessa Plateau
      {"lat" : "30.873940237887673", "lng" : "51.7236328125", "title" : "1", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.92570748876045", "lng" : "49.85595703125", "title" : "2", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.758028282691168", "lng" : "58.42529296875", "title" : "Help the Blood Legion combat ghost siege weapons. (19)", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.027170140497404", "lng" : "54.3603515625", "title" : "4", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.421184710331893", "lng" : "57.85400390625", "title" : "5", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.412847064309968", "lng" : "51.50390625", "title" : "6", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.53712939907997", "lng" : "50.86669921875", "title" : "7", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.82479361826492", "lng" : "57.23876953125", "title" : "Assist the Quarry Workers (17)", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.32547125932813", "lng" : "66.6650390625", "title" : "Assist Bloodsaw Mill workers (24)", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.40171052870773", "lng" : "64.423828125", "title" : "Protect Redreave Mill From Human Separatist (22)", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.234758470233754", "lng" : "67.56591796875", "title" : "11", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.630123006707414", "lng" : "67.47802734375", "title" : "Assist the Ash Legion (25)", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.69759650228324", "lng" : "60.7763671875", "title" : "13", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.916331404599124", "lng" : "60.66650390625", "title" : "Help Rak Deachmare maintain StoneFall Estate (21)", "desc" : "", "wikiLink" : ""},
    
    //Wayfarer Foothills
      {"lat" : "9.806503561727165", "lng" : "40.166015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.438224391343384", "lng" : "41.50634765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.522390602069239", "lng" : "44.6923828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.742053062720423", "lng" : "43.154296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.402759378194212", "lng" : "40.8251953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.38209494787754", "lng" : "39.00146484375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.21105827648823", "lng" : "41.85791015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.03643072466741", "lng" : "43.79150390625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.671235828577068", "lng" : "38.408203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.735762444449126", "lng" : "43.9892578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.08116546459062", "lng" : "41.8798828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.43803717312449", "lng" : "45.15380859375", "title" : "", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name : "Waypoints",
    slug : "waypoints",
    markers : [
      //Queensdale
      {"lat" : "31.306715155075167", "lng" : "-45.516357421875", "title" : "Orchard Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.19053283229458", "lng" : "-43.033447265625", "title" : "Fields Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.9168522330702", "lng" : "-40.4296875", "title" : "Shaemoor Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.816969440401084", "lng" : "-37.957763671875", "title" : "Garrison Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.106120832355593", "lng" : "-37.55126953125", "title" : "Trading Post Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.150462029224112", "lng" : "-29.86083984375", "title" : "Godslost Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.06890909546339", "lng" : "-30.6298828125", "title" : "Monastery Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.696545111585152", "lng" : "-26.8505859375", "title" : "Tunwatch Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.072501451715098", "lng" : "-31.8603515625", "title" : "Swamplost Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.745840238902282", "lng" : "-36.8701171875", "title" : "Heartwood Pass Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.401933838235202", "lng" : "-42.1435546875", "title" : "Claypool Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.51713945052516", "lng" : "-41.33056640625", "title" : "Crossing Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.2312509238978", "lng" : "-45.5712890625", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.869228848968337", "lng" : "-33.64013671875", "title" : "Ojon's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.062345409804433", "lng" : "-24.89501953125", "title" : "Beetletun Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.624152158090435", "lng" : "-34.78271484375", "title" : "Phiney Waypoint", "desc" : "", "wikiLink" : ""},
    
      //Black Citadel
      {"lat" : "18.15629140283555", "lng" : "50.504150390625", "title" : "Ligacus Aquilo Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.947855781294248", "lng" : "52.679443359375", "title" : "Memorial Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.706828124019655", "lng" : "52.020263671875", "title" : "Bane Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.119792500787185", "lng" : "52.371826171875", "title" : "Imperator's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.68589519673879", "lng" : "54.33837890625", "title" : "Hero's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.287709050622045", "lng" : "56.72265625", "title" : "Mustering Ground Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.474857402687368", "lng" : "53.26171875", "title" : "Junker's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.040672893673733", "lng" : "52.657470703125", "title" : "Gladium Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.464421817388587", "lng" : "50.833740234375", "title" : "Ruins of Rin Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.21065623448997", "lng" : "51.998291015625", "title" : "Diessa Gate Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.673625561844506", "lng" : "54.437255859375", "title" : "Factorium Waypoint", "desc" : "", "wikiLink" : ""},
    
      //Divinity's Reach
      {"lat" : "41.763117447005975", "lng" : "-38.21044921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.90973623453729", "lng" : "-39.803466796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.977120098439734", "lng" : "-42.813720703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "38.01347623104201", "lng" : "-41.099853515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "36.066862132578954", "lng" : "-42.769775390625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "36.057981047025116", "lng" : "-39.04541015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "35.95132986152274", "lng" : "-38.29833984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "35.67514743608477", "lng" : "-34.024658203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "38.048091067457335", "lng" : "-38.155517578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "37.848832506474125", "lng" : "-35.628662109375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.82408857733381", "lng" : "-33.914794921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.52946653645175", "lng" : "-36.58447265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.9433599465789", "lng" : "-38.60595703125", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Hoelbrak
      {"lat" : "21.217700673132434", "lng" : "32.9150390625", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.42515371896027", "lng" : "31.541748046875", "title" : "Bear Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.251890313953055", "lng" : "29.498291015625", "title" : "Raven Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.76071275849968", "lng" : "27.147216796875", "title" : "Snow Leopard Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.13478918833265", "lng" : "24.3017578125", "title" : "Hero's Compass Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.7", "lng" : "32.8", "title" : "Legends Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.020527657852455", "lng" : "29.366455078125", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.993755452894675", "lng" : "28.67431640625", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.04628122538919", "lng" : "26.12548828125", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.284185114076546", "lng" : "31.9921875", "title" : "Eastern Watchpost Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.846605106396417", "lng" : "31.124267578125", "title" : "Wolf Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.73238608141858", "lng" : "27.3779296875", "title" : "Great Lodge Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.56231770191497", "lng" : "29.805908203125", "title" : "Southern Watchpost Waypoint", "desc" : "", "wikiLink" : ""},
    
      //Lion's Arch
      {"lat" : "13.0", "lng" : "-7.4", "title" : "Western Ward Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.919073517982541", "lng" : "-4.41650390625", "title" : "Canal Ward Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.3", "lng" : "-6.1", "title" : "Sanctum Harbor Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.1", "lng" : "-2.8", "title" : "Plaza Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.903921416775091", "lng" : "-8.10791015625", "title" : "Diverse Lodges", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.033766870069377", "lng" : "-1.0986328125", "title" : "Fort Mariner", "desc" : "", "wikiLink" : ""},
      {"lat" : "7.482303825233107", "lng" : "0.439453125", "title" : "Bloodcoast Ward Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.090179355733854", "lng" : "0.120849609375", "title" : "Eastern Ward Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.040295996106867", "lng" : "1.571044921875", "title" : "Smuggler's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.4", "lng" : "-2.8", "title" : "Trader's Forum Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.8", "lng" : "-4.0", "title" : "Lion's Claw Dock Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.368243250897414", "lng" : "2.98828125", "title" : "Lion's Shadow Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.012129557908269", "lng" : "2.823486328125", "title" : "Tokk's Waypoint", "desc" : "", "wikiLink" : ""},
    
      //Plains of Ashford
      {"lat" : "19.114029215762084", "lng" : "60.57861328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.31917640744295", "lng" : "59.69970703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.238549860797505", "lng" : "63.78662109375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.880391767822594", "lng" : "69.54345703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.56249250837498", "lng" : "71.806640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.260653356758464", "lng" : "75.5859375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.251890313953027", "lng" : "79.5849609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.794023610508134", "lng" : "79.013671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.971891580929071", "lng" : "83.0126953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.801088279674424", "lng" : "84.4189453125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.350734120814117", "lng" : "78.50830078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.763197528547348", "lng" : "80.595703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.878102209376678", "lng" : "71.47705078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.469257905863346", "lng" : "68.2470703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.188783763403356", "lng" : "66.73095703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.4240404443548", "lng" : "61.98486328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.016688524459965", "lng" : "62.0947265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.654775665159775", "lng" : "64.1162109375", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Gendarran Fields
      {"lat" : "20.08688850556112", "lng" : "-19.8193359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.04940739011068", "lng" : "-19.5556640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.99628979062852", "lng" : "-17.64404296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.581367353810133", "lng" : "-15.53466796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.27162705391839", "lng" : "-12.8759765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.373809171544103", "lng" : "-9.1845703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.116177147210735", "lng" : "-10.08544921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.78151672434982", "lng" : "-10.7666015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.28151823530902", "lng" : "-6.1962890625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.794654487638184", "lng" : "-22.1044921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.04656562272895", "lng" : "-16.611328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.849336891707704", "lng" : "-6.39404296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.44937385955676", "lng" : "-6.85546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.565502029745446", "lng" : "-4.74609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.2560056198251", "lng" : "-0.63720703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.770213848960374", "lng" : "1.07666015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.441494859380374", "lng" : "-1.23046875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.708473013246085", "lng" : "3.53759765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.500072915744475", "lng" : "4.28466796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.88465917954292", "lng" : "2.98828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.6", "lng" : "-15.3", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.6", "lng" : "-21.5", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Snowden Drifts
      {"lat" : "33.367237465838414", "lng" : "33.22265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.53371242139575", "lng" : "27.7294921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.06890909546349", "lng" : "31.04736328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.98702796028043", "lng" : "22.8076171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.53371242139575", "lng" : "24.2578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.83504997263528", "lng" : "16.72119140625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.72259860404417", "lng" : "7.80029296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.704058230919607", "lng" : "7.97607421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.24486252149738", "lng" : "7.31689453125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.200123477645086", "lng" : "11.8212890625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.770213848960374", "lng" : "9.0966796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.334096684794556", "lng" : "15.6884765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.106120832355618", "lng" : "19.53369140625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.61180952105558", "lng" : "21.97265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.31423555219768", "lng" : "24.2138671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.730632525532013", "lng" : "32.62939453125", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Kessex Hills
      {"lat" : "8.135367205502869", "lng" : "-28.05908203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.979670885582076", "lng" : "-24.697265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "7.286190082778875", "lng" : "-33.486328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.050065023002487", "lng" : "-32.7392578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.878102209376602", "lng" : "-39.61669921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.044584984211827", "lng" : "-47.13134765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "5.517575200830646", "lng" : "-46.6259765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "6.697342732664423", "lng" : "-41.63818359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.32926910761284", "lng" : "-43.41796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.445319477691255", "lng" : "-50.42724609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.08829121795549", "lng" : "-46.845703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.330682820381487", "lng" : "-44.3408203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.025272685376816", "lng" : "-41.4404296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.697086445411754", "lng" : "-36.80419921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.193274736612832", "lng" : "-34.78271484375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.571241563074171", "lng" : "-28.67431640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.971891580928995", "lng" : "-26.38916015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.96223292114012", "lng" : "-30.43212890625", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Diessa Plateau
      {"lat" : "30.96818929679427", "lng" : "49.04296875", "title" : "Charrgate Haven Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.9810201489815", "lng" : "54.82177734375", "title" : "Bloodcliff Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.64402894504787", "lng" : "52.20703125", "title" : "Butcher's Block Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.96970080869418", "lng" : "57.54638671875", "title" : "Blasted Moors Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.05649649076856", "lng" : "56.93115234375", "title" : "Nageling Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.271627053918312", "lng" : "51.2841796875", "title" : "Nolan Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.31499127724558", "lng" : "60.22705078125", "title" : "Manbane's Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.3706449247866", "lng" : "64.00634765625", "title" : "Fort of Rhand Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.905541455900405", "lng" : "63.80859375", "title" : "??", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.10994829789434", "lng" : "68.291015625", "title" : "Incendio Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.154627220775996", "lng" : "65.28076171875", "title" : "Bloodsaw Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.88763921713654", "lng" : "61.98486328125", "title" : "Dawnright Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.53939432901708", "lng" : "65.0390625", "title" : "Redreave Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.10803380146314", "lng" : "70.11474609375", "title" : "Nemus Grove Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.30650325984886", "lng" : "69.27978515625", "title" : "Sanctum Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.45316801591622", "lng" : "62.0947265625", "title" : "Breached Wall Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.421184710331893", "lng" : "68.97216796875", "title" : "Breachwater Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.2", "lng" : "55.0", "title" : "Charradis Estate Waypoint", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.5", "lng" : "51.0", "title" : "Oldgate Waypoint", "desc" : "", "wikiLink" : ""},
    
      //Wayfarer Foothills
      {"lat" : "9.763197528547286", "lng" : "40.25390625", "title" : "1", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.512322409887782", "lng" : "43.9013671875", "title" : "2", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.758231584069833", "lng" : "40.49560546875", "title" : "3", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.891704754215514", "lng" : "40.341796875", "title" : "4", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.95539932594267", "lng" : "38.34228515625", "title" : "5", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.11452913883854", "lng" : "37.353515625", "title" : "6", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.008964269673143", "lng" : "37.19970703125", "title" : "7", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.684984142872146", "lng" : "41.1328125", "title" : "8", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.835600986620975", "lng" : "44.18701171875", "title" : "9", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.65449123359245", "lng" : "44.58251953125", "title" : "10", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.01019643193155", "lng" : "43.43994140625", "title" : "11", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.353451668635046", "lng" : "42.38525390625", "title" : "12", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.04056643058465", "lng" : "39.26513671875", "title" : "13", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.61540601339964", "lng" : "38.69384765625", "title" : "14", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.60660971922694", "lng" : "44.9560546875", "title" : "15", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.091882620021835", "lng" : "37.2216796875", "title" : "16", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.916013113401725", "lng" : "43.8134765625", "title" : "17", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name : "Points of interest",
    slug : "poi",
    markers : [
      //Queensdale
      {"lat" : "31.17520982831087", "lng" : "-46.680908203125", "title" : "L1", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.5161103860623", "lng" : "-44.1650390625", "title" : "L2", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.91227382662561", "lng" : "-42.681884765625", "title" : "L3", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.142566155107037", "lng" : "-46.549072265625", "title" : "L4", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.248063243796576", "lng" : "-41.143798828125", "title" : "Trainer's Terrace", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.19003509582261", "lng" : "-25.42236328125", "title" : "1", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.855698009751254", "lng" : "-27.0263671875", "title" : "2", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.236947003917535", "lng" : "-24.1259765625", "title" : "3", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.97361354260757", "lng" : "-32.18994140625", "title" : "5", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.82956108605351", "lng" : "-30.3662109375", "title" : "7", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.27450351782018", "lng" : "-38.1005859375", "title" : "8", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.36339623960374", "lng" : "-29.42138671875", "title" : "9", "desc" : "", "wikiLink" : ""},
    
      //Black Citadel
      {"lat" : "17.287709050622045", "lng" : "52.6904296875", "title" : "1", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.823966027173784", "lng" : "52.1630859375", "title" : "2", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.52873013889776", "lng" : "53.50341796875", "title" : "3", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.541430360300097", "lng" : "54.481201171875", "title" : "4", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.277218735781705", "lng" : "57.392578125", "title" : "5", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.1897038040042", "lng" : "48.6474609375", "title" : "6", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.40665471391919", "lng" : "56.458740234375", "title" : "7", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.500447458475193", "lng" : "57.139892578125", "title" : "8", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.88039176782262", "lng" : "55.6787109375", "title" : "9", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.82872538768128", "lng" : "56.920166015625", "title" : "10", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.934067182498445", "lng" : "52.62451171875", "title" : "11", "desc" : "", "wikiLink" : ""},
    
      //Divinity's Reach
      {"lat" : "41.45919537950716", "lng" : "-36.05712890625", "title" : "1", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.858890491257895", "lng" : "-39.539794921875", "title" : "2", "desc" : "", "wikiLink" : ""},
      {"lat" : "35.42486791930566", "lng" : "-42.099609375", "title" : "3", "desc" : "", "wikiLink" : ""},
      {"lat" : "35.64836915737436", "lng" : "-35.321044921875", "title" : "4", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.72408857733381", "lng" : "-36.068115234375", "title" : "5", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.68182601089372", "lng" : "-38.463134765625", "title" : "6", "desc" : "", "wikiLink" : ""},
      {"lat" : "39.95185892663013", "lng" : "-36.573486328125", "title" : "7", "desc" : "", "wikiLink" : ""},
      {"lat" : "40.58058466412772", "lng" : "-37.452392578125", "title" : "8", "desc" : "", "wikiLink" : ""},
      {"lat" : "37.29153547292747", "lng" : "-34.925537109375", "title" : "9", "desc" : "", "wikiLink" : ""},
      {"lat" : "38.09998264736488", "lng" : "-34.178466796875", "title" : "10", "desc" : "", "wikiLink" : ""},
    
      //Hoelbrak
      {"lat" : "20.01464544534147", "lng" : "24.071044921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.186677697957947", "lng" : "25.938720703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.084500083517455", "lng" : "28.905029296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.333669445771413", "lng" : "29.498291015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.045813453752295", "lng" : "28.114013671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.888659787381727", "lng" : "33.3544921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.668625907386028", "lng" : "33.870849609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.207860470525615", "lng" : "32.98095703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.678013256725603", "lng" : "31.014404296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.89589255941514", "lng" : "33.8818359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.482106236077787", "lng" : "30.509033203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.21792016631114", "lng" : "26.16943359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.299261499741313", "lng" : "33.57421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.69431424182586", "lng" : "32.596435546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.098598010302002", "lng" : "31.717529296875", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Lion's Arch
      {"lat" : "15.559544421458217", "lng" : "-9.55810546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.56231770191497", "lng" : "-3.66943359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.511665400971145", "lng" : "-5.20751953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.447723189292407", "lng" : "-6.295166015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.736800512460412", "lng" : "-2.757568359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.30780233662297", "lng" : "-1.724853515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.401377554543666", "lng" : "-7.657470703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.217625353199693", "lng" : "-2.74658203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.109486058403887", "lng" : "-9.415283203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.070107304439219", "lng" : "-5.888671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.102096738726571", "lng" : "-1.91162109375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.733077421211691", "lng" : "0.94482421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.350796722383798", "lng" : "2.13134765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.069551294233344", "lng" : "2.933349609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "10.822515257716894", "lng" : "-1.724853515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.576906799409084", "lng" : "-3.306884765625", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Plains of Ashford
      {"lat" : "17.675427818339486", "lng" : "62.42431640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.531700307384146", "lng" : "66.64306640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.05173366503927", "lng" : "71.455078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.738222936441854", "lng" : "77.58544921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.508020154916856", "lng" : "77.49755859375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.56249250837498", "lng" : "76.66259765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.675427818339486", "lng" : "84.61669921875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.06198809720237", "lng" : "68.115234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.436576538380162", "lng" : "62.20458984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.48578959390858", "lng" : "65.7421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.65799740350309", "lng" : "60.27099609375", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Gendarran Fields
      {"lat" : "18.76071275849968", "lng" : "-22.69775390625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.473323877771275", "lng" : "-8.54736328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.357105493969836", "lng" : "-6.85546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.175116531621864", "lng" : "-5.69091796875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.18624218560884", "lng" : "-10.65673828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.136728169747503", "lng" : "-22.39013671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.44937385955676", "lng" : "-0.98876953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.205785724383425", "lng" : "1.95556640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.04561082743983", "lng" : "5.07568359375", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Snowden Drifts
      {"lat" : "26.559049984075635", "lng" : "28.30078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.091882620021885", "lng" : "27.7734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.123373210819324", "lng" : "32.76123046875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.82282272723712", "lng" : "15.05126953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.853479438420123", "lng" : "19.53369140625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.334096684794556", "lng" : "13.73291015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.195000424307608", "lng" : "21.64306640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.532528468534544", "lng" : "23.642578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.155229394940672", "lng" : "32.45361328125", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Kessex Hills
      {"lat" : "5.88926056013395", "lng" : "-25.59814453125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "7.700104531441842", "lng" : "-23.8623046875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "7.569437336251447", "lng" : "-35.83740234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.487871434931584", "lng" : "-48.75732421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.636738848907648", "lng" : "-39.462890625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.565286943988037", "lng" : "-41.1328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.235251505390544", "lng" : "-37.55126953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.443090823463722", "lng" : "-33.57421875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.028575662342272", "lng" : "-26.43310546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "15.146369299638852", "lng" : "-26.6748046875", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Diessa Plateau
      {"lat" : "30.96818929679427", "lng" : "47.9443359375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.06228599981221", "lng" : "57.48046875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.388779254390236", "lng" : "63.61083984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.53223722395911", "lng" : "64.51171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.40053532686396", "lng" : "61.54541015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.15640841455705", "lng" : "56.53564453125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.021543509740052", "lng" : "65.5224609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.479034752500706", "lng" : "61.76513671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.908644463291324", "lng" : "64.62158203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "30.930500817607815", "lng" : "67.47802734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.473033261279564", "lng" : "67.78564453125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.21488107113262", "lng" : "61.34765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.417142025372076", "lng" : "52.7783203125", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Wayfarer Foothills
      {"lat" : "9.481572085088555", "lng" : "41.19873046875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "12.908198108318558", "lng" : "46.1865234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.06198809720232", "lng" : "42.95654296875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.570142140283014", "lng" : "35.9033203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "26.65727767421761", "lng" : "39.13330078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.54478779619949", "lng" : "43.9013671875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.568861182555594", "lng" : "41.1328125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.60546961227191", "lng" : "45.54931640625", "title" : "", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name: "Skill points",
    slug: "skillpoints",
    markers: [
      //Queensdale
      {"lat" : "28.99853181405182", "lng" : "-38.12255859375", "title" : "Commune with Earthen Magic", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.25698131588254", "lng" : "-47.4169921875", "title" : "Use Erts Unguent", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.416716988945726", "lng" : "-25.576171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.197577453351066", "lng" : "-30.60791015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.67696979820268", "lng" : "-44.14306640625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.55698192033834", "lng" : "-35.2880859375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.606609719226917", "lng" : "-24.19189453125", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Plains of Ashford
      {"lat" : "20.27250325013499", "lng" : "59.326171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.763395779624545", "lng" : "66.81884765625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "18.65665448654011", "lng" : "80.83740234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "13.33617518649503", "lng" : "72.31201171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "8.135367205502945", "lng" : "67.4560546875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "11.469257905863346", "lng" : "71.4990234375", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Gendarran Fields
      {"lat" : "18.823116948090608", "lng" : "-22.43408203125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "21.54506606426634", "lng" : "-16.5673828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.887562215174604", "lng" : "-9.51416015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.513626363462834", "lng" : "-5.80078125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.0", "lng" : "-22.0", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.771051193172372", "lng" : "-1.77978515625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "19.611543503814335", "lng" : "5.42724609375", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Snowden Drifts
      {"lat" : "35.182788138002394", "lng" : "27.7734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.4793919710482", "lng" : "14.8095703125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.42503613021342", "lng" : "10.1953125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "31.886886525780906", "lng" : "8.10791015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "25.353954558526787", "lng" : "7.62451171875", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "24.497146320572", "lng" : "33.046875", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Kessex Hills
      {"lat" : "6.806444048123707", "lng" : "-24.697265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "9.589917307087443", "lng" : "-39.8583984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "7.591217970942801", "lng" : "-48.88916015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "17.507867096450823", "lng" : "-24.23583984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "14.99785187368062", "lng" : "-24.14794921875", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Diessa Plateau
      {"lat" : "30.91165100451827", "lng" : "48.27392578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.49750272138164", "lng" : "54.0087890625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "29.754839972510958", "lng" : "57.67822265625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.139815912754475", "lng" : "57.7880859375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.78673916270255", "lng" : "60.8642578125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.62376800118816", "lng" : "64.66552734375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "27.498526722798346", "lng" : "61.3916015625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "23.008964269673143", "lng" : "63.1494140625", "title" : "", "desc" : "", "wikiLink" : ""},
    
      //Wayfarer Foothills
      {"lat" : "12.37219737335799", "lng" : "46.20849609375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "22.948276856880934", "lng" : "36.2548828125", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "20.478481600090593", "lng" : "45.90087890625", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "16.07748586908874", "lng" : "39.8583984375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "28.815799886487323", "lng" : "42.86865234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "33.458942753687666", "lng" : "40.05615234375", "title" : "", "desc" : "", "wikiLink" : ""},
      {"lat" : "34.06176136129721", "lng" : "45.263671875", "title" : "", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name: "Dungeons",
    slug: "dungeons",
    markers: [
      {"lat" : "19.00499664280239", "lng" : "75.574951171875", "title" : "Ascalonian Catacombs", "desc" : "", "wikiLink" : ""},
      {"lat" : "32.31499127724558", "lng" : "-25.64208984375", "title" : "Caudecus Manor", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name: "Asura gates",
    slug: "asurasgates",
    markers: [
      //Asura Gate (Divinity's Reach)
      {"lat" : "37.08147564886055", "lng" : "-37.694091796875", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "37.2478212015543", "lng" : "-33.59619140625", "title" : "", "desc" : "", "wikiLink" : ""}, 
      //Asura Gate (Lion's Arch)
      {"lat" : "11.91035355577419", "lng" : "-3.746337890625", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "11.102946786877641", "lng" : "-3.856201171875", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "10.822515257716844", "lng" : "-3.394775390625", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "11.081384602413124", "lng" : "-2.96630859375", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "11.501556900932576", "lng" : "-2.87841796875", "title" : "", "desc" : "", "wikiLink" : ""}, 
      //Asura Gate (Lion's Arch PVP)
      {"lat" : "8.515835561202307", "lng" : "-1.51611328125", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "8.21149032342077", "lng" : "-1.1865234375", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "8.276727101164122", "lng" : "-0.966796875", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "8.494104537551959", "lng" : "-0.9228515625", "title" : "", "desc" : "", "wikiLink" : ""}, 
      {"lat" : "8.711358875426589", "lng" : "-0.966796875", "title" : "", "desc" : "", "wikiLink" : ""}, 
      //Asura Gate (Gendarran Fields)
      {"lat" : "27.926474039865067", "lng" : "-0.5712890625", "title" : "", "desc" : "", "wikiLink" : ""}, 
      //Asura Gate (Black Citadel)
      {"lat" : "18.3440978021016", "lng" : "50.460205078125", "title" : "", "desc" : "", "wikiLink" : ""},
      //Asura Gate (Hoelbrak) 
      {"lat" : "17.014767530557872", "lng" : "25.927734375", "title" : "", "desc" : "", "wikiLink" : ""}
    ]
  },
  {
    name: "Jumping puzzles",
    slug: "jumpingpuzzles",
    markers: [
    {"lat" : "20.786930592570315", "lng" : "-25.191650390625", "title" : "Demongrub Pits", "desc" : "Demongrub Pits is an underground Jumping Puzzle located in southeast Queensdale.", "wikiLink" : ""},
    {"lat" : "29.907329376851603", "lng" : "58.216552734375", "title" : "Grendich Gamble", "desc" : "Grendich Gamble is a jumping puzzle in the west part of the Diessa Plateau It is located on a building next to a Skillpoint with Cannons and Trebuchets as well as Ascalonian Ghosts on it.", "wikiLink" : ""},
    {"lat" : "8.537565350804067", "lng" : "80.9912109375", "title" : "Loreclaw Expanse", "desc" : "The Loreclaw Expanse is the southeastern section of the Plains of Ashford and includes the seperatist camp in the area.", "wikiLink" : ""}, 
    {"lat" : "21.30984614108724", "lng" : "36.639404296875", "title" : "Shamans Rookery", "desc" : "", "wikiLink" : ""},
    {"lat" : "6.26069737295141", "lng" : "-27.850341796875", "title" : "The Collapsed Observatory", "desc" : "The Collapsed Observatory is a jumping puzzle in the southeast part of Kessex Hills. The entrance is straight south of Cereboth Canyon and the cave eventually leads to Isgarren's View.", "wikiLink" : ""}
    ]
  },
  {
    name: "Scouts",
    slug: "scouts",
    markers: []
  }
  ]
}

