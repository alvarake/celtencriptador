
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY visualizacion_tb IS  
END visualizacion_tb;
  
ARCHITECTURE behavior OF visualizacion_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT visualizacion
    PORT(
         clk : IN  std_logic;
         cnt_5ms : IN  std_logic;
         Digito0 : IN  std_logic_vector(3 downto 0);
         Digito1 : IN  std_logic_vector(3 downto 0);
         Digito2 : IN  std_logic_vector(3 downto 0);
         Digito3 : IN  std_logic_vector(3 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal cnt_5ms : std_logic := '0';
   signal Digito0 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito1 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito2 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito3 : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: visualizacion PORT MAP (
          clk => clk,
          cnt_5ms => cnt_5ms,
          Digito0 => Digito0,
          Digito1 => Digito1,
          Digito2 => Digito2,
          Digito3 => Digito3,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7
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

      wait for clk_period*125000;
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';
		Digito0 <= "0001";
		Digito1 <= "0110";
		wait for clk_period*125000;
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';
		wait for clk_period*125000;
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';
		wait for clk_period*125000; 
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';
		wait for clk_period*125000;
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';
		wait for clk_period*125000;
		cnt_5ms <= '1';
		wait for clk_period;
		cnt_5ms <= '0';

      wait;
   end process;

END;
