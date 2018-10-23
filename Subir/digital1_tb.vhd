

library STD;
use std.textio.all;

library ieee;                                  -- INCLUIR ESTAS LIBRERIAS EN TODOS LOS FICHEROS VHDL
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
 
entity digital1_tb is
--        
end digital1_tb;
 
architecture behavior of digital1_tb is 

    constant clk_period     : time := 20 ns;         -- 50Mhz
    constant rst_pulse      : time := 5 us;

    component digital1 is
    Port (  Rst : in  STD_LOGIC;                   -- Rst para el registro Reg_f (switch 0)
            clk   : in  STD_LOGIC;                   -- Reloj de la FPGA
			
            Up0 : in  STD_LOGIC;                   -- Pulsador 0
            Up1 : in  STD_LOGIC;                   -- Pulsador 1
            Down0 : in  STD_LOGIC;                   -- Pulsador 2
            Down1 : in  STD_LOGIC;                   -- Pulsador 3
			
            Seg7  : out  STD_LOGIC_VECTOR (6 downto 0);  -- Salida de 7 segmentos para los Displays
            Disp0 : out  STD_LOGIC;                  -- Salida para activar Display 1  
            Disp1 : out  STD_LOGIC;                  -- Salida para activar Display 2
            Disp2 : out  STD_LOGIC;                  -- Salida para activar Display 3 
            Disp3 : out  STD_LOGIC );                -- Salida para activar Display 4 
    end component;

    
    -- 1. Inputs    
    signal rst                  : std_logic := '0';
    signal clk                  : std_logic := '0';
    signal pulsadores           : std_logic_vector(3 downto 0):= "0000";

    -- 2. Outputs
    signal seg_7                : std_logic_vector(6 downto 0):= "0000000";
    signal Disp_0               : std_logic:= '0';
    signal Disp_1               : std_logic:= '0';
    signal Disp_2               : std_logic:= '0';
    signal Disp_3               : std_logic:= '0';

    -- 3. Constants
    constant c_100ms            : integer := 5000000;
    constant c_5ms              : integer :=  250000;
	 constant c_mia				  : integer := 2500000;

	
begin

----- *** DESCOMENTAR PARA SIMULAR EL COMPONENTE 'digital1' ***
unit_digital1 : entity work.digital1
       port map    (  
           rst                 => rst,
           clk                 => clk,
           Up0               => pulsadores(0),
           Up1               => pulsadores(2),
           Down0               => pulsadores(1),
           Down1               => pulsadores(3),
           Seg7                => seg_7,
           Disp0               => Disp_0,
           Disp1               => Disp_1,
           Disp2               => Disp_2,
           Disp3               => Disp_3
       );    

				 
    -- clk process 
    clk_process : process
    begin
        clk <= '1', '0' after clk_period/2;     -- (clk_pulse = 20 ns)
        wait for clk_period;
    end process clk_process;

    -- Rst process
    rst_process : process
    begin
        rst <= '1', '0' after rst_pulse;        -- (rst_pulse = 5 ms)      
        wait;
    end process;

	
	
    p_send : process
    begin
        pulsadores <= "0000";
        wait for   c_mia*clk_period;             -- wait 200ms         

        pulsadores <= "0001";                        -- glitch
        wait for       c_5ms*clk_period;             -- glitch (5ms)
		  
        pulsadores <= "0000";                        -- nothing
        wait for   3*c_100ms*clk_period;             -- wait 300ms
        
	     pulsadores <= "0001";                       -- up0
        wait for   c_mia*clk_period;             -- add 1 for 55 clock cycles (+1)
		  
		  pulsadores <= "0000";
        wait for   c_mia*clk_period; 
		  
	     pulsadores <= "0001";                       -- up0
        wait for   c_mia*clk_period;             -- add 1 for 55 clock cycles (+1)		  
		  
	     pulsadores <= "0001";                       -- up0
        wait for   c_mia*clk_period;             -- add 1 for 55 clock cycles (+1)
		  
        pulsadores <= "0010";                        -- down0
        wait for  c_mia*clk_period;             -- subtract 1 for 105 clock cycles (-1)
		  
		   pulsadores <= "0001";                       -- up0
        wait for   c_mia*clk_period;             -- add 1 for 55 clock cycles (+1)
      
			
        pulsadores <= "1000";                        -- down
        wait for   c_mia*clk_period;             -- subtract 100 for 55 clock cycles (-10)
        pulsadores <= "0100";                        -- up1
        wait for  c_mia*clk_period;             -- add 100 for 105 clock cycles (+10)
			
	     wait;
    end process p_send;

end behavior;