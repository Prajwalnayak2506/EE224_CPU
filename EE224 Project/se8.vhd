library ieee;
use ieee.std_logic_1164.all;

entity se8 is
	--This component increases the size of a 8 bit vector to 16 bit vector, keeping the value of the vector same
	port (A: in std_logic_vector(7 downto 0);
			outp: out std_logic_vector(15 downto 0));
end se8;

architecture bhv of se8 is
begin
	outp <= "00000000"&A;
end bhv;