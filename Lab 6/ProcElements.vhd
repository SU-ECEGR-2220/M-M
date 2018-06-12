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
    MemtoReg <= '1' when opcode = "0000011" else '0'; --LW
    MemRead <= '0' when opcode = "0000011" else '1'; --LW
    MemWrite <= '1' when opcode = "0100011" else '0'; --SW

    ALUsrc <=
        '1' when opcode = "0010011" and funct3 = "000" else --addi
        '1' when opcode = "0010011" and funct3 = "110" else --ori
        '1' when opcode = "0010011" and funct3 = "100" else  --xori
        '1' when opcode = "0100011" else --sw
        '1' when opcode = "0000011" else --lw
        '1' when opcode = "0010011" and funct3 = "001" else  --sll
        '1' when opcode = "0010011" and funct3 = "101" else  --srl
        '1' when opcode = "0010011" and funct3 = "001" else  --slli
        '1' when opcode = "0010011" and funct3 = "101" else  --srli
        '1' when opcode = "0110111" else   --lui
        '0';

    Branch <=
        "01" when opcode = "1100011" and funct3 = "000" else --beq
        "10" when opcode = "110011" and funct3 = "001" else --bne
        "00";

    ALUOp <=
        "00000" when opcode = "" and "" = else -- add
        "00001" when opcode = "" and "" = else -- sub
        "10000" when opcode = "" and "" = else -- sll
        "10001" when opcode = "" and "" = else -- srl
        "" when opcode = "" and "" = else -- beq
        "" when opcode = "" and "" = else -- bne
        "" when opcode = "" and "" = else -- lui
        "" when opcode = "" and "" = else -- sw
        "" when opcode = "" and "" = else -- lw
        "" when opcode = "" and "" = else -- addi
        "00110" when opcode = "" and "" = else -- ori
        "00110" when opcode = "" and "" = else -- or
        "" when opcode = "" and "" = else -- slli
        "00100" when opcode = "" and "" = else -- andi
        "" when opcode = "" and "" = else -- srli
        "00100" when opcode = "" and "" = else -- and


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

signal tempPC: std_logic_vector(31 downto 0); --to hold the temp PC value
architecture executive of ProgramCounter is
begin
-- Add your code here
 
--the program counter simply keeps track of where in the program we are--
--------- Operations of PC ----------
-- 1. Increment
-- 2. No-Op (halt)
-- 3. Reset
-------------------------------------

    ProgCount: process(Clock, Reset)
    begin
        if Reset = '1' then
            tempPC <= X"00400000";
        elsif rising_edge(Clock) then
            tempPC <= PCin;
        end if;
        PCout <= tempPC;
    end process ProgCount;

end executive;
--------------------------------------------------------------------------------
