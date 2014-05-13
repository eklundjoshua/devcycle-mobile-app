devcycle-mobile-app
===================

devcycle-mobile-app is a hybrid iOS/Android application built using Sencha Touch and Cordova for the TD Five Boro Bike Tour. To setup the dashboard/server that is used alongside this application, please refer first to our [TourTrak server repository].

![screenshot](https://raw.githubusercontent.com/tofferrosen/devcycle-mobile-app/master/preview.png)

[TourTrak server repository]: https://github.com/tofferrosen/devcycle-server.git

###Dependencies Required for Building Project
* Ruby 1.9.3
* Java Runtime Environment > 1.7
* Cordova > 3.2.0
* Sencha Command Line Tools > 4.0.1.45
* SASS (Ruby Gem)
* Compass (Ruby Gem)
* Android SDK (if building native Android)
* iOS SDK (if building native iOS)

###Required Cordova Plugins
Below is a list of the required plugins. We have included a script that will fetch these automatically by simply running `python fetchPlugins.py` for mac, or `python fetchPluginsWindows.py` for Windows. This assumes that the locations of these repos are still as written below.

* [Cordova Device Plugin]
* [The TourTrak iOS Plugin]
* [The TourTrak Android Plugin]
* [Cordova Geolocation Plugin]

[Cordova Device Plugin]: https://github.com/apache/cordova-plugin-device.git
[The TourTrak iOS Plugin]: https://github.com/cck9672/geolocation-ios-noapp.git
[The TourTrak Android Plugin]: https://github.com/tofferrosen/tourtrak-android-plugin.git
[Cordova Geolocation Plugin]: https://github.com/apache/cordova-plugin-geolocation.git

###Set up
1. Ensure you meet all the dependencies above in the Dependencies Required for Contributing.
2. Clone this repository and move into this folder.
3. Run the command `sencha cordova init edu.rit.se.tourtrak TourTrak`
4. Open the cordova.local.properties file with your favorite text editor and type the platform you intend to build i.e. android or ios or both.
4. Go into your cordova folder
5. If you did not run our script, add all the required plugins in the order specified above by running `cordova plugin add {git-url}`. For example, one valid command would be `cordova plugin add https://github.com/apache/cordova-plugin-device.git`. We have also included a handy script to automate this for you if you have Python installed. Just run `python fetchPlugins.py` for mac or `python fetchPluginsWindows.py` for Windows!
6. Go back to the application root folder and run `sencha app build native` to build the native applications.
7. The native apps will be in the cordova/platform/{ios or android} folder. You can open the Android project in Eclipse as an existing android project, and the iOS project in XCode.

###Adding custom splashscreen for Android to app
1. Ensure your splashscreen .png file is being passed along by the TourTrak Android cordova plugin. Please see Android plugin repository.
2. In the TourTrak.java file, insert the following line of code between super.OnCreate() and super.init():
  super.setIntegerProperty("splashscreen", R.drawable.splash);

###Adding/Modifying FAQ tags and questions
####Adding/modifying  questions for a tag
1. Find the json file for the tag. All FAQ data is stored in json files that can be found in the resources/data/ folder. These json files are named for the tags they represent.
2. Open the tag's json file in the text editor of your choice. All json files used by the AccordionList that powers the FAQ follow the same format, seen below: 
```
{
    "items" : [{
                "text" : "<question a>?",
                "items" : [{
                            "text" : "<answer a>",
                            "leaf" : true
                        }]
            },
            {
                "text" : "<question b>?",
                "items" : [{
                            "text" : "<answer b>",
                            "leaf" : true
                        }]
            }]
}
```
Each question is contained within a set of curly brackets, with a "text" declared that represents the question, and a list of "items" with only a "text" that represents the answer and a "leaf" that is always set to true.
3. Modify as needed. If you need to modify an existing question, simply change the text for the question or answer. If you need to delete a question, simply remove the curly brackets that contains the "text" and "items" declarations, all its contents, and the comma that precedes them. To add a question, add new text that follows the above format, ensuring that each item is separated by a comma.

####Adding a new tag
1. Create a new json file for the tag. The file should be <tag name>.json, and should be placed in the resources/data/ folder.
2. Create a new store js file. The file should be <tag name>.js, and should be placed in the app/store/ folder. The contents of the store js file should be as follows:
```
Ext.define('DevCycleMobile.store.<tag name>', {
    extend: 'Ext.data.TreeStore',
    requires: [
        'DevCycleMobile.model.Answer'
    ],

    config: {
        defaultRootProperty: 'items',
        model: 'DevCycleMobile.model.Answer',

        // XXX: AccordionList Now show data from JSON
        proxy: {
            type: 'ajax',
            url: 'resources/data/<tag name>.json'
        }
    }

});
```
3. Add a new item to the Main.js view file. In the app/view/ folder, there is a file named AboutMain.js. This is the view file that defines the tab panel seen in the FAQ page of the application. Each tab is a tag in the FAQ, and the panel displays the questions and answers for the tag as an AccordionList. To add a new tag, add the following block of code to the comma-delimited array for items, making sure to do so after the titlebar item:
```
            {
                title: '<tag title>',
                layout: 'vbox',
                items: [
                    {
                        xtype: 'accordionlist',
                        store: Ext.create('DevCycleMobile.store.<tag name>'),
                        flex: 1,
                        itemId: 'paging',
                        listeners: {
                            initialize: function() {
                                this.load();
                            }
                        }
                    }
                ],
                control: {
                    'button[action=expand]': {
                        tap: function() {
                            this.down('accordionlist').doAllExpand();
                        }
                    },
                     'button[action=collapse]': {
                        tap: function() {
                            this.down('accordionlist').doAllCollapse();
                        }
                    }
                }
            }
```

###Config File
In the config.json, you can specify the following parameters shown below. Please note that all timestamps are in unix time (seconds since epoch) for the GMT timezone, as we are timezone agnostic. Make sure you convert your tour time to GMT time, before converting that to the unix timestamp.

* app name : name of the app
* dcs_url : the url to the data collection server
* tour_id : the tour id
* tour_start_time : the unix timestamp of the tour start time ( when automatic tracking starts: secs since epoch GMT time)
* tour_end_time : the unix timestamp of the tour end time ( when tracking should end: secs since epoch GMT time)
* reg_retry_init : if registration fails, how often it should retry for the next 10 tries (in seconds)
* reg_retry_after : if registration is still failing after 10 tries, how often it should retry (in seconds)

###Adding new slippery map tiles
To generate a new set of tiles, please refer to our [BikeNY-red] repository which includes instructions for setup.

[BikeNY-red]: https://github.com/tofferrosen/bikeNY-red.git

###Modifying the Points of Interests
All points of interested are parsed from a KML file located under resources/data.kml. To modify this file in a GUI-like way, you can open it directly in [Google Earth] where you are free to add new markers or modify any existing markers. Re-extract the KML file, saving it as data.kml, and replace the previous one. 

To get the appropriate marker icons, please refer to our [Map Marker Icon Area Tags] document under the reference directory, In the description for each marker, one signifies the icon of marker by including an `[AREA][/AREA]` tag. Instructions are included in the aformentioned document.

The locations themselves are parsed in the kml.js file inside third_party_libraries folder, which needs to be modified if new types of icons are desired. 

[Map Marker Icon Area Tags]: https://github.com/tofferrosen/devcycle-mobile-app/raw/master/reference/Map%20Marker%20Icon%20Area%20Tags.docx

[Google Earth]: http://www.google.com/earth/

### More
We have included some system diagrams and the offline map architecture under the references folder.

