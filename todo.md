optional - when rader detect a car -> set light mode to fast flash
count brakes #x y/n
display speed option -> enabled when demo active
display brake count
set default to 4%

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

  