import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.AntPlus;

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

      WatchUi.pushView(tlMenu, new $.GeneralMenuDelegate(self, tlMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      //item.setSubLabel($.subMenuToggleMenuItem(id as String));
      return;
    }
  }

  function onSelectedSelection(value as Object, storageKey as String) as Void {
    Storage.setValue(storageKey, value as Number);
  }
}

class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _delegate as DataFieldSettingsMenuDelegate;
  hidden var _item as MenuItem?;
  hidden var _currentPrompt as String = "";
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
        id.equals("head_light_mode_3"))
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
        id.equals("tail_light_mode_3"))
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
        id.equals("other_light_mode_3"))
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

    if (id instanceof String && id.equals("display_field")) {
      var sp = new selectionMenuPicker("Display field", id as String);
      for (var i = 0; i <= 6; i++) {
        sp.add($.getDisplayText(i), "", i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    _currentPrompt = item.getLabel();
    var numericOptions = $.parseLabelToOptions(_currentPrompt);

    var currentValue = $.getStorageValue(id as String, 0) as Numeric;
    if (numericOptions.isFloat) {
      currentValue = currentValue.toFloat();
    }
    var view = new $.NumericInputView(_debug, _currentPrompt, currentValue);
    view.processOptions(numericOptions);

    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_RIGHT);
  }

  function onAcceptNumericinput(value as Numeric) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;
        Storage.setValue(storageKey, value);

        switch (value) {
          case instanceof Long:
          case instanceof Number:
            (_item as MenuItem).setSubLabel(value.format("%.0d"));
            break;
          case instanceof Float:
          case instanceof Double:
            (_item as MenuItem).setSubLabel(value.format("%.2f"));
            break;
        }
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
    var view = new $.NumericInputView(_debug, _currentPrompt, 0);
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

  function onSelectedSelection(value as Object, storageKey as String) as Void {
    Storage.setValue(storageKey, value as Number);
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
      return "80-100%"; // LIGHT_MODE_ST_81_100
    case 2:
      return "60-80%"; //LIGHT_MODE_ST_61_80
    case 3:
      return "40-60%"; //LIGHT_MODE_ST_41_60
    case 4:
      return "20-40%"; //LIGHT_MODE_ST_21_40
    case 5:
      return "0-20%"; //LIGHT_MODE_ST_0_20
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
      return "80-100"; // LIGHT_MODE_ST_81_100
    case 2:
      return "60-80"; //LIGHT_MODE_ST_61_80
    case 3:
      return "40-60"; //LIGHT_MODE_ST_41_60
    case 4:
      return "20-40"; //LIGHT_MODE_ST_21_40
    case 5:
      return "0-20"; //LIGHT_MODE_ST_0_20
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
    default:
      return "";
  }
}

function getLightModeFor(key as String) as String {
  return Lang.format("$1$|$2$|$3$|$4$", [
    $.getLightModeTextShort($.getStorageValue(key + "0", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "1", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "2", -1) as Number),
    $.getLightModeTextShort($.getStorageValue(key + "3", -1) as Number),
  ]);
}
function getStorageNumberAsString(key as String) as String {
  return ($.getStorageValue(key, 0) as Number).format("%.0d");
}
