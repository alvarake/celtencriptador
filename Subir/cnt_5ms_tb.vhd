
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY contador_5ms_tb IS
END contador_5ms_tb;
 
ARCHITECTURE behavior OF contador_5ms_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT contador_5ms
    PORT(
         clk : IN  std_logic;
         cnt_5ms : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal cnt_5ms : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador_5ms PORT MAP (
          clk => clk,
          cnt_5ms => cnt_5ms
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		wait for clk_period*125005;
      wait;
   end process;

END;
