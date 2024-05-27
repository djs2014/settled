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

      // var version = getStorageValue("version", "") as String;
      // if (!version.equals("1.0.0")) {
      //   Storage.setValue("version", "1.0.0");
      //   Storage.setValue("resetDefaults", true);
      // }

      var reset = Storage.getValue("resetDefaults");
      if (reset == null || (reset as Boolean)) {
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
        Storage.setValue("head_light_mode_6", 0); // Solar intensity drops to %
        Storage.setValue("head_light_mode_7", 2); // Light mode solid 60-80%

        Storage.setValue("tail_light_mode_0", 0);
        Storage.setValue("tail_light_mode_1", 0);
        Storage.setValue("tail_light_mode_2", 6);
        Storage.setValue("tail_light_mode_3", 7);
        Storage.setValue("tail_light_mode_4", 15);
        Storage.setValue("tail_light_mode_5", 0);
        Storage.setValue("tail_light_mode_6", 0);
        Storage.setValue("tail_light_mode_7", -1);

        Storage.setValue("other_light_mode_0", 0);
        Storage.setValue("other_light_mode_1", 0);
        Storage.setValue("other_light_mode_2", 6);
        Storage.setValue("other_light_mode_3", 7);
        Storage.setValue("other_light_mode_4", 15);
        Storage.setValue("other_light_mode_5", 0);
        Storage.setValue("other_light_mode_6", 0);
        Storage.setValue("other_light_mode_7", -1);

        Storage.setValue("alert_no_network", true);
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
          $.getStorageValue("head_light_mode_6", 0) as Number,
          $.getStorageValue("head_light_mode_7", 2) as Number,
        ] as Array<Number>;
      $.gTail_light_mode =
        [
          $.getStorageValue("tail_light_mode_0", 0) as Number,
          $.getStorageValue("tail_light_mode_1", 0) as Number,
          $.getStorageValue("tail_light_mode_2", 6) as Number,
          $.getStorageValue("tail_light_mode_3", 7) as Number,
          $.getStorageValue("tail_light_mode_4", 15) as Number,
          $.getStorageValue("tail_light_mode_5", 0) as Number,
          $.getStorageValue("tail_light_mode_6", 0) as Number,
          $.getStorageValue("tail_light_mode_7", -1) as Number,
        ] as Array<Number>;
      $.gOther_light_mode =
        [
          $.getStorageValue("other_light_mode_0", 0) as Number,
          $.getStorageValue("other_light_mode_1", 0) as Number,
          $.getStorageValue("other_light_mode_2", 6) as Number,
          $.getStorageValue("other_light_mode_3", 7) as Number,
          $.getStorageValue("other_light_mode_4", 15) as Number,
          $.getStorageValue("other_light_mode_5", 0) as Number,
          $.getStorageValue("other_light_mode_6", 0) as Number,
          $.getStorageValue("other_light_mode_7", -1) as Number,
        ] as Array<Number>;

      $.gDisplay_field = $.getStorageValue("display_field", $.gDisplay_field) as FieldDisplay;
      $.gShow_label = $.getStorageValue("show_label", $.gShow_label) as Boolean;
      $.gShow_lightInfo = $.getStorageValue("show_lightInfo", $.gShow_lightInfo) as Boolean;
      $.gShow_solar = $.getStorageValue("show_solar", $.gShow_solar) as Boolean;

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
var gAlert_no_network as Boolean = true;
// [ timer off, timer stopped, timer paused, timer on, seconds, paused for seconds, drop to solar intensity%, lightmode]
var gHead_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0, 0, 2];
var gTail_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0, 0, -1];
var gOther_light_mode as Array<Number> = [0, 0, 6, 7, 15, 0, 0, -1];
var gtest_TimerState as Number = -1;

var gIdxPauseSec as Number = 4;
var gIdxPauseMode as Number = 5;
var gIdxSolarIntensity as Number = 6;
var gIdxSolarMode as Number = 7;

var gDisplay_field as FieldDisplay = FldLights;
var gShow_label as Boolean = false;
var gShow_lightInfo as Boolean = false;
var gShow_solar as Boolean = false;

public enum FieldDisplay {
  FldLights = 0,
  FldDerailleurFIndex = 1,
  FldDerailleurRIndex = 2,
  FldDerailleurFRIndex = 3,
  FldDerailleurFSize = 4,
  FldDerailleurRSize = 5,
  FldDerailleurFRSize = 6,
  FldClock = 7,
  FldSolarIntensity = 8,
}
