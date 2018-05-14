package states;

import analytics.MyGameAnalyticsListener;
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
import extension.gameanalytics.detail.events.DefaultAnnotations;
import extension.gameanalytics.detail.events.ErrorEventType;

@:access(extension.gameanalytics.GameAnalytics)
@:access(extension.gameanalytics.detail.impl.GameAnalyticsImpl)
@:access(extension.gameanalytics.detail.storage.SharedObjectStorage)
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
		
		var baseX:Int = Std.int(FlxG.width / 3);
		var baseY:Int = 20;
		var makeEventButton = function(text:String, onPress:Void->Void) {
			var recordEventButton = new BigButton(text, onPress);
			recordEventButton.x = baseX + 50;
			recordEventButton.y = baseY;
			baseY += Std.int(recordEventButton.height + 10);
			add(recordEventButton);
		}
		
		makeEventButton("Record Start Session Event", function() {
			addText("Recording Start Session Event");
			analytics.recordStartSessionEvent();
		});
		
		makeEventButton("Record End Session Event", function() {
			addText("Recording End Session Event");
			analytics.recordEndSessionEvent();
		});
		
		makeEventButton("Record Business Event", function() {
			addText("Recording Business Event");
			analytics.recordBusinessEvent("hat:epic", 1, "USD", 0, "menu_demo", null);
		});
		
		makeEventButton("Record Design (Custom) Event", function() {
			addText("Recording Design (Custom) Event");
			analytics.recordDesignEvent("design1:design2:design3", 9001);
		});
		
		makeEventButton("Record Error Event", function() {
			addText("Recording Error Event");
			analytics.recordErrorEvent(ErrorEventType.INFO, "test error");
		});
		
		makeEventButton("Record Progression Event", function() {
			addText("Recording Progression Event");
			analytics.recordProgressionEvent("Start:TestButtonPress", 1, 1);
		});
		
		makeEventButton("Record Resource Event", function() {
			addText("Recording Resource Event");
			analytics.recordResourceEvent("Source:life:rewardedVideo:gainLife", 100);
		});
		
		var initButton = new BigButton("Initialize and connect", function() {
			addText("Will attempt to connect to GameAnalytics and initialize");
			analytics.init();
		});
		initButton.x = baseX + 250;
		initButton.y = Std.int(FlxG.height / 2) - 50;
		add(initButton);
		
		var postEventsButton = new BigButton("Post All Events", function() {
			addText("Will attempt to post all analytics events");
			analytics.postEvents();
		});
		postEventsButton.x = baseX + 250;
		postEventsButton.y = Std.int(FlxG.height / 2) + 50;
		add(postEventsButton);
		
		var flushEventsButton = new BigButton("Flush Events To Disk", function() {
			addText("Will attempt to flush events to disk");
			analytics.impl.storage.commitData();
		});
		flushEventsButton.x = baseX + 250;
		flushEventsButton.y = Std.int(FlxG.height / 2) + 100;
		add(flushEventsButton);
		
		var printStoredEventsInfo = new BigButton("Output Stored Events Info", function() {
			addText("Will output stored events info");
			
			var events = analytics.impl.storage.getEvents();
			if (events != null) {
				addText("Got " + events.length + " events");
				for (event in events) {
					addText(event);
					trace(event);
				}
			} else {
				addText("Events data is null...");
			}
		});
		printStoredEventsInfo.x = baseX + 250;
		printStoredEventsInfo.y = Std.int(FlxG.height / 2) + 150;
		add(printStoredEventsInfo);
		
		var purgeStoredEventsInfo = new BigButton("Purge Stored Events Info", function() {
			addText("Will purge stored events info");
			analytics.impl.storage.purgeEvents();
		});
		purgeStoredEventsInfo.x = baseX + 250;
		purgeStoredEventsInfo.y = Std.int(FlxG.height / 2) + 200;
		add(purgeStoredEventsInfo);
		
		var clearLogButton = new BigButton("Clear Log", clearLog);
		clearLogButton.x = 100;
		clearLogButton.y = FlxG.height - clearLogButton.height - 20;
		add(clearLogButton);
		
		// Actually create/setup the GameAnalytics instance
		analyticsListener = new MyGameAnalyticsListener(this);
		
		var analyticsSettings:GameAnalyticsSettings = {
			gameKey : Sandbox.sandboxGameKey,
			secretKey : Sandbox.sandboxSecretKey,
			host : Sandbox.sandboxHost,
			compression: GameAnalyticsCompressionOption.NONE,
			protocol: GameAnalyticsProtocolOption.HTTP,
			maxCachedEventCount: 1000
		};
		
		addText("Creating GameAnalytics instance with key: " + analyticsSettings.gameKey + "\nAnd secret key: " + analyticsSettings.secretKey + "\nFor host: " + analyticsSettings.host);
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
	public function addText(text:String):Void {
		eventText.text = text + "\n" + eventText.text;
	}
	
	/**
	 * Clear the event log
	 */
	public function clearLog():Void {
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