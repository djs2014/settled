import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.AntPlus;

class SettledView extends WatchUi.DataField {
  hidden var mActivityPauzed as Boolean = true;
  hidden var mHeadLightMode as Number = -1;
  hidden var mTailLightMode as Number = -1;
  hidden var mOtherLightMode as Number = -1;

  hidden var mHeadLightCounter as Number = -1;
  hidden var mTailLightCounter as Number = -1;
  hidden var mOtherLightCounter as Number = -1;

  hidden var mTimerState as Activity.TimerState = Activity.TIMER_STATE_OFF;
  hidden var mValueA as Numeric = 0;
  hidden var mValueB as Numeric = 0;

  hidden var mFontsNumbers as Array = [
    Graphics.FONT_XTINY,
    Graphics.FONT_TINY,
    Graphics.FONT_SYSTEM_SMALL,
    Graphics.FONT_NUMBER_MILD,
    Graphics.FONT_NUMBER_HOT,
    Graphics.FONT_NUMBER_THAI_HOT,
  ];
  hidden var mFontsLabel as Array = [
    Graphics.FONT_XTINY,
    Graphics.FONT_TINY,
    Graphics.FONT_SYSTEM_SMALL,
    // Graphics.FONT_SYSTEM_MEDIUM,
    // Graphics.FONT_SYSTEM_LARGE,
  ];
  hidden var mFonts as Array = [
    Graphics.FONT_XTINY,
    Graphics.FONT_TINY,
    Graphics.FONT_SYSTEM_SMALL,
    Graphics.FONT_SYSTEM_MEDIUM,
    // Graphics.FONT_SYSTEM_LARGE,
  ];

  // ?? hidden var mBikeLights as Lang.Array<AntPlus.BikeLight>?;
  hidden var mBikeLights as Lang.Array<AntPlus.LightNetworkState>?;
  hidden var mLightNetworkState as Number = 0;
  hidden var mLightNetworkListener as BikeLightNetworkListener;
  hidden var mLightNetwork as AntPlus.LightNetwork;

  hidden var mLightType as Number = 0;
  hidden var mLightMode as Number = 0;
  hidden var mEvent as String = "";

  function initialize() {
    DataField.initialize();

    mLightNetworkListener = new BikeLightNetworkListener(self);
    mLightNetwork = new AntPlus.LightNetwork(mLightNetworkListener);
  }

  function onLayout(dc as Dc) as Void {}

  function compute(info as Activity.Info) as Void {
    mTimerState = $.getActivityValue(info, :timerState, Activity.TIMER_STATE_OFF) as Activity.TimerState;

    mHeadLightMode = $.gHead_light_mode[mTimerState as Number] as Number;
    mTailLightMode = $.gTail_light_mode[mTimerState as Number] as Number;
    mOtherLightMode = $.gOther_light_mode[mTimerState as Number] as Number;

    // When paused, count down then optional change mode
    var mode = -1;
    var maxHeadLightSecInPause = $.gHead_light_mode[4] as Number;
    mHeadLightCounter = processPauseCounter(maxHeadLightSecInPause, mHeadLightCounter);
    if (mHeadLightCounter == 0) {
      mode = $.gHead_light_mode[5] as Number;
      if (mode > -1) {
        mHeadLightMode = mode;
      }
    }
    var maxTailLightSecInPause = $.gTail_light_mode[4] as Number;
    mTailLightCounter = processPauseCounter(maxTailLightSecInPause, mTailLightCounter);
    if (mTailLightCounter == 0) {
      mode = $.gTail_light_mode[5] as Number;
      if (mode > -1) {
        mTailLightMode = mode;
      }
    }
    var maxOtherLightSecInPause = $.gOther_light_mode[4] as Number;
    mOtherLightCounter = processPauseCounter(maxOtherLightSecInPause, mOtherLightCounter);
    if (mOtherLightCounter == 0) {
      mode = $.gOther_light_mode[5] as Number;
      if (mode > -1) {
        mOtherLightMode = mode;
      }
    }

    mBikeLights = mLightNetwork.getBikeLights();
    updateBikeLights();

    mActivityPauzed = mTimerState != Activity.TIMER_STATE_ON;

    mValueA = 0;
    mValueB = 0;
    switch ($.gDisplay_field) {
      case FldLights:
        break;
      case FldDerailleurFIndex:
        mValueA = $.getActivityValue(info, :frontDerailleurIndex, 0) as Number;
        break;
      case FldDerailleurRIndex:
        mValueA = $.getActivityValue(info, :rearDerailleurIndex, 0) as Number;
        break;
      case FldDerailleurFRIndex:
        mValueA = $.getActivityValue(info, :frontDerailleurIndex, 0) as Number;
        mValueB = $.getActivityValue(info, :rearDerailleurIndex, 0) as Number;
        break;
      case FldDerailleurFSize:
        mValueA = $.getActivityValue(info, :frontDerailleurSize, 0) as Number;
        break;
      case FldDerailleurRSize:
        mValueA = $.getActivityValue(info, :rearDerailleurSize, 0) as Number;
        break;
      case FldDerailleurFRSize:
        mValueA = $.getActivityValue(info, :frontDerailleurSize, 0) as Number;
        mValueB = $.getActivityValue(info, :rearDerailleurSize, 0) as Number;
        break;
    }
  }

  // When paused, countdown then optional change mode
  function processPauseCounter(maxSecondsPaused as Number, counter as Number) as Number {
    if (mTimerState != Activity.TIMER_STATE_PAUSED || maxSecondsPaused <= 0) {
      return -1;
    }

    if (counter == -1) {
      return maxSecondsPaused;
    }
    return counter - 1;
  }

  function onUpdate(dc as Dc) as Void {
    if ($.gExitedMenu) {
      // fix for leaving menu, draw complete screen, large field
      dc.clearClip();
      $.gExitedMenu = false;
    }

    var width = dc.getWidth();
    var height = dc.getHeight();
    var bgColor = getBackgroundColor();
    var fgColor = Graphics.COLOR_BLACK;
    if (bgColor == fgColor) {
      fgColor = Graphics.COLOR_WHITE;
    }

    dc.setColor(fgColor, bgColor);
    dc.clear();

    if ($.gDebug) {
      drawDebugInfo(dc, width, height);
      return;
    }

    if ($.gShow_label && mActivityPauzed) {
      var label = $.getDisplayText($.gDisplay_field);
      if (label.length() > 0) {
        var fontLabel = $.getMatchingFont(dc, mFontsLabel, width, height, label) as FontType;
        dc.setColor(Graphics.COLOR_LT_GRAY, bgColor);
        dc.drawText(2, 1, fontLabel, label, Graphics.TEXT_JUSTIFY_LEFT);
      }
    }
    if ($.gShow_lightInfo) {
      dc.setColor(Graphics.COLOR_LT_GRAY, bgColor);
      drawLightInfo(dc, width, height, true);
    }

    dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);

    var text = "";
    switch ($.gDisplay_field) {
      case FldLights:
        drawLightInfo(dc, width, height, false);
        break;
      case FldDerailleurFIndex:
      case FldDerailleurRIndex:
      case FldDerailleurFSize:
      case FldDerailleurRSize:
        text = mValueA.format("%d");
        break;
      case FldDerailleurFRIndex:
        text = mValueA.format("%d") + "|" + mValueB.format("%d");
        break;
      case FldDerailleurFRSize:
        text = mValueA.format("%d") + "|" + mValueB.format("%d");
        break;
    }

    var justification = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    var font = $.getMatchingFont(dc, mFontsNumbers, width, height, text) as FontType;
    var x = width / 2;
    var y = height / 2;

    dc.drawText(x, y, font, text, justification);
  }

  function drawLightInfo(dc as Dc, width as Number, height as Number, atBottom as Boolean) as Void {
    var font = Graphics.FONT_MEDIUM;
    var lh = dc.getFontHeight(font);
    var x = width / 2;
    var y = height / 2;
    var justification = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    var text = "";

    var status = mLightNetwork.getNetworkState();
    if (status == AntPlus.LIGHT_NETWORK_STATE_FORMING) {
      text = "Network forming";
    } else if (status != AntPlus.LIGHT_NETWORK_STATE_FORMED) {
      text = "No network";
    } else if (status == AntPlus.LIGHT_NETWORK_STATE_FORMED) {
      mBikeLights = mLightNetwork.getBikeLights();

      if (mBikeLights == null || mBikeLights.size() == 0) {
        text = "No lights";
      } else {
        var bikeLights = mBikeLights as Array;
        for (var j = 0; j < bikeLights.size() / 2; j++) {
          y = y - lh - 1;
        }

        var textHead = "";
        var textTail = "";
        var textOther = "";
        for (var i = 0; i < bikeLights.size(); i++) {
          var light = bikeLights[i] as BikeLight?;

          if (light != null) {
            if (atBottom) {
              switch (light.type as Number) {
                case 0:
                  textHead = "H-" + $.getLightModeText(light.mode as Number);
                  break;
                case 2:
                  textTail = " T-" + $.getLightModeText(light.mode as Number);
                  break;
                case 6:
                  textOther = " O-" + $.getLightModeText(light.mode as Number);
                  break;
              }
              text = textHead + textTail + textOther;
            } else {
              var line = $.getBikeLightTypeText(light.type as Number) + " " + $.getLightModeText(light.mode as Number);
              font = $.getMatchingFont(dc, mFonts, width, height, line) as FontType;
              dc.drawText(x, y, font, line, justification);
              y = y + lh + 1;
            }
          }
        }
      }
    }

    if (text.length() > 0) {
      font = $.getMatchingFont(dc, mFonts, width, height, text) as FontType;
      if (atBottom) {
        justification = Graphics.TEXT_JUSTIFY_LEFT;
        x = 1;
        lh = dc.getFontHeight(font);
        y = height - lh;
      }
      dc.drawText(x, y, font, text, justification);
      return;
    }
  }
  function drawDebugInfo(dc as Dc, width as Number, height as Number) as Void {
    var font = Graphics.FONT_MEDIUM;
    var lh = dc.getFontHeight(font);
    var x = width / 2;
    var y = lh + 1;
    var justification = Graphics.TEXT_JUSTIFY_CENTER;

    var text = getActivityText(mTimerState);
    dc.drawText(x, y, font, text, justification);
    y = y + lh + 1;

    text = "Light Network: " + mLightNetworkState.format("%d");
    dc.drawText(x, y, font, text, justification);
    y = y + lh + 1;

    text = "Event: " + mEvent;
    dc.drawText(x, y, font, text, justification);
    y = y + lh + 1;

    if (mBikeLights == null || mBikeLights.size() == 0) {
      return;
    }
    var bikeLights = mBikeLights as Array;
    for (var i = 0; i < bikeLights.size(); i++) {
      var light = bikeLights[i] as BikeLight?;

      if (light != null) {
        y = y + lh + 1;
        text = "Light: " + $.getBikeLightTypeText(light.type as Number);
        dc.drawText(x, y, font, text, justification);

        y = y + lh + 1;

        var lightMode = -1;
        switch (light.type) {
          case AntPlus.LIGHT_TYPE_HEADLIGHT:
            lightMode = mHeadLightMode;
            break;
          case AntPlus.LIGHT_TYPE_TAILLIGHT:
            lightMode = mTailLightMode;
            break;
          default:
          case AntPlus.LIGHT_TYPE_OTHER:
            lightMode = mOtherLightMode;
            break;
        }

        text = "Mode: " + (light.mode as Number).format("%d") + " ->  " + lightMode.format("%d");
        dc.drawText(x, y, font, text, justification);

        text = "gTail:";
        for (var t = 0; t < $.gTail_light_mode.size(); t++) {
          text = text + "|" + ($.gTail_light_mode[t] as Number).format("%0d");
        }
        y = y + lh + 1;
        dc.drawText(x, y, font, text, justification);

        var capableModes = light.getCapableModes();
        if (capableModes != null) {
          text = "Capable: ";
          var modes = capableModes as Lang.Array<AntPlus.LightMode>;
          for (var c = 0; c < modes.size(); c++) {
            text = text + (modes[c] as Number).format("%d") + " ";
          }
          y = y + lh + 1;
          dc.drawText(x, y, font, text, justification);
        }
      }
    }
  }

  function updateBikeLights() as Void {
    if (mBikeLights == null || mBikeLights.size() == 0) {
      return;
    }
    var bikeLights = mBikeLights as Array;
    for (var i = 0; i < bikeLights.size(); i++) {
      var light = bikeLights[i] as BikeLight?;

      if (light != null) {
        var lightMode = -1;
        switch (light.type) {
          case AntPlus.LIGHT_TYPE_HEADLIGHT:
            lightMode = mHeadLightMode;
            break;
          case AntPlus.LIGHT_TYPE_TAILLIGHT:
            lightMode = mTailLightMode;
            break;
          default:
          case AntPlus.LIGHT_TYPE_OTHER:
            lightMode = mOtherLightMode;
            break;
        }

        if (lightMode > -1 && lightMode != (light.mode as Number)) {
          var capableModes = light.getCapableModes();
          if (capableModes != null) {
            if ((capableModes as Lang.Array<AntPlus.LightMode>).indexOf(lightMode as AntPlus.LightMode) > -1) {
              light.setMode(lightMode as AntPlus.LightMode);
            }
          }
        }
      }
    }
  }

  function onNetworkStateUpdate(state as AntPlus.LightNetworkState) as Void {
    mLightNetworkState = state as Number;
    mEvent = "State: " + mLightNetworkState.format("%d");
    mBikeLights = mLightNetwork.getBikeLights();

    $.storeCapableLightModes(mBikeLights);
  }

  function updateLight(light as AntPlus.BikeLight, mode as AntPlus.LightMode) as Void {
    if (light == null) {
      mEvent = "";
      return;
    }
    mEvent = "light: " + $.getBikeLightTypeText(light.type) + "\n mode: " + (mode as Number).format("%d");
  }

  // const lightType = ["Head", "?", "Tail", "Signal", "SignalLeft", "SignalRight", "Other"];

  function getActivityText(value as Activity.TimerState) as String {
    switch (value) {
      case Activity.TIMER_STATE_OFF:
        return "Off";
      case Activity.TIMER_STATE_PAUSED:
        return "Paused";
      case Activity.TIMER_STATE_STOPPED:
        return "Stopped";
      case Activity.TIMER_STATE_ON:
        return "On";
      default:
        return "--";
    }
  }
}

function storeCapableLightModes(bikeLights as Lang.Array<AntPlus.LightNetworkState>?) as Void {
  if (bikeLights == null || bikeLights.size() == 0) {
    return;
  }

  var lights = bikeLights as Array;
  for (var i = 0; i < lights.size(); i++) {
    var light = lights[i] as BikeLight;

    if (light != null) {
      var key = "lightmodes_" + $.getBikeLightTypeText(light.type as Number);
      Storage.setValue(key, light.getCapableModes());
    }
  }
}

function getCapableLightModes(lightType as Number) as Lang.Array<AntPlus.LightMode>? {
  var key = "lightmodes_" + $.getBikeLightTypeText(lightType as Number);
  return getStorageValue(key, null) as Lang.Array<AntPlus.LightMode>?;
}

function getBikeLightTypeText(value as Number) as String {
  switch (value) {
    case 0:
      return "Head";
    case 2:
      return "Tail";
    case 3:
      return "Signal";
    case 4:
      return "SignalLeft";
    case 5:
      return "SignalRight";
    case 6:
      return "Other";
    default:
      return "--";
  }
}
