LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity tb_uart_tx_core is
end entity;

architecture tb of tb_uart_tx_core is

-- DUT signals
signal s_data     : std_logic_vector(7 downto 0);
signal s_send     : std_logic := '0';
signal s_clk      : std_logic := '0';
signal s_baud_sel : std_logic_vector(1 downto 0) := "01";

signal s_ready    : std_logic;
signal s_tx       : std_logic;

constant CLK_PERIOD : time := 20 ns; -- 50 MHz

begin

-- UUT
uut: entity work.uart_tx_core
port map(
 i_data     => s_data,
 i_send     => s_send,
 i_clk      => s_clk,
 i_baud_sel => s_baud_sel,
 o_ready    => s_ready,
 o_tx       => s_tx
);

-- clock generator
clk_process : process
begin
 while true loop
  s_clk <= '0';
  wait for CLK_PERIOD/2;
  s_clk <= '1';
  wait for CLK_PERIOD/2;
 end loop;
end process;

-- stimulus
stim_proc : process
begin

 -- initial values
 s_data <= x"55";
 s_send <= '0';

 wait for 200 ns;

 ------------------------------------------------
 -- send first byte
 ------------------------------------------------
 --wait until s_ready = '1';

 s_data <= x"55";
 s_send <= '1';
 wait for CLK_PERIOD;
 s_send <= '0';

 ------------------------------------------------
 -- wait for transmission to finish
 ------------------------------------------------
 wait until s_ready = '1';

 wait for 500 ns;

 ------------------------------------------------
 -- send second byte
 ------------------------------------------------
 s_data <= x"A3";
 s_send <= '1';
 wait for 2*CLK_PERIOD;
 s_send <= '0';

 wait until s_ready = '1';

 wait for 200 ns;

 ------------------------------------------------
 -- send third byte
 ------------------------------------------------
 s_data <= x"F0";
 s_send <= '1';
 wait for CLK_PERIOD;
 s_send <= '0';

 wait until s_ready = '1';

 wait for 500 ns;

 assert false report "Simulation Finished" severity failure;

end process;

end architecture tb;
