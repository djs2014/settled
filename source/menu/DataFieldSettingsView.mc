import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

var gExitedMenu as Boolean = false;

//! Initial view for the settings
class DataFieldSettingsView extends WatchUi.View {

  hidden var _backColor as Graphics.ColorType = Graphics.COLOR_BLACK;
  hidden var _textColor as Graphics.ColorType = Graphics.COLOR_WHITE;
  hidden var _isNightModeEnabled as Boolean = true;

  //! Constructor
  function initialize() {    
    View.initialize();

    var settings = System.getDeviceSettings();
    if (settings has :isNightModeEnabled) {
      _isNightModeEnabled = settings.isNightModeEnabled;
    }
    if (_isNightModeEnabled) {
      _backColor = Graphics.COLOR_BLACK;
      _textColor = Graphics.COLOR_WHITE;     
    } else {
      _textColor = Graphics.COLOR_BLACK;
      _backColor = Graphics.COLOR_WHITE;      
    }
  }

  //! Update the view
  //! @param dc Device context
  function onUpdate(dc as Dc) as Void {
    dc.clearClip();
    dc.setColor(_backColor, _backColor);
    dc.clear();
    dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);

    var mySettings = System.getDeviceSettings();
    var version = mySettings.monkeyVersion;
    var versionString = Lang.format("$1$.$2$.$3$", version);

    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() / 2 - 30,
      Graphics.FONT_SMALL,
      "Press Menu\nfor settings\nCIQ " + versionString,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }
}

//! Handle opening the settings menu
class DataFieldSettingsDelegate extends WatchUi.BehaviorDelegate {
  //! Constructor
  function initialize() {
    BehaviorDelegate.initialize();
  }

  //! Handle the menu event
  //! @return true if handled, false otherwise
  function onMenu() as Boolean {
    var menu = new $.DataFieldSettingsMenu();

    var mi = new WatchUi.MenuItem("Display", null, "display", null);
    menu.addItem(mi);
    
    mi = new WatchUi.MenuItem("Day light modes", null, "daylight_modes", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Night light modes", null, "nightlight_modes", null);
    menu.addItem(mi);
  
    mi = new WatchUi.MenuItem("Alerts", null, "alerts", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Brake light", null, "brakelight", null);
    menu.addItem(mi);
   
    mi = new WatchUi.MenuItem("Radar", null, "radar", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Backlight", null, "backlight", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Test Timer State", null, "test_TimerState", null);
    var value = getStorageValue(mi.getId() as String, 0) as Number;
    mi.setSubLabel($.getTimerStateAsString(value));
    menu.addItem(mi);

    var boolean = Storage.getValue("resetDefaults") ? true : false;
    menu.addItem(new WatchUi.ToggleMenuItem("Reset to defaults", null, "resetDefaults", boolean, null));

    boolean = Storage.getValue("debug") ? true : false;
    menu.addItem(new WatchUi.ToggleMenuItem("Debug", null, "debug", boolean, null));

    var view = new $.DataFieldSettingsView();
    WatchUi.pushView(menu, new $.DataFieldSettingsMenuDelegate(view), WatchUi.SLIDE_IMMEDIATE);
    return true;
  }

  function onBack() as Boolean {
    $.gExitedMenu = true;
    getApp().onSettingsChanged();
    return false;
  }
}
