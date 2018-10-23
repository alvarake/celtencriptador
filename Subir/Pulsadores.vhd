------------------------------------------------------------------------------
---CONTROL DE PULSADORES
-- El bloque de control de pulsadores se encarga
-- de selecionar el valor de la clave de
-- del programa y su volumen.
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Pulsadores is
    Port ( clk : in  STD_LOGIC;							-- Reloj del sistema
           rst : in  STD_LOGIC;							-- Reset del sistema
           Up0 : in  STD_LOGIC;							-- Pulsador 0 o +1
           Down0 : in  STD_LOGIC;						-- Pulsador 1 o -1
           Up1 : in  STD_LOGIC;							-- Pulsador 2 o +10
           Down1 : in  STD_LOGIC;			  			-- Pulsador 3 o -10
			  sw6 : in  STD_LOGIC;
			 b : out  STD_LOGIC_VECTOR(5 downto 0); 	-- Clave introducida
			 v : out  STD_LOGIC_VECTOR(3 downto 0));	-- Volumen introducido
end Pulsadores;

architecture Behavioral of Pulsadores is
--Señales auxiliares
signal s_rst_cnt:STD_LOGIC;					
signal s_en_cnt:STD_LOGIC ;					
signal s_cnt_100ms:STD_LOGIC;					
signal s_rst_b:STD_LOGIC;						
signal s_en_b:STD_LOGIC ;						
signal s_sel:STD_LOGIC_VECTOR(1 downto 0);

component MooreFSM is
    Port ( clk : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           cnt_100ms : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
			  
           rst_cnt : out  STD_LOGIC;
           en_cnt : out  STD_LOGIC;
           rst_b : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component contador_100ms is
    Port ( clk : in  STD_LOGIC;
           rst_cnt : in  STD_LOGIC;
           en_cnt : in  STD_LOGIC;
           cnt_100ms : out  STD_LOGIC);
end component;

component Reg_b is
    Port ( clk : in  STD_LOGIC;
           rst_b : in  STD_LOGIC;
           en_b : in  STD_LOGIC;
			  sw6 : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
			    
           b : out  STD_LOGIC_VECTOR(5 downto 0);
			  v : out  STD_LOGIC_VECTOR(3 downto 0));
			
end component;

begin

U1: MooreFSM			--Port Map 
port map(
		clk =>clk,
      Up0 => Up0,		
      Down0 =>Down0,	
      Up1 =>Up1,		
      Down1 => Down1,
      cnt_100ms => s_cnt_100ms, 
      Rst => rst,			
		rst_cnt=> s_rst_cnt, 
		rst_b=>s_rst_b,		
		en_cnt=> s_en_cnt,	
		en_b => s_en_b,		
		sel => s_sel ) ;		

U2: contador_100ms
	port map(
		clk => clk,
		rst_cnt => s_rst_cnt, 
		en_cnt => s_en_cnt,	 
		cnt_100ms => s_cnt_100ms); 

U3: Reg_b
	port map(
		clk => clk,
		rst_b =>s_rst_b,	
		en_b =>s_en_b,		
		sel => s_sel,
      v => v,
		sw6 => sw6,
		b => b);				
		
end Behavioral;


