------------------------------------------------------------------------------------------------------------------------
--CONTROL DAC
--El bloque de control del DAC es el encargado de generar
--todas las señales digitales que necesita el DAC para realizar la conversión
-------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Control_DAC is
    Port ( clk : in  STD_LOGIC;	--Entrada de reloj
           Rst : in  STD_LOGIC;	--Reset del sistema
           start_DAC : in  STD_LOGIC; --Señal que da comienzo al bloque
           end_DAC : out  STD_LOGIC;  --Señal de Finalizado el bloque DAC
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0); --Señal procedente del encriptador. 
           CS1 : out  STD_LOGIC;		--Señal de control del DAC
           SCLK : out  STD_LOGIC; 	--Señal de control
           DIN : out  STD_LOGIC); 	--envio de los datos del DAC
end Control_DAC;

architecture Behavioral of Control_DAC is
type STATE_TYPE is (st_00,st_01,st_11); --Estados

--Señales para el primer contador
signal contador_primero : STD_LOGIC_VECTOR(5 downto 0) :="000000"; -- Primer contador de un 1us
signal  fin_de_cuenta : STD_LOGIC; 	 	--Manda un 1 cuando se termina la cuenta
signal s_sclk : STD_LOGIC :='0'; 		-- Señal auxiliar para la interconexion de pulsadores

signal n_state : STATE_TYPE := st_00;
signal bit_DIN : STD_LOGIC_VECTOR(3 DOWNTO 0):= (others=>'0');
signal en_cnt : STD_LOGIC; --Activacion de los contadores
signal dato_DAC : STD_LOGIC_VECTOR(15 DOWNTO 0):= (others=>'0'); -- salida de los bytes de del DAC

begin
--PRIMER CONTADOR
process(clk)
begin 
if clk'event and clk='1' then    --contador que activa un pulso cada 1us
		fin_de_cuenta <= '0';  
		if (en_cnt='1') then    
			contador_primero <= contador_primero + '1'; 
		end if; 
		if contador_primero >= "110010" then     --50 equviale al numero en binario ya que el periodo del reloj es de 20ns y necesitamos 50 pulsos de reloj para 1us  
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
		if( fin_de_cuenta = '1' and s_sclk ='0')then   
			s_sclk<='1';								   	  
		end if;		
		if (fin_de_cuenta = '1' and s_sclk ='1')then   
			s_sclk<='0';
		end if;
	end if;
end process;
sclk<=s_sclk;

PROCESS (Rst, clk)
BEGIN
 IF (Rst = '1') THEN
		end_DAC<='0';
		en_cnt <= '0';
		bit_DIN <= "0000";
		dato_DAC <= "0000000000000000";
		
 ELSIF clk'event and clk = '1' THEN
 
 CASE n_state IS
 --ESTADO DE REPOSO
	WHEN st_00 =>
		end_DAC<='0';
		en_cnt <= '0';
		dato_DAC <= "000" & valor_DAC & '0';
		IF (start_DAC = '1') THEN  --Permiso para que el DAC empiece
			n_state <= st_01;
		END IF;


--ESTADO DE ENVIO DE LOS DOS BYTES
	WHEN st_01=>
		end_DAC<='0';
		en_cnt <= '1';
		IF (fin_de_cuenta = '1' and s_sclk = '1') THEN --se van desplzando los bits al 15 que es el que se va sacando por DIN
			dato_DAC <= dato_DAC(14 downto 0) & '0';
			bit_DIN <= bit_DIN + "01";
			IF bit_DIN >= "1111" THEN	-- condicion de cambio de estado
				n_state <= st_11; 
				bit_DIN <= (others => '0');	--bit-DIN a 0
			END IF;
		END IF;
--FIN DEL ESTADO DE ENVIO DE LOS DOS BYTES

--ESTADO DE FINALIZACION
	WHEN st_11 =>
		n_state <= st_00;
		end_DAC<='1';
	WHEN others =>
		end_DAC<='0';
		n_state <= st_00;
 END CASE;
 END IF;
END PROCESS;
DIN <= dato_DAC(15) when (n_state= st_01) else '0'; --Saca cada unos de los nuevos "bits15" y su desplazamiento. Se ejecuta a la vez
CS1 <= '0' when (n_state = st_01) else '1';
end Behavioral;

