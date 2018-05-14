package analytics;

import extension.gameanalytics.GameAnalyticsListener;
import extension.gameanalytics.detail.requests.InitResponseData;
import states.PlayState;

class MyGameAnalyticsListener extends GameAnalyticsListener {
	private var game:PlayState;
	
	public function new(game:PlayState) {
		super();
		this.game = game;
	}
	
	override public function onInitRequested():Void {
		super.onInitRequested();
		
		game.addText("GameAnalytics initialization requested");
	}
	
	override public function onInitSucceeded(response:InitResponseData):Void {
		super.onInitSucceeded(response);
		
		game.addText("GameAnalytics initialization succeeded, response data: " + Std.string(response));
	}
	
	override public function onInitFailed(httpResponseCode:Int):Void {
		super.onInitFailed(httpResponseCode);
		
		game.addText("GameAnalytics initialization failed");
	}
	
	override public function onPostEventsRequested():Void {
		super.onPostEventsRequested();
		
		game.addText("Post events requested");
	}
	
	override public function onPostEventsSucceeded():Void {
		super.onPostEventsSucceeded();
		
		game.addText("Post events succeeded");
	}
	
	override public function onPostEventsFailed(httpResponseCode:Int):Void {
		super.onPostEventsFailed(httpResponseCode);
		
		game.addText("Post events failed");
	}
}