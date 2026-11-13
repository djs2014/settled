using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties as Properties;

class BikeRadarSensorListener extends AntPlus.BikeRadarListener {
  public var batteryStatus as Lang.Number = AntPlus.BATT_STATUS_INVALID;
  public var batteryVoltage as Lang.Float? = null;

  var _eventHandler as Lang.WeakReference;

  function initialize(eventHandler as SettledView) {
    BikeRadarListener.initialize();
    _eventHandler = eventHandler.weak();
  }

  // data probably always size of 8? Lucky that it is not described in the documentation.
  // Thanks to: https://github.com/kartoone/mybiketraffic/blob/master/source/MyBikeTrafficFitContributions.mc
  function onBikeRadarUpdate(data as Lang.Array<AntPlus.RadarTarget>) as Void {
    if (_eventHandler.stillAlive()) {
      var obj = _eventHandler.get();
      if (obj != null) {
        (obj as SettledView).onUpdateRadar(data);
      }
    }
  }

  function onBatteryStatusUpdate(data as AntPlus.BatteryStatus) as Void {
    if (data == null) {
      return;
    }

    // Guard against null or out-of-bounds enum values
    if (
      data.batteryStatus != null &&
      data.batteryStatus < AntPlus.BATT_STATUS_CNT
    ) {
      // Only overwrite if valid, or explicitly handle INVALID if tracking dropouts
      if (data.batteryStatus != AntPlus.BATT_STATUS_INVALID) {
        batteryStatus = data.batteryStatus;
      }
    }

    // Voltage can be null if the sensor only reports coarse status flags
    if (data.batteryVoltage != null && data.batteryVoltage > 0.0f) {
      batteryVoltage = data.batteryVoltage;
    }
  }

  function onDeviceStateUpdate(data as AntPlus.DeviceState) as Void {
    // Reset cached battery state if the sensor fully disconnects/drops
    if (data != null && data.state == AntPlus.DEVICE_STATE_DEAD) {
      batteryStatus = AntPlus.BATT_STATUS_INVALID;
      batteryVoltage = null;
    }
  }
}
