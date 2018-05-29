--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
-- Mahalia Polk & Mackenzie Kay
-- ECEGR 2220
-- May 30, 2018
-- Spring Quarter
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
signal i_ram : ram_type;
constant high_imp: std_logic_vector(31 downto 0) := (others => 'Z');
constant zeros: std_logic_vector(31 downto 0) := (others => '0');

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;
	
	-- This first line checks if the address is outside of our given
	-- address range, if so it sets data out to high impedance signal 
	-- composed of all 'Z's
	if (to_integer(unsigned(Address)) > 127) then
		DataOut(31 downto 0) <= high_imp(31 downto 0);
	end if;
		
	if falling_edge(Clock) then	
	-- write out on the clock edge if WE is high
		if WE = '1' then
			i_ram(to_integer(unsigned(Address))) <= DataIn;
		end if;	
    end if;
	
	-- read out from the register bank
	if OE = '0' then 
		 DataOut <= i_ram(to_integer(unsigned(Address)));
	else 
		DataOut(31 downto 0) <= high_imp(31 downto 0);
	end if;
		
		
  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;


architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

signal Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7: std_logic_vector(31 downto 0);
constant high_imp: std_logic_vector(31 downto 0) := (others => 'Z');
constant zeros: std_logic_vector(31 downto 0) := (others => '0');
signal WriteCode: std_logic_vector(5 downto 0);
signal writeEn: std_logic_vector(8 downto 0);
	
begin
	-- set up the WriteCode signal so that it can
	-- be used for encoding
	WriteCode <= WriteCmd & WriteReg;

	--encoding
	with WriteCode select writeEn <=
	"000000001" when "100000", --zero
	"000000010" when "110000", --a0
	"000000100" when "110001",	-- a1
	"000001000" when "110010",	-- a2
	"000010000" when "110011",	-- a3
	"000100000" when "110100",	-- a4
	"001000000" when "110101",	-- a5
	"010000000" when "110110",	-- a6
	"100000000" when "110111",	-- a7
	"000000000" when others;	

	-- map to each register using the coding above:
	-- note that we are using all zeroes for the enable bits because that is how 
	-- our 32 bit reg is set up in registers to write in data!
	a0:		register32 port map(WriteData, '0', '0', '0', WriteEn(1), Reg0);
	a1:		register32 port map(WriteData, '0', '0', '0', WriteEn(2), Reg1);
	a2:		register32 port map(WriteData, '0', '0', '0', WriteEn(3), Reg2);
	a3:		register32 port map(WriteData, '0', '0', '0', WriteEn(4), Reg3);
	a4:		register32 port map(WriteData, '0', '0', '0', WriteEn(5), Reg4);
	a5:		register32 port map(WriteData, '0', '0', '0', WriteEn(6), Reg5);
	a6:		register32 port map(WriteData, '0', '0', '0', WriteEn(7), Reg6);
	a7:		register32 port map(WriteData, '0', '0', '0', WriteEn(8), Reg7);
	zeros:		register32 port map(zeros, '0', '0', '0', WriteEn(0), zeros);

	-- read out register 1
	with ReadReg1 select ReadData1 <=
	zeros when "00000",
	a0 when "10000",
	a1 when "10001",
	a2 when "10010",
	a3 when "10011",
	a4 when "10100",
	a5 when "10101",
	a6 when "10110",
	a7 when "10111",
	high_imp when others;

	-- read out register 2
	with ReadReg2 select ReadData2 <=
	zeros when "00000",
	a0 when "10000",
	a1 when "10001",
	a2 when "10010",
	a3 when "10011",
	a4 when "10100",
	a5 when "10101",
	a6 when "10110",
	a7 when "10111",
	high_imp when others;

end remember;
