using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties as Properties;

class ABikeRadarListener extends AntPlus.BikeRadarListener {
  var _eventHandler as Lang.WeakReference;
  
  function initialize(eventHandler as SettledView) {
    BikeRadarListener.initialize();
    _eventHandler = eventHandler.weak();
  }

 

  function onBikeRadarUpdate(data as Lang.Array<AntPlus.RadarTarget>) as Void {
    if (_eventHandler.stillAlive()) {
      var obj = _eventHandler.get();
      if (obj != null) {
        (obj as SettledView).onUpdateRadar(data);
      }     
    }
  }
}

