library ieee;
use ieee.std_logic_1164.all;

entity MUX_32_1 is

	port (
		X : in std_logic_vector(31 downto 0);
		S : in std_logic_vector(4 downto 0);
		Y : out std_logic
	);

end MUX_32_1;

architecture RTL of MUX_32_1 is

begin

	with S select
		Y <= X(0) when "00000",
			  X(1) when "00001",
			  X(2) when "00010",
			  X(3) when "00011",
			  X(4) when "00100",
			  X(5) when "00101",
			  X(6) when "00110",
			  X(7) when "00111",
			  X(8) when "01000",
			  X(9) when "01001",
			  X(10) when "01010",
			  X(11) when "01011",
			  X(12) when "01100",
			  X(13) when "01101",
			  X(14) when "01110",
			  X(15) when "01111",
			  X(16) when "10000",
			  X(17) when "10001",
			  X(18) when "10010",
			  X(19) when "10011",
			  X(20) when "10100",
			  X(21) when "10101",
			  X(22) when "10110",
			  X(23) when "10111",
			  X(24) when "11000",
			  X(25) when "11001",
			  X(26) when "11010",
			  X(27) when "11011",
			  X(28) when "11100",
			  X(29) when "11101",
			  X(30) when "11110",
			  X(31) when "11111",
			  '-' when others;

end RTL;
