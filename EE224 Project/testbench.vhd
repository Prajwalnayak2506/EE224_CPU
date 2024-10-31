library ieee;
use ieee.std_logic_1164.all;

entity TESTBENCH is
end;

architecture TB_BHV of TESTBENCH is

component main is
	port(clock, reset: in std_logic;
			output : out std_logic);
end component main;
signal clk : std_logic:='0';
signal outputdub : std_logic;
	
begin
clk <= not clk after 2 ms;
Trf : main port map (clk,'0',outputdub);

end TB_BHV;