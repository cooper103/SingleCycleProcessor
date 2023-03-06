# SingleCycleProcessor

This project contains a verilog implementation of a single cycle ARM processor, using the Basys3 FPGA. Note that only a subset of the entire ISA is implemented.

A detailed functional description is given below:
SW0-SW15:
All 16 switches are utilized for various purposes. SW0 is a reset switch that resets the LEDs
when in Color Send mode. SW[3:1] have two purposes. Firstly, they are used to select the
number of bits to send to the LED strip, and thus the number of LEDs to light up, determined as
the binary value of the switches. They are also used to denote Automatic Color Cycle and Game
mode (3’b110 and 3’b111 respectively). When the device is in Color Send mode, SW[15:4]
denote the GRB bit patterns that will be sent to the LEDs. SW[15:12], SW[11:8], and SW[7:4]
correspond to the Green, Red, and Blue channels respectively.

JA1:J1:
The port JA1 is used for serial data transfer to the LEDs and should be connected to the DataIn
line on the LEDs.

BTNC:
BTNC is used at the “Go” signal for serial data transfer in Color Send mode. It is also used in
Game mode to receive input from the user as the LEDs are flashing. BTNC does not have any
functionality in Automatic Color Cycle mode.

LED0:
LED0 is used to denote a state in the SSStateMachine FSM. LED0 is assigned to be on when the
“Ready2Go” signal is 1, meaning that when LED0 is on, the device is ready for serial data
transfer.

Seven-Segment Display:
The seven-segment LED display is constantly driven as AN[3:0] = 4’b1110. This results in only
the rightmost display being driven and is sufficient for the design’s purposes. The seven-segment
LEDs will display the current score of Game mode, starting at 0 and incrementing to 7, at which
point the user has won the game.

