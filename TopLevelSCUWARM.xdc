## TopLevelSCUWARM.xdc
#
#  Design constraints for EE 4490 Fall 2017 SingleCycle ARM processor in-situ example.
#  Derived from the Basys3_Master.xdc provided by Digilent:
#  (a) Only the desired lines retained.
#  (b) Signal names edited to match interface parameter of top level Verilog source file.
#
## Clock signal (BEWARE:  Can't change period here, fixed at 100 MHz, need to use an MMC Tile)
#  In this project, "clk" is used to drive the multiplexed seven segment displays on the 
#  Basys3 board.  A manual "PushButton" is used to actually drive the ARM processor.
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
## For BASYS3 with Vivado 2016.2 and above, the following lines remove an implementation warning
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design] 

## Pushbutton
# BTNC (See silkscreen on BASYS3 board, center pushbutton)
# This is used as the "clock" for the ARM model, allowing the user to
# move the machine through each instruction in a stepwise fashion.
set_property PACKAGE_PIN U18 [get_ports {PushButton}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {PushButton}]
# Following line needed in Vivado 2016.2 and newer, ignore the warning regarding "at least one object"
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PushButton_IBUF]

## Switches
# SW0 (See silkscreen on BASYS3 board, rightmost switch)
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
# SW15-12 (leftmost, provide debug identification of register to be viewed)
set_property PACKAGE_PIN R2  [get_ports {theReg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {theReg[3]}]
set_property PACKAGE_PIN T1  [get_ports {theReg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {theReg[2]}]
set_property PACKAGE_PIN U1  [get_ports {theReg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {theReg[1]}]
set_property PACKAGE_PIN W2  [get_ports {theReg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {theReg[0]}]
# SW11 (describes which portion of the 32-bit reg to display (low is bottom))
set_property PACKAGE_PIN R3  [get_ports {TopHalf}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {TopHalf}]
# SW1 (switch to view machine code of current instruction)
set_property PACKAGE_PIN V16  [get_ports {iCode}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {iCode}]

## Seven Segment Display Segment Drives (active low, indexes a-0,...,g-6)
set_property PACKAGE_PIN W7 [get_ports {sevenSegmentsa2g[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[0]}]
set_property PACKAGE_PIN W6 [get_ports {sevenSegmentsa2g[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[1]}]
set_property PACKAGE_PIN U8 [get_ports {sevenSegmentsa2g[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[2]}]
set_property PACKAGE_PIN V8 [get_ports {sevenSegmentsa2g[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[3]}]
set_property PACKAGE_PIN U5 [get_ports {sevenSegmentsa2g[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[4]}]
set_property PACKAGE_PIN V5 [get_ports {sevenSegmentsa2g[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[5]}]
set_property PACKAGE_PIN U7 [get_ports {sevenSegmentsa2g[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sevenSegmentsa2g[6]}]

## Seven Segment Display Anode Drives (active low)
set_property PACKAGE_PIN U2 [get_ports {anodeDrives[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeDrives[0]}]
set_property PACKAGE_PIN U4 [get_ports {anodeDrives[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeDrives[1]}]
set_property PACKAGE_PIN V4 [get_ports {anodeDrives[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeDrives[2]}]
set_property PACKAGE_PIN W4 [get_ports {anodeDrives[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeDrives[3]}]

## End of TopLevelSCUWARM.xdc
