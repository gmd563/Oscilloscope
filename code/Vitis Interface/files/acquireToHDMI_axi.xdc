# data = BD
# OD = OS

# acquireToHDMI ===================================================
set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataN_ext_0[0]}]
set_property PACKAGE_PIN V20 [get_ports {tmdsDataP_ext_0[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataP_ext_0[0]}]

set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataN_ext_0[1]}]
set_property PACKAGE_PIN T20 [get_ports {tmdsDataP_ext_0[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataP_ext_0[1]}]

set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataN_ext_0[2]}]
set_property PACKAGE_PIN N20 [get_ports {tmdsDataP_ext_0[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsDataP_ext_0[2]}]

set_property IOSTANDARD TMDS_33 [get_ports tmdsClkN_ext_0]
set_property PACKAGE_PIN N18 [get_ports tmdsClkP_ext_0]
set_property IOSTANDARD TMDS_33 [get_ports tmdsClkP_ext_0]

set_property PACKAGE_PIN V16 [get_ports hdmiOen_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports hdmiOen_ext_0]
#==================================================================

# page 15 -> 5
#==================================================================

# clk =============================================================
set_property PACKAGE_PIN U18 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports clk]
#==================================================================


# resetn ==========================================================
set_property PACKAGE_PIN N15 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]
#==================================================================


# btn - ORANGE ====================================================
# PL KEY 4 - FORCE MODE
set_property PACKAGE_PIN R17 [get_ports {enb_ext_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {enb_ext_0}]

# PL KEY 3 - SINGLE TRIGGER
set_property PACKAGE_PIN T17 [get_ports {enb_ext_1}]
set_property IOSTANDARD LVCMOS33 [get_ports {enb_ext_1}]
# PL KEY 2
#set_property PACKAGE_PIN N16 [get_ports {sampleRateSelect}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sampleRateSelect}]

set_property PACKAGE_PIN F17 [get_ports pwmSignal_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports pwmSignal_ext_0]

set_property PACKAGE_PIN M19 [get_ports pwmSignal_ext_1]
set_property IOSTANDARD LVCMOS33 [get_ports pwmSignal_ext_1]
#==================================================================


# an7606convst - GREEN ============================================
set_property PACKAGE_PIN R14 [get_ports an7606convst_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports an7606convst_ext_0]
#==================================================================


# an7606cs - BLUE =================================================
set_property PACKAGE_PIN V15 [get_ports an7606cs_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports an7606cs_ext_0]
#==================================================================


# an7606rd - PINK =================================================
set_property PACKAGE_PIN Y17 [get_ports an7606rd_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports an7606rd_ext_0]
#==================================================================


# an7606reset - DARK BLUE =========================================
set_property PACKAGE_PIN Y16 [get_ports an7606reset_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports an7606reset_ext_0]
#==================================================================


# an7606busy - ORANGE =============================================
set_property PACKAGE_PIN W15 [get_ports an7606busy_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports an7606busy_ext_0]
#==================================================================


# reg0Magnitude[0] - BLUE =========================================
set_property PACKAGE_PIN M14 [get_ports ch1Trig_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports ch1Trig_ext_0]

set_property PACKAGE_PIN M15 [get_ports ch2Trig_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports ch2Trig_ext_0]

set_property PACKAGE_PIN K16 [get_ports conversionPlusReadoutTime_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports conversionPlusReadoutTime_ext_0]

set_property PACKAGE_PIN J16 [get_ports sampleTimerRollover_ext_0]
set_property IOSTANDARD LVCMOS33 [get_ports sampleTimerRollover_ext_0]
#==================================================================


# an7606od - PURPLE ===============================================
set_property PACKAGE_PIN W18 [get_ports an7606od_ext_0[0]]
set_property IOSTANDARD LVCMOS33 [get_ports an7606od_ext_0[0]]

set_property PACKAGE_PIN W19 [get_ports an7606od_ext_0[1]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606od_ext_0[1]]

set_property PACKAGE_PIN P14 [get_ports an7606od_ext_0[2]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606od_ext_0[2]]
#==================================================================


# an7606data - YELLOW =============================================
set_property PACKAGE_PIN U15 [get_ports an7606data_ext_0[0]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[0]]

set_property PACKAGE_PIN U14 [get_ports an7606data_ext_0[1]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[1]]

set_property PACKAGE_PIN P16 [get_ports an7606data_ext_0[2]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[2]]

set_property PACKAGE_PIN P15 [get_ports an7606data_ext_0[3]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[3]]

set_property PACKAGE_PIN U17 [get_ports an7606data_ext_0[4]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[4]]

set_property PACKAGE_PIN T16 [get_ports an7606data_ext_0[5]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[5]]

set_property PACKAGE_PIN V18 [get_ports an7606data_ext_0[6]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[6]]

set_property PACKAGE_PIN V17 [get_ports an7606data_ext_0[7]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[7]]

set_property PACKAGE_PIN T15 [get_ports an7606data_ext_0[8]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[8]]

set_property PACKAGE_PIN T14 [get_ports an7606data_ext_0[9]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[9]]

set_property PACKAGE_PIN V13 [get_ports an7606data_ext_0[10]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[10]]

set_property PACKAGE_PIN U13 [get_ports an7606data_ext_0[11]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[11]]

set_property PACKAGE_PIN W13 [get_ports an7606data_ext_0[12]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[12]]

set_property PACKAGE_PIN V12 [get_ports an7606data_ext_0[13]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[13]]

set_property PACKAGE_PIN U12 [get_ports an7606data_ext_0[14]] 
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[14]]

set_property PACKAGE_PIN T12 [get_ports an7606data_ext_0[15]]
set_property IOSTANDARD LVCMOS33 [get_ports an7606data_ext_0[15]]

