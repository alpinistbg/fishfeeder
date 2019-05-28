# fishfeeder
Simple feeder for a fish tank. Uses small servo for rotating a cylindrical container by 180 degrees once a day. 
The goal is to create useful feeder with minimum parts and without any complexity.

It is designed originally for MSP-EXP430G2 LaunchPad kit, but AFAIK it can be easily ported to Arduino One or like.

# Prerequisites

## Hardware

1. Printed parts from the **stl** folder

2. [MSP-EXP430G2](http://www.ti.com/tool/MSP-EXP430G2) LaunchPad kit 

3. Servo motor, used one has the following parameters:

  * Torque: 3.7 kg (4.8 V), 4.1 kg (6V)
  * Speed: 0.16 sec. (4.8 V) 0.14 sec. (6V)
  * Dimensions: 40.3 x 19.7 x 37.3 mm
  * Weight: 36 g
  
4. 1K resistor

## Software

1. [Energia](http://energia.nu/), the Arduino framework to the Texas Instruments MSP430 based LaunchPad 

2. [OpenSCAD](http://www.openscad.org/) (optional), 3D CAD Modeller 
