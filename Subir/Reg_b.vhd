----------------------------------------------------------------------------------
--REG_b
--Este registro contiene en binario el valor del código introducido por el usuario, b. En su
--funcionalidad se incorpora también que el registro sea capaz de variar su valor (en función de lo que
--indiquen las señales que provienen de la máquina de estados de Moore), y que no se excedan los
--límites máximos y mínimos permitidos (0-63)
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;


entity Reg_b is
    Port ( clk : in  STD_LOGIC;							--Reloj del sistema
           rst_b : in  STD_LOGIC;						-- Rst de b
           en_b : in  STD_LOGIC;							-- Enable de b
           sel : in  STD_LOGIC_VECTOR(1 downto 0);	-- Señal de control de suma o resta
           sw6: in STD_LOGIC;								-- Modo volumne o contraseña
			  v : out  STD_LOGIC_VECTOR(3 downto 0);	-- Valor almacenado en  Volumen
			  b : out  STD_LOGIC_VECTOR(5 downto 0));	-- Valor de la contraseña almacenado
end Reg_b;

architecture Behavioral of Reg_b is
signal s_Reg_b : STD_LOGIC_VECTOR(5 downto 0); -- señal auxiliar para poder usar correctamente el b.
signal s_Reg_v : STD_LOGIC_VECTOR(3 downto 0); -- señal auxiliar para poder usar correctamente el volumen.

begin
process (rst_b, clk,s_Reg_b,sel) --Proceso que actualiza el valor de b y de v segun lo que se ha pulsado
begin 
  if (rst_b = '1') then s_Reg_b <= "000000"; s_Reg_v <= "0101";              -- Asignación del valor por defecto con el Reset
  elsif clk'event and clk='1' then    
    if en_b = '1' then 
		if sw6 = '0' then
			if ((sel = "00") and (s_Reg_b < "111111")) then s_Reg_b <= s_Reg_b + "01";         -- Incremento +1 de la señal 
			end if;     																							  -- Ponemos "111111" ya que es la maximo numero(63) no podemos sumar mas de este numero
			if ((sel = "01") and (s_Reg_b > "000000")) then s_Reg_b <= s_Reg_b - "01";         -- Decremento -1 de la señal 
			end if;     																							  -- Ponemos "000000" ya que es el minimo valor es 0
			if ((sel = "10") and (s_Reg_b < "110110")) then s_Reg_b <= s_Reg_b + "01010";      -- Incremento +10 de la señal 
			end if;     																							  -- Ponemos  "110110" que es el numero 54 y no podremos sumar 10 a ese numero
			if ((sel = "11") and (s_Reg_b > "001001")) then s_Reg_b <= s_Reg_b - "01010";      -- Decremento -10 de la señal 
			end if; 																									  -- Ponemos "001001" que es 9 como valor minimo para no restar y sobrepasar el 0.
		elsif sw6 ='1' then
			if ((sel = "00") and (s_Reg_v < "1001")) then s_Reg_v <= s_Reg_v + "01";         -- Incremento +1 de la señal 
			end if;     																							  -- Ponemos "111111" ya que es la maximo numero(63) no podemos sumar mas de este numero
			if ((sel = "01") and (s_Reg_v > "0001")) then s_Reg_v <= s_Reg_v - "01";         -- Decremento -1 de la señal 
			end if;
		end if;
	end if; 
  end if; 
 b<=s_Reg_b; 
 v<=s_Reg_v;
end process;


end Behavioral;

