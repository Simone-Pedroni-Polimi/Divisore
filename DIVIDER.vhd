library ieee;
use ieee.std_logic_1164.all;

entity DIVIDER is

	port (
		N   : in std_logic_vector(31 downto 0);
		D   : in std_logic_vector(31 downto 0);
		STR : in std_logic;
		Q   : out std_logic_vector(31 downto 0);
		R   : out std_logic_vector(31 downto 0);
		ERR : out std_logic;
		EOC : out std_logic;
		RST : in std_logic;
		CLK : in std_logic
	);  

end DIVIDER;

architecture STRUCT of DIVIDER is

	-- COMPONENTS
	
	component MODULE is
		port (
			X     : in std_logic_vector(31 downto 0);
			SIGN  : in std_logic;
			X_MOD : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component COUNTER is
		port (
			Z   : out std_logic_vector(4 downto 0);
			RST : in std_logic;
			CLK : in std_logic
		);
	end component;
	
	component MUX_32_1 is
		port (
			X : in std_logic_vector(31 downto 0);
			S : in std_logic_vector(4 downto 0);
			Y : out std_logic
		);
	end component;
	
	component ALGORITHM is
		port (
			RIN   : in std_logic_vector(31 downto 0);
			D     : in std_logic_vector(31 downto 0);
			N_VAL : in std_logic;
			ROUT  : out std_logic_vector(31 downto 0);
			Q_BIT : out std_logic
		);
	end component;
	
	component DEMUX_1_32 is
		port (
			X : in std_logic;
			S : in std_logic_vector(4 downto 0);
			Y : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component ZERO_COMPARATOR is
		generic (
			N : integer := 32
		);

		port (
			X : in std_logic_vector(N-1 downto 0);
			Y : out std_logic
		);
	end component;
	
	
	-- SIGNALS
	
	-- Output of the N register
	signal N_REG_OUT : std_logic_vector(31 downto 0);
	-- Sign of N
	signal N_SIGN : std_logic;
	-- Module of N
	signal N_MOD : std_logic_vector(31 downto 0);
	
	-- Output of the D register
	signal D_REG_OUT : std_logic_vector(31 downto 0);
	-- Sign of D
	signal D_SIGN : std_logic;
	-- Module of D
	signal D_MOD : std_logic_vector(31 downto 0);
	
	-- Indicates if the D input equals 0
	signal D_ZERO : std_logic;
	-- Temporary Error
	signal TERR : std_logic;
	
	-- Temporary Available
	signal TAV : std_logic;
	-- Output of the AV Register
	signal AV_OUT : std_logic;
	-- Available signal
	signal AV : std_logic;
	-- Negated Clock
	signal NCLK : std_logic;
	
	-- Reset of the Counter
	signal CNT_RST : std_logic;
	-- Output of the Counter
	signal CNT : std_logic_vector(4 downto 0);
	-- Negated output of the Counter
	signal CNT_NEG : std_logic_vector(4 downto 0);
	-- Indicates if the output of the Counter equals 31
	signal CNT_ZERO : std_logic;
	
	-- Selected N bit for the Algorithm
	signal N_VAL : std_logic;
	-- Calculated Q bit by the Algorithm
	signal Q_BIT : std_logic;
	-- Value of Q calculated by the Algorithm
	signal Q_ALG : std_logic_vector(31 downto 0);
	
	-- Input of the Q register
	signal Q_REG_IN : std_logic_vector(31 downto 0);
	-- Output of the Q register
	signal Q_REG_OUT : std_logic_vector(31 downto 0);
	-- Sign of Q
	signal Q_SIGN : std_logic;
	-- Selected value of Q
	signal Q_SEL : std_logic_vector(31 downto 0);
	-- Temporary Q
	signal TQ : std_logic_vector(31 downto 0);
	
	-- Input of the R register
	signal R_REG_IN : std_logic_vector(31 downto 0);
	-- Output of the R register
	signal R_REG_OUT : std_logic_vector(31 downto 0);
	-- Sign of R
	signal R_SIGN : std_logic;
	-- Selected value of Q
	signal R_SEL : std_logic_vector(31 downto 0);
	-- Temporary R
	signal TR : std_logic_vector(31 downto 0);
	
begin

	-- INPUT REGISTERS
	-- N Register
	N_REG : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST =  '1' ) then
				N_REG_OUT <= (others => '0');
			else
				if ( AV = '1' ) then
					N_REG_OUT <= N;
				end if;
			end if;
		end if;
	end process;
	
	-- D Register
	D_REG : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST = '1' ) then
				D_REG_OUT <= (others => '0');
			else
				if ( AV = '1' ) then
					D_REG_OUT <= D;
				end if;
			end if;
		end if;
	end process;
	
	
	-- INPUT'S MODULES
	-- N Module
	N_SIGN <= N_REG_OUT(31);
	
	N_MODULE : MODULE
	port map (
		X     => N_REG_OUT,
		SIGN  => N_SIGN,
		X_MOD => N_MOD
	);
	
	-- D Module
	D_SIGN <= D_REG_OUT(31);
	
	D_MODULE : MODULE
	port map (
		X     => D_REG_OUT,
		SIGN  => D_SIGN,
		X_MOD => D_MOD
	);
	
	
	-- NULL D
	D_ZCMP : ZERO_COMPARATOR
	generic map (
		N => 32
	)
	port map (
		X => D_MOD,
		Y => D_ZERO
	);


	-- COUNTER
	CNT_RST <= RST or TAV;
	
	COUNT : COUNTER
	port map (
		Z   => CNT,
		RST => CNT_RST,
		CLK => CLK
	);
	
	CNT_NEG <= not CNT;
	
	CNT_ZCMP : ZERO_COMPARATOR
	generic map (
		N => 5
	)
	port map (
		X => CNT_NEG,
		Y => CNT_ZERO
	);
	

	-- AVAILABLE REGISTER
	TAV  <= CNT_ZERO and (not STR);
	NCLK <= not CLK;
	
	AV_REG : process ( NCLK )
	begin
		if ( NCLK'event and NCLK = '1' ) then
			if ( RST = '1' ) then
				AV_OUT <= '1';
			else
				AV_OUT <= TAV;
			end if;
		end if;
	end process;
	
	AV <= AV_OUT when RST = '0' else
			'0'    when RST = '1' else
			'-';


	-- MUX
	MUX : MUX_32_1
	port map (
		X => N_MOD,
		S => CNT,
		Y => N_VAL
	);

	
	-- ALGORITHM
	ALG : ALGORITHM
	port map (
		RIN   => R_REG_OUT,
		D     => D_MOD,
		N_VAL => N_VAL,
		ROUT  => R_REG_IN,
		Q_BIT => Q_BIT
	);
	
	
	-- DEMUX
	DEMUX : DEMUX_1_32
	port map (
		X => Q_BIT,
		S => CNT,
		Y => Q_ALG
	);
	
	
	-- INTERMEDIATE REGISTERS
	-- Q Register
	Q_REG_IN <= Q_REG_OUT or Q_ALG;
	
	Q_REG : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST = '1' or AV = '1' ) then
				Q_REG_OUT <= (others => '0');
			else
				Q_REG_OUT <= Q_REG_IN;
			end if;
		end if;
	end process;
	
	-- R Register
	R_REG : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST = '1' or AV = '1' ) then
				R_REG_OUT <= (others => '0');
			else
				R_REG_OUT <= R_REG_IN;
			end if;
		end if;
	end process;
	
	
	-- INTERMEDIATE'S MODULES
	-- Q Module
	Q_SIGN <= N_SIGN xor D_SIGN;
	
	Q_MODULE : MODULE
	port map (
		X     => Q_REG_OUT,
		SIGN  => Q_SIGN,
		X_MOD => Q_SEL
	);
	
	-- R Module
	R_SIGN <= N_SIGN;
	
	R_MODULE : MODULE
	port map (
		X     => R_REG_OUT,
		SIGN  => R_SIGN,
		X_MOD => R_SEL
	);
	
	
	-- OUTPUT REGISTERS
	-- Output Q Register
	Q_OUT : process ( AV )
	begin
		if ( AV'event and AV = '1' ) then
			if ( RST = '1' or D_ZERO = '1' ) then
				TQ <= (others => '0');
			else
				TQ <= Q_SEL;
			end if;
		end if;
	end process;
	
	Q <= TQ 					when RST = '0' else
		  (others => '0') when RST = '1' else
		  (others => '-');
		  
	-- Output R Register
	R_OUT : process ( AV )
	begin
		if ( AV'event and AV = '1' ) then
			if ( RST = '1' or D_ZERO = '1' ) then
				TR <= (others => '0');
			else
				TR <= R_SEL;
			end if;
		end if;
	end process;
	
	R <= TR 					when RST = '0' else
		  (others => '0') when RST = '1' else
		  (others => '-');
		  
	-- Output ERR Register
	ERR_OUT : process ( AV )
	begin
		if ( AV'event and AV = '1' ) then
			if ( RST = '1' ) then
				TERR <= '0';
			else
				TERR <= D_ZERO;
			end if;
		end if;
	end process;
	
	ERR <= TERR when RST = '0' else
			 '0'  when RST = '1' else
			 '-';
			 
	-- Output EOC Register
	EOC_OUT : process ( CLK )
	begin
		if ( CLK'event and CLK = '1' ) then
			if ( RST = '1' or AV = '0' ) then
				EOC <= '0';
			else
				EOC <= '1';
			end if;
		end if;
	end process;

end STRUCT;

