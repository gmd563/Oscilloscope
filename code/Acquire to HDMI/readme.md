# Acquire to HDMI
## Top-level Synthesis
&nbsp;&nbsp;&nbsp;&nbsp;[acquireToHDMI.vhd](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Top-level%20Synthesis/acquireToHDMI.vhd)
- Coordinates ADC sample acquisition, datapath processing, and HDMI display.

&nbsp;&nbsp;&nbsp;&nbsp;[acquireToHDMI_package.vhd](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Top-level%20Synthesis/acquireToHDMI_package.vhd)

![Top-level Architecture](/photos/acquireToHDMI.png)
## Datapath and Control
&nbsp;&nbsp;&nbsp;&nbsp;[acquireToHDMI_datapath.vhdl](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Datapath%20and%20Control/acquireToHDMI_datapath.vhdl)
- Stores and reads ADC samples in two simple dual-port BRAMs, one for each channel.
- Computes the signed value of the BRAM output using two's complement and converts signed ADC samples into pixel value.
- Compares the signed pixel value with the current vertical pixel position for waveform display in the Scope Face Generator.
- Detects trigger events for Channels 1 and 2 to assist Finite State Machine.

![Datapath and Control Arhcitecture](/photos/acquireToHdmi_datapath.png)
## Finite State Machine
&nbsp;&nbsp;&nbsp;&nbsp;[acquireToHDMI_fsm.vhdl](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Finite%20State%20Machine/acquireToHDMI_fsm.vhdl)
- Initializes the ADC through a reset and startup delays for hardware stability.
- Controls signal acquisition by coordinating the ADC-handshake, sample storage based on Datapath trigger detection, and the UART-configured sampling interval.
- Monitors BRAM buffer status and ends sample acquisition once the memory is full.

&nbsp;&nbsp;&nbsp;&nbsp;[Control Word Table](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Finite%20State%20Machine/CW%20Table.xlsx)

![FSM Architecture](/photos/fsmArchitecture.svg)
## HDMI Display
&nbsp;&nbsp;&nbsp;&nbsp;[videoSignalGenerator.vhdl](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/HDMI%20Display/videoSignalGenerator.vhdl)
- Determines the current pixel location and produces the horizontal and vertical sync signals for display rendering.

&nbsp;&nbsp;&nbsp;&nbsp;[scopeFace.vhd](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/HDMI%20Display/scopeFace.vhd)
- Assigns RGB values to a given pixel location provided by the Timing Video Generator
- Displays the oscilloscope grid, waveforms, and trigger markers.

&nbsp;&nbsp;&nbsp;&nbsp;[scopeToHDMI_package.vhd](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/HDMI%20Display/scopeToHdmi_package.vhd)
## ADC Sampler
&nbsp;&nbsp;&nbsp;&nbsp;[an7606.vhd](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/an7606.vhd)
