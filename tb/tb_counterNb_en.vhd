LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_counterNb_en is
end entity tb_counterNb_en;

architecture tb of tb_counterNb_en is
 signal s_clk: std_logic := '0';
 signal s_rst: std_logic := '1';
 signal s_en : std_logic := '0';
 signal s_preload: std_logic_vector(3 downto 0) := "1000";
 signal s_cnt: std_logic_vector(3 downto 0);

 constant TIME_PERIOD: time := 20 ns;
begin

 --== Device Under Test Instantation
 DUT: entity work.counterNb_en
  generic map(
   CWIDTH => 4   
  )
  port map(
   i_clk =>s_clk,
   i_rst =>s_rst,
   i_preload=>s_preload,
   i_en => s_en,

   o_cnt=> s_cnt
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
   --== wait for 5 cycle 
   wait for 5*TIME_PERIOD;

   s_preload <= "1000";
   s_en <= '1';
   s_rst<= '0';

   wait for 10*TIME_PERIOD;
   s_en <= '0';
   
   wait for  10*TIME_PERIOD;
   s_preload <= "0011";
   s_en <= '1';

   wait for 100*TIME_PERIOD;
   s_rst <= '1';
   wait for TIME_PERIOD;
   s_rst <= '0';

   wait for 100*TIME_PERIOD;
   s_rst <= '1';
   wait for TIME_PERIOD;
   s_rst <= '0';
   
 end process stimulus;
end architecture tb;