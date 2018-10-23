----------------------------------------------------------------------------------
--Contador que genera un pulso cada 100ms y esta habiltiado por una señal de enable
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;


entity Contador_100ms is
    Port ( clk : in  STD_LOGIC;				--Reloj del sistema
           rst_cnt : in  STD_LOGIC;			-- Reset del contador
           en_cnt : in  STD_LOGIC;			-- Enable del contador
           cnt_100ms : out  STD_LOGIC);	-- Fin de cuenta
end Contador_100ms;

architecture Behavioral of Contador_100ms is

signal contador : STD_LOGIC_VECTOR(22 downto 0):="00000000000000000000000"; -- declaracion de la señal. 
--22 down to 0 ya que son 5M y nos hacen falta 2^23 
--numeros binarios para poder representar 5M que son numeros de pulsos de reloj 
--necesarios para contar 100ms
begin

process (clk) 
begin 
	if clk'event and clk='1' then    
		cnt_100ms <= '0'; 
		if en_cnt='1' then    									--solo cuenta si se activa el enable
			contador <= contador + '1'; 
		end if; 
		if contador >= "10011000100101101000000" then    -- valor máximo de la cuenta en binario  
			cnt_100ms <= '1';  									  
			contador <= (others => '0'); 
		end if; 
		if rst_cnt='1' then   							-- en caso de tener reset ponemos el contador a '0' y ponemos el contador de 100 a cero tambien. 
			cnt_100ms <= '0'; 
			contador <= (others => '0'); 
		end if; 
	end if;

end process; 

end Behavioral;

