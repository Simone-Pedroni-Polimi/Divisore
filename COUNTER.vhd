library ieee;
use ieee.std_logic_1164.all;

entity COUNTER is

	port (
		Z   : out std_logic_vector(4 downto 0);
		RST : in std_logic;
		CLK : in std_logic
	);

end COUNTER;

architecture STRUCT of COUNTER is

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

	-- Temporary TZ
	signal TZ : std_logic_vector(4 downto 0);
	
	-- Register Input
	signal RI : std_logic_vector(4 downto 0);

begin

	RCA_DECREASE : RCA
	generic map (
		N => 5
	)
	port map (
		X    => TZ,
		Y    => (others => '1'),
		CIN  => '0',
		S    => RI,
		COUT => open
	);

	STATUS : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST = '1' ) then
				TZ <= (others => '1');
			else
				TZ <= RI;
			end if;
		end if;
	end process;

	Z <= TZ;

end STRUCT;
