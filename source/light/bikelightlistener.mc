using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties as Properties;

class BikeLightNetworkListener extends AntPlus.LightNetworkListener {
  private var _eventHandler as Lang.WeakReference;

  function initialize(eventHandler as SettledView) {
    LightNetworkListener.initialize();
    _eventHandler = eventHandler.weak();
  }

  function onLightNetworkStateUpdate(state as AntPlus.LightNetworkState) as Void {
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
