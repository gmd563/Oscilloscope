# Acquire to HDMI
## Top-level Synthesis
[<ins>Top-level Synthesis Module</ins>]()
- Coordinates ADC sample acquisition, datapath processing, and HDMI display.

[<ins>text</ins>]()
### Datapath and Control
[<ins>text</ins>]()
- Stores and reads ADC samples in a set of two simple dual-port BRAMs, one for each channel.
- . 
### Finite State Machine
[<ins>text</ins>]()
## HDMI Display
[<ins>Video Timing Generator</ins>]()
- Determines the current pixel location and produces the horizontal and verticle sync signals for display rendering.

[<ins>Scope Face Generator</ins>]()
- Assigns RGB values to a given pixel location provided by the Timing Video Generator
- Displays the oscilloscope grid, waveforms, and trigger markers.

[<ins>Scope Face Generator Package</ins>]()
## ADC Sampler
[<ins>text</ins>]()
