
-- Contador que genera un pulsa cada 5ms
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL; 


entity contador_5ms is
    Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end contador_5ms;

architecture Behavioral of contador_5ms is

signal contador : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";

begin

process (clk) 
begin 
	if clk'event and clk='1' then    
		cnt_5ms <= '0'; 
		contador <= contador + '1'; 
		if contador >= "111101000010010000" then        -- Valor máximo de la cuenta.
			cnt_5ms <= '1';  										
			contador <= (others => '0'); 
		end if; 
	end if;
  
end process; 


end Behavioral;

