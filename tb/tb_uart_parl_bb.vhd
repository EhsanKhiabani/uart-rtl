LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



entity tb_uart_parl_bb is
end entity tb_uart_parl_bb;

architecture sim of tb_uart_parl_bb is
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


 procedure uart_send (
  signal  o_rx_line :out std_logic;
  constant DATA     :in std_logic_vector( 7 downto 0);
  constant BAUDRATE :in integer
 ) is
  variable v_bit_time : time;
 begin
  v_bit_time := 1 sec/BAUDRATE; -- bit time calculation
 
  -- Idle   
  o_rx_line <= '1';
  wait for v_bit_time;
 
  -- Start bit  
  o_rx_line <= '0';
  wait for v_bit_time;
  
  -- Data bits (LSB first)
  for i in 0 to DATA'length-1 loop
    o_rx_line <= DATA(i);
    wait for v_bit_time;
  end loop;

  -- Stop bit
  o_rx_line <= '1';
  wait for v_bit_time;

 end procedure uart_send;
-- ==============================================
-- =======        DATA Type Definitions =========
type data_test_array_t is array(natural range <>) of std_logic_vector(7 downto 0);

-- ==============================================
-- ==============================================
-- DUT signals
signal s_clk      : std_logic := '0';
signal s_baud_sel : std_logic_vector(1 downto 0) := "01";


signal s_tx       : std_logic;
signal s_rx       : std_logic;
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
dut: entity work.uart_parl_bb
port map(
  i_clk     => s_clk,
  i_ser_rx  => s_rx,
  i_baud_sel=> s_baud_sel,
  o_ser_tx  => s_tx
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

   uart_send(s_rx, test_data(i), 9600); 
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

end architecture sim;