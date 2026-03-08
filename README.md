# FPGA-Oscilloscope
## HDL Files and Hardware Documentation
HDL Files\
&nbsp;&nbsp;&nbsp;&nbsp;**Oscilloscope** [Acquire to HDMI](https://github.com/gmd563/Oscilloscope/tree/main/code/Acquire%20to%20HDMI)\
&nbsp;&nbsp;&nbsp;&nbsp;**Vitis Interface** [AXI4-Lite and Embedded C Firmware](https://github.com/gmd563/Oscilloscope/tree/main/code/Vitis%20Interface)

Hardware Documentation
- FPGA &rarr; **AX7010** [Schematic](/photos/AX7010_BoardSchematic.pdf) , [Layout](/photos/AX7010_BoardPCB.pdf) , and [Form Factor](/photos/AX7010_FormFactors.pdf)
- ADC &rarr; **AD7606** [Schematic](/photos/AD7606_Schematic.pdf)
- ADC Daughter Board &rarr; **AD7606 Daughter Board** [Schematic](/photos/ALINXdaughterSchematic.pdf)
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
