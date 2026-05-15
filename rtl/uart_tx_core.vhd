LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity uart_tx_core is
 port(
  i_data : in std_logic_vector (7 downto 0);
  i_send : in std_logic;
  i_clk  : in std_logic;
  i_baud_sel : in std_logic_vector (1 downto 0);

  o_ready: out std_logic;
  o_tx   : out std_logic
 );
end entity;

architecture structural of uart_tx_core is
 signal s_data : std_logic_vector(9 downto 0);
 signal s_tx_bit_cnt: std_logic_vector(3 downto 0);
 signal s_baud_tick : std_logic;
 signal s_tx_cnt_rst: std_logic;
 signal s_load : std_logic;
 signal s_piso_rst :  std_logic := '0';
 signal s_baud_en  :  std_logic := '1';

begin
 
 tx_sm: entity work.tx_fsm
  port map(
   i_clk        => i_clk, 
   i_tx_bit_cnt => s_tx_bit_cnt,
   i_send       => i_send,

   o_tx_cnt_rst => s_tx_cnt_rst,
   o_ready      => o_ready,
   o_load_frame => s_load
  );


 tx_bit_cntr: entity work.CounterNb
  generic map ( CWIDTH => 4)
  port map (
   i_clk => i_clk,
   i_en  => s_baud_tick,
   i_rst => s_tx_cnt_rst,
   o_cnt => s_tx_bit_cnt 
  );

 piso_reg: entity work.piso
  generic map (
   CWIDTH => 10,
   LEFT_SHIFT => false    
  )
  port map (
   i_data => s_data,  
   i_clk  => i_clk,
   i_load => s_load, 
   i_shift=> s_baud_tick, 
   i_rst  => s_piso_rst, 
   o_bit  => o_tx   
  );

 tick_gen: entity work.baud_tick_gen_tx
  generic map( CWIDTH => 16 )
  port map(
	i_clk => i_clk,
        i_en  => s_baud_en,
	i_baud_select => i_baud_sel,
	o_tick => s_baud_tick	
  ); 

  s_data <= '1' & i_data & '0';

end architecture structural;