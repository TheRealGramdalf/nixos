### geetech BLTouch pinouts

Board UART3 Header:
- GND -> BRN jumper -> BRN on BLTouch cable: GND
- RX3 (D15, PJ0) -> ONG jumper -> WHT on BLTouch cable: Zmin
- TX3 (D14, PJ1) -> YLW jumper -> YLW on BLTouch cable: Control signal
- 5V -> RED jumper -> RED on BLTouch cable: +5V

Board ISP header:
- GND (above `6` on PCB) -> GRN jumper -> BLK on BLTouch cable: GND

Gramdalf
 — 
7/27/25, 10:28 AM
> Heya, I've got some questions about pinouts for wiring a BLTouch sensor. I did some digging of my own, then talked with chatgpt to get some reference links, and would like to verify some information before going ahead with things. It looks like I can use pins D14 and D15 on my trigorilla v1.1 board for said BLTouch sensor, as long as the display is disconnected - there appear to be two physical pins for each, (labeled as Y- and Y+ as part of the limit switches, and TX3/RX3 as part of UART3), two of which are currently routed to a daughterboard and eventually to the display. The other pair is easily accessible and wouldn't require soldering, so I'm wondering if I can use them safely if I disconnect the display
![./trigorilla_pinout.png]
> There's a reddit post saying that ar14 and ar15 worked for BLTouch, but I can't find a super clear conversion table between trigorilla pins and ATMega pins
https://www.reddit.com/r/klippers/comments/ldwgrr/trigorilla_pins_to_arduino_pins/


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:32 AM
> ar14 is D14, ar15 is D15
> but klipper doesnt use ar syntax anymore
> alias table is here, if its useful https://github.com/Klipper3d/klipper/blob/master/config/sample-aliases.cfg#L17
> ar = D, analog=A


Gramdalf
 — 
7/27/25, 10:40 AM
> Very. In general, are there any differences between ar# pins, or are they all the same hardware wise and just differentiated in firmware/software definitions?


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:41 AM
> no, just how they are denoted, standard digital pins


Gramdalf
 — 
7/27/25, 10:41 AM
> Good to know, thanks


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:41 AM
> some use D some use ar, depends on the convention used


zGrozemaG Δ
 — 
7/27/25, 10:41 AM
> theyre only differentiuated to digital and analog in the chip, but on the board itself every pin can have extra shit, like mosfets, pullups, diodes


Gramdalf
 — 
7/27/25, 10:42 AM
> Also good to know
> And 5V/GND can be grabbed from pretty much anywhere? Or do those ever get toggled by the chip?


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:44 AM
they are constant, anywhere is fine


Gramdalf
 — 
7/27/25, 10:52 AM
> Ok last question until I remember something else - my printer has two Z axis motors, and two Z limit switches. How would you go about making sure both motors are keeping the linear rails parrallel to the printer (I think it's called Z axis twist)? or is there a specific homing routine for these kinds of printers utilizing the BLTouch alone?


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:53 AM
> do you have 2 z drivers? or both motor on a shared z driver?


Gramdalf
 — 
7/27/25, 10:53 AM
> Individual drivers


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:53 AM
> then you would use z_tilt
> which is x axis tramming to the bed with a probe
> ie measures the bed on both sides, makes adjustments to each z to make X parallel with the bed
> you remove the limit switches, use the bltouch to home, and then perform a z_tilt_adjust operation
> then home z again to make sure there is no slight difference from the tramming process


Gramdalf
 — 
7/27/25, 10:56 AM
> And that would happen before each print, or as a one time thing?


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:56 AM
> usually you would do this as part of your start print gcode
> so it does it every time after a home in the print process
> ie 

```gcode
G28
Z_TILT_ADJUST
G28 Z
```

> instead of just G28


Gramdalf
 — 
7/27/25, 10:58 AM
> Ok, I'll see how it goes. I won't be able to test it till later, I need to get a friend to print a mounting bracket for the BLTouch first


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:58 AM
> you will also need to configure z_tilt module
> as an example, this is mine 

```yaml
[z_tilt]
z_positions:
    -29.5, 117.5
    248, 117.5
points:
    50, 117.50
    200, 117.50
speed: 200
horizontal_move_z: 15
retries: 25
retry_tolerance: 0.08
```


Gramdalf
 — 
7/27/25, 10:59 AM
> Yep, I'm not afraid to RTFM - it just really helps to be able to ask clarifying questions


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 10:59 AM
> z_positions are the point in cartesian space of your pivot points, ie where your z towers are, and points are sane places on the bed to probe
> if not cartesian, then may not be the towers, dont know what printer this is


Gramdalf
 — 
7/27/25, 11:01 AM
> Anycubic i3 Mega S


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 11:01 AM
> so bed slinger


Gramdalf
 — 
7/27/25, 11:01 AM
> Yep


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 11:01 AM
> so yes, positions are your towers in cartesian space
> as that is where they pivot


Gramdalf
 — 
7/27/25, 11:03 AM
> Which is outside of the print bed bounding box, at the center of the vertical screws? 

JamesH[Ender3v2,Micron+]
 — 
7/27/25, 11:03 AM
> yep
> cartesian space, not printable space
> so mine is -29.5 for the left tower, ie 29.5mm left of X0


Gramdalf
 — 
7/27/25, 11:04 AM
> Probably measured with calipers or something?
> Unless there's a value available for your model, though it might be inaccurate  due to manufacturing tolerances


JamesH[Ender3v2,Micron+]
 — 
7/27/25, 11:07 AM
> just measure it 🙂
> send nozzle to X0, measure back to left tower, then for right tower it should be same distance plus width of bed in the other direction
> assuming symmetry
> X0 should be edge of bed, but not always, depends on your setup and calibration
> some set X0 to be in bed, due to clips etc
> but generally X0 Y0 is front left corner of the bed