--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	-- Signals
	signal direction: std_logic; --direction of the shift register
	signal operation: std_logic; --operation of the adder/subtractor 
	signal addsub_res: std_logic_vector(31 downto 0); --result of the adder/subtractor
	signal shift_res: std_logic_vector(31 downto 0); --result of the shifter
	signal op_res: std_logic_vector(31 downto 0); --result of the operation
	constant zeros: std_logic_vector(31 downto 0) := (others => '0'); --zero vector for comparison
	signal carry: std_logic; -- use for adder_subtractor port map	
begin
	-- Add ALU VHDL implementation here
   
	-- use first bit of Control input to decide direction
	with ALUCtrl(0) select direction <=
	'0' when '0', --SLL (left) 
	'1' when '1', --SLR (right)
	'0' when others; --set to high impedence for others

	with ALUCtrl(0) select operation <=
	'0' when '0', -- add
	'1' when '1', -- subtract
	'0' when others;


	shift: shift_register PORT MAP(DataIn1(31 downto 0), direction, DataIn2(4 downto 0), shift_res(31 downto 0)); -- perform shift 
	add_sub: adder_subtracter PORT MAP(DataIn1(31 downto 0), DataIn2(31 downto 0), operation, addsub_res(31 downto 0), carry); --add/sub
	
	--encode the operations:
	with ALUCtrl select op_res <=
	addsub_res(31 downto 0) when "00000", -- adder (add/addi)
	addsub_res(31 downto 0) when "00001", -- subtractor
	shift_res(31 downto 0) when "10000", -- SLL
	shift_res(31 downto 0) when "10001", -- SLR
	(DataIn1(31 downto 0) AND DataIn2(31 downto 0)) when "00100", -- AND/ANDI
	(DataIn1(31 downto 0) OR DataIn2(31 downto 0)) when "00110", -- OR/ORI
	DataIn2(31 downto 0) when "00111", -- Pass Through DataIn2
	zeros when others; -- sets the result to 0 if no approved operation was input
	


	ALUResult(31 downto 0) <= op_res(31 downto 0); -- get the result

	process(op_res) is
	begin
		if(op_res = zeros) then
			Zero <= '1'; -- tell the user that the result was all 0s
		else 
			Zero <= '0'; -- tell the user the operation was performed, no issue
		end if;
	end process;

end architecture ALU_Arch;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
-- use the fulladder from above
COMPONENT fulladder 
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end COMPONENT;
-- use cary32 as the register for adding
-- use hold to work through the operations
SIGNAL carry32: std_logic_vector(32 DOWNTO 0);
SIGNAL hold: std_logic_vector(31 DOWNTO 0);

begin
	
	carry32(0) <= add_sub; -- no carry in for the first bit
	-- this will flip the bits of datain_b if add_sub is '1'
	-- i.e. if it is a subtraction operation
	holdReg: for i in 31 downto 0 GENERATE
		holdit: hold(i) <= datain_b(i) xor add_sub;
	END GENERATE;

	-- use the full adder component via port-mapping 
	-- to complete the addition now that the subtraction
	-- posibility has been taken care of
	addOp: for j in 0 to 31 generate
		totSum: fulladder PORT MAP(datain_a(j), hold(j), carry32(j), dataout(j), carry32(j+1));	
	end generate; 
	
	co <= carry32(32); -- assign the final carry out
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic; --direction
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	SIGNAL shift: std_logic_vector(5 downto 0);
begin
	-- shift vector gets the direction and shift amount
	shift <= dir & shamt;
	-- insert code here.
	-- using with/select for concurrency
	WITH shift SELECT dataout(31 downto 0) <=
		datain(28 downto 0) & "000" WHEN "000011",
		datain(29 downto 0) & "00" WHEN "000010",
		datain(30 downto 0) & "0" WHEN "000001",
		"000" & datain(28 downto 0) WHEN "100011",
		"00" & datain(29 downto 0) WHEN "100010",
		"0" & datain(30 downto 0) WHEN "100001",
		datain(31 downto 0) WHEN OTHERS;

end architecture shifter;
