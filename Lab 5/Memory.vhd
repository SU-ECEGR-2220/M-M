--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
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
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	
		if WE = 1 then
			i_ram(to_intger(unsigned(Address)))(31 downto 0) <= DataIn(31 downto 0);
		end if
	
    end if;

	-- Rest of the RAM implementation
		if OE = 0 then 
			 DataOut(31 downto 0) <= i_ram(to_intger(unsigned(Address)))(31 downto 0);
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

signal R0, R1, R2, R3, R4, R5, R6, R7: std_logic_vector(31 downto 0);


architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
begin
	
R0 <= writeData when WriteCmd&Writereg = "100001";
R1 <= writeData when WriteCmd&Writereg = "100001";
R2 <= writeData when WriteCmd&Writereg = "100011";
R3 <= writeData when WriteCmd&Writereg = "100100";
R4 <= writeData when WriteCmd&Writereg = "100101";
R5 <= writeData when WriteCmd&Writereg = "100110";
R6 <= writeData when WriteCmd&Writereg = "100111";
R7 <= writeData when WriteCmd&Writereg = "101000";    

end remember;
