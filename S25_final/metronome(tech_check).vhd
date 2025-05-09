library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity metronome3 is
	Port ( clk_12MHz : in  STD_LOGIC;
	      CS : in STD_LOGIC;
       	resetn : in  STD_LOGIC;
       	dataIN : in STD_LOGIC_VECTOR (15 downto 0);
       	leds : out STD_LOGIC_VECTOR (9 downto 0)
     	);
end metronome3;

architecture Behavioral of metronome3 is
	
	signal count : integer range 0 to 9 := 0;							-- count: which LED is on	
	signal direction : STD_LOGIC := '1';								-- direction: direction of led bounce
	signal bpm : integer range 0 to 511 := 60;  						-- bpm: value from accumulator
	signal divcount : integer := 0;										-- divcount: counts up to divider for slowed clock
	signal divider : integer range 1 to 12000000 := 12000000;	-- divider: # clock signals per led move
	signal CStoggle : STD_LOGIC := '0';									-- CStoggle: don't give new command if same AC value
	signal switch9 : STD_LOGIC := '0';									-- switch9: lighting mode toggle
	signal bTrack : integer range 0 to 9 := 0; 						-- bTrack: keep track of where we are in brightness
	signal bCount : integer range 0 to 9 := 0;						-- bCount: how many brightness spacers we have

begin
	-- Process to update BPM and calculate divider ONLY when CS is high
	process(clk_12MHz)
	begin
    	if rising_edge(clk_12MHz) then
		
        	-- Update BPM and divider only when CS is high
        	if CS = '1' then
					
					-- get values from accumulator
            	bpm <= to_integer(unsigned(dataIN(8 downto 0)));
					switch9 <= dataIN(9);

            	-- prevent division by zero, calculate clock cycles per update
            	if bpm > 6 then
                	divider <= 2*12000000 / (bpm / 3);
            	else
                	divider <= 12000000; -- Default slowest speed
            	end if;
					
        	end if;

        	-- Clock divider logic
        	if divcount < divider - 1 then
            	divcount <= divcount + 1;
        	else
            	divcount <= 0;
					
					-- update brightness logic as well
					if bpm > 6 then
						if bCount = 9 then
							bCount <= 0;
						else
							bCount <= bCount + 1;
						end if;
					end if;
        	end if;
    	end if;
	end process;

	-- Process to control LED movement
	process(clk_12MHz, resetn)
	begin
		-- reset logic
    	if resetn = '0' then
        	count <= 0;
        	direction <= '1';
        	CStoggle <= '0';
        	leds <= (others => '0');
			
		-- lighting mode logic
    	elsif rising_edge(clk_12MHz) then
		
			-- case 1: we are on bouncing mode
			if (switch9 = '0') and (divcount = 0) then
				if CS = '1' then
						CStoggle <= '1';
				end if;

				-- state machine
				if CStoggle = '1' and bpm > 6 then
				
						-- LED oscillation logic
						if direction = '1' then	-- go right
							if count < 9 then
								count <= count + 1;
							else
								direction <= '0';
							end if;
						else							-- go left
							if count > 0 then
								count <= count - 1;
							else
								direction <= '1';
							end if;
						end if;

						-- update LEDs
						leds <= (others => '0');
						leds(count) <= '1';
				end if;
			
			-- case 2: flashing logic
			elsif switch9 = '1' then
				if CS = '1' then
						CStoggle <= '1';
				end if;
				
				-- count buffers to make it seem dimmer
				if bTrack = bCount then
					bTrack <= 0;
					leds <= (others => '1');
				else
					bTrack <= bTrack + 1;
					leds <= (others => '0');
				end if;			
			end if;
    	end if;
	end process;
end Behavioral;



