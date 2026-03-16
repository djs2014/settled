update bikelight info per second

daylight offset
 - also for backlight turn on
 $.gDay_nite_switch_seconds
 backlight_nite_switch_seconds

show battery bigger on edge *50  
show battery radar horiz/vertical?
on which batterylevel to show


fallback field  / when paused -> di gear == 0 -> show other data etc.


use metrics and fieldtype -> for field to show + fallback
optional show white / red/ circle for light status
--
optional - when rader detect a car -> set light mode to fast flash
count brakes #x y/n
display speed option -> enabled when demo active
display brake count
set default to 4%

x bug isnighttime -> get sunset/sunrise dynamic locations utils update 
x convert light modes to use array in storage
x + conversion old and remove obsolete fields
x    DeviceSettings.isNightModeEnabled --> use in constructor to detect.
x    test diff with getbackgroundcolor
x test menu edge 530 - long press  
x to test numeric input    x - update to other project numericinputview / delegate
break light
x% less than previous y seconds
-> fast flash

40 -> 38 == 5,1 %
30 -> 28 == 6,89 %
20 -> 19 == 5.1
20 -> 18 == 10 %
29 -> 28 == 3%
30 -> 29 == 3%


set defaults: 40% and brake ,,
choose border color -> brake
demo brake lights - 2 sec per km/h item
display text?

numinput
 - fix 830 screen width, bigger squares based on width of screen

alerts
- only when timer activity on?
- alert after x seconds
- beep x time -> counter

- backlight on
    - only when: only when dark / sun under
    - every 1 km, background light on
    - every x seconds (30 - ...)
    - seconds / meters

fix: size of clock bigger on 830 screen

API doc issue:
 getBikeLights() as Lang.Array<AntPlus.LightNetworkState> or Null  => definition is wrong?

  