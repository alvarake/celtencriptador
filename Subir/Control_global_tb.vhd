
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY Control_global_tb IS
END Control_global_tb;
 
ARCHITECTURE behavior OF Control_global_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control_global
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_ADC : OUT  std_logic;
         start_random : OUT  std_logic;
         start_DAC : OUT  std_logic;
         end_ADC : IN  std_logic;
         end_random : IN  std_logic;
         end_DAC : IN  std_logic;
         global_st : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal end_ADC : std_logic := '0';
   signal end_random : std_logic := '0';
   signal end_DAC : std_logic := '0';

 	--Outputs
   signal start_ADC : std_logic;
   signal start_random : std_logic;
   signal start_DAC : std_logic;
   signal global_st : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control_global PORT MAP (
          clk => clk,
          Rst => Rst,
          start_ADC => start_ADC,
          start_random => start_random,
          start_DAC => start_DAC,
          end_ADC => end_ADC,
          end_random => end_random,
          end_DAC => end_DAC,
          global_st => global_st
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
		Rst <='1' ;
		wait for 2*clk_period;
		Rst <='0' ;
      wait for 150 us;
		end_ADC <= '1';
		wait for clk_period;
		end_ADC <= '0';
		wait for clk_period*10;
		end_random <= '1';
		wait for clk_period;
		end_random <= '0';
		wait for clk_period*10;
		end_DAC <= '1';
		wait for clk_period;
		end_DAC <= '0';
      wait;
   end process;

END;
