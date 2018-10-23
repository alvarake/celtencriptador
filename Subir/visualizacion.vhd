
--Bloque de Visualizacion cuya finalidad es la recibir la salida del BCD de los digitos que se han interpretado a partir de la señal b
-- y sacar su correspondiente representacion a los displays mediante seg7 y activandolos mediante Disp
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;   
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

 
entity visualizacion is
    Port ( clk : in  STD_LOGIC;								-- Reloj de sistema
           cnt_5ms : in  STD_LOGIC;							-- Cuenta de 5ms
           Digito0 : in  STD_LOGIC_VECTOR(3 downto 0);-- Valor del BCD para su interpretacion
           Digito1 : in  STD_LOGIC_VECTOR(3 downto 0);-- Valor del BCD para su interpretacion
           Digito2 : in  STD_LOGIC_VECTOR(3 downto 0);-- Valor del BCD para su interpretacion
           Digito3 : in  STD_LOGIC_VECTOR(3 downto 0);-- Valor del BCD para su interpretacion
          sw6: in  STD_LOGIC;          					--Modo volumen o encriptacion
			 Disp0 : out  STD_LOGIC;							-- Enable display
           Disp1 : out  STD_LOGIC;							-- Enable display
           Disp2 : out  STD_LOGIC;							-- Enable display
           SDP : out  STD_LOGIC;  							--Salida Punto Decimal
			  Disp3 : out  STD_LOGIC;							-- Enable display
           Seg7 : out  STD_LOGIC_VECTOR(0 to 6));		-- Segmentos del display
				
				--NOTA: los numeros van de G,F,E,D,C,B,A POR QUE LO TENEMOS EN 0 TO 6 ADEMAS SON ACTIVAS A NIVEL BAJO
end visualizacion;

architecture Behavioral of visualizacion is

signal sel : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal digitoBCD : STD_LOGIC_VECTOR (3 downto 0):= "0000";

begin

process (clk)

begin
 if clk'event and clk='1' then --proceso que cambia la señal de valor cada 5 ms
	if(cnt_5ms = '1') then		 --pasa de 00-01-10-11-00....
		sel<=sel+"01";
		else
			sel<= sel;
	end if; 
 end if; 
end process;

process (sel, digito0, digito1, digito2, digito3) --este proceso cambia de estado cada 5ms valor imperceptible por el ojo humano luego vemos 
begin															   --todo el rato los displays encendidos aunque la realidad es que se apagan.
																
	-- Valores por defecto 		
	digitoBCD <= digito0; 
	Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '1'; SDP <= '1';
	
	CASE sel IS
		when "00" => 
		digitoBCD <= digito0;
		Disp0 <= '0';
		Disp1 <= '1';
		Disp2 <= '1';
		Disp3 <= '1';
		if sw6= '0' THEN
		SDP <= '0';
		end if;
		when "01" => 
		digitoBCD <= digito1;
		Disp0 <= '1';
		Disp1 <= '0';
		Disp2 <= '1';
		Disp3 <= '1';
		SDP <= '1';
		when "10" => 
		digitoBCD <= digito2;
		Disp0 <= '1';
		Disp1 <= '1';
		Disp2 <= '1';
		Disp3 <= '1';
		SDP <= '1';
		when "11" => 
		digitoBCD <= digito3;
		Disp0 <= '1';
		Disp1 <= '1';
		Disp2 <= '1';
		Disp3 <= '0';
		if sw6= '1' THEN
		SDP <= '0';
		end if;
		when others => 
		Disp0 <= '1';
		Disp1 <= '1';
		Disp2 <= '1';
		Disp3 <= '1';
		SDP <= '1';
		digitoBCD <= digito0;
		
	END CASE;
end process;
with DigitoBCD select Seg7 <=
 "1000000" when "0000", ---los numero van de G,F,E,D,C,B,A PORQUE LO TENEMOS EN 0 TO 6 ADEMAS SON ACTIVAS A NIVEL BAJO
 "1111001" when "0001",
 "0100100" when "0010",
 "0110000" when "0011",
 "0011001" when "0100",
 "0010010" when "0101",
 "0000010" when "0110",
 "1111000" when "0111",
 "0000000" when "1000",
 "0011000" when "1001",
 "1111111" when others; 
 
 
 
end Behavioral;

