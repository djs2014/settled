using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties as Properties;

class BikeLightNetworkListener extends AntPlus.LightNetworkListener {
  // Default to invalid/unknown until a valid page 82 arrives
  public var batteryStatus as Lang.Number = AntPlus.BATT_STATUS_INVALID;
  public var batteryVoltage as Lang.Float? = null;

  private var _eventHandler as Lang.WeakReference;

  function initialize(eventHandler as SettledView) {
    LightNetworkListener.initialize();
    _eventHandler = eventHandler.weak();
  }

  // Triggered asynchronously when Common Data Page 82 is received
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

  function onLightNetworkStateUpdate(
    state as AntPlus.LightNetworkState
  ) as Void {
    if (_eventHandler.stillAlive()) {
      var obj = _eventHandler.get();
      if (obj != null) {
        (obj as SettledView).onNetworkStateUpdate(state);
      }
    }
  }

  function onBikeLightUpdate(light as AntPlus.BikeLight) as Void {
    if (_eventHandler.stillAlive()) {
      var obj = _eventHandler.get();
      if (obj != null) {
        (obj as SettledView).onUpdateLight(light, light.mode);
      }
    }
  }
}
