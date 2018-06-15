--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- simply select the result based on high or low
-- of selector
    with selector select 
        Result <= In0 when '0',
        In1 when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
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
end Control;

architecture Boss of Control is
begin
-- Add your code here
-----------------------------
----- Decode operations -----
-----------------------------
-- funct 3 and funct 7 are part of decoding
    
    -- Op-code decode
    MemtoReg <= '1' when opcode = "0000011" and funct3 = "010" else '0'; --LW
    MemRead <= '0' when opcode = "0000011" and funct3 = "010"  else '1'; --LW
    MemWrite <= '1' when opcode = "0100011"  and funct3 = "010"  else '0'; --SW

    -- maha changed ALUsrc to get 0 for all cases
    --also changed it to be simpler
    ALUsrc <=
        '0' when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else -- add
        '0' when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else -- sub
        '0' when opcode = "1100011" and funct3 = "000" else -- beq
        '0' when opcode = "1100011" and funct3 = "001" else -- bne
        '0' when opcode = "0110011" and funct3 = "110" and funct7 = "0100000" else -- or
        '0' when opcode = "0110011" and funct3 = "111" and funct7 = "0000000" else -- and
        '1';

    Branch <=
        "01" when opcode = "1100011" and funct3 = "000" else --beq 
        "10" when opcode = "110011" and funct3 = "001" else --bne
        "00";

    ALUCtrl <=
        "00000" when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else -- add
        "00001" when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else -- sub
        "10000" when opcode = "0110011" and funct3 = "001" and funct7 = "0000000" else -- sll
        "10001" when opcode = "0110011" and funct3 = "100" and funct7 = "0000000" else -- srl
        "00001" when opcode = "1100011" and funct3 = "000" else -- beq
        "00001" when opcode = "1100011" and funct3 = "001" else -- bne
        "00000" when opcode = "0110111" else -- lui
        "00000" when opcode = "0100011" and funct3 = "010" else -- sw
        "00000" when opcode = "0000011" and funct3 = "010" else -- lw
        "00000" when opcode = "0010011" and funct3 = "000" else -- addi
        "00110" when opcode = "0010011" and funct3 = "110" else -- ori
        "00110" when opcode = "0110011" and funct3 = "110" and funct7 = "0100000" else -- or
        "10000" when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- slli
        "00100" when opcode = "0010011" and funct3 = "111" else -- andi
        "10001" when opcode = "0010011" and funct3 = "101" and funct7 = "0100000" else -- srli
        "00100" when opcode = "0110011" and funct3 = "111" and funct7 = "0000000" else -- and
        "11111";
    
    ImmGen <= 
            "00" when opcode = "0010011" and funct3 = "000" else --addi
            "10" when opcode = "1100011" and funct3 = "000" else --beq
            "10" when opcode = "1100011" and funct3 = "001" else --bne            
            "00" when opcode = "0010011" and funct3 = "110" else --ori
            "00" when opcode = "0000011" and funct3 = "010" else  --lw 
            "00" when opcode = "0010011" and funct3 = "111" else	 --andi
            "01" when opcode = "0100011" and funct3 = "010" else --sw
            "11" when opcode = "0110111" else	 --lui
            "00" when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- slli
            "00" when opcode = "0010011" and funct3 = "101" and funct7 = "0100000" else -- slri
            "ZZ";
        
    RegWrite <= 
            '0' when opcode="0100011" and funct3="010" else	   --sw	
	        '0' when opcode="1100011" and funct3="000" else	   --beq
	        '0' when opcode="1100011" and funct3="001" else	    --bne
            (not clk);
    
end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;


architecture executive of ProgramCounter is

signal tempPC: std_logic_vector(31 downto 0); --to hold the temp PC value

begin
-- Add your code here
 
--the program counter simply keeps track of where in the program we are--
--------- Operations of PC ----------
-- 1. Increment
-- 2. No-Op (halt)
-- 3. Reset
-------------------------------------

    PCProc: process(Clock, Reset)
  begin
    -- Reset PC
    if Reset = '1' then
	tempPC <= X"003FFFFC";
    end if;

    -- Update PC
    if rising_edge(Clock) and Clock = '1' then
       tempPC <= PCin;
    end if;
  end process PCProc;

  -- Output current PC value
  PCOut <= tempPC;

end executive;
--------------------------------------------------------------------------------
