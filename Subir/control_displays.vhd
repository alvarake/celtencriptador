-------------------------------------------------------------------------
-- Bloque Control Display
--	Recibe la señal b que es el estado en el que estan los displays segun lo pulsado en Pulsadores
-- para posteriormente traducirlo con un conversor BCD y sacarlo por los displays.
-- Tambien recibe la señal v con el valor del volumen
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_displays is
    Port ( clk : in  STD_LOGIC;							--Reloj del sistema
           v : in  STD_LOGIC_VECTOR(3 downto 0);	-- Volumen del sistema
			  b : in  STD_LOGIC_VECTOR (5 downto 0);	--Clave pulsada
           sw6: in  STD_LOGIC;							-- Modo. Volumen o encriptacion
			  Disp0 : out  STD_LOGIC;						--Enable display 0
           Disp1 : out  STD_LOGIC;						--Enable display 1
           Disp2 : out  STD_LOGIC;						--Enable display 2
           Disp3 : out  STD_LOGIC;						--Enable display 3
         SDP : out  STD_LOGIC;  							--Salida Punto Decimal
			Seg7 : out  STD_LOGIC_VECTOR (0 to 6));	--salida que se encarga de encender los segmentos de cada display
end control_displays;

architecture Behavioral of control_displays is
-- variables auxiliares
signal s_Digito0 :STD_LOGIC_VECTOR (3 downto 0);	
signal s_Digito1 :STD_LOGIC_VECTOR (3 downto 0);	
signal s_Digito2 :STD_LOGIC_VECTOR (3 downto 0);	
signal s_Digito3 :STD_LOGIC_VECTOR (3 downto 0);
signal s_cnt_5ms :STD_LOGIC;								


Component visualizacion is									
 Port ( clk : in  STD_LOGIC;
           cnt_5ms : in  STD_LOGIC;
           Digito0 : in  STD_LOGIC_VECTOR(3 downto 0);
           Digito1 : in  STD_LOGIC_VECTOR(3 downto 0);
           Digito2 : in  STD_LOGIC_VECTOR(3 downto 0);
           Digito3 : in  STD_LOGIC_VECTOR(3 downto 0);
			   sw6: in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
			  SDP : out  STD_LOGIC;  
           Seg7 : out  STD_LOGIC_VECTOR(0 to 6));
			  
end component;

Component conversorBCD is							
  Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR(5 downto 0);
			  v : in  STD_LOGIC_VECTOR(3 downto 0);
			   sw6: in  STD_LOGIC;
           D0 : out  STD_LOGIC_VECTOR(3 downto 0);
           D1 : out  STD_LOGIC_VECTOR(3 downto 0);
           D2 : out  STD_LOGIC_VECTOR(3 downto 0);
           D3 : out  STD_LOGIC_VECTOR(3 downto 0));
end component;
				
Component contador_5ms is						
   Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end component;



begin
U1: visualizacion
port map(
clk=>clk,
cnt_5ms=>s_cnt_5ms,
Digito0=>s_Digito0,
Digito1=>s_Digito1,
Digito2=>s_Digito2,
Digito3=>s_Digito3,
Disp0=>Disp0,
Disp1=>Disp1,
Disp2=>Disp2,
Disp3=>Disp3,
SDP => SDP,
sw6 => sw6,
Seg7=>Seg7);

U2:conversorBCD
port map(
clk=>clk,
b=>b,
v => v,
sw6 => sw6,
D0=>s_Digito0,
D1=>s_Digito1,
D2=>s_Digito2,
D3=>s_Digito3);

U3: contador_5ms
port map(
clk=>clk,
cnt_5ms=>s_cnt_5ms);

end Behavioral;

