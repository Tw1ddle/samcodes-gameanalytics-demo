package states;

import extension.gameanalytics.GameAnalytics;
import extension.gameanalytics.GameAnalyticsCompressionOption;
import extension.gameanalytics.GameAnalyticsListener;
import extension.gameanalytics.GameAnalyticsProtocolOption;
import extension.gameanalytics.GameAnalyticsSettings;
import extension.gameanalytics.detail.endpoints.Sandbox;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.events.Event;
import source.analytics.MyGameAnalyticsListener;

class PlayState extends FlxState {
	private var eventText:FlxText; // Event log text in top left of screen
	
	private var analyticsListener:GameAnalyticsListener;
	private var analytics:GameAnalytics;

	/**
	 * Setup the demo state
	 */
	override public function create():Void {
		super.create();
		bgColor = FlxColor.BLACK;
		
		eventText = new FlxText();
		add(eventText);
		
		addText("Press some buttons...");
		
		Lib.current.stage.addEventListener(Event.ACTIVATE, function(p:Dynamic):Void {
			addText("App received ACTIVATE event");
		});
		Lib.current.stage.addEventListener(Event.DEACTIVATE, function(p:Dynamic):Void {
			addText("App received DEACTIVATE event");
		});
		
		var baseX:Int = Std.int(FlxG.width / 4);
		var baseY:Int = Std.int(FlxG.height / 4);
		var makeEventButton = function(text:String, onPress:Void->Void) {
			var recordEventButton = new BigButton(text, onPress);
			recordEventButton.x = baseX + 50;
			recordEventButton.y = baseY;
			baseY += Std.int(recordEventButton.height + 10);
			add(recordEventButton);
		}
		
		makeEventButton("Record Business Event", function() {
			addText("Recording Business Event");
		});
		
		makeEventButton("Record Complete Event", function() {
			addText("Recording Complete Event");
		});
		
		makeEventButton("Record Design (Custom) Event", function() {
			addText("Recording Design (Custom) Event");
		});
		
		makeEventButton("Record Error Event", function() {
			addText("Recording Error Event");
		});
		
		makeEventButton("Record Progression Event", function() {
			addText("Recording Progression Event");
		});
		
		makeEventButton("Record Resource Event", function() {
			addText("Recording Resource Event");
		});
		
		var startSessionButton = new BigButton("Start Session", function() {
			addText("Will attempt to start analytics session");
			
			analytics.startSession();
		});
		startSessionButton.x = baseX + 250;
		startSessionButton.y = Std.int(FlxG.height / 2) - 50;
		add(startSessionButton);
		
		var endSessionButton = new BigButton("End Session", function() {
			addText("Will attempt to end analytics session");
			
			analytics.endSession();
		});
		endSessionButton.x = baseX + 250;
		endSessionButton.y = Std.int(FlxG.height / 2);
		add(endSessionButton);
		
		var postEventsButton = new BigButton("Post All Events", function() {
			addText("Will attempt to post all analytics events");
			
			analytics.postEvents();
		});
		postEventsButton.x = baseX + 250;
		postEventsButton.y = Std.int(FlxG.height / 2) + 100;
		add(postEventsButton);
		
		var printStoredEventsInfo = new BigButton("Print Stored Events Info", function() {
			addText("Will print stored events info");
			
			// TODO
		});
		printStoredEventsInfo.x = baseX + 250;
		printStoredEventsInfo.y = Std.int(FlxG.height / 2) + 150;
		add(printStoredEventsInfo);
		
		var clearLogButton = new BigButton("Clear Log", clearLog);
		clearLogButton.x = 100;
		clearLogButton.y = FlxG.height - clearLogButton.height - 20;
		add(clearLogButton);
		
		analyticsListener = new MyGameAnalyticsListener();
		
		var analyticsSettings:GameAnalyticsSettings = {
			gameKey : Sandbox.sandboxGameKey,
			secretKey : Sandbox.sandboxSecretKey,
			endpoint : Sandbox.sandboxEndpoint,
			compression: GameAnalyticsCompressionOption.NONE,
			protocol: GameAnalyticsProtocolOption.HTTPS
		};
		
		addText("Creating GameAnalytics instance with key: " + analyticsSettings.gameKey + "\nAnd secret key: " + analyticsSettings.secretKey + "\nFor endpoint: " + analyticsSettings.endpoint);
		
		analytics = new GameAnalytics(analyticsSettings, analyticsListener);
	}
	
	/**
	 * Update the state
	 */
	override public function update(dt:Float):Void {
		super.update(dt);
	}
	
	/**
	 * Add a message to the text event log
	 */
	private function addText(text:String):Void {
		eventText.text = text + "\n" + eventText.text;
	}
	
	/**
	 * Clear the event log
	 */
	private function clearLog():Void {
		eventText.text = "Cleared text log... Waiting...";
	}
}

class BigButton extends FlxButton {
	public function new(text:String, onPress:Void->Void) {
		super(0, 0, text, onPress);
		scale.set(2, 2);
		updateHitbox();
	}
}