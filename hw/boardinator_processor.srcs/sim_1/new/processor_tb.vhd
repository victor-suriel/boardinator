----------------------------------------------------------------------------------
--------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

--use work.simple.all;

entity processor_tb is
--  Port ( );
end processor_tb;

architecture Behavioral of processor_tb is
    component processor
    Port ( temporary_processor_instr_input : in STD_LOGIC_VECTOR(15 downto 0);  --delet
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pc_out : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    signal instr_input : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal rst: std_logic := '1';
    signal pc: std_logic_vector(9 downto 0) := "0000000000";
    
    type prog_mem_t is array (999 downto 0) of std_logic_vector(15 downto 0);
    signal prog_rom: prog_mem_t :=
    (    
    			0 => "0000000000101010",		--	set 	r0,0x2A
		1 => "0000000111100001",		--	set 	r1,0xE1
		2 => "0000001010001000",		--	set 	r2,0x88
		3 => "0000001111111111",		--	set 	r3,0xFF
		4 => "1000111000000011",		--setstk r6,r3
		5 => "0001111000000001",		-- addl r6,1
		6 => "1000111000000010",		--setstk r6,r2
		7 => "0001111000000001",		-- addl r6,1
		8 => "1000111000000001",		--setstk r6,r1
		9 => "0001111000000001",		-- addl r6,1
		10 => "1000111000000000",		--setstk r6,r0
		11 => "0001111000000001",		-- addl r6,1
		12 => "1001110100000000",		--getpcl r5
		13 => "1010010000000000",		-- getpch r4
		14 => "0001110100001011",		--  addl r5,11
		15 => "1000000000010001",		-- jovf inc_upper
		16 => "0101100000010010",		--  jmp pushret
		17 => "0001110000000001",		-- addl r4,1
		18 => "1000111000000100",		--setstk r6,r4
		19 => "0001111000000001",		-- addl r6,1
		20 => "1000111000000101",		--setstk r6,r5
		21 => "0001111000000001",		-- addl r6,1
		22 => "0101100000011001",		-- jmp add16
		23 => "0010111000000110",		--	subl	r6,6
		24 => "0101100000011000",		--	jmp		end
		25 => "1000111000000111",		--setstk r6,r7
		26 => "0001111000000001",		-- addl r6,1
		27 => "0000111100000110",		-- mov r7,r6
		28 => "0010111100000000",		--subl r7,0	
		29 => "0010111100000100",		-- subl r7,4
		30 => "1001000000000111",		-- getstk r0,r7
		31 => "0001111100000100",		-- addl r7,4
		32 => "0001111100000000",		-- addl r7,0	
		33 => "0010111100000001",		--subl r7,1	
		34 => "0010111100000100",		-- subl r7,4
		35 => "1001000100000111",		-- getstk r1,r7
		36 => "0001111100000100",		-- addl r7,4
		37 => "0001111100000001",		-- addl r7,1	
		38 => "0010111100000011",		--subl r7,3	
		39 => "0010111100000100",		-- subl r7,4
		40 => "1001001000000111",		-- getstk r2,r7
		41 => "0001111100000100",		-- addl r7,4
		42 => "0001111100000011",		-- addl r7,3	
		43 => "0010111100000010",		--subl r7,2	
		44 => "0010111100000100",		-- subl r7,4
		45 => "1001001100000111",		-- getstk r3,r7
		46 => "0001111100000100",		-- addl r7,4
		47 => "0001111100000010",		-- addl r7,2	
		48 => "0001000100000010",		--	add 	r1,r2
		49 => "1000000000110011",		--	jovf	add16_lo_ovflw
		50 => "0101100000110111",		--	jmp 	add16_add_hi_bytes
		51 => "0001100000000001",		--	addl 	r0,1
		52 => "1000000000110110",		--	jovf	add16_hi_ovflw_1
		53 => "0101100000110111",		--	jmp 	add16_add_hi_bytes
		54 => "0000001000000001",		--	set 	r2,1
		55 => "0001000000000011",		--	add 	r0,r3
		56 => "1000000000111011",		--	jovf	add16_hi_ovflw_2
		57 => "0000001000000000",		--	set 	r2,0
		58 => "0101100000111100",		--	jmp 	add16_exit
		59 => "0000001000000001",		--	set 	r2,1
		60 => "0000111000000111",		--	mov r6,r7
		61 => "0010111000000001",		--subl r6,1
		62 => "1001011100000110",		-- getstk r7,r6
		63 => "0010111000000001",		--subl r6,1
		64 => "1001010100000110",		-- getstk r5,r6
		65 => "0010111000000001",		--subl r6,1
		66 => "1001010000000110",		-- getstk r4,r6
		67 => "1010110000000101",		-- setpc r4,r5
		68 => "1000111000000111",		--setstk r6,r7
		69 => "0001111000000001",		-- addl r6,1
		70 => "0000111100000110",		-- mov r7,r6
		71 => "0010111100000000",		--subl r7,0
		72 => "0010111100000100",		-- subl r7,4
		73 => "1001000000000111",		-- getstk r0,r7
		74 => "0001111100000100",		-- addl r7,4
		75 => "0001111100000000",		-- addl r7,0
		76 => "0010111100000001",		--subl r7,1
		77 => "0010111100000100",		-- subl r7,4
		78 => "1001000100000111",		-- getstk r1,r7
		79 => "0001111100000100",		-- addl r7,4
		80 => "0001111100000001",		-- addl r7,1
		81 => "0010111100000010",		--subl r7,2
		82 => "0010111100000100",		-- subl r7,4
		83 => "1001001000000111",		-- getstk r2,r7
		84 => "0001111100000100",		-- addl r7,4
		85 => "0001111100000010",		-- addl r7,2
		86 => "0000111000000111",		--	mov r6,r7
		87 => "0010111000000001",		--subl r6,1
		88 => "1001011100000110",		-- getstk r7,r6
		89 => "0010111000000001",		--subl r6,1
		90 => "1001010100000110",		-- getstk r5,r6
		91 => "0010111000000001",		--subl r6,1
		92 => "1001010000000110",		-- getstk r4,r6
		93 => "1010110000000101",		-- setpc r4,r5


        others => "0000000000000000"
    );
    --signal prog_rom: prog_mem_t := HEXFILE;
begin
    
    uut: processor port map (
        temporary_processor_instr_input => instr_input,
        clk => clk,
        rst => rst,
        pc_out => pc
    );
    
    

    clk_proc: process
    begin
        clk <= '1';
        instr_input <= prog_rom(to_integer(unsigned(pc)));
        wait for 50ns;
        clk <= '0';
        wait for 50ns;
    end process;
    
    main_proc: process
    begin
        rst <= '0';
        wait for 360ns;
        rst <= '1';
        wait for 20ns;

        --let the program execute        
        wait for 10000us;
        

    end process;

end Behavioral;
