# Copyright (C) 2022  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: sscp.tcl
# Generated on: Sun Jan 22 09:07:15 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "sscp"]} {
		puts "Project sscp is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists sscp]} {
		project_open -revision SscpTop sscp
	} else {
		project_new -revision SscpTop sscp
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "11:36:01  JUNE 27, 2021"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
	set_global_assignment -name VHDL_FILE ../../src/Core/CoreTypes.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/Opcodes.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUCommands.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUStatus.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUShiftBlock.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUMulBlock.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUFBlock.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALUAddBlock.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AGandBHalu/ALU.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/Cycler.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/Decoder.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/AluControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/RegControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/PmaControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/DmaControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/IoaControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/IntControl.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/Sequncer.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/RegisterFile.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/ALU.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/PMA.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/DMA.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/IOA.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE ../../src/Core/CPU.vhd -library AvrCore
	set_global_assignment -name VHDL_FILE EmuPrint.vhd
	set_global_assignment -name VHDL_FILE EmuTest.vhd
	set_global_assignment -name VHDL_FILE EmuTrigger.vhd
	set_global_assignment -name VHDL_FILE Io.vhd
	set_global_assignment -name VHDL_FILE ProgramMemory.vhd
	set_global_assignment -name VHDL_FILE DataMemory.vhd
	set_global_assignment -name VHDL_FILE Memory.vhd
	set_global_assignment -name VHDL_FILE SscpTop.vhd
	set_global_assignment -name VHDL_FILE Bench.vhd
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 896
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 6
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name DEVICE 5CSEMA5F31C6
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (VHDL)"
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
