--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

begin
	-- Add signals

	-- MUXES
	signal MUXtoALU: std_logic_vector(31 downto 0); -- mux output to ALU
	signal MUXtoWD: std_logic_vector(31 downto 0); -- mux output to write data register from DM or ALU
	signal MUXtoPC: std_logic_vector(31 downto 0); -- mux output to PC from ADD/SUM

	--Control
	signal Ctrl_branch: std_logic_vector(1 downto 0); -- Control to branch: eq/not eq
	signal Ctrl_MemRead: std_logic;			  -- Control to data memory
	signal Ctrl_MemtoReg: std_logic;		  -- Control to MUX
	signal Ctrl_ALUCtrl: std_logic_vector(4 downto 0); -- Control to ALU
	signal Ctrl_MemWrite: std_logic;		  -- Control to data memory
	signal Ctrl_ALUSrc: std_logic;			  -- Control to MUX
	signal Ctrl_RegWrite: std_logic;		  -- Control to registers
	signal Ctrl_ImmGen: std_logic_vector(1 downto 0); -- Control to Imm Gen

	--Instruction Memory
	signal Instr_mem: std_logic_vector(31 downto 0);  -- Intruction memory to ctrl, registers, and imm gen

	--PC Out
	signal PC_Out: std_logic_vector(31 downto 0); -- PC to instruction memory

	--Registers
	signal Read_Data_1: std_logic_vector(31 downto 0);  -- registers to ALU
	signal Read_Data_2: std_logic_vector(31 downto 0);  -- registers to MUX

	--ALU
	--others

begin
	Ctrl: Control port map(clock, instruction(6 downto 0), instruction(14 downto 12), instruction(31 downto 27), Ctrl_branch, Ctrl_MemRead, Ctrl_MemtoReg, Ctrl_ALUCtrl, Ctrl_RegWrite, Ctrl_ImmGen);

	PC: ProgramCounter port map(reset, clock, 



end holistic;

