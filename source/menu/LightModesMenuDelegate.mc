import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.AntPlus;
import Toybox.Activity;

class LightModesMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _item as MenuItem?;
  hidden var _debug as Boolean = false;

  // Indicates the current value is retrieved and stored from an array
  // TODO
  hidden var _storageKey as String = "";
  hidden var _arrayIndex as Number = -1;

  function initialize(menu as WatchUi.Menu2) {
    Menu2InputDelegate.initialize();
  }

  hidden function getKeyAndIndex(key as String, index as Number) as String {
    return Lang.format("$1$|$2$", [key, index.toString()]);
  }

  function onSelect(item as MenuItem) as Void {
    _item = item;
    var id = item.getId() as String;

    // Extract selected storage key and index
    _storageKey = stringLeft(id, "|", id);
    var idx = stringRight(id, "|", "").toNumber();
    if (idx == null) {
      _arrayIndex = -1;
    } else {
      _arrayIndex = idx;
    }

    System.println([
      "LightModesMenuDelegate onSelect:",
      id,
      _storageKey,
      _arrayIndex,
    ]);

    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      // item.setSubLabel($.subMenuToggleMenuItem(id as String));
      return;
    }

    if (
      id instanceof String &&
      (id.equals("head_nightlight_mode") ||
        id.equals("tail_nightlight_mode") ||
        id.equals("other_nightlight_mode") ||
        id.equals("head_daylight_mode") ||
        id.equals("tail_daylight_mode") ||
        id.equals("other_daylight_mode"))
    ) {
      var title = stringReplace(id.toString(), "_", " ");
      var tlMenu = new WatchUi.Menu2({ :title => title });

      var storageKey = id.toString();

      var array = $.getStorageValue(storageKey, []) as Array<Number>;
      // Check size
      if (
        ensureArraySize(
          array as Array<Application.PropertyValueType>,
          $.gSizeArrLightModes,
          -1
        )
      ) {
        Storage.setValue(storageKey, array);
      }

      var index = 0;
      addMenuItem(
        tlMenu,
        "Timer off",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      index = 1;
      addMenuItem(
        tlMenu,
        "Timer stopped",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      index = 2;
      addMenuItem(
        tlMenu,
        "Timer paused",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      index = 3;
      addMenuItem(
        tlMenu,
        "Timer on",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      index = 4;
      addMenuItem(
        tlMenu,
        "When paused for| (seconds)",
        (array[index] as Number).toString() + " seconds",
        getKeyAndIndex(storageKey, index)
      );

      index = 5;
      addMenuItem(
        tlMenu,
        "Set mode to",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      index = 6;
      addMenuItem(
        tlMenu,
        "When solar drops|-1~100 (%)",
        (array[index] as Number).toString() + " %",
        getKeyAndIndex(storageKey, index)
      );

      index = 7;
      addMenuItem(
        tlMenu,
        "Set mode to",
        $.getLightModeText(array[index] as Number),
        getKeyAndIndex(storageKey, index)
      );

      WatchUi.pushView(
        tlMenu,
        self, // will use its own instance
        WatchUi.SLIDE_UP
      );
      return;
    }

    if (
      id instanceof String &&
      (id.equals("head_daylight_mode|0") ||
        id.equals("head_daylight_mode|1") ||
        id.equals("head_daylight_mode|2") ||
        id.equals("head_daylight_mode|3") ||
        id.equals("head_daylight_mode|5") ||
        id.equals("head_daylight_mode|7") ||
        id.equals("head_nightlight_mode|0") ||
        id.equals("head_nightlight_mode|1") ||
        id.equals("head_nightlight_mode|2") ||
        id.equals("head_nightlight_mode|3") ||
        id.equals("head_nightlight_mode|5") ||
        id.equals("head_nightlight_mode|7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_HEADLIGHT);
      var sp = new selectionMenuPicker("Headlightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(
            i as AntPlus.LightMode
          ) > -1
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
      (id.equals("tail_daylight_mode|0") ||
        id.equals("tail_daylight_mode|1") ||
        id.equals("tail_daylight_mode|2") ||
        id.equals("tail_daylight_mode|3") ||
        id.equals("tail_daylight_mode|5") ||
        id.equals("tail_daylight_mode|7") ||
        id.equals("tail_nightlight_mode|0") ||
        id.equals("tail_nightlight_mode|1") ||
        id.equals("tail_nightlight_mode|2") ||
        id.equals("tail_nightlight_mode|3") ||
        id.equals("tail_nightlight_mode|5") ||
        id.equals("tail_nightlight_mode|7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_TAILLIGHT);

      var sp = new selectionMenuPicker("Taillightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(
            i as AntPlus.LightMode
          ) > -1
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
      (id.equals("other_daylight_mode|0") ||
        id.equals("other_daylight_mode|1") ||
        id.equals("other_daylight_mode|2") ||
        id.equals("other_daylight_mode|3") ||
        id.equals("other_daylight_mode|5") ||
        id.equals("other_daylight_mode|7") ||
        id.equals("other_nightlight_mode|0") ||
        id.equals("other_nightlight_mode|1") ||
        id.equals("other_nightlight_mode|2") ||
        id.equals("other_nightlight_mode|3") ||
        id.equals("other_nightlight_mode|5") ||
        id.equals("other_nightlight_mode|7"))
    ) {
      var capableModes = $.getCapableLightModes(AntPlus.LIGHT_TYPE_OTHER);
      var sp = new selectionMenuPicker("Otherlightmode", id as String);
      for (var i = -1; i <= 63; i++) {
        if (
          capableModes == null ||
          (capableModes as Lang.Array<AntPlus.LightMode>).indexOf(
            i as AntPlus.LightMode
          ) > -1
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

    // Numeric input (TODO, is from array or plain storageKey)
    var prompt = item.getLabel();
    System.println(["Numeric input key:", id]);
    var value = $.getStorageValue(id as String, 0) as Numeric;
    var view = $.getNumericInputView(prompt, value);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(
      view,
      new $.NumericInputDelegate(_debug, view),
      WatchUi.SLIDE_RIGHT
    );
  }

  hidden function addMenuItem(
    menu as WatchUi.Menu2,
    label as String,
    subLabel as String,
    id as String
  ) {
    var mi = new WatchUi.MenuItem(label, subLabel, id, null);
    menu.addItem(mi);
  }

  function onAcceptNumericinput(value as Numeric, subLabel as String) as Void {
    try {
      if (_item != null) {
        // Note contains `storageKey|index` or `storageKey`
        var key = _item.getId() as String;
        $.setStorageValueOrArray(key, value);
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

    Toybox.WatchUi.pushView(
      view,
      new $.NumericInputDelegate(_debug, view),
      WatchUi.SLIDE_IMMEDIATE
    );
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

  // Note key contains `storageKey|index` or `storageKey`
  function onSelectedSelection(
    key as String,
    value as Application.PropertyValueType
  ) as Void {
    $.setStorageValueOrArray(key, value);
  }
}
