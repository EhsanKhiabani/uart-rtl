LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



entity tb_uart_tx_core is
end entity;

architecture tb of tb_uart_tx_core is
-- ==============================================
-- ======== Procedures Declaration     ==========

procedure uart_receive (
 signal i_tx_line : in std_logic;
 signal o_data    : out std_logic_vector(7 downto 0);
 signal o_valid   : out std_logic;
 signal o_error   : out std_logic;
 constant CLK_PERIOD: time;
 constant BAUD_RATE : integer
) is
variable v_bit_time : time;
variable v_data : std_logic_vector(7 downto 0);

begin
 
 -- ==== bit time calculation
 v_bit_time := 1 sec / BAUD_RATE;

 -- ==== Detected Start
 wait until falling_edge(i_tx_line);
 
 -- ==== Delay for sample in middle of bit
 wait for v_bit_time/2;
 -- ==== start bit sample
 if i_tx_line='1' then
   o_error <= '1';
   o_valid <= '0';
   wait for CLK_PERIOD;
   o_error <= '0';
   o_valid <= '0';
   return;
 end if;

 -- === sample data frame
 for i in 0 to 7 loop

   wait for v_bit_time;
   v_data(i) := i_tx_line;
   

 end loop;
 o_data <= v_data;
 -- ==== sample stop bit 
 wait for v_bit_time;
 if i_tx_line='1' then
   o_valid <= '1';
   o_error <= '0';
 else 
   o_valid <= '0';
   o_error <= '1';
 end if;

 wait for CLK_PERIOD;

 o_valid <= '0';
 o_error <= '0'; 

end procedure;

-- ==============================================
-- =======        DATA Type Definitions =========
type data_test_array_t is array(natural range <>) of std_logic_vector(7 downto 0);

-- ==============================================
-- ==============================================
-- DUT signals
signal s_data     : std_logic_vector(7 downto 0);
signal s_send     : std_logic := '0';
signal s_clk      : std_logic := '0';
signal s_baud_sel : std_logic_vector(1 downto 0) := "01";

signal s_ready    : std_logic;
signal s_tx       : std_logic;

signal s_rx_data : std_logic_vector(7 downto 0);
signal s_rx_valid : std_logic := '0';
signal s_rx_error : std_logic := '0';

-- Data test array
signal test_data : data_test_array_t(0 to 2) := ("10101010","11100101","00001111");

constant CLK_PERIOD : time := 20 ns; -- 50 MHz
constant BIT_TIME   : time := 1 sec / 9600; --
begin

-- ===================================================
-- =====            DUT INSTANTATION             =====
-- ===================================================
uut: entity work.uart_tx_core
port map(
 i_data     => s_data,
 i_send     => s_send,
 i_clk      => s_clk,
 i_baud_sel => s_baud_sel,
 o_ready    => s_ready,
 o_tx       => s_tx
);

-- ===================================================
-- =====       CLOCK Generation Process          =====
-- ===================================================
clk_process : process
begin
 while true loop
  s_clk <= '0';
  wait for CLK_PERIOD/2;
  s_clk <= '1';
  wait for CLK_PERIOD/2;
 end loop;
end process;

-- ===================================================
-- =====            Stimulus Process             =====
-- ===================================================
stim_proc : process
begin

 wait for 200 ns;
 for i in 0 to 2 loop 
   s_data <= test_data(i);
   wait until rising_edge(s_clk);
   s_send <= '1';
   wait until rising_edge(s_clk);
   s_send <= '0';
   
   wait for 20*BIT_TIME;
   
 end loop;


end process;

-- ===================================================
-- =====             Monitor Process             =====
-- ===================================================

 mon_proc: process
 begin
  
   for i in 0 to 2 loop
      uart_receive( s_tx, s_rx_data, s_rx_valid, s_rx_error, CLK_PERIOD, 9600);

      if s_rx_error='1' or s_rx_valid='0' then
          report "RX error/invalid Test Case" & integer'image(i) severity error;
      elsif s_rx_data /= test_data(i) then
          report "Mismatch Test Case" & integer'image(i) severity error;
      else
          report "OK Test Case " & integer'image(i) severity note;
      end if;

   end loop;

 report "=== ALL TESTS COMPLETED ===" severity note;
 wait;
 end process  mon_proc;

end architecture tb;
