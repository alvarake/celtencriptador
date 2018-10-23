
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_digital_tb IS
END top_digital_tb;
 
ARCHITECTURE behavior OF top_digital_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_digital
    PORT(
         clk : IN  std_logic;
         Reset : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0);
         sw : IN  std_logic_vector(5 downto 0);
         CS0 : OUT  std_logic;
         CS1 : OUT  std_logic;
			ssclk : OUT std_logic; 
			din : out STD_LOGIC;
         DOUT : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
 --  signal SW7 : std_logic := '0';
   signal DOUT : std_logic := '0';
   signal pulsadores : std_logic_vector(3 downto 0);

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);
   signal CS0 : std_logic;
   signal CS1 : std_logic;
	signal ssclk : std_logic;
	signal din :std_logic;


   -- Clock period definitions
   constant clk_period : time := 20 ns;
    constant c_50ms            : integer := 2500000;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_digital PORT MAP (
          clk => clk,
          Reset => Rst,
          Up0 => pulsadores(0),
          Down0 => pulsadores(1),
          Up1 => pulsadores(2),
          Down1 => pulsadores(3),
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7,
          sw => sw,
          CS0 => CS0,
          CS1 => CS1,
          ssclk => ssclk,
          din => din,
          DOUT => DOUT
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
      wait for 100 us;	

      wait for clk_period*10;
		Rst <= '1';
		wait for clk_period;
		Rst <= '0';
      -- insert stimulus here 
		  pulsadores <= "0000";
        wait for   5000000*clk_period;              -- Espera         

        pulsadores <= "0001";                        -- +1
        wait for   5000000*clk_period;              -- Pulsador presionado
        pulsadores <= "0000";                        -- Pulsadores sin presionar
        wait for   5000000*clk_period;              -- Espera
        
	     pulsadores <= "0100";                        -- +10
        wait for   5000000*clk_period;              -- Pulsador presionado
        pulsadores <= "0000";                        -- Pulsadores sin presionar
        wait for   5000000*clk_period;              -- Espera
		  
		  sw <= "001010";


      wait;
   end process;

END;
