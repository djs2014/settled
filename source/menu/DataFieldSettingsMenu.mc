import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.AntPlus;
import Toybox.Activity;

class DataFieldSettingsMenu extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({ :title => "Settings" });
  }
}

//! Handles menu input and stores the menu data
class DataFieldSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _currentMenuItem as MenuItem?;
  hidden var _view as DataFieldSettingsView;

  function initialize(view as DataFieldSettingsView) {
    Menu2InputDelegate.initialize();
    _view = view;
  }

  function onSelect(item as MenuItem) as Void {
    _currentMenuItem = item;
    var id = item.getId();

    if (id instanceof String && id.equals("display")) {
      var dispMenu = new WatchUi.Menu2({ :title => "Display" });

      var mi = new WatchUi.MenuItem("Field", null, "display_field", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getDisplayText(value));
      dispMenu.addItem(mi);

      var boolean = Storage.getValue("show_label") ? true : false;
      dispMenu.addItem(new WatchUi.ToggleMenuItem("Show label", null, "show_label", boolean, null));

      boolean = Storage.getValue("show_lightInfo") ? true : false;
      dispMenu.addItem(new WatchUi.ToggleMenuItem("Show light info", null, "show_lightInfo", boolean, null));

      boolean = Storage.getValue("show_solar") ? true : false;
      dispMenu.addItem(new WatchUi.ToggleMenuItem("Show solar %", null, "show_solar", boolean, null));

      WatchUi.pushView(dispMenu, new $.GeneralMenuDelegate(self, dispMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("head_light_mode_")) {
      var tlMenu = new WatchUi.Menu2({ :title => "Head light mode" });

      var mi = new WatchUi.MenuItem("Timer off", null, "head_light_mode_0", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer stopped", null, "head_light_mode_1", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer paused", null, "head_light_mode_2", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer on", null, "head_light_mode_3", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When paused for| (seconds)", null, "head_light_mode_4", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " seconds");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "head_light_mode_5", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When solar drops|-1~100 (%)", null, "head_light_mode_6", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " %");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "head_light_mode_7", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      WatchUi.pushView(tlMenu, new $.GeneralMenuDelegate(self, tlMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("tail_light_mode_")) {
      var tlMenu = new WatchUi.Menu2({ :title => "Tail light mode" });

      var mi = new WatchUi.MenuItem("Timer off", null, "tail_light_mode_0", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer stopped", null, "tail_light_mode_1", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer paused", null, "tail_light_mode_2", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer on", null, "tail_light_mode_3", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When paused for| (seconds)", null, "tail_light_mode_4", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " seconds");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "tail_light_mode_5", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When solar drops|-1~100 (%)", null, "tail_light_mode_6", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " %");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "tail_light_mode_7", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      WatchUi.pushView(tlMenu, new $.GeneralMenuDelegate(self, tlMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("other_light_mode_")) {
      var tlMenu = new WatchUi.Menu2({ :title => "Other light mode" });

      var mi = new WatchUi.MenuItem("Timer off", null, "other_light_mode_0", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer stopped", null, "other_light_mode_1", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer paused", null, "other_light_mode_2", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Timer on", null, "other_light_mode_3", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When paused for| (seconds)", null, "other_light_mode_4", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " seconds");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "other_light_mode_5", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("When solar drops|-1~100 (%)", null, "other_light_mode_6", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " %");
      tlMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Set mode to", null, "other_light_mode_7", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      tlMenu.addItem(mi);

      WatchUi.pushView(tlMenu, new $.GeneralMenuDelegate(self, tlMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("alerts")) {
      var alertMenu = new WatchUi.Menu2({ :title => "Alerts" });

      var boolean = Storage.getValue("alert_no_network") ? true : false;
      alertMenu.addItem(
        new WatchUi.ToggleMenuItem("Light disconnect-", "ed, red screen ", "alert_no_network", boolean, null)
      );

      boolean = Storage.getValue("alert_no_phone") ? true : false;
      alertMenu.addItem(
        new WatchUi.ToggleMenuItem("Phone disconnect-", "ed, orange screen", "alert_no_phone", boolean, null)
      );

      var mi = new WatchUi.MenuItem("Phone alert after| (seconds)", null, "alert_no_phone_sec", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " seconds");
      alertMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Phone alert moving|0~1 (times)", null, "alert_no_phone_beep_moving", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " times");
      alertMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Phone alert stopped|0~1 (times)", null, "alert_no_phone_beep_stopped", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " times");
      alertMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Stopped speed lower than|0.0~10 (kmph/3.599999997)", null, "alert_stopped_speed_mps", null);
      var mps = $.getStorageValue(mi.getId() as String, 0) as Float;
      mi.setSubLabel((mps * 3.599999997f).format("%0.2f") + " kmph");
      alertMenu.addItem(mi);

      WatchUi.pushView(alertMenu, new $.GeneralMenuDelegate(self, alertMenu), WatchUi.SLIDE_UP);
      return;
    }

   if (id instanceof String && id.equals("backlight")) {
      var blightMenu = new WatchUi.Menu2({ :title => "Backlight" });

      var boolean = Storage.getValue("backlight_on") ? true : false;
      blightMenu.addItem(
        new WatchUi.ToggleMenuItem("Backlight", null, "backlight_on", boolean, null)
      );
      boolean = Storage.getValue("backlight_on_alerts") ? true : false;
      blightMenu.addItem(
        new WatchUi.ToggleMenuItem("On for alerts", null, "backlight_on_alerts", boolean, null)
      );
      
      boolean = Storage.getValue("backlight_at_night") ? true : false;
      blightMenu.addItem(
        new WatchUi.ToggleMenuItem("Only at night", null, "backlight_at_night", boolean, null)
      );

      var mi = new WatchUi.MenuItem("Trigger after| (seconds)", null, "backlight_on_sec", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " seconds");
      blightMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Trigger after| (meters)", null, "backlight_on_meters", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " meters");
      blightMenu.addItem(mi);     

      WatchUi.pushView(blightMenu, new $.GeneralMenuDelegate(self, blightMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("brakelight")) {
      var brakeMenu = new WatchUi.Menu2({ :title => "Brake light" });

      var boolean = Storage.getValue("brakelight_on") ? true : false;
      brakeMenu.addItem(        new WatchUi.ToggleMenuItem("Brake light", null, "brakelight_on", boolean, null));

      var mi = new WatchUi.MenuItem("Minimal speed |0.0 (km/h)", null, "brakelight_minimal_speed", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Speed slower|0.0~100 (%)", null, "brakelight_on_perc_0", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " %");
      brakeMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Mode", null, "brakelight_mode_0", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      brakeMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Speed slowest|0.0~100 (%)", null, "brakelight_on_perc_1", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " %");
      brakeMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Mode", null, "brakelight_mode_1", null);
      value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      brakeMenu.addItem(mi);
    
      mi = new WatchUi.MenuItem("Brake border|0~10 (px)", null, "brakelight_border", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " px");
      brakeMenu.addItem(mi);

      boolean = Storage.getValue("brakelight_demo") ? true : false;
      brakeMenu.addItem(        new WatchUi.ToggleMenuItem("Demo", null, "brakelight_demo", boolean, null));
      
      mi = new WatchUi.MenuItem("demo speed 0|0.0~100 (km/h)", null, "brakelight_data_0", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 1|0.0~100 (km/h)", null, "brakelight_data_1", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 2|0.0~100 (km/h)", null, "brakelight_data_2", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 30|0.0~100 (km/h)", null, "brakelight_data_3", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 4|0.0~100 (km/h)", null, "brakelight_data_4", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 5|0.0~100 (km/h)", null, "brakelight_data_5", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 6|0.0~100 (km/h)", null, "brakelight_data_6", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 7|0.0~100 (km/h)", null, "brakelight_data_7", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);
      mi = new WatchUi.MenuItem("demo speed 8|0.0~100 (km/h)", null, "brakelight_data_8", null);
      mi.setSubLabel($.getStorageNumberAsString(mi.getId() as String) + " km/h");
      brakeMenu.addItem(mi);

      WatchUi.pushView(brakeMenu, new $.GeneralMenuDelegate(self, brakeMenu), WatchUi.SLIDE_UP);
      return;
    }


    if (id instanceof String && id.equals("radar")) {
      var radarMenu = new WatchUi.Menu2({ :title => "Radar" });

      var boolean = Storage.getValue("radar_enabled") ? true : false;
      radarMenu.addItem(new WatchUi.ToggleMenuItem("Enabled", null, "radar_enabled", boolean, null));

      boolean = Storage.getValue("radar_first_detected_only") ? true : false;
      radarMenu.addItem(new WatchUi.ToggleMenuItem("Only first detected", null, "radar_first_detected_only", boolean, null));
      
      boolean = Storage.getValue("radar_activity_on_only") ? true : false;
      radarMenu.addItem(new WatchUi.ToggleMenuItem("Only when activity", null, "radar_activity_on_only", boolean, null));
      
      var mi = new WatchUi.MenuItem("When detected", null, "radar_hit_mode", null);
      var value = getStorageValue(mi.getId() as String, 0) as Number;
      mi.setSubLabel($.getLightModeText(value));
      radarMenu.addItem(mi);

      WatchUi.pushView(radarMenu, new $.GeneralMenuDelegate(self, radarMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("test_TimerState")) {
      var sp = new selectionMenuPicker("Test TimerState", id as String);
      for (var i = -1; i <= 3; i++) {
        sp.add($.getTimerStateAsString(i), "", i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      //item.setSubLabel($.subMenuToggleMenuItem(id as String));
      return;
    }
  }

  function onSelectedSelection(storageKey as String, value as Application.PropertyValueType) as Void {
    Storage.setValue(storageKey, value);
  }
}

class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _delegate as DataFieldSettingsMenuDelegate;
  hidden var _item as MenuItem?;
  hidden var _debug as Boolean = false;

  function initialize(delegate as DataFieldSettingsMenuDelegate, menu as WatchUi.Menu2) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  function onSelect(item as MenuItem) as Void {
    _item = item;
    var id = item.getId() as String;

    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      // item.setSubLabel($.subMenuToggleMenuItem(id as String));
      return;
    }
    if (
      id instanceof String &&
      (id.equals("head_light_mode_0") ||
        id.equals("head_light_mode_1") ||
        id.equals("head_light_mode_2") ||
        id.equals("head_light_mode_3") ||
        id.equals("head_light_mode_5") ||
        id.equals("head_light_mode_7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_HEADLIGHT);
      var sp = new selectionMenuPicker("Headlightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(i as AntPlus.LightMode) > -1
        ) {
          var text = $.getLightModeText(i);
          if (text.length() > 0) {
            sp.add(text, "", i);
          }
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }
    if (
      id instanceof String &&
      (id.equals("tail_light_mode_0") ||
        id.equals("tail_light_mode_1") ||
        id.equals("tail_light_mode_2") ||
        id.equals("tail_light_mode_3") ||
        id.equals("tail_light_mode_5") ||
        id.equals("tail_light_mode_7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_TAILLIGHT);

      var sp = new selectionMenuPicker("Taillightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(i as AntPlus.LightMode) > -1
        ) {
          var text = $.getLightModeText(i);
          if (text.length() > 0) {
            sp.add(text, "", i);
          }
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (
      id instanceof String &&
      (id.equals("other_light_mode_0") ||
        id.equals("other_light_mode_1") ||
        id.equals("other_light_mode_2") ||
        id.equals("other_light_mode_3") ||
        id.equals("other_light_mode_5") ||
        id.equals("other_light_mode_7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_OTHER);
      var sp = new selectionMenuPicker("Otherlightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(i as AntPlus.LightMode) > -1
        ) {
          var text = $.getLightModeText(i);
          if (text.length() > 0) {
            sp.add(text, "", i);
          }
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (
      id instanceof String &&
      (id.equals("brakelight_mode_0") ||
       id.equals("brakelight_mode_1"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_TAILLIGHT);

      var sp = new selectionMenuPicker("Brakelightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(i as AntPlus.LightMode) > -1
        ) {
          var text = $.getLightModeText(i);
          if (text.length() > 0) {
            sp.add(text, "", i);
          }
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

 if (
      id instanceof String &&
      id.equals("radar_hit_mode") )
     {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_TAILLIGHT);

      var sp = new selectionMenuPicker("Radarhitmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(i as AntPlus.LightMode) > -1
        ) {
          var text = $.getLightModeText(i);
          if (text.length() > 0) {
            sp.add(text, "", i);
          }
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }


    if (id instanceof String && id.equals("display_field")) {
      var sp = new selectionMenuPicker("Display field", id as String);
      for (var i = 0; i <= 8; i++) {
        sp.add($.getDisplayText(i), "", i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    // Numeric input
    var prompt = item.getLabel();
    var value = $.getStorageValue(id as String, 0) as Numeric;
    var view = $.getNumericInputView(prompt, value);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_RIGHT);
  }

  function onAcceptNumericinput(value as Numeric, subLabel as String) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;

        Storage.setValue(storageKey, value);
        (_item as MenuItem).setSubLabel(subLabel);
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function onNumericinput(
    editData as Array<Char>,
    cursorPos as Number,
    insert as Boolean,
    negative as Boolean,
    opt as NumericOptions
  ) as Void {
    // Hack to refresh screen
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    var view = new $.NumericInputView("", 0);
    view.processOptions(opt);
    view.setEditData(editData, cursorPos, insert, negative);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_IMMEDIATE);
  }

  //! Handle the back key being pressed

  function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected

  function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  // --

  function onSelectedSelection(storageKey as String, value as Application.PropertyValueType) as Void {
    Storage.setValue(storageKey, value);
  }
}

// global

function getLightModeText(value as Number) as String {
  switch (value) {
    case -1:
      return "---"; // do nothing
    case 0:
      return "off"; // LIGHT_MODE_OFF
    case 1:
      return "100%"; // LIGHT_MODE_ST_81_100
    case 2:
      return "80%"; //LIGHT_MODE_ST_61_80
    case 3:
      return "60%"; //LIGHT_MODE_ST_41_60
    case 4:
      return "40%"; //LIGHT_MODE_ST_21_40
    case 5:
      return "20%"; //LIGHT_MODE_ST_0_20
    case 6:
      return "slow flash"; //LIGHT_MODE_SLOW_FLASH
    case 7:
      return "fast flash"; //LIGHT_MODE_FAST_FLASH
    case 8:
      return "random flash"; //LIGHT_MODE_RANDOM_FLASH
    case 9:
      return "auto"; //LIGHT_MODE_AUTO
    case 10:
      return "left sc"; //LIGHT_MODE_SIGNAL_LEFT_SC
    case 11:
      return "left"; //LIGHT_MODE_SIGNAL_LEFT
    case 12:
      return "right sc"; //LIGHT_MODE_SIGNAL_RIGHT_SC
    case 13:
      return "right"; //LIGHT_MODE_SIGNAL_RIGHT
    case 14:
      return "hazard"; //LIGHT_MODE_SIGNAL_HAZARD

    case 59:
      return "custom 5"; //LIGHT_MODE_CUSTOM_5
    case 60:
      return "custom 4"; //LIGHT_MODE_CUSTOM_4
    case 61:
      return "custom 3"; //LIGHT_MODE_CUSTOM_3
    case 62:
      return "custom 2"; //LIGHT_MODE_CUSTOM_2
    case 63:
      return "custom 1"; //LIGHT_MODE_CUSTOM_1

    default:
      return "";
  }
}
function getLightModeTextShort(value as Number) as String {
  switch (value) {
    case -1:
      return "-"; // do nothing
    case 0:
      return "off"; // LIGHT_MODE_OFF
    case 1:
      return "100"; // LIGHT_MODE_ST_81_100
    case 2:
      return "80"; //LIGHT_MODE_ST_61_80
    case 3:
      return "60"; //LIGHT_MODE_ST_41_60
    case 4:
      return "40"; //LIGHT_MODE_ST_21_40
    case 5:
      return "20"; //LIGHT_MODE_ST_0_20
    case 6:
      return "s-flash"; //LIGHT_MODE_SLOW_FLASH
    case 7:
      return "f-flash"; //LIGHT_MODE_FAST_FLASH
    case 8:
      return "r-flash"; //LIGHT_MODE_RANDOM_FLASH
    case 9:
      return "auto"; //LIGHT_MODE_AUTO
    case 10:
      return "l-sc"; //LIGHT_MODE_SIGNAL_LEFT_SC
    case 11:
      return "l"; //LIGHT_MODE_SIGNAL_LEFT
    case 12:
      return "r-sc"; //LIGHT_MODE_SIGNAL_RIGHT_SC
    case 13:
      return "r"; //LIGHT_MODE_SIGNAL_RIGHT
    case 14:
      return "haz"; //LIGHT_MODE_SIGNAL_HAZARD

    case 59:
      return "c5"; //LIGHT_MODE_CUSTOM_5
    case 60:
      return "c4"; //LIGHT_MODE_CUSTOM_4
    case 61:
      return "c3"; //LIGHT_MODE_CUSTOM_3
    case 62:
      return "c2"; //LIGHT_MODE_CUSTOM_2
    case 63:
      return "c1"; //LIGHT_MODE_CUSTOM_1

    default:
      return "";
  }
}

function getDisplayText(value as Number) as String {
  switch (value as FieldDisplay) {
    case FldLights:
      return "Lights";
    case FldDerailleurFIndex:
      return "Front derailleur index";
    case FldDerailleurRIndex:
      return "Rear derailleur index";
    case FldDerailleurFRIndex:
      return "F/R derailleur index";
    case FldDerailleurFSize:
      return "Front derailleur size";
    case FldDerailleurRSize:
      return "Rear derailleur size";
    case FldDerailleurFRSize:
      return "F/R derailleur size";
    case FldClock:
      return "Clock";
    case FldSolarIntensity:
      return "Solar intensity";
    default:
      return "";
  }
}

function getLightModeFor(key as String) as String {
  var pauseAction = "";
  var sec = $.getStorageValue(key + "4", -1) as Number;
  if (sec > -1) {
    pauseAction = sec.format("%0d") + ":" + $.getLightModeTextShort($.getStorageValue(key + "5", -1) as Number);
  }
  return Lang.format("$1$|$2$|$3$|$4$|$5$", [
    $.getLightModeTextShort($.getStorageValue(key + "0", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "1", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "2", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "3", -1) as Number),
    pauseAction,
  ]);
}

function getTimerStateAsString(key as Number) as String {
  switch (key) {
    case -1:
      return "Ignore";
    case Activity.TIMER_STATE_OFF:
      return "Off";
    case Activity.TIMER_STATE_STOPPED:
      return "Stopped";
    case Activity.TIMER_STATE_PAUSED:
      return "Paused";
    case Activity.TIMER_STATE_ON:
      return "On";
    default:
      return "--";
  }
}

function getStorageNumberAsString(key as String) as String {
  return ($.getStorageValue(key, 0) as Number).format("%0d");
}

