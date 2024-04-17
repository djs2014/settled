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

        Storage.setValue("head_light_mode_0", 0); // off
        Storage.setValue("head_light_mode_1", 0); // stopped -> off
        Storage.setValue("head_light_mode_2", 6); // paused -> slow flash
        Storage.setValue("head_light_mode_3", 7); // on -> fast flash
        Storage.setValue("tail_light_mode_0", 0); // off
        Storage.setValue("tail_light_mode_1", 0); // stopped -> off
        Storage.setValue("tail_light_mode_2", 6); // paused -> slow flash
        Storage.setValue("tail_light_mode_3", 7); // on -> fast flash
        Storage.setValue("other_light_mode_0", 0); // off
        Storage.setValue("other_light_mode_1", 0); // stopped -> off
        Storage.setValue("other_light_mode_2", 6); // paused -> slow flash
        Storage.setValue("other_light_mode_3", 7); // on -> fast flash
      }

      $.gDebug = getStorageValue("debug", gDebug) as Boolean;
      
      $.gHead_light_mode = [
        $.getStorageValue("head_light_mode_0", 0) as Number,
        $.getStorageValue("head_light_mode_1", 0) as Number,
        $.getStorageValue("head_light_mode_2", 6) as Number,
        $.getStorageValue("head_light_mode_3", 7) as Number,
      ] as Array<Number>;
      $.gTail_light_mode = [
        $.getStorageValue("tail_light_mode_0", 0) as Number,
        $.getStorageValue("tail_light_mode_1", 0) as Number,
        $.getStorageValue("tail_light_mode_2", 6) as Number,
        $.getStorageValue("tail_light_mode_3", 7) as Number,
      ] as Array<Number>;
      $.gOther_light_mode = [
        $.getStorageValue("other_light_mode_0", 0) as Number,
        $.getStorageValue("other_light_mode_1", 0) as Number,
        $.getStorageValue("other_light_mode_2", 6) as Number,
        $.getStorageValue("other_light_mode_3", 7) as Number,
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
var gHead_light_mode as Array<Number> = [0,0,6,7];
var gTail_light_mode as Array<Number> = [0,0,6,7];
var gOther_light_mode as Array<Number> = [0,0,6,7];

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
}
