LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_pwm_controller is
end entity tb_pwm_controller;

architecture tb of tb_pwm_controller is
 signal s_clk : std_logic := '0';
 signal s_rst : std_logic := '1';
 signal s_duty: std_logic_vector(7 downto 0) := (others=>'0');
 signal s_pwm : std_logic := '0';
begin
 
 -- instantation of unit under test
 uut: entity work.pwm_controller
 generic map ( CWIDTH => 8)
 port map (
  i_clk => s_clk,
  i_rst => s_rst,
  i_duty=> s_duty,
  
  o_pwm => s_pwm
 );

 -- clk generator process
 clk_gen: process
 begin
  s_clk <= not s_clk;
  wait for 500 ns;
 end process clk_gen;

 -- initializtion signal such as i_rst and i_duty 
 -- in this section set some number for duty signal
 initial: process
 begin
  wait for 500 ns;
  s_duty <= x"80"; -- ~50% / 128
  wait for 100 ns ;
  s_rst <= '0';
  wait for 10 ms;
  s_duty <= x"C0"; -- ~75% / 192
  wait for 10 ms;
  s_duty <= x"40"; -- ~25% / 64
  wait;
 end process initial;

end architecture tb;
