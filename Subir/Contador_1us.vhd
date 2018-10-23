----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:53:19 11/15/2016 
-- Design Name: 
-- Module Name:    Contador_1us - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Contador_1us is
Port ( clk : in  STD_LOGIC;
           en_cnt : in  STD_LOGIC;
           cnt_1us : out  STD_LOGIC);
end Contador_1us;

architecture Behavioral of Contador_1us is

signal contador : STD_LOGIC_VECTOR(22 downto 0); -- declaracion de la señal. 

begin
begin process
	if clk'event and clk='1' then    
		cnt_1us <= '0'; 
		if clk='1' & en_cnt='1' then    
			contador <= contador + '1'; 
		end if; 
		if contador >= 50 then       
			cnt_1us <= '1';  
			contador <= (others => '0'); 
		end if; 
	end if;
  
end process; 

end Behavioral;



