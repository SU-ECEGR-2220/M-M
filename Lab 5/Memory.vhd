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

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
begin
    -- Add your code here for the Register Bank implementation

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------
		 	REGISTER BANK ENTITY
-------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------
			SINGLE BIT FLIP FLOP
--------------------------------------------------------------------------





-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------
			8 BIT REGISTER
--------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	--using bitstorage from above as a component	
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- insert your code here.
	--Code: using generate to instantiate the register
	
	REG_GEN:
		FOR r8 IN 0 TO 7 GENERATE
			R0: bitstorage PORT MAP(datain(r8), enout, writein, dataout(r8));
		END GENERATE;
end architecture memmy;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------
			32 BIT REGISTER
---------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
COMPONENT register8		--this defines the 8bit register as a usable component
		PORT(datain: IN std_logic_vector(7 DOWNTO 0);
	    	enout:  IN std_logic;
	     	writein: IN std_logic;
	     	dataout: OUT std_logic_vector(7 DOWNTO 0));
	END COMPONENT;
	--enable created as a vector, used to enable the 4 components of the 32
	--bit register.
	SIGNAL 	enable: std_logic_vector(3 DOWNTO 0);
	SIGNAL	writein: std_logic_vector(3 DOWNTO 0);
begin
	-- insert code here.
	-- instantiating the register
	-- creating the structure for each component, set enables
	enable <= 	"0000" WHEN enout32 = '0' ELSE
				"1100" WHEN enout32 = '1' AND enout16 = '0' ELSE
				"1110" WHEN enout32 = '1' AND enout16 = '1' AND enout8 = '0' ELSE
				"1111" WHEN enout32 = '1' AND enout16 = '1' AND enout8 = '1';
	
	writein <=	"1111" WHEN writein32 = '1' ELSE
				"0011" WHEN writein32 = '0' AND writein16 = '1' ELSE
				"0001" WHEN writein32 = '0' AND writein16 = '0' AND writein8 = '1' ELSE
				"0000" WHEN writein32 = '0' AND writein16 = '0' AND writein8 = '0';

	-- using component of 8 bit register; stack of 4 8Bits creates a 32Bit reg:
R1: register8 PORT MAP(datain(7 DOWNTO 0), enable(0), writein(0), dataout(7 DOWNTO 0));
R2: register8 PORT MAP(datain(15 DOWNTO 8), enable(1), writein(1), dataout(15 DOWNTO 8));
R3: register8 PORT MAP(datain(23 DOWNTO 16), enable(2), writein(2), dataout(23 DOWNTO 16));
R4: register8 PORT MAP(datain(31 DOWNTO 24), enable(3), writein(3), dataout(31 DOWNTO 24));


end architecture biggermem;