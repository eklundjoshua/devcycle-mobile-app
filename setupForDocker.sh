# Notes on this shell script
# the sencha cordova line fails unless the version is cordova version 5.4 and npm version 11.15
# additionally, fetchPlugins will fail. This is because the latest version of npm / cordova expects
# that each plugin has a package.json. For the iOS and Android Plugins for tourtrak, they do not have
# a package.json so fetching them fails.
sencha cordova init edu.rit.se.tourtrak TourTrak
python2 fetchPlugins.py
git submodule update --init --recursive
mv config.json.template config.json
# Dynamically create the tour start and end time to start 1 hr from current time and end 8 hours later. The time format is is EPOCH format
export START_TIME=$(date -d'+1hour' +%s%3N) && export END_TIME=$(date -d'+8hour' +%s%3N) && sed -i 's/TOUR_START_TIME/'$START_TIME'/g' config.json && sed -i 's/TOUR_END_TIME/'$END_TIME'/g' config.json
