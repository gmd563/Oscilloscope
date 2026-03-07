--//////////Top Level for signal Acquisition /////////////////////////////--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.acquireToHDMI_package.all;					-- include your library here with added components ac97, ac97cmd
use work.basicBuildingBlocks_package.all;					-- include your library here with added components ac97, ac97cmd
use work.scopeToHDMI_package.all;


use IEEE.NUMERIC_STD.ALL;


entity acquireToHDMI is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
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
           hdmiOen:   out STD_LOGIC;
           
           MODE, SINGLE : in STD_LOGIC;	-- btn process replacements	   -- SMALL SIGNALS IN
           sampleRateSelect : in STD_LOGIC_VECTOR(1 downto 0); -- SMALL SIGNALS IN
           ch1Data16bitSLV, ch2Data16bitSLV : out STD_LOGIC_VECTOR(15 downto 0); -- LARGE SIGNALS OUT
           trigVolt16Sgn : in STD_LOGIC_VECTOR(15 downto 0)
		   );		   
end acquireToHDMI;

architecture behavior of acquireToHDMI is
    
    signal cw: STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0); -- 21 downto 0
    signal sw: STD_LOGIC_VECTOR(SW_WIDTH -1 downto 0); -- 9 downto 0
    signal forcedMode: STD_LOGIC;
    signal btnStatus : STD_LOGIC;
    signal btnPrev, btnPress : STD_LOGIC;
    signal btn0 : STD_LOGIC;
    
        	
begin

    conversionPlusReadoutTime <= cw(CONVR_PLUS_READOUT_CW_BIT_INDEX);
    sampleTimerRollover <= cw(SAMPLE_TMR_ROLLOVER_CW_BIT_INDEX);
    
    ch1Trig <= sw(CH1_TRIGGER_SW_BIT_INDEX);
    ch2Trig <= sw(CH2_TRIGGER_SW_BIT_INDEX);
    
    an7606convst <= cw(CONVST_CW_BIT_INDEX);    
    an7606cs <= cw(CS_CW_BIT_INDEX); 
    an7606rd <= cw(RD_CW_BIT_INDEX); 
    an7606reset <= cw(RESET_AD7606_CW_BIT_INDEX);
    sw(BUSY_SW_BIT_INDEX) <= an7606busy;
    an7606od <= "000"; 

 	datapath_inst: acquireToHDMI_datapath 
 	    PORT MAP ( clk => clk,
 	               resetn => resetn,
 	               cw => cw,
 	               sw => sw(DATAPATH_SW_WIDTH-1 downto 0), -- 7 downto 0
 	               an7606data => an7606data,
 	               trigVolt16Sgn => SIGNED(trigVolt16Sgn),
 	               triggerTimePixel => STD_LOGIC_VECTOR(TO_UNSIGNED(640, VIDEO_WIDTH_IN_BITS)),
 	               ch1Data16bitSLV => ch1Data16bitSLV,
 	               ch2Data16bitSLV => ch2Data16bitSLV,
 	               
 	               tmdsDataP => tmdsDataP,
 	               tmdsDataN => tmdsDataN,
 	               tmdsClkP => tmdsClkP,
 	               tmdsClkN => tmdsClkN,
 	               hdmiOen => hdmiOen,
 	               
 	               sampleRateSelect => sampleRateSelect
 	               );
                
	control_inst: acquireToHDMI_fsm 
	   PORT MAP ( 
            clk => clk,
            resetn => resetn,
            sw => sw,
            cw => cw);
                
    --========================= BTN PROCESS ============================
    -- PL KEY3 | toggle b/w FORCED & TRIGGER | btn(0)
    -- PL KEY4 | single key                  | btn(1)
    -- PL KEY2 |                             | btn(2)
    sw(SINGLE_SW_BIT_INDEX) <= SINGLE;
    sw(FORCED_MODE_SW_BIT_INDEX) <= MODE;

end behavior;
