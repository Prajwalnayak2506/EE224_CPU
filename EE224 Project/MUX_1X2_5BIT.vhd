Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_1X2_5BIT is 
  port (A,B:in std_logic_vector(5 downto 0);Sig_5BIT: in std_logic;Y: out std_logic_VECTOR(5 downto 0));
  end entity MUX_1X2_5BIT ;


architecture Struct of MUX_1X2_5BIT is

 component MUX_2_1  is
  port (S, A, B: in std_logic; Y: out std_logic);
end component MUX_2_1;

  --signal y_1,y_0 : std_logic;
  
  
  begin 
  
	M0 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(5), B => B(5) , Y => Y(5));
	M1 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(4), B => B(4) , Y => Y(4));
   M2 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(3), B => B(3) , Y => Y(3));
	M3 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(2), B => B(2) , Y => Y(2));
	M4 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(1), B => B(1) , Y => Y(1));
	M5 : MUX_2_1 port map ( S => Sig_5BIT, A=> A(0), B => B(0) , Y => Y(0));
end Struct;