# FPGA-Oscilloscope
HDL Files and Documentation
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
### Datapath and Control
![Screenshot of Datapath and Control Arhcitecture](/photos/datapathArchitecture.png)
### Finite State Machine
![Screenshot of FSM Architecture](/photos/fsmArchitecture.png)
### AXI-lite Control Interface
![Screenshot of AXI Interface Architecture](/photos/AXI_InterfaceArchitecture.png)
