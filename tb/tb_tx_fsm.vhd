LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_tx_fsm is
end entity tb_tx_fsm;

architecture tb of tb_tx_fsm is
 signal s_clk: std_logic := '0';
 signal s_baud_tick: std_logic := '0';
 signal s_send: std_logic := '0';
 signal s_ready: std_logic := '0';
 signal s_load: std_logic := '0';
 signal s_tx_cnt_rst : std_logic := '1';
 signal s_tx_bit_cnt : std_logic_vector( 3 downto 0) := (others=>'0');
begin

 uut: entity work.tx_fsm
  port map(
   i_clk  => s_clk,
   i_send => s_send,
   o_ready=> s_ready,
   i_tx_bit_cnt => s_tx_bit_cnt,
   o_load_frame => s_load,
   o_tx_cnt_rst => s_tx_cnt_rst
  );

  -- process to generate clk signal
  clk_gen: process
  begin
   s_clk <= not s_clk;
   wait for 20 ns;
  end process clk_gen;


  -- process to generate baud tick every 10k clk cycle
  baud_tick: process(s_clk)
   variable v_cnt: integer := 0;
  begin
   if rising_edge(s_clk) then
    if v_cnt< 10 then
     v_cnt := v_cnt + 1;
     s_baud_tick <= '0';
    else
     v_cnt := 0;
     s_baud_tick <= '1';
    end if;
   end if;
  end process baud_tick;


  -- process to check tx process
  tx_procss: process
  begin
   wait for 100 ns;
   s_send <= '1';
   wait for 20 ns;
   s_send <= '0';
   wait;
  end process tx_procss;

  
end architecture tb;