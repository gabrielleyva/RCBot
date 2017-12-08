# RCBot iOS App for iSPY

# Install
Clone the repository
```
$ git clone https://github.com/gabrielleyva/RCBot.git
```
Navigate to the RCBot directory through terminal thern run the command (You need Cocoa Pods for this)
```
$ pod install
```
# Set Up
Now open up Xcode workspace
You will have unlock and fix some files from the CircularSlider Module in order for it to work on Swift 4.
Luckily it is an easy fix. All you have to do is follow Xcode's suggestions to fix it. It basically replaces 
old capital variable names with lower case.

IMPORTANT: Go to the ViewController.swift file and make sure the ip address in the url variable matches the ip of the server.

# Run 
Hit the run button in Xcode and then Start button in the app and it will start communicating with the server
