-- ============================================================
--  Description
-- ============================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- =========================
-- Entity Declaration
-- =========================
entity uart_parl_bb is
 port(
   i_ser_rx  : in std_logic;
   i_clk     : in std_logic;
   i_baud_sel: in std_logic_vector(1 downto 0);

   o_ser_tx : out std_logic
 );
end entity  uart_parl_bb;

-- =========================
-- Architecture Definition
-- =========================
architecture structural of  uart_parl_bb is
 signal s_sent2valid : std_logic;
 signal s_data       : std_logic_vector(7 downto 0);
begin
 
  rx_core: entity work.uart_rx_core 
  port map(
   i_clk      => i_clk,
   i_baud_sel => i_baud_sel,
   i_rx_line  => i_ser_rx,
   o_valid    => s_sent2valid,
   o_error=> open,
   o_data => s_data
  );
  tx_core: entity work.uart_tx_core
  port map(
   i_clk =>  i_clk,
   i_data=>  s_data,
   i_send=>  s_sent2valid,
   i_baud_sel => i_baud_sel,
   
   o_ready => open,
   o_tx => o_ser_tx
  );
 
end architecture structural;
