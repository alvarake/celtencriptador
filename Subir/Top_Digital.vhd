library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Digital is
Port(
	clk : in STD_LOGIC;			-- Señal de reloj	
	Reset : in  std_logic; 		-- Reset de sistema (SW7)
	Up0 : in STD_LOGIC; 			--	Pulsador 0
	Down0 : in STD_LOGIC; 		--	Pulsador 1
	Up1 : in STD_LOGIC; 			--	Pulsador 2
	Down1 : in STD_LOGIC; 		--	Pulsador 3
	dout : in STD_LOGIC;			-- Señal que le entra al ADC
	sw : in STD_LOGIC_VECTOR ( 5 downto 0 ) ; --Swithches
	sw6: in STD_LOGIC; 			--Seleccion del modo de trabajo (SW6)
	din : out STD_LOGIC; 		-- Señal de salida procesada en el DAC y otro por el ADC
	ssclk : out STD_LOGIC; 		--Señal de los pulsos de 1us
	cs0 : out STD_LOGIC;			--Habilita el funcionamiento del ADC
	cs1 : out STD_LOGIC;			--Habilita el funcionamiento del DAC
   Disp0 : out  STD_LOGIC; 	--Enable display 1
   Disp1 : out  STD_LOGIC; 	--Enable display 2
   Disp2 : out  STD_LOGIC; 	--Enable display 3
   Disp3 : out  STD_LOGIC; 	--Enable display 4
	SDP : out  STD_LOGIC;  		--Enable Punto Decimal
	Seg7 : out  STD_LOGIC_VECTOR(0 to 6)); --Segmentos del display
	
end Top_Digital;
 
architecture Behavioral of Top_Digital is

signal s_start_ADC:STD_LOGIC:= '0';	--Señal de comienzo del ADC
signal s_start_DAC:STD_LOGIC:= '0'; --Señal de comienzo del DAC
signal s_start_random:STD_LOGIC;		--Señal de comienzo de encriptacion

signal s_end_DAC:STD_LOGIC:= '0';	--Señal de finalizacion del ADC
signal s_end_ADC:STD_LOGIC:='0';		--Señal de finalizacion del DAC
signal s_end_random:STD_LOGIC;		--Señal de finalizacion de encriptacion

signal s_valor_ADC:STD_LOGIC_VECTOR (11 downto 0):= (others=>'0'); -- señal que saca ADC con los bits recibidos
signal s_valor_DAC:STD_LOGIC_VECTOR (11 downto 0):= (others=>'0'); -- señal que saca el DAC con los bits recibidos

signal s_b:STD_LOGIC_VECTOR(5 downto 0);	--Señal auxiliar  de pulsadores con b que es la señal asociado al codigo
signal s_v:STD_LOGIC_VECTOR(3 downto 0);	--Señal auxiliar  de pulsadores con v que es la señal asociado al volumen

signal s_global_st : STD_LOGIC_VECTOR(1 downto 0);	--Estado global del sistema (Señal de control)

signal din1 :STD_LOGIC := '0'; 	--Señal din para el ADC (se asocian a la DIN en un OR)
signal din2 :STD_LOGIC := '0'; 	--Señal din para el DAC (se asocian a la DIN en un OR)
 
signal ssclk1 :STD_LOGIC:= '0'; -- señal ssclk para el ADC (se asocian a la SSCLK en un OR)
signal ssclk2 :STD_LOGIC:= '0'; -- señal ssclk para el ADC (se asocian a la SSCLK en un OR)


Component Control_DAC is
    Port ( clk : IN  std_logic;
         Rst : IN  std_logic;
         start_DAC : IN  std_logic;
         end_DAC : OUT  std_logic;
         CS1 : OUT  std_logic;
         SCLK : OUT  std_logic;
         DIN : OUT  std_logic;
         valor_DAC : IN  std_logic_vector (11 downto 0) );
	end component;
	 
Component Control_ADC is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_ADC : in  STD_LOGIC;
           end_ADC : out  STD_LOGIC;
           CS0 : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           DIN : out  STD_LOGIC;
           DOUT : in  STD_LOGIC;
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));
END COMPONENT;

component PseudoRandom is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_random : in  STD_LOGIC;
			  end_random : out  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (5 downto 0);
           b : in  STD_LOGIC_VECTOR (5 downto 0);
			  v : in  STD_LOGIC_VECTOR (3 downto 0);
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));
           
END COMPONENT;	

component Control_global is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_ADC : out  STD_LOGIC;
           start_random : out  STD_LOGIC;
			  start_DAC : out  STD_LOGIC;
           end_ADC : in  STD_LOGIC;
           end_random : in  STD_LOGIC;
           end_DAC : in  STD_LOGIC;
			  global_st : out  STD_LOGIC_VECTOR (1 downto 0));
end component;  

component Pulsadores is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
			  sw6 : in  STD_LOGIC;
           b : out  STD_LOGIC_VECTOR(5 downto 0);
			  v : out  STD_LOGIC_VECTOR(3 downto 0));
end component;

component control_displays is
    Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
			  v : in  STD_LOGIC_VECTOR(3 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
			  sw6 : in  STD_LOGIC;
			  SDP : out  STD_LOGIC;
			  Seg7 : out  STD_LOGIC_VECTOR (0 to 6));
end component;


begin

U1: Control_DAC
port map(
			clk => clk,
         Rst => Reset,
         start_DAC => s_start_DAC,
         end_DAC => s_end_DAC,
         CS1 => cs1, 
         SCLK => ssclk2, 
         DIN => din2,
         valor_DAC =>s_valor_DAC 
			) ; 
			
U2: Control_ADC
	port map(
			clk => clk,
         Rst => Reset,
         start_ADC => s_start_ADC,
         end_ADC => s_end_ADC,
         CS0 => cs0,
         SCLK => ssclk1,
			DOUT => dout,
         DIN => din1,
         valor_ADC =>s_valor_ADC
	);
	
U3: PseudoRandom
	port map( 
	clk => clk,
	Rst => Reset,
   start_random => s_start_random,
	end_random =>s_end_random,
   sw => sw, 
   b =>s_b,
	v =>s_v,
   valor_ADC => s_valor_ADC,
   valor_DAC => s_valor_DAC	
	);
	
U4: Control_global
	port map(
	    clk => clk,
       Rst => Reset,
       start_ADC => s_start_ADC,
       start_random => s_start_random,
		 start_DAC => s_start_DAC,
       end_ADC => s_end_ADC,
       end_random => s_end_random,
       end_DAC => s_end_DAC,
	    global_st => s_global_st
		 );
		 
U5: Pulsadores
	port map( 
         clk => clk,
			rst => Reset,
         Up0 => Up0,
         Down0 => Down0,
         Up1 => Up1,
         Down1 => Down1,
			sw6 =>sw6,
         v => s_v,
			b =>s_b		
			);
			
U6: control_displays
	port map(
			  clk => clk,
           b => s_b, 		
           v => s_v,
			  Disp0 => Disp0,
           Disp1 => Disp1,
           Disp2 =>Disp2,
           Disp3 =>Disp3,
			  sw6 =>sw6,
			  SDP => SDP,  
           Seg7 => Seg7
	
			);
		
		SSCLK<= ssclk1 or ssclk2;
		DIN <= din1 or din2;

end Behavioral;




