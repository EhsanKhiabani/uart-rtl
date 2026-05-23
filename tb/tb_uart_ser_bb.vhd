LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



entity tb_uart_ser_bb is
end entity;

architecture sim of tb_uart_ser_bb is
-- ==============================================
-- =======        DATA Type Definitions =========
type data_test_array_t is array(natural range <>) of std_logic_vector(7 downto 0);

-- ==============================================
-- ==============================================
-- DUT signals
signal s_idata     : std_logic_vector(7 downto 0);
signal s_odata     : std_logic_vector(7 downto 0);
signal s_send     : std_logic := '0';
signal s_clk      : std_logic := '0';
signal s_baud_sel : std_logic_vector(1 downto 0) := "01";

signal s_ready    : std_logic;
signal s_valid    : std_logic;
signal s_error    : std_logic;
-- Data test array
signal test_data : data_test_array_t(0 to 2) := ("10101010","11100101","00001111");

constant CLK_PERIOD : time := 20 ns; -- 50 MHz
constant BIT_TIME   : time := 1 sec / 9600; --
begin

-- ===================================================
-- =====            DUT INSTANTATION             =====
-- ===================================================
dut: entity work.uart_ser_bb
port map(
  i_clk     => s_clk,
  i_data    => s_idata, 
  i_send    => s_send,
  i_baud_sel=> s_baud_sel,
  
  o_ready=> s_ready,
  o_error=> s_error,
  o_valid=> s_valid,
  o_data => s_odata
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
   s_idata <= test_data(i);
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

      wait until rising_edge(s_valid);
  
      if s_idata /= test_data(i) then
          report "Mismatch Test Case" & integer'image(i) severity error;
      else
          report "OK Test Case " & integer'image(i) severity note;
      end if;

   end loop;

 report "=== ALL TESTS COMPLETED ===" severity note;
 wait;
 end process  mon_proc;

end architecture sim;