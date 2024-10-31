library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port (
			clock: in std_logic;
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	sel: in std_logic_vector(3 downto 0);
	X: out std_logic_vector(15 downto 0));
end alu;

architecture a1 of alu is
function add(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	   variable sum : std_logic_vector(15 downto 0) := (others => '0');
		variable carry : std_logic_vector(15 downto 0) := (others => '0');
    begin
		L1: for i in 0 to 15 loop
		  if i = 0 then
  	      sum(i) := A(i) xor B(i) xor '0';
		  carry(i) := A(i) and B(i);
	  else 
	    sum(i) := A(i) xor B(i) xor carry(i-1);
		 carry(i) := (A(i) and B(i)) or (carry(i-1) and (A(i) xor B(i)));
	  end if;
	end loop L1;
  return sum;
end add;

function anding(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	  variable s : std_logic_vector(15 downto 0) := (others => '0');
    begin
		L1: for i in 0 to 15 loop
		 s(i) := A(i) and B(i);
		end loop L1;
  return s;
end anding;

function ora(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	  variable s : std_logic_vector(15 downto 0) := (others => '0');
    begin
		L1: for i in 0 to 15 loop
		 s(i) := A(i) or B(i);
		end loop L1;
  return s;
end ora;

function imp(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	  variable s : std_logic_vector(15 downto 0) := (others => '0');
    begin
		L1: for i in 0 to 15 loop
		 s(i) := (not A(i)) or B(i);
		end loop L1;
  return s;
end imp;


function comp(A: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	  variable s,t : std_logic_vector(15 downto 0) := (others => '0');
    begin
		L1: for i in 0 to 15 loop
		 s(i) := (not A(i));
		 
		end loop L1;
		t := add(s,"0000000000000001");
  return t;
end comp;

function mul(A: in std_logic_vector(3 downto 0);
    B: in std_logic_vector(3 downto 0))
    return std_logic_vector is
	         variable temp_result : std_logic_vector(6 downto 0);
    begin
        temp_result := (others => '0');

        for i in 0 to 3 loop
            for j in 0 to 3 loop
                if ((A(i) = '1') and (B(j) = '1')) then
                    temp_result(i + j) := temp_result(i + j) xor '1';
                end if;
            end loop;
        end loop;

  return temp_result;
end mul;

function lli(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	         variable temp_result : std_logic_vector(15 downto 0);
    begin
        temp_result:= "00000000"&A(7 downto 0);       

  return temp_result;
end lli;

function lhi(A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0))
    return std_logic_vector is
	         variable temp_result : std_logic_vector(15 downto 0);
    begin
        temp_result:= A(7 downto 0)&"00000000";       

  return temp_result;
end lhi;


begin
alu_proc: process(A, B, sel)
variable temp,temp1: std_logic_vector(15 downto 0);
variable temp2: std_logic_vector(6 downto 0);
begin
    if sel="0000" then 
      temp := add(A,B);
	   X<= temp(15 downto 0);
    elsif sel="0001" then
	   temp1:= comp(A);
      temp := add(temp1,B);
		X<=temp(15 downto 0);
    elsif sel="0010" then
      temp2 := mul(A(3 downto 0), B(3 downto 0));
		X <= "000000000"&temp2(6 downto 0);
	 elsif sel="0100" then
      temp := anding(A, B);
		X <= temp;
	 elsif sel="0101" then
      temp := ora(A, B);
		X <= temp;
	 elsif sel="0110" then
      temp := imp(A,B);
		X <= temp;
	elsif sel="0011" then
      temp := lhi(A,B);
		X <= temp;
	elsif sel="0111" then
      temp := lli(A,B);
		X <= temp;
	 else
      null;
    end if;
	
end process;
end a1;