LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


entity tb_uart_rx_core is 
end entity tb_uart_rx_core;

architecture sim of tb_uart_rx_core is

-- ===================================
-- =====  Procedure Declaration  =====
 procedure uart_send (
  signal  o_rx_line :out std_logic;
  constant BAUDRATE :in integer;
  constant DATA     :in std_logic_vector( 7 downto 0)
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

-- ===================================
 signal s_clk : std_logic := '0';
 signal s_rx_line : std_logic := '1';
 signal s_baud_sel : std_logic_vector(1 downto 0) := "00"; -- 4800 bit/sec
 signal s_valid : std_logic;
 signal s_error : std_logic;
 signal s_data  : std_logic_vector(7 downto 0);
 constant TIME_PERIOD : time := 20 ns;
begin

-- ====================================
-- =====  DUT Instantation        =====
-- ====================================
 dut: entity work.uart_rx_core 
  port map (
    i_baud_sel => s_baud_sel,
    i_clk => s_clk,
    i_rx_line => s_rx_line,
    o_valid => s_valid,
    o_error => s_error,
    o_data  => s_data
  );

-- ====================================
-- ===== Clock Generation Process =====
-- ====================================

 clk_gen: process
 begin
  s_clk <= '1';
  wait for TIME_PERIOD/2;
  s_clk <= '0';
  wait for TIME_PERIOD/2;
 end process clk_gen;

-- ====================================
-- ====== Stimulus Process  ===========
-- ====================================
 stim_process: process
 begin
   wait for 1000*TIME_PERIOD;

   uart_send(s_rx_line, 4800, "10101010");
   wait for 1000*TIME_PERIOD;

   uart_send(s_rx_line, 4800, "11101001");
   wait for 1000*TIME_PERIOD;

   uart_send(s_rx_line, 4800, "10001011");
   wait for 1000*TIME_PERIOD;

   uart_send(s_rx_line, 4800, "11101111");
   wait for 1000*TIME_PERIOD;

   uart_send(s_rx_line, 4800, "00001001");
   wait for 1000*TIME_PERIOD;

 end process stim_process;

 

-- ====================================
-- ======  Monitor Process ============
-- ====================================
 mon_proc: process
 begin
  
  wait until rising_edge(s_valid);
  if s_data="10101010" then
     report "Frame 1: OK";
  else 
     report "Frame 1: Error" severity error;
  end if;

  wait until rising_edge(s_valid);
  if s_data="11101001" then
     report "Frame 2: OK";
  else 
     report "Frame 2: Error" severity error;
  end if;

  wait until rising_edge(s_valid);
  if s_data="10001011" then
     report "Frame 3: OK";
  else 
     report "Frame 3: Error" severity error;
  end if;


  wait until rising_edge(s_valid);
  if s_data="00001001" then
     report "Frame 4: OK";
  else 
     report "Frame 4: Error" severity error;
  end if;

 end process;
end architecture sim;

