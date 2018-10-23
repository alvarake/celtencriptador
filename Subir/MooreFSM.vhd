-------------------------------------------------------------------------------
--AUTÓMATA DE MOORE
--Máquina de estados (Finite State Machine, FSM) de Moore que controla el
--funcionamiento del módulo. Recibe las señales de los pulsadores (Up0, Down0, Up1 y Down1) y el
--interruptor (Rst), gestiona la cuenta de 100 ms. (mediante las señales rst_cnt, en_cnt, y cnt_100ms), y
--controla el valor del registro Reg_b(mediante las señales rst_b, en_b y sel). 
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MooreFSM is
    Port ( clk : in  STD_LOGIC;								--Reloj del sistema
           Up0 : in  STD_LOGIC;								-- Pulsador 0 o +1
           Down0 : in  STD_LOGIC;							-- Pulsador 1 o -1
           Up1 : in  STD_LOGIC;								-- Pulsador 2 o +10
           Down1 : in  STD_LOGIC;							-- Pulsador 3 o decremento -10
           cnt_100ms : in  STD_LOGIC;						-- Fin de cuenta
           Rst : in  STD_LOGIC;								-- Reset del sistema
          sw6: in  STD_LOGIC;	
			 rst_cnt : out  STD_LOGIC;						-- Reset de contador
           en_cnt : out  STD_LOGIC;							-- Enable de la cuenta de 100ms
           rst_b : out  STD_LOGIC;							-- Reset de b
           en_b : out  STD_LOGIC;							-- Enable de b
           sel : out  STD_LOGIC_VECTOR (1 downto 0));	-- Estado del sistema
end MooreFSM;

architecture Behavioral of MooreFSM is

type STATE_TYPE is(st_Reset,st_Main,st_Up0a,st_Up0b,		-- Estados del Moore
st_Up1a,st_Up1b,st_Down0a,st_Down0b,st_Down1a,st_Down1b);

signal n_state : STATE_TYPE := st_Main; --estado Main(inicial por defecto)




begin
process(CLK)
begin
	if(clk'event and clk='1') then
	--Valores por defecto a las salidas
	rst_cnt <= '1';	--en cada ejecucion debemos poner si ha ocurrido que se ha activado el contador 100ms a '0'
	en_cnt <= '0';		
	rst_b <= '0';
	en_b <= '0';
	sel <= "00";

			case n_state is				--Estado de reset que resetea la b 
				when st_Reset =>
					rst_b <= '1';
					n_state <= st_Main;
				when st_Main =>			--Estado Main del Moore desde el que se accede a el resto de estados
					if(Rst = '1') then
						n_state <= st_Reset;
					elsif(Up0 = '1') then	-- estado que se da si se pulsa el pulsador asociado a +1 ( en nuestro caso el primero)
						n_state <= st_Up0a;
					elsif(Down0 = '1') then	-- estado que se da si se pulsa el pulsador asociado a -1 ( en nuestro caso el segundo)
						n_state <= st_Down0a;
					elsif(Up1 = '1') then	-- estado que se da si se pulsa el pulsador asociado a +10 ( en nuestro caso el tercero)
						n_state <= st_Up1a;
					elsif(Down1 = '1') then	-- estado que se da si se pulsa el pulsador asociado a -10 ( en nuestro caso el cuarto)
						n_state <= st_Down1a;
					end if;
					
		--------INCREMENTO +1------------	
		
				when st_Up0a =>			--estado al que se llega despues de Up0
					rst_cnt <= '0';
					en_cnt <= '1';
					if(cnt_100ms = '1') then --espera hasta que se cumpla la condicion de que llegue a los 100ms
						n_state <= st_Up0b;	 --llega a 100ms y pasa al siguiente estado
					else 
						n_state <= st_Up0a;	--si no ha pasado de estado sigue en este hasta que llegue a los 100ms
					end if;
				when st_Up0b =>
					en_b <= '1';
					sel <= "00";
					n_state <= st_Main;
					
		-------INCREMENTO +10--------------
		
				when st_Up1a =>
					rst_cnt <= '0';
					en_cnt <= '1';
					if(cnt_100ms = '1') then
						n_state <= st_Up1b;
					else
						n_state <= st_Up1a;
					end if;
				when st_Up1b =>
					en_b <= '1';
					sel <= "10";
					n_state <= st_Main;
					
		--------DECREMENTO -1---------------	
		
				when st_Down0a =>
					rst_cnt <= '0';
					en_cnt <= '1';
					if(cnt_100ms = '1') then
						n_state <= st_Down0b;
					else
						n_state <= st_Down0a;
					end if;
				when st_Down0b => 
					en_b <= '1';
					sel <= "01";
					n_state <= st_Main;
					
		--------DECREMENTO -10---------------	
	
				when st_Down1a =>
					rst_cnt <= '0';
					en_cnt <= '1';
					if(cnt_100ms = '1') then
						n_state <= st_Down1b;
					else
						n_state <= st_Down1a;
					end if;
				when st_Down1b =>
					en_b <= '1';
					sel <= "11";
					n_state <= st_Main;
					
		end case;
	end if;
end process;


end Behavioral;

