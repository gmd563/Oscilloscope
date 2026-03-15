# FPGA-Oscilloscope
## HDL Files and Hardware Documentation
HDL Files\
&nbsp;&nbsp;&nbsp;&nbsp;**Oscilloscope** [Acquire to HDMI](https://github.com/gmd563/Oscilloscope/tree/main/code/Acquire%20to%20HDMI)\
&nbsp;&nbsp;&nbsp;&nbsp;**Vitis Interface** [AXI4-Lite and Embedded C Firmware](https://github.com/gmd563/Oscilloscope/tree/main/code/Vitis%20Interface)

Hardware Documentation\
&nbsp;&nbsp;&nbsp;&nbsp;FPGA &rarr; **AX7010** [Schematic](/photos/AX7010_BoardSchematic.pdf) , [Layout](/photos/AX7010_BoardPCB.pdf) , and [Form Factor](/photos/AX7010_FormFactors.pdf)\
&nbsp;&nbsp;&nbsp;&nbsp;ADC &rarr; **AD7606** [Schematic](/photos/AD7606_Schematic.pdf)\
&nbsp;&nbsp;&nbsp;&nbsp;ADC Daughter Board &rarr; **AD7606 Daughter Board** [Schematic](/photos/ALINXdaughterSchematic.pdf)
## Features
- Real-time ADC signal acquisition.
- Edge-trigger detection for FSM-controlled sampling.
- Two simple dual-port BRAM buffering.
- HDMI video display pipeline.
- Adjustable voltage and trigger markers.
- UART-controlled sine and sinc waveform generator.
- AXI_Lite interface for Vitis configuration.
## Technologies
- **FPGA:** AX7010 (Xilinx Zynq-7010)
- **HDL:** VHDL
- **Embedded Software:** C
- **Interfaces:** ADC , HDMI , AXI-Lite, UART
- **Memory Architecture:** Simple Dual-Port BRAM , AXI-Lite Peripheral Registers
- **Development Tools:** Vivado , Vitis
## Oscilloscope Images
- **CH1** - Yellow
- **CH2** - Green
### Sine Waves
![Photo of Sine Waveforms](/photos/sine.jpeg)
### Sine and Sinc Waves
![Photo of Sine and Sinc Waveforms](/photos/sine_and_sinc.jpeg)
<!--## Images-->
<!--### HDMI Display & Waveform (! ! ! ADD ! ! !)-->
<!--![Photo of Display and Waveform](/photos/)-->
## Top-level + RTL Datapath and Control
![Top-level + Datapath and Control Arhcitecture](/photos/topLevel_and_datapathArchitecture.png)
## Finite State Machine
![FSM Architecture](/photos/fsmArchitecture.svg)
## AXI-Lite Interface
![AXI Interface Architecture](/photos/AXI_InterfaceArchitecture.svg)
