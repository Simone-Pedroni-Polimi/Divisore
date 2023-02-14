library ieee;
use ieee.std_logic_1164.all;

entity ZERO_COMPARATOR is

	generic (
		N : integer := 32
	);

	port (
		X : in std_logic_vector(N-1 downto 0);
		Y : out std_logic
	);

end ZERO_COMPARATOR;

architecture RTL of ZERO_COMPARATOR is

	signal S : std_logic_vector(N-2 downto 0);

begin

	S(0) <= x(0) or x(1);

	GEN : for I in 0 to N-3 generate
		S(I+1) <= S(I) or x(I+2);
	end generate;

	y <= not S(N-2);

end RTL;
