
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY Pulsadores_tb IS
END Pulsadores_tb;
 
ARCHITECTURE behavior OF Pulsadores_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Pulsadores
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         b : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';

 	--Outputs
   signal b : std_logic_vector(5 downto 0) :="000000";

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Pulsadores PORT MAP (
          clk => clk,
          Rst => Rst,
          Up0 => Up0,
          Down0 => Down0,
          Up1 => Up1,
          Down1 => Down1,
          b => b
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
	-- Margen de Arranque.
		wait for clk_period*5;
	-- Comienzo del Test
		wait for clk_period*5;
		Rst<='1';
		wait for clk_period*3;
		Rst<='0';
		wait for clk_period*5;
      Up0 <= '1';
		wait for clk_period;
		Up0 <= '0';
      wait for clk_period*5000000;
		Up1 <= '1';
		wait for clk_period;
		Up1 <= '0';
      wait for clk_period*5000000;
		Down0 <= '1';
		wait for clk_period;
		Down0 <= '0';
      wait for clk_period*5000000;
		Down1 <= '1';
		wait for clk_period;
		Down1 <= '0';
      wait for clk_period*5000000;
      wait;
   end process;

END;