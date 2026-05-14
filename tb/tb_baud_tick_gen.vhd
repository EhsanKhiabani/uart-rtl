LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_baud_tick is
end entity tb_baud_tick;

architecture tb of tb_baud_tick is
 signal s_clk: std_logic := '0';
 signal s_en : std_logic := '0';
 signal s_baud_select: std_logic_vector(1 downto 0) := "11";
 signal s_tick: std_logic ;
 signal s_tick_rx: std_logic;

 constant TIME_PERIOD: time := 20 ns;
begin

 --== Device Under Test Instantation
 dut_tx : entity work.sample_tick_gen
	generic map ( CWIDTH => 16 )
	port map(
	  i_clk=> s_clk,
	  i_baud_select=> s_baud_select,
	  o_tick=> s_tick
	); 

 dut_rx : entity work.baud_tick_gen
	generic map ( CWIDTH => 16 )
	port map(
	  i_clk=> s_clk,
	  i_baud_select=> s_baud_select,
          i_en => s_en,
	  o_tick=> s_tick_rx
	); 

 --== clock generator
 clk_gen: process
 begin
   s_clk <= '0';
   wait for TIME_PERIOD/2;
   s_clk <= '1';
   wait for TIME_PERIOD/2;
 end process clk_gen;

 --== stimulus

 stimulus: process
 begin

   --== start rx and tx tick generator together
   s_en  <= '1';
 wait;
 end process stimulus;

end architecture tb;