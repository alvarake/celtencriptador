
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY Encriptacion_tb IS
END Encriptacion_tb;
 
ARCHITECTURE behavior OF Encriptacion_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Encriptacion
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_random : IN  std_logic;
         end_random : OUT  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         b : IN  std_logic_vector(5 downto 0);
         valor_ADC : IN  std_logic_vector(11 downto 0);
         valor_DAC : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_random : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal valor_ADC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_random : std_logic ;
   signal valor_DAC : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Encriptacion PORT MAP (
          clk => clk,
          Rst => Rst,
          start_random => start_random,
          end_random => end_random,
          sw => sw,
          b => b,
          valor_ADC => valor_ADC,
          valor_DAC => valor_DAC
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
      --hold Rst state for 100 ns.
		Rst<='1';
      wait for 100 ns;	
		Rst<='0';
	 wait for 100 ns;	
		b <= "011000";
		sw <= "011000";
		valor_ADC <= "011111111111";
		
      wait for clk_period*10;

		start_random <= '1';
		wait for clk_period;
		start_random <= '0';
		
		b <= "011000";
		sw <= "010000";
		valor_ADC <= "011111111111";
		
		wait for clk_period*10;

		start_random <= '1';
		wait for clk_period;
		start_random <= '0';

      wait;
   end process;

END;
