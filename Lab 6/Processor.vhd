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
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0); --ALUOP
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
	    Port(	ReadReg1: in std_logic_vector(4 downto 0); 
                ReadReg2: in std_logic_vector(4 downto 0); 
                WriteReg: in std_logic_vector(4 downto 0);
				WriteData: in std_logic_vector(31 downto 0);
				WriteCmd: in std_logic;
				ReadData1: out std_logic_vector(31 downto 0);
		 		ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	Port(	Reset:	  in std_logic;
		 		Clock:	  in std_logic;
				Address: in std_logic_vector(29 downto 0);
		 		DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	Port(	Reset:	  in std_logic;
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

	-- Add signals
	-- changed separated signals based on operation
	--Program Counter
	signal PC_Out: std_logic_vector(31 downto 0);

	--Adder Signals
	signal addOut1: std_logic_vector(31 downto 0);
	signal addOut2: std_logic_vector(31 downto 0);
	signal co1, co2: std_logic;

	--The Instriction Mem Output
	signal Instr_mem: std_logic_vector(31 downto 0);

	--Control Outputs
	signal Ctrl_branch: std_logic_vector(1 downto 0); -- Control to branch: eq/not eq
	signal Ctrl_MemRead: std_logic;			  -- Control to data memory
	signal Ctrl_MemtoReg: std_logic;		  -- Control to MUX
	signal Ctrl_ALUCtrl: std_logic_vector(4 downto 0); -- Control to ALU
	signal Ctrl_MemWrite: std_logic;		  -- Control to data memory
	signal Ctrl_ALUSrc: std_logic;			  -- Control to MUX
	signal Ctrl_RegWrite: std_logic;		  -- Control to registers
	signal Ctrl_ImmGen: std_logic_vector(1 downto 0); -- Control to Imm Gen

	--Register Outputs
	signal Read1: std_logic_vector(31 downto 0); --regs to ALU
	signal Read2: std_logic_vector(31 downto 0); --regs to ALUMux, RAM

	--Data Mem Output
	signal ReadMem: std_logic_vector(31 downto 0);

	--Muxes Outputs
	signal MuxToALU: std_logic_vector(31 downto 0); -- mux to alu
	signal MuxToWriteD: std_logic_vector(31 downto 0); -- mux to reg write data
	signal MuxToPC: std_logic_vector(31 downto 0); --mux to PC
	
	--ALU Outputs
	signal ALUres: std_logic_vector(31 downto 0); 
	signal ALUzero: std_logic; 
	signal BranchO: std_logic; --branch output

	--ImmGen Output
	signal ImmGenO: std_logic_vector(31 downto 0);

	--Temporary Signal
	signal temp: std_logic_vector(29 downto 0);

	

begin

	--Mux everything
	ALUMux: BusMux2to1   port map(Ctrl_ALUSrc, Read2, ImmGenO, MuxToALU); -- ImmGen output goes into the missing port
	AdderMux: BusMux2to1   port map(BranchO, addOut1, addOut2, MuxToPC);
	DataMemMux: BusMux2to1  port map(Ctrl_MemtoReg, ALUres, ReadMem, MuxToWriteD);

	--Addition
	addFour: adder_subtracter port map(PC_Out, X"00000004", '0', addOut1, co1);
	addOp: adder_subtracter port map(PC_Out, ImmGenO, '0', AddOut2, co2);

	--Other Components
	PC:ProgramCounter port map(reset, clock, MuxToPC, PC_Out);

	Ctrl: Control port map(clock, Instr_mem(6 downto 0), Instr_mem(14 downto 12), Instr_mem(31 downto 25), Ctrl_branch, Ctrl_MemRead, Ctrl_MemtoReg, Ctrl_ALUCtrl, Ctrl_MemWrite,Ctrl_ALUSrc, Ctrl_RegWrite, Ctrl_ImmGen);

	InstrMem: InstructionRAM port map(reset, clock, PC_Out(31 downto 2), Instr_mem);
	
	Regis: Registers port map(Instr_mem(19 downto 15), Instr_mem(24 downto 20), Instr_mem(11 downto 7), MuxToWriteD, Ctrl_RegWrite, Read1, Read2);
	
	ArithLU: ALU port map(Read1, MUXtoALU, Ctrl_ALUCtrl, ALUzero, ALUres); --maha changed order to be ALUResult, ALUzero

	temp <= "0000" & ALUres(27 downto 2);

	DataMem: RAM port map(reset, clock, Ctrl_MemRead, Ctrl_MemWrite, temp, Read2, ReadMem);

	--Branch Control
	with Ctrl_Branch & ALUZero select
	BranchO <=  
				'1' when "101",
                '1' when "010",
				'0' when others;
	
	-- use ImmGen for encoding/opcoding
	with Ctrl_ImmGen & Instr_mem(31) select
	ImmGenO <=   
	"111111111111111111111" & Instr_mem(30 downto 20) when "001",  -- I type				  
	"000000000000000000000" & Instr_mem(30 downto 20) when "000",  -- I type	
	"111111111111111111111" & Instr_mem(30 downto 25) & Instr_mem(11 downto 7) when "011",  -- S type				  
	"000000000000000000000" & Instr_mem(30 downto 25) & Instr_mem(11 downto 7) when "010",  -- S type		
	"11111111111111111111" & Instr_mem(7) & Instr_mem(30 downto 25) & Instr_mem(11 downto 8) & '0' when "101", -- Btype			  
	"00000000000000000000" & Instr_mem(7) & Instr_mem(30 downto 25) & Instr_mem(11 downto 8) & '0' when "100", -- B type						   
	"1" & Instr_mem(30 downto 12) & "000000000000" when "111", -- U type				  
	"0" & Instr_mem(30 downto 12) & "000000000000" when "110", -- U type   
	"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;


end holistic;