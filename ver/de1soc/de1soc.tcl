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
# File: de1soc.tcl
# Generated on: Tue Jan 31 11:33:06 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "de1soc"]} {
		puts "Project de1soc is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists de1soc]} {
		project_open -revision de1soc de1soc
	} else {
		project_new -revision de1soc de1soc
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CSEMA5F31C6
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.1STD.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "09:05:31  JANUARY 22, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (VHDL)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 896
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 6
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
	set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name VHDL_FILE ../../src/Core/CoreTypes.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/Opcodes.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/Cycler.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/Decoder.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/AluControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/RegControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/PmaControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/DmaControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/IoaControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/IntControl.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/Sequncer.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/RegisterFile.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/AluAddBlock.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/AluLogicBlock.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/AluShiftBlock.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/AluMulBlock.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/ALU.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/PMA.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/DMA.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/IOA.vhd
	set_global_assignment -name VHDL_FILE ../../src/Core/CPU.vhd
	set_global_assignment -name SDC_FILE de1soc.sdc
	set_location_assignment PIN_AF14 -to CLOCK_50
	set_location_assignment PIN_V16 -to LEDR[0]
	set_location_assignment PIN_W16 -to LEDR[1]
	set_location_assignment PIN_V17 -to LEDR[2]
	set_location_assignment PIN_V18 -to LEDR[3]
	set_location_assignment PIN_W17 -to LEDR[4]
	set_location_assignment PIN_W19 -to LEDR[5]
	set_location_assignment PIN_Y19 -to LEDR[6]
	set_location_assignment PIN_W20 -to LEDR[7]
	set_location_assignment PIN_W21 -to LEDR[8]
	set_location_assignment PIN_Y21 -to LEDR[9]
	set_location_assignment PIN_AB12 -to SW[0]
	set_location_assignment PIN_AC12 -to SW[1]
	set_location_assignment PIN_AF9 -to SW[2]
	set_location_assignment PIN_AF10 -to SW[3]
	set_location_assignment PIN_AD11 -to SW[4]
	set_location_assignment PIN_AD12 -to SW[5]
	set_location_assignment PIN_AE11 -to SW[6]
	set_location_assignment PIN_AC9 -to SW[7]
	set_location_assignment PIN_AD10 -to SW[8]
	set_location_assignment PIN_AE12 -to SW[9]
	set_location_assignment PIN_AE26 -to HEX0_N[0]
	set_location_assignment PIN_AE27 -to HEX0_N[1]
	set_location_assignment PIN_AE28 -to HEX0_N[2]
	set_location_assignment PIN_AG27 -to HEX0_N[3]
	set_location_assignment PIN_AF28 -to HEX0_N[4]
	set_location_assignment PIN_AG28 -to HEX0_N[5]
	set_location_assignment PIN_AH28 -to HEX0_N[6]
	set_location_assignment PIN_AJ29 -to HEX1_N[0]
	set_location_assignment PIN_AH29 -to HEX1_N[1]
	set_location_assignment PIN_AH30 -to HEX1_N[2]
	set_location_assignment PIN_AG30 -to HEX1_N[3]
	set_location_assignment PIN_AF29 -to HEX1_N[4]
	set_location_assignment PIN_AF30 -to HEX1_N[5]
	set_location_assignment PIN_AD27 -to HEX1_N[6]
	set_location_assignment PIN_AB23 -to HEX2_N[0]
	set_location_assignment PIN_AE29 -to HEX2_N[1]
	set_location_assignment PIN_AD29 -to HEX2_N[2]
	set_location_assignment PIN_AC28 -to HEX2_N[3]
	set_location_assignment PIN_AD30 -to HEX2_N[4]
	set_location_assignment PIN_AC29 -to HEX2_N[5]
	set_location_assignment PIN_AC30 -to HEX2_N[6]
	set_location_assignment PIN_AD26 -to HEX3_N[0]
	set_location_assignment PIN_AC27 -to HEX3_N[1]
	set_location_assignment PIN_AD25 -to HEX3_N[2]
	set_location_assignment PIN_AC25 -to HEX3_N[3]
	set_location_assignment PIN_AB28 -to HEX3_N[4]
	set_location_assignment PIN_AB25 -to HEX3_N[5]
	set_location_assignment PIN_AB22 -to HEX3_N[6]
	set_location_assignment PIN_AA24 -to HEX4_N[0]
	set_location_assignment PIN_Y23 -to HEX4_N[1]
	set_location_assignment PIN_Y24 -to HEX4_N[2]
	set_location_assignment PIN_W22 -to HEX4_N[3]
	set_location_assignment PIN_W24 -to HEX4_N[4]
	set_location_assignment PIN_V23 -to HEX4_N[5]
	set_location_assignment PIN_W25 -to HEX4_N[6]
	set_location_assignment PIN_V25 -to HEX5_N[0]
	set_location_assignment PIN_AA28 -to HEX5_N[1]
	set_location_assignment PIN_Y27 -to HEX5_N[2]
	set_location_assignment PIN_AB27 -to HEX5_N[3]
	set_location_assignment PIN_AB26 -to HEX5_N[4]
	set_location_assignment PIN_AA26 -to HEX5_N[5]
	set_location_assignment PIN_AA25 -to HEX5_N[6]
	set_location_assignment PIN_AA14 -to KEY_N[0]
	set_location_assignment PIN_AA15 -to KEY_N[1]
	set_location_assignment PIN_W15 -to KEY_N[2]
	set_location_assignment PIN_Y16 -to KEY_N[3]
	set_location_assignment PIN_B15 -to HPS_CONV_USB_N
	set_location_assignment PIN_F26 -to HPS_DDR3_ADDR[0]
	set_location_assignment PIN_G30 -to HPS_DDR3_ADDR[1]
	set_location_assignment PIN_F28 -to HPS_DDR3_ADDR[2]
	set_location_assignment PIN_F30 -to HPS_DDR3_ADDR[3]
	set_location_assignment PIN_J25 -to HPS_DDR3_ADDR[4]
	set_location_assignment PIN_J27 -to HPS_DDR3_ADDR[5]
	set_location_assignment PIN_F29 -to HPS_DDR3_ADDR[6]
	set_location_assignment PIN_E28 -to HPS_DDR3_ADDR[7]
	set_location_assignment PIN_H27 -to HPS_DDR3_ADDR[8]
	set_location_assignment PIN_G26 -to HPS_DDR3_ADDR[9]
	set_location_assignment PIN_D29 -to HPS_DDR3_ADDR[10]
	set_location_assignment PIN_C30 -to HPS_DDR3_ADDR[11]
	set_location_assignment PIN_B30 -to HPS_DDR3_ADDR[12]
	set_location_assignment PIN_C29 -to HPS_DDR3_ADDR[13]
	set_location_assignment PIN_H25 -to HPS_DDR3_ADDR[14]
	set_location_assignment PIN_E29 -to HPS_DDR3_BA[0]
	set_location_assignment PIN_J24 -to HPS_DDR3_BA[1]
	set_location_assignment PIN_J23 -to HPS_DDR3_BA[2]
	set_location_assignment PIN_K28 -to HPS_DDR3_DM[0]
	set_location_assignment PIN_M28 -to HPS_DDR3_DM[1]
	set_location_assignment PIN_R28 -to HPS_DDR3_DM[2]
	set_location_assignment PIN_W30 -to HPS_DDR3_DM[3]
	set_location_assignment PIN_K23 -to HPS_DDR3_DQ[0]
	set_location_assignment PIN_K22 -to HPS_DDR3_DQ[1]
	set_location_assignment PIN_H30 -to HPS_DDR3_DQ[2]
	set_location_assignment PIN_G28 -to HPS_DDR3_DQ[3]
	set_location_assignment PIN_L25 -to HPS_DDR3_DQ[4]
	set_location_assignment PIN_L24 -to HPS_DDR3_DQ[5]
	set_location_assignment PIN_J30 -to HPS_DDR3_DQ[6]
	set_location_assignment PIN_J29 -to HPS_DDR3_DQ[7]
	set_location_assignment PIN_K26 -to HPS_DDR3_DQ[8]
	set_location_assignment PIN_L26 -to HPS_DDR3_DQ[9]
	set_location_assignment PIN_K29 -to HPS_DDR3_DQ[10]
	set_location_assignment PIN_K27 -to HPS_DDR3_DQ[11]
	set_location_assignment PIN_M26 -to HPS_DDR3_DQ[12]
	set_location_assignment PIN_M27 -to HPS_DDR3_DQ[13]
	set_location_assignment PIN_L28 -to HPS_DDR3_DQ[14]
	set_location_assignment PIN_M30 -to HPS_DDR3_DQ[15]
	set_location_assignment PIN_U26 -to HPS_DDR3_DQ[16]
	set_location_assignment PIN_T26 -to HPS_DDR3_DQ[17]
	set_location_assignment PIN_N29 -to HPS_DDR3_DQ[18]
	set_location_assignment PIN_N28 -to HPS_DDR3_DQ[19]
	set_location_assignment PIN_P26 -to HPS_DDR3_DQ[20]
	set_location_assignment PIN_P27 -to HPS_DDR3_DQ[21]
	set_location_assignment PIN_N27 -to HPS_DDR3_DQ[22]
	set_location_assignment PIN_R29 -to HPS_DDR3_DQ[23]
	set_location_assignment PIN_P24 -to HPS_DDR3_DQ[24]
	set_location_assignment PIN_P25 -to HPS_DDR3_DQ[25]
	set_location_assignment PIN_T29 -to HPS_DDR3_DQ[26]
	set_location_assignment PIN_T28 -to HPS_DDR3_DQ[27]
	set_location_assignment PIN_R27 -to HPS_DDR3_DQ[28]
	set_location_assignment PIN_R26 -to HPS_DDR3_DQ[29]
	set_location_assignment PIN_V30 -to HPS_DDR3_DQ[30]
	set_location_assignment PIN_W29 -to HPS_DDR3_DQ[31]
	set_location_assignment PIN_E27 -to HPS_DDR3_CAS_N
	set_location_assignment PIN_L29 -to HPS_DDR3_CKE
	set_location_assignment PIN_H24 -to HPS_DDR3_CS_N
	set_location_assignment PIN_H28 -to HPS_DDR3_ODT
	set_location_assignment PIN_D30 -to HPS_DDR3_RAS_N
	set_location_assignment PIN_C28 -to HPS_DDR3_WE_N
	set_location_assignment PIN_P30 -to HPS_DDR3_RESET_N
	set_location_assignment PIN_D27 -to HPS_DDR3_RZQ
	set_location_assignment PIN_N18 -to HPS_DDR3_DQS_P[0]
	set_location_assignment PIN_M19 -to HPS_DDR3_DQS_N[0]
	set_location_assignment PIN_N25 -to HPS_DDR3_DQS_P[1]
	set_location_assignment PIN_N24 -to HPS_DDR3_DQS_N[1]
	set_location_assignment PIN_R19 -to HPS_DDR3_DQS_P[2]
	set_location_assignment PIN_R18 -to HPS_DDR3_DQS_N[2]
	set_location_assignment PIN_R22 -to HPS_DDR3_DQS_P[3]
	set_location_assignment PIN_R21 -to HPS_DDR3_DQS_N[3]
	set_location_assignment PIN_M23 -to HPS_DDR3_CK_P
	set_location_assignment PIN_L23 -to HPS_DDR3_CK_N
	set_location_assignment PIN_H19 -to HPS_ENET_GTX_CLK
	set_location_assignment PIN_C19 -to HPS_ENET_INT_N
	set_location_assignment PIN_B21 -to HPS_ENET_MDC
	set_location_assignment PIN_E21 -to HPS_ENET_MDIO
	set_location_assignment PIN_G20 -to HPS_ENET_RX_CLK
	set_location_assignment PIN_A21 -to HPS_ENET_RX_DATA[0]
	set_location_assignment PIN_B20 -to HPS_ENET_RX_DATA[1]
	set_location_assignment PIN_B18 -to HPS_ENET_RX_DATA[2]
	set_location_assignment PIN_D21 -to HPS_ENET_RX_DATA[3]
	set_location_assignment PIN_K17 -to HPS_ENET_RX_DV
	set_location_assignment PIN_F20 -to HPS_ENET_TX_DATA[0]
	set_location_assignment PIN_J19 -to HPS_ENET_TX_DATA[1]
	set_location_assignment PIN_F21 -to HPS_ENET_TX_DATA[2]
	set_location_assignment PIN_F19 -to HPS_ENET_TX_DATA[3]
	set_location_assignment PIN_A20 -to HPS_ENET_TX_EN
	set_location_assignment PIN_C20 -to HPS_FLASH_DATA[0]
	set_location_assignment PIN_H18 -to HPS_FLASH_DATA[1]
	set_location_assignment PIN_A19 -to HPS_FLASH_DATA[2]
	set_location_assignment PIN_E19 -to HPS_FLASH_DATA[3]
	set_location_assignment PIN_D19 -to HPS_FLASH_DCLK
	set_location_assignment PIN_A18 -to HPS_FLASH_NCSO
	set_location_assignment PIN_B22 -to HPS_GSENSOR_INT
	set_location_assignment PIN_E23 -to HPS_I2C1_SCLK
	set_location_assignment PIN_C24 -to HPS_I2C1_SDAT
	set_location_assignment PIN_H23 -to HPS_I2C2_SCLK
	set_location_assignment PIN_A25 -to HPS_I2C2_SDAT
	set_location_assignment PIN_B26 -to HPS_I2C_CONTROL
	set_location_assignment PIN_G21 -to HPS_KEY_N
	set_location_assignment PIN_A24 -to HPS_LED
	set_location_assignment PIN_H17 -to HPS_LTC_GPIO
	set_location_assignment PIN_A16 -to HPS_SD_CLK
	set_location_assignment PIN_F18 -to HPS_SD_CMD
	set_location_assignment PIN_G18 -to HPS_SD_DATA[0]
	set_location_assignment PIN_C17 -to HPS_SD_DATA[1]
	set_location_assignment PIN_D17 -to HPS_SD_DATA[2]
	set_location_assignment PIN_B16 -to HPS_SD_DATA[3]
	set_location_assignment PIN_C23 -to HPS_SPIM_CLK
	set_location_assignment PIN_E24 -to HPS_SPIM_MISO
	set_location_assignment PIN_D22 -to HPS_SPIM_MOSI
	set_location_assignment PIN_D24 -to HPS_SPIM_SS
	set_location_assignment PIN_B25 -to HPS_UART_RX
	set_location_assignment PIN_C25 -to HPS_UART_TX
	set_location_assignment PIN_N16 -to HPS_USB_CLKOUT
	set_location_assignment PIN_E16 -to HPS_USB_DATA[0]
	set_location_assignment PIN_G16 -to HPS_USB_DATA[1]
	set_location_assignment PIN_D16 -to HPS_USB_DATA[2]
	set_location_assignment PIN_D14 -to HPS_USB_DATA[3]
	set_location_assignment PIN_A15 -to HPS_USB_DATA[4]
	set_location_assignment PIN_C14 -to HPS_USB_DATA[5]
	set_location_assignment PIN_D15 -to HPS_USB_DATA[6]
	set_location_assignment PIN_M17 -to HPS_USB_DATA[7]
	set_location_assignment PIN_E14 -to HPS_USB_DIR
	set_location_assignment PIN_A14 -to HPS_USB_NXT
	set_location_assignment PIN_C15 -to HPS_USB_STP
	set_location_assignment PIN_AC18 -to GPIO_0[0]
	set_location_assignment PIN_AH18 -to GPIO_0[10]
	set_location_assignment PIN_AH17 -to GPIO_0[11]
	set_location_assignment PIN_AG16 -to GPIO_0[12]
	set_location_assignment PIN_AE16 -to GPIO_0[13]
	set_location_assignment PIN_AF16 -to GPIO_0[14]
	set_location_assignment PIN_AG17 -to GPIO_0[15]
	set_location_assignment PIN_AA18 -to GPIO_0[16]
	set_location_assignment PIN_AA19 -to GPIO_0[17]
	set_location_assignment PIN_AE17 -to GPIO_0[18]
	set_location_assignment PIN_AC20 -to GPIO_0[19]
	set_location_assignment PIN_Y17 -to GPIO_0[1]
	set_location_assignment PIN_AH19 -to GPIO_0[20]
	set_location_assignment PIN_AJ20 -to GPIO_0[21]
	set_location_assignment PIN_AH20 -to GPIO_0[22]
	set_location_assignment PIN_AK21 -to GPIO_0[23]
	set_location_assignment PIN_AD19 -to GPIO_0[24]
	set_location_assignment PIN_AD20 -to GPIO_0[25]
	set_location_assignment PIN_AE18 -to GPIO_0[26]
	set_location_assignment PIN_AE19 -to GPIO_0[27]
	set_location_assignment PIN_AF20 -to GPIO_0[28]
	set_location_assignment PIN_AF21 -to GPIO_0[29]
	set_location_assignment PIN_AD17 -to GPIO_0[2]
	set_location_assignment PIN_AF19 -to GPIO_0[30]
	set_location_assignment PIN_AG21 -to GPIO_0[31]
	set_location_assignment PIN_AF18 -to GPIO_0[32]
	set_location_assignment PIN_AG20 -to GPIO_0[33]
	set_location_assignment PIN_AG18 -to GPIO_0[34]
	set_location_assignment PIN_AJ21 -to GPIO_0[35]
	set_location_assignment PIN_Y18 -to GPIO_0[3]
	set_location_assignment PIN_AK16 -to GPIO_0[4]
	set_location_assignment PIN_AK18 -to GPIO_0[5]
	set_location_assignment PIN_AK19 -to GPIO_0[6]
	set_location_assignment PIN_AJ19 -to GPIO_0[7]
	set_location_assignment PIN_AJ17 -to GPIO_0[8]
	set_location_assignment PIN_AJ16 -to GPIO_0[9]
	set_location_assignment PIN_AB17 -to GPIO_1[0]
	set_location_assignment PIN_AG26 -to GPIO_1[10]
	set_location_assignment PIN_AH24 -to GPIO_1[11]
	set_location_assignment PIN_AH27 -to GPIO_1[12]
	set_location_assignment PIN_AJ27 -to GPIO_1[13]
	set_location_assignment PIN_AK29 -to GPIO_1[14]
	set_location_assignment PIN_AK28 -to GPIO_1[15]
	set_location_assignment PIN_AK27 -to GPIO_1[16]
	set_location_assignment PIN_AJ26 -to GPIO_1[17]
	set_location_assignment PIN_AK26 -to GPIO_1[18]
	set_location_assignment PIN_AH25 -to GPIO_1[19]
	set_location_assignment PIN_AA21 -to GPIO_1[1]
	set_location_assignment PIN_AJ25 -to GPIO_1[20]
	set_location_assignment PIN_AJ24 -to GPIO_1[21]
	set_location_assignment PIN_AK24 -to GPIO_1[22]
	set_location_assignment PIN_AG23 -to GPIO_1[23]
	set_location_assignment PIN_AK23 -to GPIO_1[24]
	set_location_assignment PIN_AH23 -to GPIO_1[25]
	set_location_assignment PIN_AK22 -to GPIO_1[26]
	set_location_assignment PIN_AJ22 -to GPIO_1[27]
	set_location_assignment PIN_AH22 -to GPIO_1[28]
	set_location_assignment PIN_AG22 -to GPIO_1[29]
	set_location_assignment PIN_AB21 -to GPIO_1[2]
	set_location_assignment PIN_AF24 -to GPIO_1[30]
	set_location_assignment PIN_AF23 -to GPIO_1[31]
	set_location_assignment PIN_AE22 -to GPIO_1[32]
	set_location_assignment PIN_AD21 -to GPIO_1[33]
	set_location_assignment PIN_AA20 -to GPIO_1[34]
	set_location_assignment PIN_AC22 -to GPIO_1[35]
	set_location_assignment PIN_AC23 -to GPIO_1[3]
	set_location_assignment PIN_AD24 -to GPIO_1[4]
	set_location_assignment PIN_AE23 -to GPIO_1[5]
	set_location_assignment PIN_AE24 -to GPIO_1[6]
	set_location_assignment PIN_AF25 -to GPIO_1[7]
	set_location_assignment PIN_AF26 -to GPIO_1[8]
	set_location_assignment PIN_AG25 -to GPIO_1[9]
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[10] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[11] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[12] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[13] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[14] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[4] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[5] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[6] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[7] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[8] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[9] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CAS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CKE -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ODT -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_RAS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_WE_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_RESET_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_CONV_USB_N
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[0]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[1]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[2]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[4]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[5]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[6]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[7]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[8]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[9]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[10]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[11]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[12]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[13]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[14]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[0]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[1]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[2]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CAS_N
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CKE
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_CK_N
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_CK_P
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CS_N
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[0]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[1]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[2]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[0]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[1]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[2]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[4]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[5]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[6]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[7]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[8]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[9]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[10]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[11]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[12]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[13]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[14]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[15]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[16]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[17]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[18]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[19]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[20]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[21]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[22]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[23]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[24]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[25]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[26]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[27]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[28]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[29]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[30]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[31]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[0]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[1]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[2]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[3]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[0]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[1]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[2]
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[3]
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ODT
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RAS_N
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RESET_N
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RZQ
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_WE_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_GTX_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_INT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDC
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDIO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DV
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_EN
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_NCSO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_GSENSOR_INT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SDAT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C2_SCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C2_SDAT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C_CONTROL
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_LED
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CMD
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_MISO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_MOSI
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_SS
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_RX
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_TX
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_CLKOUT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DIR
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_NXT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_STP
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[16]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[17]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[18]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[19]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[20]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[21]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[22]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[23]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[24]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[25]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[26]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[27]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[28]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[29]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[30]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[31]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[32]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[33]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[34]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0[35]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[16]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[17]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[18]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[19]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[20]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[21]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[22]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[23]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[24]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[25]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[26]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[27]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[28]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[29]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[30]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[31]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[32]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[33]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[34]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1[35]
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name D5_DELAY 2 -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name D5_DELAY 2 -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[10] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[11] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[12] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[13] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[14] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[3] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[4] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[5] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[6] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[7] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[8] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[9] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CAS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CKE -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ODT -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_RAS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_WE_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_RESET_N -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[3] -tag __hps_sdram_p0
	set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to soc|hps_0|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO_1
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY_N[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY_N[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY_N[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY_N[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to altera_reserved_tck
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to altera_reserved_tdi
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to altera_reserved_tdo
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to altera_reserved_tms
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_KEY_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_LTC_GPIO
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
	set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to soc|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0
	set_location_assignment PIN_AA16 -to CLOCK2_50
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK2_50
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
