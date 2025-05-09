# FPGA LED Metronome

A real-time LED-based metronome implemented on the DE10-Standard FPGA using VHDL and SCOMP assembly. The system visually tracks beats per minute (BPM) through sequential LED blinks and brightness modulation via PWM.

## Features

- ⏱ **Tempo Control**: Adjustable BPM from 30 to 240 beats per minute using hardware switches.
- 💡 **Visual Feedback**: LEDs blink in a loop pattern synchronized with the set tempo.
- 🌕 **PWM Brightness**: LEDs smoothly fade in/out using pulse-width modulation for better visibility.
- 🧠 **SCOMP Integration**: Controlled via SCOMP processor using custom assembly instructions.
- 🧪 **Simulation & Debugging**: Validated functionality through ModelSim waveform simulation.

## Technologies Used

- VHDL (LED controller, PWM logic, clock divider)
- SCOMP Assembly (tempo logic, system interface)
- Quartus Prime (synthesis and hardware programming)
- ModelSim (behavioral simulation)

## How it Works

1. Clock divider reduces the 12 MHz system clock to match BPM timing.
2. PWM controls LED brightness for smooth visual transitions.
3. LEDs light up sequentially across the board at each beat.
4. BPM is set using slide switches; system updates in real-time.

## Demo
https://youtu.be/llGGj9W7zMs
