library ieee;
use ieee.std_logic_1164.all;

entity ALGORITHM is

	port (
		RIN   : in std_logic_vector(31 downto 0);
		D     : in std_logic_vector(31 downto 0);
		N_VAL : in std_logic;
		ROUT  : out std_logic_vector(31 downto 0);
		Q_BIT : out std_logic
	);

end ALGORITHM;

architecture STRUCT of ALGORITHM is

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

	-- Shifted and Assigned R
	signal SAR : std_logic_vector(31 downto 0);
	
	-- Negated D
	signal ND : std_logic_vector(31 downto 0);
	
	-- Difference between R and D
	signal DIFF : std_logic_vector(31 downto 0);
	
	-- Selection signal for ROUT and Q_BIT
	signal S : std_logic;

begin

	SAR <= RIN(30 downto 0) & N_VAL;
	
	ND <= not D;
	
	RCA_SUB : RCA
	port map (
		X    => SAR,
		Y    => ND,
		CIN  => '1',
		S    => DIFF,
		COUT => open
	);

	S <= not(DIFF(31));
	
	ROUT <= SAR when S = '0' else
			  DIFF when S = '1' else
			  (others => '-');
			  
	Q_BIT <= '0' when S = '0' else
				'1' when S = '1' else
				'-';

end STRUCT;
