# Setel-iOS
Setel Assignment

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Getting Started](#getting-started)
* [Usage](#usage)

<!-- ABOUT THE PROJECT -->
## About The Project

* An iOS application that will detect if the device is located inside of a geofence area.
* A device is considered to be inside of the geofence area if the device is connected to the specified WiFi network or remains geographically inside the defined circle.
* If device coordinates are reported outside of the zone, but the device still connected to the specific Wifi network, then the device is treated as being inside the geofence area.


<!-- GETTING STARTED -->
## Getting Started
1. Run the project with your device or simulator
2. Allow Location Permission for the app to detect your curent location 
3. You can also fake your location to do some testing - (GPX files are provided in the code, you can simulate a fake location by using it)
4. Connect to a specific Wi-FI by selecting the ```Wi-Fi``` button on top right of the navigation bar and Wi-Fi ```SSID``` and ```Password``` to connect to the network
5. Add a geofence area by pressing the ```+``` button on the top right and set the radius of the geofence area and place it to where you want to add in the Map. Default is 100

<!-- USAGE -->
## Usage
1. Navigate to the geofence area
* Your Current Status will be displayed as ```Inside``` if you are inside the Geofence Area
* Your Current Status will be displayed as ```Outside``` if you are out from the Geofence Area
* Your Current Status will be displayed as ```Inside```if you are outside from the Geofence Area but connected to the specific Wi-Fi that you connect earlier 


