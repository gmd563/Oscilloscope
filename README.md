# FPGA-Oscilloscope
## HDL Files and Documentation
&nbsp;&nbsp;&nbsp;&nbsp;**Oscilloscope**
[Acquire to HDMI](https://github.com/gmd563/Oscilloscope/tree/main/code/Acquire%20to%20HDMI)

&nbsp;&nbsp;&nbsp;&nbsp;**Vitis Interface**
[AXI4-Lite and Embedded C Firmware](https://github.com/gmd563/Oscilloscope/tree/main/code/Vitis%20Interface)

&nbsp;&nbsp;&nbsp;&nbsp;**AX7010**
Board [Schematic]() ,
[Layout]() ,
and [Form Factor]()
## Hardware
- Alinx AX7010 FPGA
- ADC input
- HDMI output
## Features
- Real-time signal acquisition
- Edge-trigger detection
- Adjustable voltage and trigger markers
- Sine and sinc waveform generator
## Architecture
- RTL datapath and control
- FSM acquisition control
- Simple dual-port BRAM
- AXI-lite control interface
### Top-level + Datapath and Control
![Top-level + Datapath and Control Arhcitecture](/photos/topLevel_and_datapathArchitecture.png)
### Finite State Machine
![FSM Architecture](/photos/fsmArchitecture.svg)
### AXI-lite Control Interface
![AXI Interface Architecture](/photos/AXI_InterfaceArchitecture.svg)
