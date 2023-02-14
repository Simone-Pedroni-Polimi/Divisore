library ieee;
use ieee.std_logic_1164.all;

entity MODULE is

	port (
		X     : in std_logic_vector(31 downto 0);
		SIGN  : in std_logic;
		X_MOD : out std_logic_vector(31 downto 0)
	);

end MODULE;

architecture STRUCT of MODULE is

	-- RCA component
	component RCA is
		generic (
			N : integer := 32
		);

		port (
			X    : in std_logic_vector(N-1 downto 0);
			Y    : in std_logic_vector(N-1 downto 0);
			CIN  : in std_logic;
			S    : out std_logic_vector(N-1 downto 0);
			COUT : out std_logic
		);
	end component;

	-- Negated input X
	signal NX : std_logic_vector(31 downto 0);
	
	-- C2 X signal
	signal X_C2 : std_logic_vector(31 downto 0);

begin

	NX <= not X;
	
	C2_RCA : RCA
	generic map (
		N => 32
	)
	port map (
		X    => NX,
		Y    => (others => '0'),
		CIN  => '1',
		S    => X_C2,
		COUT => open
	);
	
	X_MOD <= X    when SIGN = '0' else
				X_C2 when SIGN = '1' else
				(others => '-');

end STRUCT;
