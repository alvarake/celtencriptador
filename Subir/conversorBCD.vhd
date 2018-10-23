-- Bloque que se encarga de recibir la señal b que viene de pulsadores en funcion de lo pulsado
-- que es interpretada mediante unas divisiones para obtener asi de un numero en binario su correspondiente representacion
-- en unidades (D0) y decenas (D1) el resto de Digitos no los usamos de momento en nuestra implementacion.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;   
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity conversorBCD is
    Port ( clk : in  STD_LOGIC;							-- Reloj del sistema
           b : in  STD_LOGIC_VECTOR(5 downto 0);		-- Clave pulsada
           v : in  STD_LOGIC_VECTOR(3 downto 0);       --Volumen pulsado
			  sw6: in  STD_LOGIC;	
			  D0 : out  STD_LOGIC_VECTOR(3 downto 0);	-- salida que se corresponde con las unidades
           D1 : out  STD_LOGIC_VECTOR(3 downto 0); -- salida que se corresponde con las decenas
           D2 : out  STD_LOGIC_VECTOR(3 downto 0); -- 
           D3 : out  STD_LOGIC_VECTOR(3 downto 0));-- salida que se corresponde al volumen
end conversorBCD;

architecture Behavioral of conversorBCD is


begin

process(b,clk) -- el proceso basicamente resta las decenas hasta que puede y el resto se asignan a las unidades
	VARIABLE resto : STD_LOGIC_VECTOR (5 downto 0); -- señal auxiliar que nos sirve para recuperar el resto de las divisiones 
begin	
if clk'event and clk='1' then  
															-- ya que primero obtenemos el valor de las decenas y despues lo que queda son unidades
 -- VALORES POR DEFECTO
D0 <= (others => '0'); 
D1 <= (others => '0'); 
D2 <= (others => '0'); 
D3 <= v;
resto := b;


	 if b >= conv_std_logic_vector(10, 6) then
		D1 <= "0001";
		resto := b - conv_std_logic_vector(10, 6); -- resto = data_in - 10
	 end if;
	 
	 if b >= conv_std_logic_vector(20, 6) then
		D1 <= "0010"; 
		resto := b - conv_std_logic_vector(20, 6); -- resto = data_in - 20
	 end if;
	 
	 if b >= conv_std_logic_vector(30, 6) then
		D1 <= "0011";
		resto := b - conv_std_logic_vector(30, 6); -- resto = data_in - 30
	 end if;
	 
	 if b >= conv_std_logic_vector(40, 6) then
		D1 <= "0100"; 
		resto := b - conv_std_logic_vector(40, 6); -- resto = data_in - 40
	 end if;
	 
	 if b >= conv_std_logic_vector(50, 6) then
		D1 <= "0101"; 
		resto := b - conv_std_logic_vector(50, 6); -- resto = data_in - 50
	 end if;
	 
	 if b >= conv_std_logic_vector(60, 6) then
		D1 <= "0110"; 
		resto := b - conv_std_logic_vector(60, 6); -- resto = data_in - 60
	 end if;
	 
	  D0 <= resto(3 downto 0); -- Asignacion de salida
	  end if;
end process;
end Behavioral;

