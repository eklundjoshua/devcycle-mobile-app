'''
This script fetches all the required plugins automatically.
Assumes cordova has been added successfully to the project.

Usage: python fetchPlugins.py
'''

import subprocess
import os

# Change to the cordova directory
os.chdir("cordova")

# Add the cordova device plugin
subprocess.call("cordova -d plugin add https://github.com/apache/cordova-plugin-device.git", shell=True)

# Add the cordova splash screen plugin
subprocess.call("cordova -d plugin add https://github.com/apache/cordova-plugin-splashscreen.git", shell=True)

# The TourTrak iOS plugin and Android Plugin have been commented out for now.
# When building the browser plugin with sencha app build native, it tries to fetch a geo location plugin that is deprecated. This causes sencha app build native to fail the first time and you have to run it again for it to be successful. I believe either the iOS, the android, or both plugins must be updated. The documentation on the deprecated plugins README on git says that it is part of every cordova installation now so it can be removed.
# Add the tourtrak iOS plugin
# subprocess.call("cordova -d plugin add https://github.com/TourTrak/tourtrak-ios-plugin.git", shell=True)

# Add the tourtrak android plugin
#subprocess.call("cordova -d plugin add https://github.com/TourTrak/tourtrak-android-plugin.git", shell=True)

# Add the cordova geolocation plugin
subprocess.call("cordova -d plugin add https://github.com/apache/cordova-plugin-geolocation.git", shell=True)

# Print out all the plugins installed for the user
subprocess.call("cordova -d plugin ls", shell=True)

