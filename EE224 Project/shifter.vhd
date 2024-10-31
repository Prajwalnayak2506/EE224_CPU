library ieee;
use ieee.std_logic_1164.all;

entity shifter is
	port (A: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0));
end shifter;

architecture bhv of shifter is
begin
	outp <= A(14 downto 0)&"0";
end bhv;