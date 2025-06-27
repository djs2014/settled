import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.AntPlus;
import Toybox.Time;
import Toybox.System;
import Toybox.Attention;

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
    Graphics.FONT_SYSTEM_LARGE,
  ];

  // ?? hidden var mBikeLights as Lang.Array<AntPlus.BikeLight>?;
  hidden var mBikeLights as Lang.Array<AntPlus.LightNetworkState>?;
  hidden var mLightNetworkState as Number = 0;
  hidden var mLightNetworkListener as BikeLightNetworkListener;
  hidden var mLightNetwork as AntPlus.LightNetwork;

  hidden var mBikeRadarListener as ABikeRadarListener?;
  hidden var mBikeRadar as BikeRadar;
  hidden var mRadarTargetCount as Number = 0;
  hidden var mRadarTargetDetected as Boolean = false;

  hidden var mLightType as Number = 0;
  hidden var mLightMode as Number = 0;
  hidden var mEvent as String = "";

  hidden var mSolarIntensity as Number = 0;
  hidden var yOffsetPauzed as Number = 5;
  hidden var mPhoneConnected as Boolean = false;
  hidden var mAlertNoPhoneCounter as Number = -1;
  hidden var mAlertNoPhone as Boolean = false;
  hidden var mUseFontsNumbers as Boolean = true;
  hidden var mActivityNeverHappened as Boolean = true;

  hidden var mLat as Double = 0d;
  hidden var mLon as Double = 0d;
  hidden var mCurrentLocation as CurrentLocation;
  hidden var mBackLightSeconds as Number = -1;
  hidden var mBackLightMeters as Number = -1;

  hidden var mPreviousSpeed as Float = 0.0f;
  hidden var mBrakelightBorder as Number = 0;
  // -1 do nothing, 0 start demo until end of data array
  hidden var mBrakelightDemoIdx as Number = -1;
  hidden var mBrakelightDemoCountdown as Number = 0;
  hidden var mHasTaillight as Boolean = false;
  // hidden var mBrakelightCounter as Number = 0;

  function initialize() {
    DataField.initialize();

    mLightNetworkListener = new BikeLightNetworkListener(self);
    mLightNetwork = new AntPlus.LightNetwork(mLightNetworkListener);

    if ($.gRadar_enabled) {
      mBikeRadarListener = new ABikeRadarListener(self);
      mBikeRadar = new AntPlus.BikeRadar(mBikeRadarListener);
    } else {
      mBikeRadar = new AntPlus.BikeRadar(null);
    }

    mAlertNoPhoneCounter = $.gAlert_no_phone_Sec;
    mAlertNoPhone = false;
    mActivityNeverHappened = true;

    mUseFontsNumbers = false;
    if ($.hasRequiredCIQVersion("5.0.0")) {
      mUseFontsNumbers = true;
    }

    mCurrentLocation = new CurrentLocation();
    mCurrentLocation.setOnLocationChanged(self, :onLocationChanged);
  }

  function onLocationChanged(degrees as Array<Double>) as Void {
    mLat = degrees[0];
    mLon = degrees[1];
  }

  function onLayout(dc as Dc) as Void {
    // fix for leaving menu, draw complete screen, large field
    dc.clearClip();
  }

  function compute(info as Activity.Info) as Void {
    var speed = $.getActivityValue(info, :currentSpeed, 0.0f) as Float;

    mTimerState = $.getActivityValue(info, :timerState, Activity.TIMER_STATE_OFF) as Activity.TimerState;
    if ($.gtest_TimerState > -1) {
      mTimerState = $.gtest_TimerState as Activity.TimerState;
    }
    mActivityNeverHappened = mTimerState == Activity.TIMER_STATE_OFF;

    mHeadLightMode = $.gHead_light_mode[mTimerState as Number] as Number;
    mTailLightMode = $.gTail_light_mode[mTimerState as Number] as Number;
    mOtherLightMode = $.gOther_light_mode[mTimerState as Number] as Number;

    // When paused, count down then optional change mode
    var mode = -1;
    var maxHeadLightSecInPause = $.gHead_light_mode[$.gIdxPauseSec] as Number;
    mHeadLightCounter = processPauseCounter(maxHeadLightSecInPause, mHeadLightCounter);
    if (mHeadLightCounter == 0) {
      mode = $.gHead_light_mode[$.gIdxPauseMode] as Number;
      if (mode > -1) {
        mHeadLightMode = mode;
      }
    }
    var maxTailLightSecInPause = $.gTail_light_mode[$.gIdxPauseSec] as Number;
    mTailLightCounter = processPauseCounter(maxTailLightSecInPause, mTailLightCounter);
    if (mTailLightCounter == 0) {
      mode = $.gTail_light_mode[$.gIdxPauseMode] as Number;
      if (mode > -1) {
        mTailLightMode = mode;
      }
    }
    var maxOtherLightSecInPause = $.gOther_light_mode[$.gIdxPauseSec] as Number;
    mOtherLightCounter = processPauseCounter(maxOtherLightSecInPause, mOtherLightCounter);
    if (mOtherLightCounter == 0) {
      mode = $.gOther_light_mode[$.gIdxPauseMode] as Number;
      if (mode > -1) {
        mOtherLightMode = mode;
      }
    }

    // Solar intensity
    if (mSolarIntensity >= -1) {
      var solarIntensity = 0;
      var solarMode = $.gHead_light_mode[$.gIdxSolarMode] as Number;
      if (solarMode > -1) {
        solarIntensity = $.gHead_light_mode[$.gIdxSolarIntensity] as Number;
        if (mSolarIntensity <= solarIntensity) {
          mHeadLightMode = solarMode;
        }
      }
      solarMode = $.gTail_light_mode[$.gIdxSolarMode] as Number;
      if (solarMode > -1) {
        solarIntensity = $.gTail_light_mode[$.gIdxSolarIntensity] as Number;
        if (mSolarIntensity <= solarIntensity) {
          mTailLightMode = solarMode;
        }
      }
      solarMode = $.gOther_light_mode[$.gIdxSolarMode] as Number;
      if (solarMode > -1) {
        solarIntensity = $.gOther_light_mode[$.gIdxSolarIntensity] as Number;
        if (mSolarIntensity <= solarIntensity) {
          mOtherLightMode = solarMode;
        }
      }
    }

    if ($.gBrakelight_on && $.gBrakelight_demo && mHasTaillight) {
      // For demo assume activity on
      mTailLightMode = $.gTail_light_mode[Activity.TIMER_STATE_ON] as Number;
      if (mBrakelightDemoCountdown <= 0) {
        mBrakelightDemoCountdown = 3; // 3 sec per demo speed
        mBrakelightDemoIdx = mBrakelightDemoIdx + 1;
      } else {
        mBrakelightDemoCountdown = mBrakelightDemoCountdown - 1;
      }

      if (mBrakelightDemoIdx < $.gBrakelight_demo_data.size()) {
        // There is test data
        speed = $.kmPerHourToMeterPerSecond($.gBrakelight_demo_data[mBrakelightDemoIdx]);
      } else {
        // Stop demo
        $.gBrakelight_demo = false;
        mBrakelightDemoIdx = -1;
        mBrakelightDemoCountdown = 0;
      }
    } else {
      mBrakelightDemoIdx = -1;
      mBrakelightDemoCountdown = 0;
    }

    // Brake light, when speed drops % in 1 second (onCompute interval)
    // TODO check/test when speed high and brake till speed < minimal_mps ->
    mBrakelightBorder = 0;
    if ($.gBrakelight_on && (speed > $.gBrakelight_minimal_mps || mPreviousSpeed > $.gBrakelight_minimal_mps)) {
      // System.println("percdiff " + $.percentageDifference(speed, mPreviousSpeed));
      if (speed < mPreviousSpeed && mPreviousSpeed > 0.0f && speed > 0.0f) {
        var percDiff = $.percentageDifference(speed, mPreviousSpeed);
        if (percDiff >= $.gBrakelight_on_perc_1 && $.gbrakelight_mode_1 > 0) {
          mTailLightMode = $.gbrakelight_mode_1;
          mBrakelightBorder = $.gBrakelight_border;
          // mBrakelightCounter = mBrakelightCounter + 1; doesnt work this way
        } else if (percDiff >= $.gBrakelight_on_perc_0 && $.gbrakelight_mode_0 > 0) {
          mTailLightMode = $.gbrakelight_mode_0;
          mBrakelightBorder = $.gBrakelight_border;
          // mBrakelightCounter = mBrakelightCounter + 1;
        }
      }

      mPreviousSpeed = speed;
    }

    // Always check per second just in case, event onUpdateRadar happens anytime
    if (mRadarTargetDetected) {
      if ($.gRadar_hit_mode > -1) {
        mTailLightMode = $.gRadar_hit_mode;
      }
      mRadarTargetDetected = false;
    }

    mBikeLights = mLightNetwork.getBikeLights();
    updateBikeLights();

    mActivityPauzed = mTimerState != Activity.TIMER_STATE_ON;
    mPhoneConnected = System.getDeviceSettings().phoneConnected;
    var myStats = System.getSystemStats();
    var solarIntensity = myStats.solarIntensity;
    if (solarIntensity == null) {
      mSolarIntensity = -2;
    } else {
      mSolarIntensity = solarIntensity;
    }

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
      case FldClock:
        // @@
        break;
      case FldSolarIntensity:
        mValueA = mSolarIntensity;
        break;
    }

    if ($.gBrakelight_demo && mBrakelightDemoIdx > -1) {
      mValueA = $.mpsToKmPerHour(speed);
      mValueB = 0;
    }

    if (mPhoneConnected || !$.gAlert_no_phone) {
      mAlertNoPhoneCounter = $.gAlert_no_phone_Sec;
      mAlertNoPhone = false;
    } else {
      if (mAlertNoPhoneCounter > -1) {
        mAlertNoPhoneCounter = mAlertNoPhoneCounter - 1;
      }
      if (mAlertNoPhoneCounter == 0) {
        // Signal alert -> screen, beep
        mAlertNoPhone = true;
      }
    }

    if (
      mAlertNoPhone &&
      mAlertNoPhoneCounter == 0 &&
      ($.gAlert_no_phone_Beep_Moving > 0 || $.gAlert_no_phone_Beep_Stopped > 0)
    ) {
      // Signal alert -> screen, beep
      alertBacklight();
      //var speed = $.getActivityValue(info, :currentSpeed, 0.0f) as Float;
      if (speed <= $.gAlert_Stopped_Speed_mps) {
        playAlertWhenStopped();
      } else {
        playAlertWhenMoving();
      }
    }

    mCurrentLocation.onCompute(info);
    var elapsedDistance = $.getActivityValue(info, :elapsedDistance, 0.0f) as Float;
    processBackLightTrigger(elapsedDistance.toNumber());
  }

  function playAlertWhenStopped() as Void {
    if (
      mActivityNeverHappened ||
      !(Attention has :playTone) ||
      !System.getDeviceSettings().tonesOn ||
      $.gAlert_no_phone_Beep_Stopped == 0
    ) {
      return;
    }
    // @@ counter for beep
    Attention.playTone(Attention.TONE_CANARY);
  }
  function playAlertWhenMoving() as Void {
    if (
      mActivityNeverHappened ||
      !(Attention has :playTone) ||
      !System.getDeviceSettings().tonesOn ||
      $.gAlert_no_phone_Beep_Moving == 0
    ) {
      return;
    }
    Attention.playTone(Attention.TONE_KEY);
  }
  function alertBacklight() as Void {
    if (!$.gBacklight_on_alerts) {
      return;
    }
    turnBacklightOn();
  }
  function processBackLightTrigger(elapsedDistance as Number) as Void {
    if (!$.gBacklight_on) {
      return;
    }
    if ($.gBacklight_at_night) {
      if (mCurrentLocation.isAtDaylightTime(Time.now(), true)) {
        return;
      }
    }

    if ($.gBacklight_on_sec == 0) {
      mBackLightSeconds = -1;
    } else {
      if (mBackLightSeconds < 0) {
        mBackLightSeconds = $.gBacklight_on_sec;
      } else if (mBackLightSeconds == 0) {
        turnBacklightOn();
      }
      mBackLightSeconds = mBackLightSeconds - 1;
    }

    if ($.gBacklight_on_meters == 0) {
      mBackLightMeters = -1;
    } else {
      if (mBackLightMeters < elapsedDistance) {
        mBackLightMeters = elapsedDistance + $.gBacklight_on_meters;
        turnBacklightOn();
      }
    }
    // System.println([mBackLightSeconds, mBackLightMeters, elapsedDistance, $.gBacklight_on_meters]);
  }

  function turnBacklightOn() as Void {
    try {
      Attention.backlight(true);
    } catch (ex) {
      System.println(ex.getErrorMessage());
      ex.printStackTrace();
    }
  }

  // function isNightTime() as Boolean {
  //   try {

  //   } catch(ex) {
  //     return false;
  //   }
  // }

  // When paused, countdown then optional change mode
  function processPauseCounter(maxSecondsPaused as Number, counter as Number) as Number {
    if (mTimerState != Activity.TIMER_STATE_PAUSED || maxSecondsPaused <= 0) {
      return maxSecondsPaused;
    }

    if (counter == -1) {
      return maxSecondsPaused;
    } else if (counter == 0) {
      return 0;
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

    var labelColor = Graphics.COLOR_LT_GRAY;

    if ($.gAlert_no_network) {
      var status = mLightNetwork.getNetworkState();
      switch (status) {
        case AntPlus.LIGHT_NETWORK_STATE_NOT_FORMED:
          fgColor = Graphics.COLOR_WHITE;
          bgColor = Graphics.COLOR_RED;
          labelColor = Graphics.COLOR_WHITE;
          break;
        case AntPlus.LIGHT_NETWORK_STATE_FORMING:
          bgColor = Graphics.COLOR_YELLOW;
          labelColor = Graphics.COLOR_WHITE;
          break;
        case AntPlus.LIGHT_NETWORK_STATE_FORMED:
          break;
      }
    }
    // if ($.gAlert_no_phone && !mPhoneConnected) {
    // if (mAlertNoPhone) {
    //   fgColor = Graphics.COLOR_WHITE;
    //   bgColor = Graphics.COLOR_ORANGE;
    //   labelColor = Graphics.COLOR_WHITE;
    // }

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
        dc.setColor(labelColor, bgColor);
        dc.drawText(2, yOffsetPauzed, fontLabel, label, Graphics.TEXT_JUSTIFY_LEFT);
      }
    }
    if ($.gShow_lightInfo) {
      dc.setColor(labelColor, bgColor);
      drawLightInfo(dc, width, height, true);
    }

    dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);

    var text = "";
    var subtext = "";

    if ($.gBrakelight_demo && mBrakelightDemoIdx > -1) {
      // Demo km/h to show brake light
      text = mValueA.format("%0.1f") + "km/h";
      subtext = "demo";
    } else {
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
        case FldClock:
          var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
          text = Lang.format("$1$:$2$", [today.hour, today.min.format("%02d")]);
          //fi.decimals = today.sec.format("%02d");
          subtext = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.day.format("%02d"), today.month]);
          break;
        case FldSolarIntensity:
          if (mValueA < 0) {
            text = "--";
          } else {
            text = mValueA.format("%d") + "%";
          }
          // Already displayed
          $.gShow_solar = false;
          break;
      }

      // No subtext when active
      if (!mActivityPauzed) {
        subtext = "";
      }
      if ($.gShow_solar && mSolarIntensity > -1) {
        subtext = mSolarIntensity.format("%d") + "% solar intensity";
        if (mActivityPauzed) {
          subtext = "";
        }
      }
    }

    var y;
    var x = width / 2;
    if (subtext.length() > 0) {
      dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
      var fontSub = $.getMatchingFont(dc, mFontsNumbers, width, height, subtext) as FontType;
      if ($.gShow_lightInfo) {
        y = yOffsetPauzed;
      } else {
        y = height - Graphics.getFontHeight(fontSub);
      }
      dc.drawText(x, y, fontSub, subtext, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // if ($.gAlert_no_phone && !mPhoneConnected) {
    if (mAlertNoPhone) {
      fgColor = Graphics.COLOR_WHITE;
      bgColor = Graphics.COLOR_ORANGE;
      labelColor = Graphics.COLOR_WHITE;
      dc.setColor(fgColor, bgColor);
      dc.clear();
      text = "No phone!";
    }

    var justification = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    var font = $.getMatchingFont(dc, mFontsNumbers, width, height, text) as FontType;
    if (!mUseFontsNumbers) {
      font = $.getMatchingFont(dc, mFonts, width, height, text) as FontType;
    }
    y = height / 2;
    dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, font, text, justification);

    if (mBrakelightBorder > 0) {
      dc.setPenWidth(mBrakelightBorder);
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      dc.drawRectangle(0, 0, width, height);
      dc.setPenWidth(1);
    }

    // if ($.gBrakelight_showCounter && mBrakelightCounter > 0) {
    //   dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
    //   text = "#" + mBrakelightCounter.format("%d");
    //   dc.drawText(width, 1, Graphics.FONT_SMALL, text, Graphics.TEXT_JUSTIFY_RIGHT);
    // }
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
    mHasTaillight = false;
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
            mHasTaillight = true;
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

  function onUpdateLight(light as AntPlus.BikeLight, mode as AntPlus.LightMode) as Void {
    if (light == null) {
      mEvent = "";
      return;
    }
    mEvent = "light: " + $.getBikeLightTypeText(light.type) + "\n mode: " + (mode as Number).format("%d");
  }

  function onUpdateRadar(data as Lang.Array<AntPlus.RadarTarget>) as Void {
    var amountDetected = data.size();
    // Reset if not enabled, nothing detected or when not active
    if (
      !$.gRadar_enabled ||
      amountDetected == 0 ||
      ($.gRadar_activity_on_only && mTimerState != Activity.TIMER_STATE_ON)
    ) {
      mRadarTargetCount = 0;
      mRadarTargetDetected = false;
      return;
    }

    if (amountDetected <= mRadarTargetCount) {
      // Less or same # detected
      mRadarTargetCount = amountDetected;
      if ($.gRadar_first_detected_only) {
        // No more signaling
        mRadarTargetDetected = false;
        return;
      } else {
        mRadarTargetDetected = true;
      }
    } else {
      // We got more detected
      mRadarTargetCount = amountDetected;
      mRadarTargetDetected = true;
    }
    // Update light
    if ($.gRadar_hit_mode > -1) {
      mTailLightMode = $.gRadar_hit_mode;
      mBikeLights = mLightNetwork.getBikeLights();
      updateBikeLights();
    }
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
  try {
    var lights = bikeLights as Array;
    for (var i = 0; i < lights.size(); i++) {
      var light = lights[i] as BikeLight;

      if (light != null) {
        var key = "lightmodes_" + $.getBikeLightTypeText(light.type as Number);
        // @@ bug in CIQ 7.2.0 passing Array<Number>
        Storage.setValue(key, light.getCapableModes() as Array<Application.PropertyValueType>);
      }
    }
  } catch (ex) {
    System.println(ex.getErrorMessage());
    ex.printStackTrace();
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
