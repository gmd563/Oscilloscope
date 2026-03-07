# Acquire to HDMI
## Top-level Synthesis
[<ins>Top-level Synthesis Module</ins>]()
- Coordinates ADC sample acquisition, datapath processing, and HDMI display.

[<ins>Top-level Synthesis Package</ins>]()
### Datapath and Control
[<ins>Datapath and Control</ins>]()
- Stores and reads ADC samples in a set of two simple dual-port BRAMs, one for each channel.
- Calculates the 2s compliment of BRAM output and converts those values into pixel coordinates.
- Compares the 2s compliment pixel coordinate with the current pixel position to determine pixel display in the Scope Face Generator.
- Identifies trigger events for channels 1 and 2
### Finite State Machine
[<ins>Finite State Machine</ins>]()
- t

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
