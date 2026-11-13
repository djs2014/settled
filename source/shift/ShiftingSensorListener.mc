import Toybox.AntPlus;
import Toybox.System;
import Toybox.Lang;
class ShiftingSensorListener extends AntPlus.ShiftingListener {
  // Default to invalid/unknown until a valid page 82 arrives
  public var batteryStatus as Lang.Number = AntPlus.BATT_STATUS_INVALID;
  public var batteryVoltage as Lang.Float? = null;

  function initialize() {
    ShiftingListener.initialize();
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
}
