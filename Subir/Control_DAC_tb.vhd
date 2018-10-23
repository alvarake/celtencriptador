LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY control_DAC_tb IS
END control_DAC_tb;
 
ARCHITECTURE behavior OF control_DAC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    Component control_DAC
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_DAC : IN  std_logic;
         end_DAC : OUT  std_logic;
         CS1 : OUT  std_logic;
         SCLK : OUT  std_logic;
         DIN : OUT  std_logic;
         valor_DAC : IN  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_DAC : std_logic := '0';
   signal valor_DAC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_DAC : std_logic;
   signal CS1 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_DAC PORT MAP (
          clk => clk,
          Rst => Rst,
          start_DAC => start_DAC,
          end_DAC => end_DAC,
          CS1 => CS1,
          SCLK => SCLK,
          DIN => DIN,
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
		--Inicializacion de señales
		rst <= '1';
		wait for 100 * clk_period;
		rst <= '0';
		--Cargamos la entrada
		valor_DAC <= "000010010111";
		--Encendemos el DAC
      start_DAC <= '1';
		wait for clk_period;
		start_DAC <= '0';
		wait for 125us;
		--Tiempo restante para observar la salida del DAC
		start_DAC <= '1';
		wait for clk_period;
		start_DAC <= '0';
		wait for 125us;
		start_DAC <= '1';
		wait for clk_period;
		start_DAC <= '0';
      wait;
   end process;

END;