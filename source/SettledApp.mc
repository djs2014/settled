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

      var resetBL = Storage.getValue("brakelight_border");
      if (resetBL == null) {
        Storage.setValue("brakelight_on", true);
        Storage.setValue("brakelight_minimal_speed", 5.0f);        
        Storage.setValue("brakelight_on_perc_0", 3.0f);
        Storage.setValue("brakelight_mode_0", 4);
        Storage.setValue("brakelight_on_perc_1", 10.0f);
        Storage.setValue("brakelight_mode_1", 7);
        Storage.setValue("brakelight_border", 1);
      }
      
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
        Storage.setValue("alert_no_phone", true);
        Storage.setValue("alert_no_phone_sec", 3);
        Storage.setValue("alert_no_phone_beep_moving", 0);
        Storage.setValue("alert_no_phone_beep_stopped", 1);
        Storage.setValue("alert_stopped_speed_mps", 0.8f);

        Storage.setValue("backlight_on", false);
        Storage.setValue("backlight_on_alerts", false);
        Storage.setValue("backlight_at_night", true);
        Storage.setValue("backlight_on_sec", 0);
        Storage.setValue("backlight_on_meters", 1000);
       
        Storage.setValue("brakelight_on", true);
        Storage.setValue("brakelight_minimal_speed", 5.0f);        
        Storage.setValue("brakelight_on_perc_0", 3.0f);
        Storage.setValue("brakelight_mode_0", 4);
        Storage.setValue("brakelight_on_perc_1", 10.0f);
        Storage.setValue("brakelight_mode_1", 7);
        Storage.setValue("brakelight_border", 3);       
      }

      $.gDebug = getStorageValue("debug", $.gDebug) as Boolean;
      $.gAlert_no_network = getStorageValue("alert_no_network", $.gAlert_no_network) as Boolean;
      $.gAlert_no_phone = getStorageValue("alert_no_phone", $.gAlert_no_phone) as Boolean;
      $.gAlert_no_phone_Sec = getStorageValue("alert_no_phone_sec", $.gAlert_no_phone_Sec) as Number;
      $.gAlert_no_phone_Beep_Moving = getStorageValue("alert_no_phone_beep_moving", $.gAlert_no_phone_Beep_Moving) as Number;
      $.gAlert_no_phone_Beep_Stopped = getStorageValue("alert_no_phone_beep_stopped", $.gAlert_no_phone_Beep_Stopped) as Number;
      $.gAlert_Stopped_Speed_mps = getStorageValue("alert_stopped_speed_mps", $.gAlert_Stopped_Speed_mps) as Float;

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
      $.gShow_solar = $.getStorageValue("show_solar", $.gShow_solar) as Boolean;

      $.gBacklight_on = $.getStorageValue("backlight_on", $.gBacklight_on) as Boolean;
      $.gBacklight_on_alerts = $.getStorageValue("backlight_on_alerts", $.gBacklight_on_alerts) as Boolean;
      $.gBacklight_on_meters = $.getStorageValue("backlight_on_alerts", $.gBacklight_on_meters) as Number;
      $.gBacklight_at_night = $.getStorageValue("backlight_at_night", $.gBacklight_at_night) as Boolean;
      $.gBacklight_on_sec = $.getStorageValue("backlight_on_sec", $.gBacklight_on_sec) as Number;
      $.gBacklight_on_meters = $.getStorageValue("backlight_on_meters", $.gBacklight_on_meters) as Number;
          
      $.gBrakelight_on = $.getStorageValue("brakelight_on", $.gBrakelight_on) as Boolean;

      if ($.gBrakelight_on) {
        var minimalSpeed = $.getStorageValue("brakelight_minimal_speed", 5.0f) as Float;
        $.gBrakelight_minimal_mps = $.kmPerHourToMeterPerSecond(minimalSpeed);

        
        $.gBrakelight_on_perc_0 = $.getStorageValue("brakelight_on_perc_0", $.gBrakelight_on_perc_0) as Float;
        $.gbrakelight_mode_0 = $.getStorageValue("brakelight_mode_0", $.gbrakelight_mode_0) as Number;
        $.gBrakelight_on_perc_1 = $.getStorageValue("brakelight_on_perc_1", $.gBrakelight_on_perc_1) as Float;
        $.gbrakelight_mode_1 = $.getStorageValue("brakelight_mode_1", $.gbrakelight_mode_1) as Number;
        $.gBrakelight_border = $.getStorageValue("brakelight_border", $.gBrakelight_border) as Number;
        if ($.gBrakelight_on_perc_0 > $.gBrakelight_on_perc_1) {
          // swap values
          Storage.setValue("brakelight_on_perc_0", $.gBrakelight_on_perc_1);
          Storage.setValue("brakelight_mode_0", $.gbrakelight_mode_1);
          Storage.setValue("brakelight_on_perc_1", $.gBrakelight_on_perc_0);
          Storage.setValue("brakelight_mode_1", $.gbrakelight_mode_0);

          $.gBrakelight_on_perc_0 = $.getStorageValue("brakelight_on_perc_0", $.gBrakelight_on_perc_0) as Float;  
          $.gbrakelight_mode_0 = $.getStorageValue("brakelight_mode_0", $.gbrakelight_mode_0) as Number;
          $.gBrakelight_on_perc_1 = $.getStorageValue("brakelight_on_perc_1", $.gBrakelight_on_perc_1) as Float;
          $.gbrakelight_mode_1 = $.getStorageValue("brakelight_mode_1", $.gbrakelight_mode_1) as Number;
        }
      }
        
         
      System.println("User settings loaded");
    } catch (ex) {// Fast flash
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
var gAlert_no_phone as Boolean = true;
var gAlert_no_phone_Sec as Number = 3;
var gAlert_no_phone_Beep_Moving as Number = 0;
var gAlert_no_phone_Beep_Stopped as Number = 1;
var gAlert_Stopped_Speed_mps as Float = 0.8f;

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

var gBacklight_on as Boolean = false;
var gBacklight_on_alerts as Boolean = false;
var gBacklight_at_night as Boolean = true;
var gBacklight_on_sec as Number = 0;
var gBacklight_on_meters as Number = 1000;
      
var gBrakelight_on as Boolean = true;
var gBrakelight_minimal_mps as Float = 1.38888889f; // 5km/h
var gBrakelight_on_perc_0 as Float = 3.0f;
var gbrakelight_mode_0 as Number = 4; // 40%
var gBrakelight_on_perc_1 as Float = 10.0f;
var gbrakelight_mode_1 as Number = 7; // Fast flash
var gBrakelight_border as Number = 3;

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
