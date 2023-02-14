library ieee;
use ieee.std_logic_1164.all;
 
entity TB_DIVIDER is
end TB_DIVIDER;
 
architecture STRUCT of TB_DIVIDER is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component DIVIDER is
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
    end component;
    

   --Inputs
   signal N : std_logic_vector(31 downto 0);
   signal D : std_logic_vector(31 downto 0);
   signal STR : std_logic;
   signal RST : std_logic;
   signal CLK : std_logic;

 	--Outputs
   signal Q : std_logic_vector(31 downto 0);
   signal R : std_logic_vector(31 downto 0);
   signal ERR : std_logic;
   signal EOC : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   UUT : DIVIDER
	port map (
		N => N,
      D => D,
      STR => STR,
		Q => Q,
      R => R,
      ERR => ERR,
      EOC => EOC,
      RST => RST,
      CLK => CLK
	);

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   STIM_process : process
   begin
		RST <= '1';
		STR <= '0';
		N <= "00000000000000000000000000000000"; -- 0
		D <= "00000000000000000000000000000000"; -- 0
		-- Q = 0, R = 0, ERR = 1
      wait for 500 ns;
		
		RST <= '0';
		wait for CLK_period;
		
		-- CASO 1: Numero basso negativo su numero basso positivo
		N <= "11111111111111111111111111111000"; -- -8
		D <= "00000000000000000000000000000011"; -- +3
		-- Q = -2, R = -2, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 2 : Numero medio positivo su numero basso positivo
		N <= "00000000000000100000110110000100"; -- +134.532
		D <= "00000000000000000000000000001000"; -- +8
		-- Q = +16.816, R = +4, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 3 : Numero alto positivo su numero alto negativo
		N <= "01111101111111110011111011110111"; -- +2.113.879.799
		D <= "11001000011010000100000011000101"; -- -932.691.771
		-- Q = -2, R = +248.496.257, ERR = 0
		
		wait for 10*CLK_period;
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 4 : Numero alto negativo su numero medio negativo
		N <= "10001000011010110100000011000101"; -- -2.006.236.987
		D <= "11111111111011010011111011110111"; -- -1.229.065
		-- Q = +1.632, R = -402.907, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 5 : Dividendo più piccolo in modulo del divisore
		N <= "00000000000000000000000010110100"; -- +180
		D <= "11111111111111111111111000110111"; -- -457
		-- Q = 0, R = +180, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 6 : Condizione d'errore
		N <= "11111010001010110111011001100101"; -- -97.814.939
		D <= "00000000000000000000000000000000"; -- 0
		-- Q = 0, R = 0, ERR = 1
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;

		
		-- CASO 7 : Utilizzo del Reset durante una computazione
		N <= "00000000000000000000000000001001"; -- +9
		D <= "00000000000000000000000000000101"; -- +5
		-- Q = +1, R = +4, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		N <= "01010101001001010001000000100101"; -- +1.248.492.325
		D <= "10100110010100010011110010100010"; -- -1.504.625.502
		-- Q = 0, R = +1.248.492.325, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		
		wait for 21*CLK_period;
		RST <= '1';
		
		wait for 11*CLK_period;
		RST <= '0';
		
		wait for 5*CLK_period;
		
		
		-- CASO 8 : Utilizzo del Reset alla fine di una computazione
		N <= "00000000000000000000000000000011"; -- +3
		D <= "11111111111111111111111111111111"; -- -1
		-- Q = -3, R = 0, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 18*CLK_period;
		RST <= '1';
		
		wait for 16*CLK_period;
		RST <= '0';
		
		wait for 5*CLK_period;
		
		
		-- CASO 9 : Utilizzo dello Start dopo il Reset dell'architettura
		wait for 14*CLK_period;
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 10 : Inserimento e computazione degli ultimi numeri inseriti in ingresso
		N <= "00000000000000000000000000000011"; -- +3
		D <= "11111111111111111111111111111111"; -- -1
		-- Q = -3, R = 0, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
		
		-- CASO 11 : Inserimento e computazione di due numeri durante un'altra computazione in corso
		N <= "00101010010110001010010010010010"; -- +710.452.370
		D <= "11001000101000100100101010100111"; -- -928.888.153
		-- Q = 0, R = +710.452.370, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 10*CLK_period;
		
		N <= "10100101010010101010100101010010"; -- -1.521.833.646
		D <= "00101001010001010010101010000010"; -- +692.398.722
		-- Q = -2, R = -137.036.202, ERR = 0
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 20*CLK_period;
		
		wait for 5*CLK_period;
		
		wait for 26*CLK_period;
		
		STR <= '1';
		wait for CLK_period;
		STR <= '0';
		wait for 31*CLK_period;
		
		wait for 5*CLK_period;
		
      wait;
   end process;

end;
