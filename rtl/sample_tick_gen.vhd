LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity sample_tick_gen is
 generic ( CWIDTH : natural :=8 );
 port(
	i_clk : in std_logic;
	i_baud_select : in std_logic_vector(1 downto 0);
	
	o_tick : out std_logic	
 ); 
end entity sample_tick_gen;


architecture structural of sample_tick_gen is
 signal s_rst : std_logic := '0';
 signal s_cnt : std_logic_vector(CWIDTH-1 downto 0) := (others => '0');
 signal s_setpoint : std_logic_vector(CWIDTH-1 downto 0);
 signal s_tick : std_logic;
begin
 
 rate_sel: entity work.rate_selector
	port map (
		i_rate_sel=>i_baud_select,
		o_setpoint=>s_setpoint
	);
 
 counter: entity work.counterNb
	generic map ( CWIDTH =>CWIDTH )
	port map (
		i_clk=>i_clk,
		i_rst=> s_rst,-- s_rst,
		o_cnt=>s_cnt
	);

 comp: entity work.comparator 
       generic map ( CWIDTH => CWIDTH )
       port map(
	        in1=>s_cnt,
	        in2=>s_setpoint,
	        o  =>s_tick
       );

 s_rst <= s_tick;
 o_tick<= s_tick;

end architecture structural;