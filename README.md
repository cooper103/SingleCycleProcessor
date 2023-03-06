# SingleCycleProcessor

This project contains a verilog implementation of a single cycle ARM processor, using the Basys3 FPGA. Note that only a subset of the entire ISA is implemented.

A detailed functional description of the implementation on the Basys3 is given below:

BtnC:
BtnC is used to simulate the ARM system clock, with each press stepping through an instruction.

SW0:
SW0 is utilized to reset the program counter when BtnC is pressed and SW0 is on.

SW1:
SW1 is utilized to display the machine code of the current instruction. When SW1 is high, the
machine code of the current instruction is displayed, and when SW1 is low, the display will show
the register specified by SW15-SW12.

SW15-SW12:
SW15-SW12 specifies which register will be displayed on the seven-segment displays. The
binary representation of the switches encodes the register to be displayed.

SW11:
Because the four displays can only display 4 hexadecimal values (16 bits), SW11 is used to
select between the upper and lower portions of the register being displayed. If SW11 is high, the
upper 16 bits are displayed, and if SW11 is low, the lower 16 bits are displayed.
Seven-Segment Displays:
The four seven-segment displays each display a hexadecimal value, with a total quantity of
16-bits being represented.
