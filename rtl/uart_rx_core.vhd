LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


entity uart_rx_core is 
  port (
   i_baud_sel: in std_logic_vector(1 downto 0);
   i_clk     : in std_logic;
   i_rx_line : in std_logic;
   o_valid : out std_logic;
   o_error : out std_logic;
   o_data  : out std_logic_vector(7 downto 0)

  );
end entity uart_rx_core;

architecture structural of uart_rx_core is
  signal s_rx_sync : std_logic := '1';
  signal s_baud_tick : std_logic := '0';
  signal s_sipo_rst: std_logic := '0';
  signal s_edge_detect: std_logic := '0';
  signal s_rst_counter: std_logic := '1';
  signal s_bit_cnt   : std_logic_vector(3 downto 0);
  signal s_sipo_data : std_logic_vector(9 downto 0);
  signal s_baud_gen_en: std_logic := '0';
begin
  
  -- ==== Synchronizer instance 
  -- ==== Input rx line synchronize with clock domain
  synchronizer : entity work.synchronizer
   port map (
    i_clk => i_clk,
    i_async_signal => i_rx_line,
    o_sync_signal  => s_rx_sync
   );
  
  -- === SIPO(Serial Input Parallel Output Shift Register Instance
  SIPO : entity work.sipo
   generic map( CWIDTH => 10 )
   port map (
    i_clk => i_clk,
    i_bit => s_rx_sync,
    i_shift=> s_baud_tick,
    i_rst  => s_sipo_rst,
    o_data => s_sipo_data
   );

  -- === Edge Detection on RX Line
  edge_detector: entity work.falling_edge_detector
   port map (
     i_clk    => i_clk,
     i_signal => s_rx_sync,
     o_falling_edge => s_edge_detect
   ); 

  -- === Bit receive counter
  bit_counter: entity work.CounterNb 
   generic map ( CWIDTH => 4 )
   port map (
    i_clk => i_clk,
    i_en  => s_baud_tick,
    i_rst => s_rst_counter,
    o_cnt => s_bit_cnt
   );

  -- === RX FSM 
  rx_fsm: entity work.rx_fsm
   port map (
    i_clk => i_clk,
    i_rx  => s_sipo_data(9),
    i_start_detected => s_edge_detect,
    i_rx_bit_cnt => s_bit_cnt,
    o_bit_cnt_rst => s_rst_counter,
    o_baud_gen_en=> s_baud_gen_en,
    o_valid => o_valid,
    o_error => o_error
   );

  -- === baud Tick Generator
  baud_tick_gen: entity work.baud_tick_gen
   generic map ( CWIDTH => 16)
   port map (
    i_clk => i_clk,
    i_en  => s_baud_gen_en,
    i_baud_select => i_baud_sel,
    o_tick => s_baud_tick
   );
  -- === data out assignement 
  o_data <= s_sipo_data(8 downto 1);
end architecture structural;
