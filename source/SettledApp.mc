import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SettledApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  //! Return the initial view of your application here
  function getInitialView() as [Views] or [Views, InputDelegates] {
    loadUserSettings();
    return [new SettledView()];
  }

  function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
    loadUserSettings();
    return [new $.DataFieldSettingsView(), new $.DataFieldSettingsDelegate()];
  }
  function onSettingsChanged() as Void {
    loadUserSettings();
  }

  function loadUserSettings() as Void {
    try {
      System.println("Loading user settings");

      var reset = $.getStorageValue("resetDefaults", false) as Boolean;
      if (reset) {
        System.println("Reset user settings");
        Storage.setValue("resetDefaults", false);

        Storage.setValue("debug", false);
        Storage.setValue("test_TimerState", -1);

        Storage.setValue("head_light_mode_0", 0); // off
        Storage.setValue("head_light_mode_1", 0); // stopped -> off
        Storage.setValue("head_light_mode_2", 6); // paused -> slow flash
        Storage.setValue("head_light_mode_3", 7); // on -> fast flash
        Storage.setValue("head_light_mode_4", 15); // seconds in paused
        Storage.setValue("head_light_mode_5", 0); // paused for seconds

        Storage.setValue("tail_light_mode_0", 0); 
        Storage.setValue("tail_light_mode_1", 0); 
        Storage.setValue("tail_light_mode_2", 6); 
        Storage.setValue("tail_light_mode_3", 7); 
        Storage.setValue("tail_light_mode_4", 15);
        Storage.setValue("tail_light_mode_5", 0); 

        Storage.setValue("other_light_mode_0", 0); 
        Storage.setValue("other_light_mode_1", 0); 
        Storage.setValue("other_light_mode_2", 6); 
        Storage.setValue("other_light_mode_3", 7); 
        Storage.setValue("other_light_mode_4", 15); 
        Storage.setValue("other_light_mode_5", 0); 
      }

      $.gDebug = getStorageValue("debug", $.gDebug) as Boolean;
      $.gAlert_no_network = getStorageValue("alert_no_network", $.gAlert_no_network) as Boolean;

      $.gtest_TimerState = $.getStorageValue("test_TimerState", $.gtest_TimerState) as Number;

      $.gHead_light_mode =
        [
          $.getStorageValue("head_light_mode_0", 0) as Number,
          $.getStorageValue("head_light_mode_1", 0) as Number,
          $.getStorageValue("head_light_mode_2", 6) as Number,
          $.getStorageValue("head_light_mode_3", 7) as Number,
          $.getStorageValue("head_light_mode_4", 15) as Number,
          $.getStorageValue("head_light_mode_5", 0) as Number,
        ] as Array<Number>;
      $.gTail_light_mode =
        [
          $.getStorageValue("tail_light_mode_0", 0) as Number,
          $.getStorageValue("tail_light_mode_1", 0) as Number,
          $.getStorageValue("tail_light_mode_2", 6) as Number,
          $.getStorageValue("tail_light_mode_3", 7) as Number,
          $.getStorageValue("tail_light_mode_4", 15) as Number,
          $.getStorageValue("tail_light_mode_5", 0) as Number,
        ] as Array<Number>;
      $.gOther_light_mode =
        [
          $.getStorageValue("other_light_mode_0", 0) as Number,
          $.getStorageValue("other_light_mode_1", 0) as Number,
          $.getStorageValue("other_light_mode_2", 6) as Number,
          $.getStorageValue("other_light_mode_3", 7) as Number,
          $.getStorageValue("other_light_mode_4", 15) as Number,
          $.getStorageValue("other_light_mode_5", 0) as Number,
        ] as Array<Number>;

      $.gDisplay_field = $.getStorageValue("display_field", $.gDisplay_field) as FieldDisplay;
      $.gShow_label = $.getStorageValue("show_label", $.gShow_label) as Boolean;
      $.gShow_lightInfo = $.getStorageValue("show_lightInfo", $.gShow_lightInfo) as Boolean;

      System.println("User settings loaded");
    } catch (ex) {
      System.println(ex.getErrorMessage());
      ex.printStackTrace();
    }
  }
}

function getApp() as SettledApp {
  return Application.getApp() as SettledApp;
}

var gDebug as Boolean = false;
var gAlert_no_network as Boolean = false;
// off, stopped, paused, on, seconds, paused for seconds
var gHead_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0];
var gTail_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0];
var gOther_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0];
var gtest_TimerState as Number = -1;

var gDisplay_field as FieldDisplay = FldLights;
var gShow_label as Boolean = false;
var gShow_lightInfo as Boolean = false;

public enum FieldDisplay {
  FldLights = 0,
  FldDerailleurFIndex = 1,
  FldDerailleurRIndex = 2,
  FldDerailleurFRIndex = 3,
  FldDerailleurFSize = 4,
  FldDerailleurRSize = 5,
  FldDerailleurFRSize = 6,
  FldClock = 7,
}
