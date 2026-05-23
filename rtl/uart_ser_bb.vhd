-- ============================================================
--  Description
-- ============================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- =========================
-- Entity Declaration
-- =========================
entity uart_ser_bb is
 port(
  i_clk  : in std_logic;
  i_data : in std_logic_vector(7 downto 0);
  i_send : in std_logic;
  i_baud_sel: in std_logic_vector(1 downto 0);
  
  o_ready: out std_logic;
  o_error: out std_logic;
  o_valid: out std_logic;
  o_data : out std_logic_vector(7 downto 0)
 );
end entity  uart_ser_bb;

-- =========================
-- Architecture Definition
-- =========================
architecture behavioral of uart_ser_bb is
 signal serial_line: std_logic;

begin

  rx_core: entity work.uart_rx_core 
  port map(
   i_clk      => i_clk,
   i_baud_sel => i_baud_sel,
   i_rx_line  => serial_line,
   o_valid    => o_valid,
   o_error=> o_error,
   o_data => o_data
  );
  tx_core: entity work.uart_tx_core
  port map(
   i_clk =>  i_clk,
   i_data=>  i_data,
   i_send=>  i_send,
   i_baud_sel => i_baud_sel,
   
   o_ready => o_ready,
   o_tx => serial_line
  );


end architecture behavioral;