
library STD;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all; 
 
entity conversorBCD_tb is
--
end conversorBCD_tb;
 
ARCHITECTURE behavior OF conversorBCD_tb IS 
  
    COMPONENT conversorBCD
    PORT(
         clk : IN  std_logic;
         b : IN  std_logic_vector(5 downto 0);
         D0 : OUT  std_logic_vector(3 downto 0);
         D1 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal b : std_logic_vector(5 downto 0);

 	--Outputs
   signal D0 : std_logic_vector(3 downto 0);
   signal D1 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	constant c_1us              : integer := 120;        -- Timing:  1 us = 50 x 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   conversor: entity work.conversorBCD 
		PORT MAP (
          clk => clk,
          b => b,
          D0 => D0,
          D1 => D1
        );

   -- Clock process definitions
    clk_process : process
    begin
        clk <= '1', '0' after clk_period/2;     -- (clk_pulse = 20 ns)
        wait for clk_period;
    end process clk_process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      b <= "000000"; -- 15
		wait for clk_period*10; -- 2000ns
		
      b <= "000001"; -- 25
		wait for clk_period*10;
		
      b <= "001011"; -- 35
		wait for clk_period*10;
		
      b <= "001010"; -- 43
		wait for clk_period*10;
		 b <= "111111"; -- 43
		wait for clk_period*10;
		
      b <= "000000"; -- 58
      wait;
   end process;

END;
