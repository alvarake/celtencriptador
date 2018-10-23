library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

 

ENTITY Reg_b_tb IS
 END Reg_b_tb;
 
ARCHITECTURE behavior OF Reg_b_tb IS  
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg_b
    PORT(
         clk : IN  std_logic; 
         rst_b : IN  std_logic;
         en_b : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         b : OUT  std_logic_vector(5 downto 0)
        ); 
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic ; 
   signal rst_b : std_logic := '0'; 
   signal en_b : std_logic := '0';
   signal sel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs 
   signal b : std_logic_vector(5 downto 0):="111111";
 
   -- Clock period definitions
   constant clk_period : time := 10 ns;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reg_b PORT MAP (
          clk => clk, 
          rst_b => rst_b,
          en_b => en_b,
          sel => sel,
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		rst_b <= '1';
		wait for clk_period*5;
		rst_b <= '0';
		wait for clk_period*5;
		en_b<='1';
		sel <= "00";
		wait for clk_period;
		en_b<='0';
		sel <= "00";
		wait for clk_period;
		en_b<='1';
		sel <= "00";
		wait for clk_period;
		en_b<='0';
		sel <= "00";
		wait for clk_period;
		en_b<='1';
		sel <= "00";
		wait for clk_period;
		en_b<='0';
		sel <= "00";
		wait for clk_period;
		en_b<='1'; 
		sel <= "00";
		wait for clk_period;
		en_b<='0';
		sel <= "00";
		wait for clk_period;
		en_b<='1'; 
		sel <= "00";
		
		
		
--		sel <= "01";
--		wait for clk_period*5;
--		sel <= "01";
--		wait for clk_period*5;
--		sel <= "00";
--		wait for clk_period*5;
--		sel <= "00";
--		wait for clk_period*5;
--		sel <= "00";
--		wait for clk_period*5;
--		sel <= "00";
--		wait for clk_period*5;
--		sel <= "10";
--		wait for clk_period*5;
--		sel <= "11";
		

      wait;
   end process;

END;
