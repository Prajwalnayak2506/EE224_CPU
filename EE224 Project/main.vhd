library std;
use std.standard.all;
----------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------------------------------------------------------------
library work;
use work.Gates.all;
----------------------------------------------------------------------------------------------------------------------------------------
entity main is
	port(clock, reset: in std_logic;
			output : out std_logic);
end main;
-----------------------------------------------------------------------------------------------------------------------------------------
architecture bhv of main is
--Including the components
component shifter is
	port (A: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0));
end component;

	component alu is
		port (
		clock: in std_logic;
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		sel: in std_logic_vector(3 downto 0);
		X: out std_logic_vector(15 downto 0));
	end component;
	
		component temporary_register is
		port (clock, reset: in std_logic; 
        temp_write : in std_logic_vector(15 downto 0);
        temp_read : out std_logic_vector(15 downto 0);
        temp_W : in std_logic);
	end component;
	
	component register_file is 
-- PC is R7 so incorporating it in register file itself
		port(
			clock, reset, PC_w, RF_W : in std_logic;
			A1, A2, A3 : in std_logic_vector(2 downto 0);
			D3, PC_write : in std_logic_vector(15 downto 0);
			D1, D2, PC_read: out std_logic_vector(15 downto 0));
	end component;
	
	component memory is 
		port(
			 M_add, M_inp : in std_logic_vector(15 downto 0);
			 M_data : out std_logic_vector(15 downto 0);
			 clock, Mem_R, Mem_W : in std_logic);
	end component;
	
		component se7 is
		port (A: in std_logic_vector(8 downto 0);
				outp: out std_logic_vector(15 downto 0));
	end component;	
	
	component se10 is
		port (A: in std_logic_vector(5 downto 0);
				outp: out std_logic_vector(15 downto 0));
	end component;
	
	component se8 is
	
	port (A: in std_logic_vector(7 downto 0);
			outp: out std_logic_vector(15 downto 0));
   end component;

	component MUX_1X2_16BIT is 
		port (A,B: in std_logic_vector(15 downto 0) ;Sig_16BIT: in std_logic;Y: out std_logic_vector(15 downto 0));
	end component;
	
	component MUX_4x1_16BIT is 
		port (D3,D2,D1,D0 : in std_logic_vector(15 downto 0);C_1,C_0: in std_logic; Y : out std_logic_vector(15 downto 0));
	end component;
	
	component DEMUX_1X2_16BIT is 
		port (A : in std_logic_vector(15 downto 0) ;S_16BIT : in std_logic;
				Y1,Y0 : out std_logic_vector(15 downto 0));
	end component;
	
	component MUX_8X1_16BIT is 
	  port (A7,A6,A5,A4,A3,A2,A1,A0 :in std_logic_vector( 15 downto 0);
       S_2,S_1,S_0: in std_logic;Y : out std_logic_vector(15 downto 0));
	 end component;
	 
	 component MUX_4x1_3BIT is 
			port(A,B,C,D: in std_logic_vector(2 downto 0);S1,S0: in std_logic; Y: out std_logic_vector(2 downto 0));
	end component;
	
		component MUX_1X2_5BIT is 
		port (A,B: in std_logic_vector(5 downto 0) ;Sig_16BIT: in std_logic;Y: out std_logic_vector(5 downto 0));
	end component;
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Signals used
	type state is (rst,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13);--
	signal state_present,state_next: state:=rst;--
	signal m1_op,pc_op,t4_op,m2_op,m3_op,shifter_op,shifter1_op,m10_op,m_data,dm_op1,dm_op2,se10_op,se8_op,se7_op,m5_op,rf_d1,rf_d2,m6_op,m7_op,t1_op,t2_op,t3_op,m8_op,m9_op,alu_x: std_logic_vector(15 downto 0):="0000000000000000";
	signal t1_11_9,t1_5_3,t1_8_6,y: std_logic_vector(2 downto 0);--y is mux 4 outp
	signal t1_8_0: std_logic_vector(8 downto 0);--
	signal t1_5_0: std_logic_vector(5 downto 0);--
	signal a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,r,s,w,pc_w,t1_w,t2_w,t3_w,t4_w,mem_w,mem_r,rf_w: std_logic:='0';--
	signal sel: std_logic_vector(3 downto 0):="1111";--
	
begin
-- Instantiation of the components as given in the port map diagram
   shift1: shifter port map (se10_op,shifter_op);
   shift2: shifter port map (se7_op,shifter1_op);
	rf: register_file port map(clock,reset,pc_w,rf_w,y,t1_8_6,y,m5_op,m1_op,rf_d1,rf_d2,pc_op);--
	memory_main: memory port map(m2_op,m3_op,m_data,clock,mem_r,mem_w);--
	t1: temporary_register port map(clock,reset,dm_op2,t1_op,t1_w);--
	t2: temporary_register port map(clock,reset,m6_op,t2_op,t2_w);--
	t3: temporary_register port map(clock,reset,m7_op,t3_op,t3_w);--
	t4: temporary_register port map(clock,reset,pc_op,t4_op,t4_w);--
	alu_main: alu port map(clock,m8_op,m9_op,sel,alu_x);--
	se7_main: se7 port map(t1_8_0,se7_op);--
	se10_main: se10 port map(t1_5_0,se10_op);--
	--se8_main: se8 port map(t1_5_0,se8_op);
	m1: MUX_1X2_16BIT port map(alu_x,t3_op,a,m1_op);--
	m2: MUX_4x1_16BIT port map("0000000000000000",pc_op,t3_op,t2_op,b,c,m2_op);--
	m3: MUX_1X2_16BIT port map(t3_op,t2_op,s,m3_op);--
	m4: MUX_4x1_3BIT port map ("000",t1_8_6,t1_5_3,t1_11_9,e,f,y);--
	m5: MUX_4x1_16BIT port map("0000000000000000",t2_op,t3_op,t4_op,j,k,m5_op);--
	m6: MUX_1X2_16BIT port map(alu_x,rf_d1,g,m6_op);--
	m7: MUX_4x1_16BIT port map(alu_x,rf_d2,rf_d1,dm_op1,h,i,m7_op);--
	m8: MUX_8X1_16BIT port map("0000000000000000","0000000000000000","0000000000000000",t3_op,t4_op,pc_op,t2_op,m10_op,r,l,m,m8_op);--
	m9: MUX_4x1_16BIT port map(m10_op,shifter1_op,t3_op,"0000000000000001",n,p,m9_op);--
	m10: MUX_1X2_16BIT port map(se10_op,shifter_op, w, m10_op);--
	demux: DEMUX_1X2_16BIT port map(m_data,d,dm_op2,dm_op1);--
-----------------------------------------------------------------------------------------------------------------------------------------------
--Breaking the t1_op signal into the required parts
	t1_11_9<=t1_op(11 downto 9);
	t1_8_6<=t1_op(8 downto 6);
	t1_5_3<=t1_op(5 downto 3);
	t1_8_0<=t1_op(8 downto 0);
	t1_5_0<=t1_op(5 downto 0);
-------------------------+------------------------------+--------------------------+-----------------------------------------	
--Clock process
clk_process: process(clock,reset)
	begin
	if (reset = '1') then
		state_present <= s1;
	elsif (clock='1' and clock' event) then
		state_present <= state_next;
	else
		null;
	end if;
end process;

--Process for control signals
----------------------------------------------------------------------------------------------------------------------------------------
output_process: process(state_present,t1_op,t3_op,t2_op,t1_8_0)
	begin
		a<='0';--mux1
		b<='0';--mux2
		c<='0';--mux2
		d<='0';--demux
		e<='0';--mux4
		f<='0';--mux4
		g<='0';--mux6
		h<='0';--mux7
		i<='0';--mux7
		j<='0';--mux5
		k<='0';--m5
		l<='0';--m8
		m<='0';--m8
		n<='0';--m9
		p<='0';--m9
		r<='0';--m8
		s<='0';--m3
		w<='0';
		mem_r<='0';
		mem_w<='0';
		pc_w<='0';
		t1_w<='0';
		t2_w<='0';
		t3_w<='0';
		t4_w<='0';
		sel<="1111";
		rf_w<='0';
-------------------------------------------------------------------------------------------------------------
	case state_present is
	when s1=>
		a<='1'; --a=1 lets alu_x to enter pc, a=0 would let T3 to write into pc
		b<='1'; --bc = "11"=>0000, bc = "10" lets pc_op into the memory address, bc="01" lets T3 into memory address and bc="00" lets T2 into memory adress 
		d<='1';
		l<='1';
		mem_r<='1'; -- allows to read what value is present at the memory adress which is given as input
		pc_w<='1'; -- allows modification of pc
		t1_w<='1';
		t4_w<='1';
		sel<="0000";
-------------------------------------------------------------------------------------------------------
	when s2=> 
		h<='1';
		t2_w<='1';
		t3_w<='1';
		if (t1_op(15 downto 12) = "1100") then
		w <='1';
		else
		w<='0';
		end if;
		sel<="1111";
-------------------------------------------------------------------------------------------------------
	when s3=>
		if (t1_op (14 downto 12) = "000") then --add
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0000";
		elsif (t1_op (14 downto 12) = "010") then --sub
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0001";
		elsif (t1_op (14 downto 12) = "011") then --mul
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0010";		
		elsif (t1_op (14 downto 12) = "100") then  --and
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0100";		
		elsif (t1_op (14 downto 12) = "101") then  --ora
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0101";		
		elsif (t1_op (14 downto 12) = "110") then  --imp
			t2_w<='1';
			g<='1';
			m<='1';
			p<='1';
			sel<="0110";					
		else null;
		end if;
---------------------------------------------------------------------------------------------------------------
	when s4=>
		if (t1_op(15 downto 12) = "1000") then -- lhi/lli
			e<='1';
			f<='1';
		elsif ((t1_op(15 downto 12) = "0000") or (t1_op(15 downto 12) = "0010") or (t1_op(15 downto 12) = "0011")) then --add/sub/mul
			e<='0';
			f<='1';
		elsif ((t1_op(15 downto 12) = "0100") or (t1_op(15 downto 12) = "0101") or (t1_op(15 downto 12) = "0110")) then --and/or/imp
			e<='0';
			f<='1';
		elsif (t1_op(15 downto 12) = "0001") then --adi
			e<='1';
			f<='0';
		else
			null;
		end if;
		j<='1';
		sel<="1111";
		rf_w<='1';
----------------------------------------------------------------------------------------------------------------
	when s5=>
		g<='1';
		m<='1';
		n<='1';
		t2_w<='1';
		sel<="0000";
----------------------------------------------------------------------------------------------------------------
	when s6=>
		g<='1';
		t2_w<='1';
		if (t1_op(15 downto 12)="1000") then
		sel<="0011";
		elsif (t1_op(15 downto 12)="1001") then
		sel<="0111";
		else null;
		end if;
		
----------------------------------------------------------------------------------------------------------------
	when s7=>
		h<='1';
		i<='1';
		n<='1';
		r<='1';
		t3_w<='1';
		sel<="0000";
--------------------------------------------------------------------------------------------------------------------------
	when s8=>
		c<='1';
		mem_r<='1';
		t3_w<='1';
		sel<="1111";
----------------------------------------------------------------------------------------------------------------------------
	when s9=>
		c<='1';
		mem_w<='1';
		sel<="1111";
-------------------------------------------------------------------------------------
	when s10=>
		if (t1_op(13)='1') then
			if (t2_op=t3_op) then
				pc_w<='1';
				a<='1';
				l<='1';
				m<='1';
				n<='1';
				sel<="0000";
			else --nothing must be done
				sel<="1111";
			end if;	
		else 		
			l<='1';
			m<='1';
			n<='1';
			sel<="0000";
			a<='1';
			pc_w<='1';
		end if;
-------------------------------------------------------------------------------------------------------------
	when s11=>
		sel<="1111";
		rf_w<='1';
-------------------------------------------------------------------------------------------------------------
	when s12=>
		pc_w<='1';
		sel<="1111";
-----------------------------------------------------------------------------------------------------
	when s13=> 
		k<='1';
		rf_w<='1';
		sel<="1111";
---------------------------------------------------------------------------------------------------------------------------------
	when others=>
		null;
	end case;
end process;
---------------------------------------------------------------------------------------------------------------------------------

--State Transition process
state_transition: process(state_present,t1_op,t1_8_0)
	begin
	state_next<=state_present;
	case state_present is
	when rst=>
		state_next<=s1;
	when s1=>
		state_next<=s2;
	when s2=>
		case t1_op(15 downto 12) is
			when "0000"=>
				state_next<=s3;
			when "0010"=>
				state_next<=s3;
			when "0011"=>
				state_next<=s3;
			when "0001"=>
				state_next<=s5;
			when "0100"=>
				state_next<=s3;
			when "0101"=>
				state_next<=s3;
			when "0110"=>
				state_next<=s3;
			when "1000"=>
				state_next<=s6;
			when "1001"=>
				state_next<=s6; ---lli to be changed maybe
			when "1010"=>
				state_next<=s7;
			when "1011"=>
				state_next<=s7;
			when "1100"=>
				state_next<=s10;
			when "1101"=>
				state_next<=s11;
			when "1111"=>
				state_next<=s11;
			when others=>
				null;
		end case;
	when s3=>
		state_next<=s4;
		
---------------------------------------------------------------------------------------------------------------
	when s4=>
		state_next<=s1;
	when s5=>
		state_next<=s4;
	when s6=>
		state_next<=s4;
	when s7=>
		if (t1_op(15 downto 12) = "1010") then --decoder to decide which state to go to
			state_next<=s8;
		elsif (t1_op(15 downto 12) = "1011") then
			state_next<=s9;
		else null;
		end if;
	when s8=>
		state_next<=s13;
	when s9=>
		state_next<=s1;
	when s10=>
			state_next<=s1;
	when s11=>
		if (t1_op(15 downto 12) = "1101") then
			state_next<=s10;
		elsif (t1_op(15 downto 12) = "1111") then
			state_next<=s12;
		else null;
		end if;
	when s12=>
		state_next<=s1;
	when s13=>
		state_next<=s1;
	when others=>
		null;
	end case;
end process;
----------------------------------------------------------------------------------------------------------------------------------------
--The output for the RTL Simulation has been set to '0', as a dummy output.
output <= '0';
end bhv;
	