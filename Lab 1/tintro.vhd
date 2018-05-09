LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY testintro is
 	PORT (inst : BUFFER std_logic_vector(6 downto 0)
);
END testintro;

ARCHITECTURE only of testintro is

COMPONENT intro is
	PORT (
		A	: IN STD_LOGIC;
		B	: IN STD_LOGIC;
		C	: IN STD_LOGIC;
		D	: IN STD_LOGIC;
		E	: OUT STD_LOGIC);
END COMPONENT;

--Inputs
	SIGNAL Adriver :  std_logic := '0';
	SIGNAL Bdriver :  std_logic := '0';
	SIGNAL Cdriver :  std_logic := '0';
	SIGNAL Ddriver :  std_logic := '0';
	
--Outputs
	SIGNAL Eshow :  std_logic;
	
BEGIN
  	-- Instantiate the Unit Under Test (UUT)
	uut: intro PORT MAP(
    A => Adriver,
    B => Bdriver,
    C => Cdriver,
    D => Ddriver,
    E => Eshow
    );
    
	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- test exhaustively
		Adriver <= '0';
		Bdriver <= '0';
		Cdriver <= '0';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '0';
		Cdriver <= '0';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '0';
		Cdriver <= '1';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '0';
		Cdriver <= '1';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '1';
		Cdriver <= '0';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '1';
		Cdriver <= '0';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '1';
		Cdriver <= '1';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '0';
		Bdriver <= '1';
		Cdriver <= '1';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '0';
		Cdriver <= '0';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '0';
		Cdriver <= '0';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '0';
		Cdriver <= '1';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '0';
		Cdriver <= '1';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '1';
		Cdriver <= '0';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '1';
		Cdriver <= '0';
		Ddriver <= '1';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '1';
		Cdriver <= '1';
		Ddriver <= '0';
		wait for 20 ns;
		Adriver <= '1';
		Bdriver <= '1';
		Cdriver <= '1';
		Ddriver <= '1';
	

		wait; -- will wait forever
	END PROCESS;

END;    

