
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY control_displays_tb IS
END control_displays_tb;
 
ARCHITECTURE behavior OF control_displays_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_displays
    PORT(
         b : IN  std_logic_vector(5 downto 0);
         clk : IN  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal clk : std_logic;

 	--Outputs
   signal Seg7 : std_logic_vector(6 downto 0);
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_displays PORT MAP (
          b => b,
          clk => clk,
          Seg7 => Seg7,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3
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
      -- hold reset state for 100 ns.
      wait for 100 ns;
		b <= "000000";
      wait for clk_period*5000000;
		b <= "000001";
      wait for clk_period*5000000;	
		b <= "001010";
      wait for clk_period*5000000;
		b <= "001011";
		wait for clk_period*5000000;
		b <= "001010";
		wait for clk_period*5000000;
		b <= "001111";
		wait for clk_period*5000000;
		b <= "001010";
		wait for clk_period*5000000;
		b <= "000000";
      wait;
   end process;

END;

