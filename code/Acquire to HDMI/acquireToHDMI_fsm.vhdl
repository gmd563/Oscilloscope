--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- File:	acquireToHDMI_fsm.vhdl
-- HW:	Lab2
--	Crs:	ECE 383
--
-- Purp: The control unit for the audio O'scope
--
-- Documentation:	No help, though I used an example from my Digital
--						Design text book.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.acquireToHDMI_package.all;					-- include your library here with added components ac97, ac97cmd


entity acquireToHDMI_fsm is
    PORT (  clk : in  STD_LOGIC;
            resetn : in  STD_LOGIC;
            sw: in STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
            cw: out STD_LOGIC_VECTOR (CW_WIDTH - 1 downto 0));
end acquireToHDMI_fsm;

architecture Behavioral of acquireToHDMI_fsm is

	signal state: state_type;	-- define the state_type in your package file	
	signal STORE_FLAG_SW, FULL_FLAG_SW, SAMPLE_SW, LONG_DELAY_SW, SHORT_DELAY_SW : STD_LOGIC;
	signal CH1_TRIGGER_SW, CH2_TRIGGER_SW, FORCED_MODE_SW, TRIGGER_BTN_SW, BUSY_SW  : STD_LOGIC;
	
begin

    STORE_FLAG_SW  <= sw(STORE_FLAG_SW_BIT_INDEX);
    FULL_FLAG_SW   <= sw(FULL_FLAG_SW_BIT_INDEX);
    SAMPLE_SW      <= sw(SAMPLE_SW_BIT_INDEX);
    LONG_DELAY_SW  <= sw(LONG_SW_BIT_INDEX);
    SHORT_DELAY_SW <= sw(SHORT_SW_BIT_INDEX);
    CH1_TRIGGER_SW <= sw(CH1_TRIGGER_SW_BIT_INDEX);
    CH2_TRIGGER_SW <= sw(CH2_TRIGGER_SW_BIT_INDEX);
    FORCED_MODE_SW <= sw(FORCED_MODE_SW_BIT_INDEX);
    TRIGGER_BTN_SW <= sw(SINGLE_SW_BIT_INDEX);
    BUSY_SW        <= sw(BUSY_SW_BIT_INDEX);
    
    
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (resetn = '0') then 
				state <= RESET_STATE;
			else 
				case state is				
					when RESET_STATE =>
					    state <= LONG_DELAY_STATE;
						  
					when LONG_DELAY_STATE =>
					    if (LONG_DELAY_SW = '1') then state <= RESET_AD7606_STATE;
					    else state <= LONG_DELAY_STATE;
					    end if;
					    
					when RESET_AD7606_STATE =>
					    if(SHORT_DELAY_SW = '1') then state <= WAIT_STATE;
					    else state <= RESET_AD7606_STATE;
					    end if;
					    
					when WAIT_STATE =>
					    if(TRIGGER_BTN_SW = '1') then state <= SET_STORE_FLAG_STATE;
					    elsif(FORCED_MODE_SW = '0') then state <= CLEAR_STORE_FLAG_STATE;
                        else state <= WAIT_STATE;
                        end if;
					    
					when SET_STORE_FLAG_STATE =>
					    state <= BEGIN_CONV_STATE;
					    
					when CLEAR_STORE_FLAG_STATE =>
					    state <= BEGIN_CONV_STATE;
					    
					when BEGIN_CONV_STATE =>
					    state <= ASSERT_CONVST_STATE;
					    
					when ASSERT_CONVST_STATE =>
					    if(SHORT_DELAY_SW = '1') then state <= BUSY0_STATE;
					    else state <= ASSERT_CONVST_STATE;
					    end if;
					    
					when BUSY0_STATE =>
					    if(BUSY_SW = '1') then state <= BUSY1_STATE;
					    else state <= BUSY0_STATE;
					    end if;
					    
					when BUSY1_STATE =>
					    if(BUSY_SW = '0') then state <= READ_CH1_LOW_STATE;
					    else state <= BUSY1_STATE;
					    end if;
					    
					when READ_CH1_LOW_STATE =>
					    if(SHORT_DELAY_SW = '1' and STORE_FLAG_SW = '0') then state <= TRIG_CH1_STATE;
					    elsif(SHORT_DELAY_SW = '1' and STORE_FLAG_SW = '1') then state <= BRAM_CH1_STATE;
					    else state <= READ_CH1_LOW_STATE;
					    end if;
					    
					when TRIG_CH1_STATE => 
					    state <= READ_CH1_HIGH_STATE;
					    
					when BRAM_CH1_STATE => 
					    state <= READ_CH1_HIGH_STATE;
					    
					when READ_CH1_HIGH_STATE =>
					    if(SHORT_DELAY_SW = '1') then state <= RESET_SHORT_STATE;
					    else state <= READ_CH1_HIGH_STATE;
					    end if;
					    
					when RESET_SHORT_STATE =>
					    state <= READ_CH2_LOW_STATE;
					    
					when READ_CH2_LOW_STATE =>
					    if(SHORT_DELAY_SW = '1' and STORE_FLAG_SW = '0') then state <= TRIG_CH2_STATE;
					    elsif(SHORT_DELAY_SW = '1' and STORE_FLAG_SW = '1') then state <= BRAM_CH2_STATE;
					    else state <= READ_CH2_LOW_STATE;
					    end if;
					    
					when TRIG_CH2_STATE =>
					    state <= READ_CH2_HIGH_STATE;
					    
					when BRAM_CH2_STATE =>
					    state <= READ_CH2_HIGH_STATE;
					    
					when READ_CH2_HIGH_STATE =>
					    if(SHORT_DELAY_SW = '1') then state <= WAIT_SAMPLE_INT_STATE;
					    else state <= READ_CH2_HIGH_STATE;
					    end if;
				 
				 ------------------------------ WAIT_SAMPLE_INT_STATE     
					when WAIT_SAMPLE_INT_STATE =>
					    
					    if (SAMPLE_SW = '1') then
					        if (FULL_FLAG_SW = '1') then 
					            state <= SET_FULL_FLAG_STATE;
                            else
                                if (FORCED_MODE_SW = '0' and
                                    STORE_FLAG_SW = '0' and 
                                    (CH1_TRIGGER_SW = '1' or CH2_TRIGGER_SW = '1')) then
                                    state <= SET_STORE_FLAG_STATE;
                                else
                                    state <= BEGIN_CONV_STATE;
                                end if;
					        end if;
					    end if;
					         
				 ------------------------------ SET_FULL_FLAG_STATE
					when SET_FULL_FLAG_STATE =>
					    --if(CH1_TRIGGER_SW = '1' or CH2_TRIGGER_SW = '1') then state <= CLEAR_STORE_FLAG_STATE;
					    if(FORCED_MODE_SW = '0') then state <= CLEAR_STORE_FLAG_STATE;
					    else  state <= WAIT_STATE;
					    end if;

						  
				end case;
			end if;
		end if;
	end process;

	-------------------------------------------------------------------------------
    -- Dedicated Control Word spreadsheet
    -------------------------------------------------------------------------------
	output_process: process (state)
	begin
		case state is
		                                                                                                                               -- 5,4 (HARD SET --> WILL BE MUX)
                                                 -- 21    20    19    18    17    16    15    14    13    12    11    10    9,8    7,6    5,4    3,2    1,0 		
            when RESET_STATE  =>              cw <= '1' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "11" & "11" & "00" & "11" & "11"; -- RESET
            when LONG_DELAY_STATE =>          cw <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "00" & "00" & "10" & "00"; -- LONG
            when RESET_AD7606_STATE =>        cw <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '1' & "00" & "00" & "00" & "11" & "10"; -- AD7606
            when WAIT_STATE =>                cw <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "11" & "00" & "00" & "00" & "11"; -- WAIT
            when SET_STORE_FLAG_STATE =>      cw <= '0' & '1' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "00" & "00" & "00" & "00"; -- STORE
            when CLEAR_STORE_FLAG_STATE =>    cw <= '1' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "11" & "11" & "00" & "00" & "00"; -- CLEAR STORE
            when BEGIN_CONV_STATE =>          cw <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "11" & "00" & "00" & "11"; -- BEGIN
            when ASSERT_CONVST_STATE =>       cw <= '0' & '0' & '0' & '0' & '1' & '1' & '0' & '0' & '0' & '1' & '1' & '0' & "00" & "10" & "00" & "00" & "10"; -- ASSERT
            when BUSY0_STATE =>               cw <= '0' & '0' & '0' & '0' & '1' & '1' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "10" & "00" & "00" & "11"; -- BUSY0
            when BUSY1_STATE =>               cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "10" & "00" & "00" & "00"; -- BUSY1
            when READ_CH1_LOW_STATE =>        cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & "00" & "10" & "00" & "00" & "10"; -- CH1 LOW
            when TRIG_CH1_STATE =>            cw <= '0' & '0' & '0' & '1' & '1' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & "00" & "10" & "00" & "00" & "11"; -- CH1 TRIG
            when BRAM_CH1_STATE =>            cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '1' & '1' & '0' & '0' & '0' & "00" & "10" & "00" & "00" & "11"; -- CH1 BRAM
            when READ_CH1_HIGH_STATE =>       cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '1' & '0' & '0' & "00" & "10" & "00" & "00" & "10"; -- CH1 HIGH
            when RESET_SHORT_STATE =>         cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '1' & '0' & '0' & "00" & "10" & "00" & "00" & "11"; -- RESET SHORT
            when READ_CH2_LOW_STATE =>        cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & "00" & "10" & "00" & "00" & "10"; -- CH2 LOW
            when TRIG_CH2_STATE =>            cw <= '0' & '0' & '1' & '0' & '1' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & "00" & "10" & "00" & "00" & "11"; -- CH2 TRIG
            when BRAM_CH2_STATE =>            cw <= '0' & '0' & '0' & '0' & '1' & '0' & '1' & '0' & '1' & '0' & '0' & '0' & "10" & "10" & "00" & "00" & "11"; -- CH2 BRAM
            when READ_CH2_HIGH_STATE =>       cw <= '0' & '0' & '0' & '0' & '1' & '0' & '0' & '0' & '1' & '1' & '0' & '0' & "00" & "10" & "00" & "00" & "10"; -- CH2 HIGH
            when WAIT_SAMPLE_INT_STATE =>     cw <= '0' & '0' & '0' & '0' & '0' & '1' & '0' & '0' & '1' & '1' & '1' & '0' & "00" & "10" & "00" & "00" & "11"; -- WAIT SAMPLE
            when SET_FULL_FLAG_STATE =>       cw <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '1' & '1' & '1' & '0' & "11" & "11" & "00" & "00" & "00"; -- FULL

		end case;
	end process;	                       

end Behavioral;



