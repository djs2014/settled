# Settled

Connect IQ datafield for saving the state of a headlight/taillight, like Varia™ RTL515 or Varia™ UT800.
Set different light modes per timerstatus.


# Settings 

Settings are on device.

## Display

- Show connected lights
- Show derailleur index/size

## Light modes

Set light modes for a head light, tail light or other light.

Default values are:

- Timer off : light off
- Timer stopped : light off
- Timer paused: slow flash
- Timer on: fast flash
Option to set different mode after timer paused for x seconds.

Note, after connected to the lights, only the allowed modes are selectable.

## Brake light

When speed goes slower turn backlight on with specified light mode.

Minimal speed: when brake light is active.

Speed slower: percentage difference between current and previous speed (1 second interval). Ex: 3%;
Mode: define the tail lightmode. Ex: 40%

Speed slowest: percentage difference between current and previous speed (1 second interval). Ex: 10% (brake more)
Mode: define the tail lightmode. Ex: Fast flash

