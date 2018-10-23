------------------------------------------------------------------------------------------------------------------------
-- CONTROL ADC
--El bloque de control del ADC es el encargado de enviar y recibir todas las señales que deben llegar al ADC.
--Este bloque debe realizar 2 cosas: En primer lugar, enviar el byte de petición por medio de las señales CS0, SCLK y DIN.
--En segundo, recibir la respuesta a través de la señal DOUT y entregar el valor digital que se reciba a la siguiente etapa
-------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control_ADC is
    Port ( clk : in  STD_LOGIC;		--Reloj del sistema
           Rst : in  STD_LOGIC;		--Reset del sistema
           start_ADC : in  STD_LOGIC;--Enable del ADC
           end_ADC : out  STD_LOGIC; -- Final del bloque
           CS0 : out  STD_LOGIC;		 -- Salida que indica el uso del ADC y su control
           SCLK : out  STD_LOGIC;	 -- Señal interna de un contador de 1us
           DIN : out  STD_LOGIC;		 -- Salida que saca de 1 en 1 los bits que se van procesando a los distintos modulos
           DOUT : in  STD_LOGIC;		 -- Entrada de los bits al ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0)); -- Salida del ADC con los datos
end Control_ADC;


architecture Behavioral of Control_ADC is

type STATE_TYPE is (st_00,st_01,st_11,st_10); --Estados

--Señales para el primer contador
signal contador_primero : STD_LOGIC_VECTOR(5 downto 0) := "000000" ; --Primer contador de un 1us
signal  fin_de_cuenta : STD_LOGIC;	--Cuenta cuando el contador llega al valor desado
signal s_sclk : STD_LOGIC := '0'; --señal interna de sclk internconecta los contadores

signal n_state : STATE_TYPE := st_00;
signal bit_DIN : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal byte_peticion_ADC : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (others => '0');
signal en_cnt : STD_LOGIC; --señal de habilitacion de los contadores
signal dato_ADC : STD_LOGIC_VECTOR(15 DOWNTO 0);	-- dato que se manda 2 bytes al encriptador con los "0-000"

begin
--PRIMER CONTADOR
process(clk)
begin 
	if clk'event and clk='1' then    --contador que activa un pulso cada 1us
		fin_de_cuenta <= '0'; 
		if (en_cnt='1') then    
			contador_primero <= contador_primero + '1'; 
		end if; 
		if contador_primero >= "110010" then       --50 equviale al numero en binario ya que el periodo del reloj es de 20ns y necesitamos 50 pulsos de reloj para 1us
			fin_de_cuenta <= '1';  
			contador_primero <= (others => '0'); 
		end if;
		if rst='1' then    
			fin_de_cuenta <= '0'; 
			contador_primero <= (others => '0'); 
		end if; 		
	end if;
  

end process;

--SEGUNDO CONTADOR
process (clk) 
begin

	if clk'event and clk='1' then    
		if( fin_de_cuenta = '1' and s_sclk ='0')then   --segun lo entendido en el enunciado fin de cuenta hace que cambien la señal s_sclk segun lo que hay anteriormente 
			s_sclk<='1';										  --por lo tanto activa un pulso de ssclk durante un 1us y luego otro 1us a '0'
		end if;		
		if (fin_de_cuenta = '1' and s_sclk ='1')then   
			s_sclk<='0';
		end if;
	end if;
end process;
sclk <= s_sclk;


--PROCESO PRINCIPAL DEL ADC
PROCESS (Rst, clk)
BEGIN
 IF (Rst = '1') THEN			-- declarcion de los valores por defecto
 		valor_ADC<="000000000000";
 		end_ADC<='0';
		n_state<=st_00;
		en_cnt <= '0';
		bit_DIN <= "0000";
		dato_ADC <= (others=>'0');
		
 ELSIF clk'event and clk = '1' THEN
	CASE n_state IS
--ESTADO DE REPOSO
		WHEN st_00 =>
			end_ADC <= '0';
			byte_peticion_ADC <= "10010111"; --97 en HEXADECIMAL
			IF start_ADC = '1' THEN --condicion para el cambio de estado
				n_state <= st_01; --siguiente estado
			END IF;

--ENVIO DEL BYTE DE PETICION	
		WHEN st_01 => --envio del bit del byte de peticion mas signficativo  
			en_cnt <= '1';
			end_ADC <= '0';
			IF (fin_de_cuenta = '1' and s_sclk = '1') THEN
				byte_peticion_ADC <= byte_peticion_ADC(6 downto 0) & '0'; --Concatenacion de bits
				bit_DIN <= bit_DIN + "01"; --aumentamos la cuenta de bit_DIN
				IF bit_DIN >= "0111" THEN --en verdad el primero ya esta enviado luego quedan 7 mas por enviar.Condicion de cambio de estado
					n_state <= st_10; --pasamos al siguiente estado
					bit_DIN <= (others => '0'); --ponemos Bit-din a todo ceros aqui ya que se vuelve a usar en el siguiente estado
				END IF;
			END IF;

--RECEPCION DE LOS BYTES DE RESPUESTA	
		WHEN st_10 => 					--modulo de recepcion de los bits
			en_cnt<='1';
			end_ADC <= '0';
			IF (fin_de_cuenta = '1' and s_sclk = '0') THEN
				dato_ADC <= dato_ADC(14 downto 0) & DOUT; 
			END IF;
			IF (fin_de_cuenta = '1' and s_sclk = '1') THEN
				bit_DIN <= bit_DIN + "01";
				IF bit_DIN = "1111" THEN 
					n_state <= st_11;
					bit_DIN <= (others => '0');
				END IF;
			END IF;			

--ENVIO DE LA SEÑAL DEL ADC	
		
	WHEN st_11 =>
		en_cnt <= '0';
		n_state <= st_00;
		end_ADC <= '1'; --Finalizacion del proceso del ADC
		valor_ADC <= dato_ADC(14 downto 3); --se envian 12 bits al ADC se quitan los ceros
		
		
	WHEN others =>
		end_ADC <= '0';
		n_state <= st_00;
 END CASE;
 END IF;
end process;
DIN <= '0' when ((n_state =st_11)  or (n_state= st_00)) else  byte_peticion_adc(7) ; --Saca cada unos de nuestros nuevos "bits7" se ejecuta en paralelo
CS0 <= '0' when ((n_state = st_01) or (n_state = st_10)) else '1';
end Behavioral;

