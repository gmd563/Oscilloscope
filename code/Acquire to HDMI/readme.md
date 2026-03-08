# Acquire to HDMI
## Top-level Synthesis
[<ins>Top-level Synthesis Module</ins>]()
- Coordinates ADC sample acquisition, datapath processing, and HDMI display.

[<ins>Top-level Synthesis Package</ins>]()
### Datapath and Control
[<ins>Datapath and Control</ins>](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Datapath%20and%20Control/acquireToHDMI_datapath.vhdl)
- Stores and reads ADC samples in two simple dual-port BRAMs, one for each channel.
- Computes the signed value of the BRAM output using two's compliment and converts signed ADC samples into pixel value.
- Compares the signed pixel value with the current vertical pixel position for waveform display in the Scope Face Generator.
- Detects trigger events for Channels 1 and 2 to assist Finite State Machine.
### Finite State Machine
[<ins>Finite State Machine</ins>](https://github.com/gmd563/Oscilloscope/blob/main/code/Acquire%20to%20HDMI/files/Finite%20State%20Machine/acquireToHDMI_fsm.vhdl)
- Initializes the ADC through a reset and startup delays for hardware stability.
- Controls signal acquisition by coordinating the ADC-handshake, sample storage based on Datapath trigger detection, and the UART-configured sampling interval.
- Monitors BRAM buffer status and ends sample aquisition once the memory is full.

[<ins>Control Word Table</ins>]()
## HDMI Display
[<ins>Video Timing Generator</ins>]()
- Determines the current pixel location and produces the horizontal and verticle sync signals for display rendering.

[<ins>Scope Face Generator</ins>]()
- Assigns RGB values to a given pixel location provided by the Timing Video Generator
- Displays the oscilloscope grid, waveforms, and trigger markers.

[<ins>Scope Face Generator Package</ins>]()
## ADC Sampler
[<ins>text</ins>]()
