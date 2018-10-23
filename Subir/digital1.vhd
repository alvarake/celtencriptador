----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:29:01 10/25/2016 
-- Design Name: 
-- Module Name:    digital1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digital1 is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR(0 to 6));
end digital1;


architecture Behavioral of digital1 is

--signal s_Incr0:STD_LOGIC;
--signal s_Incr1:STD_LOGIC;
--signal s_Dec0:STD_LOGIC;
--signal s_Dec1:STD_LOGIC;
--signal s_RST:STD_LOGIC;
--signal s_Sel:STD_LOGIC_VECTOR (3 downto 0);
--signal s_Dato:STD_LOGIC_VECTOR (6 downto 0);
signal s_b:STD_LOGIC_VECTOR (5 downto 0);
--signal s_din:STD_LOGIC;
--signal s_ssclk:STD_LOGIC;
--signal s_cs0:STD_LOGIC;
--signal s_cs1:STD_LOGIC;
--signal s_dout:STD_LOGIC;

Component control_displays is
    Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6));
end component;

Component Pulsadores is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           b : out  STD_LOGIC_VECTOR(5 downto 0));
end component;

begin
U1:Pulsadores
port map(
clk=>clk,
Up0=>Up0,
Up1=>Up1,
Down0=>Down0,
Down1=>Down1,
rst=>Rst,
b=>s_b);
--(
--clk=>clk,
--Up0=>s_Incr0,
--Up1=>s_Incr1,
--Down0=>s_Dec0,
--Down1=>s_Dec1,
--rst=>s_RST,
--b=>s_b);

U2:control_displays
port map(
clk=>clk,
b=>s_b,
Disp0=>Disp0,
Disp1=>Disp1,
Disp2=>Disp2,
Disp3=>Disp3,
Seg7=>Seg7);

--(
--clk=>clk,
--b=>s_b,
--Disp0=>s_Sel(0),
--Disp1=>s_Sel(1),
--Disp2=>s_Sel(2),
--Disp3=>s_Sel(3),
--Seg7=>s_Dato);


end Behavioral;

