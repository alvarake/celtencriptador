-------------------------------------------------------------------------------------
--CONTROL GLOBAL
--El bloque de control global es el encargado de gestionar cuándo tiene que comenzar
--el procesamiento de cada uno de los bloques que dependen de él. Por simplicidad
--utilizaremos un protocolo de comunicación asíncrona basado en una señal de inicio
--y otra señal de fin. De esta forma, cada bloque comenzará su procesamiento cuando
--haya terminado el bloque inmediatamente anterior. Puesto que en las especificaciones
--se indica que la frecuencia de muestreo deben ser 8 kHz,
--un contador interno generará cada 125 µs la señal de inicio del primero de los bloques.
-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Control_global is
    Port ( clk : in  STD_LOGIC;		-- Reloj del sistema
           Rst : in  STD_LOGIC;		-- Reset del sistema
           start_ADC : out  STD_LOGIC;-- Enable del adc
           start_random : out  STD_LOGIC;-- Enable del random
			  start_DAC : out  STD_LOGIC; --Enable del DAC
           end_ADC : in  STD_LOGIC; -- Fin del adc
           end_random : in  STD_LOGIC; -- Fin del random
           end_DAC : in  STD_LOGIC;	-- Fin del dac
			  global_st : out  STD_LOGIC_VECTOR (1 downto 0)); --Señal de control de estado
end Control_global;

architecture Behavioral of Control_global is


signal st : STD_LOGIC_VECTOR(1 downto 0);

signal contador : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000" ; --señal auxiliar para contar los 125us
signal cnt_125us : STD_LOGIC; --señal auxiliar que activa un pulso cuando la cuenta llega a los 125us
begin

--CONTADOR DE 125US
process (clk) 
begin 
	if clk'event and clk='1' then  
		cnt_125us <= '0';
		contador <= contador + '1'; 
		if contador >= "1100001101010" then --6250 --valor máximo de la cuenta.
			cnt_125us<='1';									
			contador <= (others => '0'); 
		end if;
		if Rst = '1' then    
			cnt_125us <= '0'; 
			contador <= (others => '0'); 
		end if;
	end if;	
end  process;


--INICIO DEL PROCESO PRINCIPAL
process (clk,Rst) 
begin     
		if (Rst = '1') THEN --Valores por defecto.
			 start_ADC <= '0';
          start_random <= '0';
			 start_DAC <= '0';
			 st <= "00";
			 
		ELSIF clk'event and clk = '1' THEN
				start_ADC <= '0';
				start_random <= '0';
				start_DAC <= '0';
		CASE st IS 
--ESTADO INICIAL
			WHEN "00" => --estado de reposo
				start_ADC <= '0';
				start_random <= '0';
				start_DAC <= '0';
				
				IF cnt_125us ='1' THEN --pasa al siguiente estado cuando se activa la cuenta
					start_ADC <= '1';
					st <= "01";
				END IF;

--ESTADO ADC			
			WHEN "01" => 

				IF ( end_ADC ='1') then --pasa al siguiente estado si ha acabado el ADC 
					start_random <='1';
					st <= "11";
				END IF;
	

--ESTADO DAC			
			WHEN "11" => 
			if (end_random ='1') then --Si finaliza random
				start_DAC<='1';			--Empieza el DAC
				st <= "10";
			end if;
								
			WHEN "10" =>
				IF ( end_DAC ='1') then
					st <= "00";
				END IF;					
			WHEN others =>
				st <= "00";
			END CASE;
		END IF;
end process;
global_st <=st;


end Behavioral;

