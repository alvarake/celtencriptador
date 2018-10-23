---------------------------------------------------------------------------------------------
--PSEUDORANDOM
--El bloque de encriptación de la señal es el encargado de comparar el código predefinido de cifrado (fijado en los interruptores)
--con el código introducido por el usuario (generado mediante los pulsadores). En caso de que sean iguales,
--la señal de entrada se transmitirá a la salida.
--En caso de que no lo sean, se entrega al DAC la salida de un generador pseudo-aleatorio de 16 bits.
--------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PseudoRandom is 
    Port ( clk : in  STD_LOGIC;	-- Reloj del sistema
           Rst : in  STD_LOGIC;	-- Reset del sistema
           start_random : in  STD_LOGIC;	--Enable del encriptador
			  end_random : out  STD_LOGIC;	--Finalizacion del bloque	
           sw : in  STD_LOGIC_VECTOR (5 downto 0);	--Codigo predefinido
           b : in  STD_LOGIC_VECTOR (5 downto 0); --Codigo de los pulsadores
				v : in  STD_LOGIC_VECTOR (3 downto 0);  --Valor del volumen        
			 valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);	--Valor que llega del ADC
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0)); --Valor mandado al DAC
           
end PseudoRandom;

architecture Behavioral of PseudoRandom is
--Señales auxiliares del bloque PseudoRandom
signal  primeraXOR : STD_LOGIC := '0'; -- Salida de la primera puerta XOR combinada con la posicion 13 y 15 
signal  segundaXOR : STD_LOGIC := '0';	-- Salida de la segunda puerta XOR combinada con la posicion 12 
signal  terceraXOR : STD_LOGIC := '0'; -- Salida de la tercera puerta XOR combinada con la posicion 10
signal Q :STD_LOGIC_VECTOR(15 downto 0) :="0011001100110101";
signal v_ADC : STD_LOGIC_VECTOR (11 downto 0);

begin

process(clk,Rst)
begin
	if clk'event and clk='1' then
	end_random<='0';
		if Rst='1' then			-- declaracion de los valores por defecto cuando se activa el reset
			valor_DAC<= (others=>'0');
			end_random<='0';
			Q <= "1111000010100101";--1111000010100101  --Secuencia aleatoria
		elsif start_random = '1' then	-- Si el enable esta activado
			primeraXOR <= Q(13) XOR Q(15);		--combinacion de la primera XOR
			segundaXOR<= primeraXOR XOR Q(12);	--combinacion de la segunda XOR
			terceraXOR<= segundaXOR XOR Q(10);	--combinacion de la tercera XOR

			
			Q(15 downto 1)<= Q(14 downto 0);	-- desplazamos los numeros del 0 al 14 a la posicion del 1 al 15
			Q(0)<= terceraXOR;					-- y cambiamos el valor en la posicion 0 con el nuevo valor
			
			if (sw = b) then	--Si la clave coincide con la clave predefinida la señal pasa bien
				
	CASE v IS --Maquina que controla el volumen segun lo pulsado
	
		when "0001" => --1
			if (valor_ADC(11) = '0') then
				v_ADC<= "0000" & valor_ADC(11 downto 4);
			else
			v_ADC<= "1111" & valor_ADC(11 downto 4);
		end if;
		
		when "0010" => --2
				if (valor_ADC(11) = '0') then
			v_ADC<= "000" & valor_ADC(11 downto 3);
		else
			v_ADC<= "111" & valor_ADC(11 downto 3);
		end if;
		

		
		when "0011" => --3
				if (valor_ADC(11) = '0') then
			v_ADC<= "00" & valor_ADC(11 downto 2);
		else
			v_ADC<= "11" & valor_ADC(11 downto 2);
		end if;
		

		when "0100" => --4
		if (valor_ADC(11) = '0') then
			v_ADC<= "0" & valor_ADC(11 downto 1);
		else
			v_ADC<= "1" & valor_ADC(11 downto 1);
		end if;
		
		when "0101" => --5
		
		v_ADC<=valor_ADC;
		
		when "0110" => --6
		
		v_ADC<= valor_ADC(10 downto 0) & "0";
		
		when "0111" => --7
		
		v_ADC<= valor_ADC(9 downto 0) & "00";
		
		when "1000" => --8
		
		v_ADC<= valor_ADC(8 downto 0) & "000";
		
		when "1001" => --9
		
		v_ADC<= valor_ADC(7 downto 0) & "0000";
		
		
		when others => 
		
		v_ADC<=valor_ADC;
		
	END CASE;
				
				valor_DAC<= v_ADC + "100000000000"; --X800 hexadecimal a binario --sacamos el valor del ADC mas 800 ya que es de caracter bipolar
				end_random<='1'; --Fin del bloque
		   else	--Si la clave esta mal
				valor_DAC<= Q(15 downto 4);	--La salida es el valor aleatorio generado al DAC.
				end_random<='1';
			end if;

		end if;
 
		
	end if;
end process;



end Behavioral;

