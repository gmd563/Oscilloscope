 --------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- Modified:	Sept 2022
-- File:	acquireToHDMI_Datapath.vhdl
-- HW:		Lab 3
-- Crs:		ECE 383 and EENG 484
--
-- Purp: The complete datapath for the audio O'scope
--
-- Documentation:	No help
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
--======================== 2sToPixel Logic ===========================
-- y = (-500 * doutb / 2^16)x + 350 
--> -500 = screen height = (100 - 600) 
--> 350 = center of screen height 
--> doutb = CH1outBRAM, CH2outBRAM, and triggerVolt
--====================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.acquireToHDMI_Package.all;			
use work.basicBuildingBlocks_package.all;		
use work.scopeToHdmi_package.all;
use work.acquireToHDMI_package.all;

entity acquireToHDMI_datapath is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   cw : in STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
		   sw : out STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
		   --sw : out STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);

           trigVolt16Sgn: in SIGNED(15 downto 0);
		   triggerTimePixel: in STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
		   --triggerTimePixel: in STD_LOGIC_VECTOR(9 downto 0);
		   
		   tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsClkP : out STD_LOGIC;
           tmdsClkN : out STD_LOGIC;
           hdmiOen:    out STD_LOGIC;
           
           sampleRateSelect : in STD_LOGIC_VECTOR(1 downto 0);
           ch1Data16bitSLV, ch2Data16bitSLV: out STD_LOGIC_VECTOR(15 downto 0)
		   );
end acquireToHDMI_datapath;
     
architecture behavior of acquireToHDMI_datapath is

    signal storeIntoBramFlag: STD_LOGIC;
    signal CH1outBRAM, CH2outBRAM : STD_LOGIC_VECTOR(15 downto 0);
    signal CH1pixelBRAM, CH2pixelBRAM : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
    signal CH1compareG, CH1compareL, CH2compareG, CH2compareL, CH1_TRIGGER, CH2_TRIGGER : STD_LOGIC;
    signal store_cnt : STD_LOGIC_VECTOR(10 downto 0);
    signal long_cnt : STD_LOGIC_VECTOR(23 downto 0);
    signal short_cnt : STD_LOGIC_VECTOR(7 downto 0);
    signal sampleRate, sample_cnt : STD_LOGIC_VECTOR(31 downto 0);
    signal ch1REG1_sgn, ch1REG2_sgn, ch2REG1_sgn, ch2REG2_sgn : STD_LOGIC_VECTOR(15 downto 0);
    
    signal a1_signed16, a2_signed16, a3_signed16 : SIGNED(15 downto 0);
    signal b1_signed16, b2_signed16, b3_signed16 : SIGNED(15 downto 0);
    signal slope1, slope2, slope3 : SIGNED(31 downto 0);
    signal y1_signed16, y2_signed16, y3_signed16 : SIGNED(15 downto 0);
    signal t1_signed32, t2_signed32, t3_signed32 : SIGNED(31 downto 0);
    signal triggerVolt : STD_LOGIC_VECTOR(10 downto 0);
    
    signal pixelH, pixelV: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal videoClk, videoClk5x, clkLocked, reset: STD_LOGIC;
    signal hsync, vsync, vde : STD_LOGIC;
    signal ch1, ch2 : STD_LOGIC;
    
    signal triggerTime : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal red, green, blue :  STD_LOGIC_VECTOR(7 downto 0);
    
    signal rst : STD_LOGIC;
    signal pix_clk_locked : STD_LOGIC;
    signal addrb : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
    signal trig1, trig2 : STD_LOGIC;
    
begin
    hdmiOen <= '1';
    addrb <= STD_LOGIC_VECTOR(unsigned(pixelH) - unsigned(L_EDGE));
    reset <= not resetn;
    trig1 <= cw(TRIG_CH1_WRITE_CW_BIT_INDEX);
    trig2 <= cw(TRIG_CH2_WRITE_CW_BIT_INDEX);
    
    vsg : videoSignalGenerator
        PORT MAP (clk => videoClk,
                  resetn => resetn,
                  
                  pixelHorz => pixelH,
                  pixelVert => pixelV,
                  
                  hs => hsync,
                  vs => vsync,
                  de => vde);
    sf : scopeFace
        PORT MAP (clk => videoClk,
                  resetn => resetn,
                  
                  pixelH => pixelH,
                  pixelV => pixelV,
                  
                  ch1 => ch1,
                  ch1enb => '1',
                  ch2 => ch2,
                  ch2enb => '1',
                  
                  triggerTime => triggerTime,
                  triggerVolt => triggerVolt,
                  
                  red => red,
                  green => green,
                  blue => blue);
                  
    hdmi_inst : hdmi_tx_0
        PORT MAP (pix_clk => videoClk,
                  pix_clkx5 => videoClk5x,
                  rst => reset,
                  
                  hsync => hsync,
                  vsync => vsync,
                  vde => vde,
                  
                  pix_clk_locked => clkLocked,
                  
                  red => red,
                  green => green,
                  blue => blue,
                  
                  TMDS_DATA_P => tmdsDataP,
                  TMDS_DATA_N => tmdsDataN,
                  TMDS_CLK_P => tmdsClkP,
                  TMDS_CLK_N => tmdsClkN,
                  
                  aux0_din => "0000",
                  aux1_din => "0000",
                  aux2_din => "0000",
                  ade => '0');
                  
    vc: clk_wiz_0
	    PORT MAP( clk_out1 => videoClk,
	              clk_out2 => videoClk5x,
	              resetn => resetn,
	              locked => clkLocked,
	              clk_in1 => clk);
    
--=========================== COUNTERS ===============================
    ------------------------------------------------------------- LONG
    longCounter : genericCounter
        GENERIC MAP(24)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  c => cw(LONG_COUNT_CW_BIT_INDEX downto LONG_COUNT_CW_BIT_INDEX - 1), -- cw(9 downto 8) 
                  d => x"000000", -- 24 / 4 = 6 --> 6 hex wide
                  q => long_cnt);

    longCompareE : genericCompare
        GENERIC MAP(24)
        PORT MAP (x => long_cnt,
                  y => LONG_DELAY_50Mhz_COUNTS,
                  g => open,
                  l => open,
                  e => sw(LONG_SW_BIT_INDEX));

    ------------------------------------------------------------- SHORT
    shortCounter : genericCounter
        GENERIC MAP(8)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  c => cw(SHORT_COUNT_CW_BIT_INDEX downto SHORT_COUNT_CW_BIT_INDEX - 1), -- cw(1 downto 0) 
                  d => x"00", -- 8 / 4 = 2 --> 2 hex wide
                  q => short_cnt);

    shortCompareE : genericCompare
        GENERIC MAP(8)
        PORT MAP (x => short_cnt,
                  y => SHORT_DELAY_50Mhz_COUNTS,
                  g => open,
                  l => open,
                  e => sw(SHORT_SW_BIT_INDEX));
                  
    ------------------------------------------------------------- SAMPLE
    sampleCounter : genericCounter
        GENERIC MAP(32)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  c => cw(SAMPLE_COUNTER_CW_BIT_INDEX downto SAMPLE_COUNTER_CW_BIT_INDEX - 1), 
                  d => (others => '0'), 
                  q => sample_cnt);

    sampleMux : genericMux4x1
        GENERIC MAP(32)
        PORT MAP (y3 => LOWEST_RATE,
                  y2 => LOW_RATE,
                  y1 => HIGH_RATE,
                  y0 => HIGHEST_RATE,
                  s => sampleRateSelect,
                  f => sampleRate);

    sampleCompareE : genericCompare
        GENERIC MAP(32)
        PORT MAP (x => sample_cnt,
                  y => sampleRate,
                  g => sw(SAMPLE_SW_BIT_INDEX),
                  l => open,
                  e => open);
                  
    ------------------------------------------------------------- STORE             
    storeCounter : genericCounter
        GENERIC MAP(11)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  c => cw(DATA_STORE_COUNTER_CW_BIT_INDEX downto DATA_STORE_COUNTER_CW_BIT_INDEX-1), -- cw(9 downto 8) 
                  d => (others => '0'),
                  q => store_cnt);

    storeCompareE : genericCompare
        GENERIC MAP(11) 
        PORT MAP (x => WIDTH,
                  y => store_cnt, -- wrAddr
                  g => open,
                  l => open,
                  e => sw(FULL_FLAG_SW_BIT_INDEX));
                  
                  
--============================ BRAMs =================================
    ch1BRAM : CH_BRAM
        PORT MAP (clka => clk,
                  ena => '1',
                  wea => cw(DATA_STORE_CH1_WRITE_CW_BIT_INDEX downto DATA_STORE_CH1_WRITE_CW_BIT_INDEX),
                  addra => store_cnt(9 downto 0),
                  dina => an7606data,
                  clkb => videoClk,
                  enb => '1',
                  addrb => addrb(9 downto 0),
                  doutb => CH1outBRAM
                  );
                  
                  
    ch2BRAM : CH_BRAM
        PORT MAP (clka => clk,
                  ena => '1',
                  wea => cw(DATA_STORE_CH2_WRITE_CW_BIT_INDEX downto DATA_STORE_CH2_WRITE_CW_BIT_INDEX),
                  addra => store_cnt(9 downto 0),
                  dina => an7606data,
                  clkb => videoClk,
                  enb => '1',
                  addrb => addrb(9 downto 0),
                  doutb => CH2outBRAM
                  );

--========================= CHANNEL STUFF ============================
    --============================================================ CH1
    ch1PixelCompareE : genericCompare
        GENERIC MAP(VIDEO_WIDTH_IN_BITS) -- ch1 bram is 16bit wide
        PORT MAP (x => CH1pixelBRAM(VIDEO_WIDTH_IN_BITS -1 downto 0),
                  y => pixelV,
                  g => open,
                  l => open,
                  e => ch1);

    ch1TrigReg1 : genericRegister
        GENERIC MAP(16) -- bc an7606data is 16bit wide
        PORT MAP (clk => clk,
                  resetn => resetn,
                  load => trig1, -- load register every time the channel is being written to
                  d => an7606data,
                  q => ch1REG1_sgn); 

    ch1TrigReg2 : genericRegister
        GENERIC MAP(16)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  load => trig1,
                  d => ch1REG1_sgn, 
                  q => ch1REG2_sgn);

    ch1signCompareG : genericCompareSigned
        GENERIC MAP(16)
        PORT MAP (x => SIGNED(ch1REG1_sgn), 
                  y => trigVolt16Sgn,
                  g => CH1compareG,
                  l => open,
                  e => open);

    ch1signCompareL : genericCompareSigned
        GENERIC MAP(16)
        PORT MAP (x => SIGNED(ch1REG2_sgn), 
                  y => trigVolt16Sgn, -- 2^15
                  g => open,
                  l => CH1compareL,
                  e => open);
    -- AND Gate              
    CH1_TRIGGER <= CH1compareG and CH1compareL;
    sw(CH1_TRIGGER_SW_BIT_INDEX) <= CH1_TRIGGER;
    
    --=================== 2sToPixel ===================
    -- CH1
    a1_signed16 <= TO_SIGNED(-500,16);
    b1_signed16 <= SIGNED(CH1outBRAM); 
    t1_signed32 <= a1_signed16 * b1_signed16; 
    slope1 <= SHIFT_RIGHT(t1_signed32 , 16);
    y1_signed16 <= slope1(15 downto 0) + TO_SIGNED(350, 16);
    CH1pixelBRAM <= STD_LOGIC_VECTOR(y1_signed16(VIDEO_WIDTH_IN_BITS - 1 downto 0));

    --============================================================ CH2
    ch2PixelCompareE : genericCompare
        GENERIC MAP(VIDEO_WIDTH_IN_BITS) -- 2sToPixel output is 16-bits 
        PORT MAP (x => CH2pixelBRAM,
                  y => pixelV,
                  g => open,
                  l => open,
                  e => ch2);

    ch2TrigReg1 : genericRegister
        GENERIC MAP(16)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  load => trig2, -- load register every time the channel is being written to
                  d => an7606data,
                  q => ch2REG1_sgn); 

    ch2TrigReg2 : genericRegister
        GENERIC MAP(16)
        PORT MAP (clk => clk,
                  resetn => resetn,
                  load => trig2,
                  d => ch2REG1_sgn,
                  q => ch2REG2_sgn);

    ch2signCompareG : genericCompareSigned
        GENERIC MAP(16)
        PORT MAP (x => SIGNED(ch2REG1_sgn),
                  y => trigVolt16Sgn,
                  g => CH2compareG,
                  l => open,
                  e => open);

    ch2signCompareL : genericCompareSigned
        GENERIC MAP(16)
        PORT MAP (x => SIGNED(ch2REG2_sgn),
                  y => trigVolt16Sgn,
                  g => open,
                  l => CH2compareL,
                  e => open);
    -- AND Gate 
    CH2_TRIGGER <= CH2compareG and CH2compareL;
    sw(CH2_TRIGGER_SW_BIT_INDEX) <= CH2_TRIGGER;
    
    --=================== 2sToPixel ===================
    -- CH2
    a2_signed16 <= TO_SIGNED(-500,16);
    b2_signed16 <= SIGNED(CH2outBRAM); 
    t2_signed32 <= a2_signed16 * b2_signed16; 
    slope2 <= SHIFT_RIGHT(t2_signed32 , 16);
    y2_signed16 <= slope2(15 downto 0) + TO_SIGNED(350, 16);
    CH2pixelBRAM <= STD_LOGIC_VECTOR(y2_signed16(VIDEO_WIDTH_IN_BITS - 1 downto 0));
    
    --========= Simple SR Latch to assist FSM =========
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(resetn ='0') then
                storeIntoBramFlag <= '0';
            elsif (cw(SET_STORE_FLAG_CW_BIT_INDEX) = '1') then
                storeIntoBramFlag <= '1';
            elsif (cw(CLEAR_STORE_FLAG_CW_BIT_INDEX) = '1') then
                storeIntoBramFlag <= '0';
            end if;
        end if;
    end process;

    sw(STORE_FLAG_SW_BIT_INDEX) <= storeIntoBramFlag;
    
     --=================== 2sToPixel ===================
     -- OTHER ONE 
    a3_signed16 <= TO_SIGNED(-500,16);
    b3_signed16 <= trigVolt16Sgn; 
    t3_signed32 <= a3_signed16 * trigVolt16Sgn; 
    slope3 <= SHIFT_RIGHT(t3_signed32 , 16);
    y3_signed16 <= slope3(15 downto 0) + TO_SIGNED(350, 16);
    triggerVolt <= STD_LOGIC_VECTOR(y3_signed16(VIDEO_WIDTH_IN_BITS - 1 downto 0));

end behavior;
