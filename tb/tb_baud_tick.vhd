LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_baud_tick is
end entity tb_baud_tick;

architecture tb of tb_baud_tick is
 signal s_clk: std_logic := '0';
 signal s_baud_select: std_logic_vector(1 downto 0) := "11";
 signal s_tick: std_logic := '0';
begin

 uut : entity work.sample_tick_gen
	generic map ( CWIDTH => 16 )
	port map(
	  i_clk=> s_clk,
	  i_baud_select=> s_baud_select,
	  o_tick=> s_tick
	);
 clk_gen : process
 begin
  s_clk <= not s_clk;
  wait for 10 ns;
 end process;


end architecture tb;