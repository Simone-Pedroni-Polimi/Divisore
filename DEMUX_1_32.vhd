library ieee;
use ieee.std_logic_1164.all;

entity DEMUX_1_32 is

	port (
		X : in std_logic;
		S : in std_logic_vector(4 downto 0);
		Y : out std_logic_vector(31 downto 0)
	);

end DEMUX_1_32;

architecture RTL of DEMUX_1_32 is

begin

	Y(0)  <= X when S = "00000" else '0';
	Y(1)  <= X when S = "00001" else '0';
	Y(2)  <= X when S = "00010" else '0';
	Y(3)  <= X when S = "00011" else '0';
	Y(4)  <= X when S = "00100" else '0';
	Y(5)  <= X when S = "00101" else '0';
	Y(6)  <= X when S = "00110" else '0';
	Y(7)  <= X when S = "00111" else '0';
	Y(8)  <= X when S = "01000" else '0';
	Y(9)  <= X when S = "01001" else '0';
	Y(10) <= X when S = "01010" else '0';
	Y(11) <= X when S = "01011" else '0';
	Y(12) <= X when S = "01100" else '0';
	Y(13) <= X when S = "01101" else '0';
	Y(14) <= X when S = "01110" else '0';
	Y(15) <= X when S = "01111" else '0';
	Y(16) <= X when S = "10000" else '0';
	Y(17) <= X when S = "10001" else '0';
	Y(18) <= X when S = "10010" else '0';
	Y(19) <= X when S = "10011" else '0';
	Y(20) <= X when S = "10100" else '0';
	Y(21) <= X when S = "10101" else '0';
	Y(22) <= X when S = "10110" else '0';
	Y(23) <= X when S = "10111" else '0';
	Y(24) <= X when S = "11000" else '0';
	Y(25) <= X when S = "11001" else '0';
	Y(26) <= X when S = "11010" else '0';
	Y(27) <= X when S = "11011" else '0';
	Y(28) <= X when S = "11100" else '0';
	Y(29) <= X when S = "11101" else '0';
	Y(30) <= X when S = "11110" else '0';
	Y(31) <= '0';

end RTL;
