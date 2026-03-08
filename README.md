# FPGA-Oscilloscope
[HDL Files and Documentation](https://github.com/gmd563/Oscilloscope/tree/main/code)
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
### Top-level
![Screenshot of Top-level Arhcitecture](/photos/acquireToHDMI.png)
### Datapath and Control
![Screenshot of Datapath and Control Arhcitecture](/photos/acquireToHdmi_datapath.png)
### Finite State Machine
![FSM Architecture](/photos/fsmArchitecture.svg)
### AXI-lite Control Interface
![AXI Interface Architecture](/photos/AXI_InterfaceArchitecture.svg)
### Top-level + Datapath and Control + Finite State Machine
![Top-level + Datapath and Control Arhcitecture](/photos/topLevel_and_datapathArchitecture.png)
