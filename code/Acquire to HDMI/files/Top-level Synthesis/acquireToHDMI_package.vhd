----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.scopeToHdmi_package.all;


package acquireToHDMI_package is


-- Clock period definitions
CONSTANT clk_period : time := 20 ns;			-- 50Mhz crystal input (XTL_IN).

--======================= STATE DECLARATIONS ==========================
type state_type is (RESET_STATE,
                    LONG_DELAY_STATE,
                    RESET_AD7606_STATE,
                    WAIT_STATE,
                    SET_STORE_FLAG_STATE,
                    CLEAR_STORE_FLAG_STATE,
                    BEGIN_CONV_STATE,
                    ASSERT_CONVST_STATE,
                    BUSY0_STATE,
                    BUSY1_STATE,
                    READ_CH1_LOW_STATE,
                    TRIG_CH1_STATE,
                    BRAM_CH1_STATE,
                    READ_CH1_HIGH_STATE,
                    RESET_SHORT_STATE,
                    READ_CH2_LOW_STATE,
                    TRIG_CH2_STATE,
                    BRAM_CH2_STATE,
                    READ_CH2_HIGH_STATE,
                    WAIT_SAMPLE_INT_STATE,
                    SET_FULL_FLAG_STATE);

--========================== CONTROL WORD =============================
CONSTANT CW_WIDTH : NATURAL := 22;
CONSTANT CONTROL_CW_WIDTH : NATURAL := 22; 

--constant VIDEO_WIDTH_IN_BITS: NATURAL := 11;

-----------------------------FLAGS
CONSTANT CLEAR_STORE_FLAG_CW_BIT_INDEX : NATURAL := 21;
CONSTANT SET_STORE_FLAG_CW_BIT_INDEX : NATURAL := 20;

-----------------------------CH WRITE
CONSTANT TRIG_CH2_WRITE_CW_BIT_INDEX : NATURAL := 19;
CONSTANT TRIG_CH1_WRITE_CW_BIT_INDEX : NATURAL := 18;

CONSTANT CONVR_PLUS_READOUT_CW_BIT_INDEX : NATURAL := 17;
CONSTANT SAMPLE_TMR_ROLLOVER_CW_BIT_INDEX : NATURAL := 16;

-----------------------------DATA STORAGE
CONSTANT DATA_STORE_CH2_WRITE_CW_BIT_INDEX : NATURAL := 15;
CONSTANT DATA_STORE_CH1_WRITE_CW_BIT_INDEX : NATURAL := 14;

-----------------------------AD7606
CONSTANT CONVST_CW_BIT_INDEX : NATURAL := 13;
CONSTANT RD_CW_BIT_INDEX : NATURAL := 12;
CONSTANT CS_CW_BIT_INDEX : NATURAL := 11;
CONSTANT RESET_AD7606_CW_BIT_INDEX : NATURAL := 10;

-----------------------------COUNTERS AND SELECT
CONSTANT DATA_STORE_COUNTER_CW_BIT_INDEX : NATURAL := 9; -- 9 TO 8
CONSTANT SAMPLE_COUNTER_CW_BIT_INDEX : NATURAL := 7; -- 7 TO 6
CONSTANT SAMPLE_RATE_SELECT_CW_BIT_INDEX : NATURAL := 5; -- 5 TO 4
CONSTANT LONG_COUNT_CW_BIT_INDEX : NATURAL := 3; -- 3 TO 2
CONSTANT SHORT_COUNT_CW_BIT_INDEX : NATURAL := 1; --1 TO 0

--========================== STATUS WORD =============================
CONSTANT SW_WIDTH : NATURAL := 10;
CONSTANT DATAPATH_SW_WIDTH : NATURAL := 7;

------------------------------------------------------------ SW INDEX
----------------------------- DATAPATH
CONSTANT STORE_FLAG_SW_BIT_INDEX: NATURAL := 0; --SR LATCH
CONSTANT FULL_FLAG_SW_BIT_INDEX: NATURAL := 1; -- STORE COUNTER COMPARE
CONSTANT SAMPLE_SW_BIT_INDEX: NATURAL := 2; -- SAMPLE COUNTER COMPARE
CONSTANT LONG_SW_BIT_INDEX: NATURAL := 3; -- LONG COUNTER COMPARE
CONSTANT SHORT_SW_BIT_INDEX: NATURAL := 4; -- SHORT COUNTER COMPARE
CONSTANT CH1_TRIGGER_SW_BIT_INDEX: NATURAL := 5; -- TRIGGER EVENT on CH1
CONSTANT CH2_TRIGGER_SW_BIT_INDEX: NATURAL := 6; -- TRIGGER EVENT on CH2

----------------------------- BTN PROCESS
CONSTANT FORCED_MODE_SW_BIT_INDEX : NATURAL := 7;
CONSTANT SINGLE_SW_BIT_INDEX: NATURAL := 8; -- SINGLE TRIGGER FOR FORCED MODE

----------------------------- AN7606
CONSTANT BUSY_SW_BIT_INDEX: NATURAL := 9;
--====================================================================

CONSTANT LONG_DELAY_50Mhz_CONST_WIDTH : NATURAL := 24;
CONSTANT LONG_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(LONG_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"00FFFF";

CONSTANT SHORT_DELAY_50Mhz_CONST_WIDTH : NATURAL := 8; 
CONSTANT SHORT_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"20";

--========================= SAMPLE RATES =============================
CONSTANT HIGHEST_RATE   : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(300, 32)); -- coulstons sample rate
CONSTANT HIGH_RATE      : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(600, 32));
CONSTANT LOWEST_RATE    : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(1200, 32));
CONSTANT LOW_RATE       : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(2400, 32));
--====================================================================

--CONSTANT SAMPLE_DELAY_50Mhz_CONST_WIDTH : NATURAL := 32; 
--CONSTANT SAMPLE_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := HIGHEST_RATE;

component acquireToHDMI_fsm is
    PORT(clk : in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         
         --state_debug : out STD_LOGIC_VECTOR(31 downto 0);
         
         sw: in STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
         cw: out STD_LOGIC_VECTOR (CW_WIDTH - 1 downto 0));
end component;

component acquireToHDMI_datapath is
    PORT(clk : in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         cw : in STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
         sw : out STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
         an7606data: in STD_LOGIC_VECTOR(15 downto 0);
         
         trigVolt16Sgn: in SIGNED(15 downto 0);
         triggerTimePixel: in STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
         ch1Data16bitSLV, ch2Data16bitSLV: out STD_LOGIC_VECTOR(15 downto 0);
         tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
         
         tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
         tmdsClkP : out STD_LOGIC;
         tmdsClkN : out STD_LOGIC;
         hdmiOen:    out STD_LOGIC;
         
         sampleRateSelect : in STD_LOGIC_VECTOR(1 downto 0)
         );
end component;

component acquireToHDMI is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   ch1Trig, ch2Trig: out STD_LOGIC;		   
		   conversionPlusReadoutTime: out STD_LOGIC;
		   sampleTimerRollover: out STD_LOGIC;
		   
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   
		   tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsClkP : out STD_LOGIC;
           tmdsClkN : out STD_LOGIC;
           hdmiOen:    out STD_LOGIC;
           
           MODE, SINGLE : in STD_LOGIC;	-- btn process replacements	   
           sampleRateSelect : in STD_LOGIC_VECTOR(1 downto 0);
           ch1Data16bitSLV, ch2Data16bitSLV : out STD_LOGIC_VECTOR(15 downto 0);
           trigVolt16Sgn : in STD_LOGIC_VECTOR(15 downto 0)
           );
end component;	

component an7606 is
    PORT ( clk : in  STD_LOGIC;
           an7606data: out STD_LOGIC_VECTOR(15 downto 0);
           an7606convst, an7606cs, an7606rd, an7606reset: in STD_LOGIC;
           an7606od: in STD_LOGIC_VECTOR(2 downto 0);
           an7606busy : out STD_LOGIC);
end component;

component CH_BRAM is
    PORT (clka : IN STD_LOGIC;
          ena : IN STD_LOGIC;
          wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
          addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
          dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          clkb : IN STD_LOGIC;
          enb : IN STD_LOGIC;
          addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
          doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end component;

end package;
