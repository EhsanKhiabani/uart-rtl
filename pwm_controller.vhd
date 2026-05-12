LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity pwm_controller is
 generic (
  CWIDTH : natural := 8
 );
 port(
  i_clk : in std_logic;
  i_rst : in std_logic;
  i_duty: in std_logic_vector(CWIDTH-1 downto 0);

  o_pwm : out std_logic
 );
end entity pwm_controller;

architecture structural of pwm_controller is
 signal s_cnt: std_logic_vector(CWIDTH-1 downto 0) := (others=>'0');
 signal s_pwm: std_logic := '0';
begin
 
 counter: entity work.counterNb
   generic map ( CWIDTH => 8 )
   port map(
    i_clk => i_clk,
    i_rst => i_rst,
    o_cnt => s_cnt
   );
  comparator: entity work.comparator
   generic map ( CWIDTH => 8 )
   port map(
    in1 => i_duty,
    in2 => s_cnt,
    o   => s_pwm
   );  

   

end architecture structural;