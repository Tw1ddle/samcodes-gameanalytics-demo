# Haxe GameAnalytics Demo

[![License](https://img.shields.io/:license-mit-blue.svg?style=flat-square)](https://github.com/Tw1ddle/samcodes-gameanalytics-demo/blob/master/LICENSE)

HaxeFlixel demo of the Haxe [samcodes-gameanalytics](https://github.com/Tw1ddle/samcodes-gameanalytics) analytics haxelib. Run it [in your browser](https://tw1ddle.github.io/samcodes-gameanalytics-demo/index.html).

Has various issues that break demo functionality at the moment (can't get POST over HTTPS to work for some reason among other things).

## Usage

Enter the sandbox/test game id, secrets etc in PlayState.hx, then build and run the app. Press the "Initialize and connect" button once to connect, then hit the "Record..." buttons to enqueue game analytics events. Hit the "Post All Events" button to send the events to the GameAnalytics servers.

## Screenshots

![Screenshot of demo app](https://github.com/Tw1ddle/samcodes-gameanalytics-demo/blob/master/screenshots/analytics-demo.png?raw=true "Analytics Demo")