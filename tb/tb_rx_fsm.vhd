LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_rx_fsm is
end entity;


architecture sim of tb_rx_fsm is

 -- ====== Procedure Decleration ======
 procedure drive_rx (
    signal i_clk : in std_logic;
    signal o_rx  : out std_logic;
    signal o_start_detect : out std_logic;
    signal o_cnt_bit : out std_logic_vector( 3 downto 0);
    constant DATA : std_logic_vector( 9 downto 0)
 ) is
 begin
  wait until rising_edge(i_clk);
  if(DATA(0) = '0') then
    o_start_detect <= '1';
  end if;

  for j in 1 to 5 loop
    wait until rising_edge(i_clk);
  end loop;    
  o_cnt_bit <= std_logic_vector(to_unsigned(1,o_cnt_bit'length)); 
  o_rx <= DATA(0);
  
  for i in 1 to 9 loop
 
      for j in 1 to 10 loop
         wait until rising_edge(i_clk);
      end loop;
      o_cnt_bit <= std_logic_vector(to_unsigned(i+1,o_cnt_bit'length)); 
      o_rx <= DATA(i);

   end loop;
 end procedure drive_rx;

 -- ===================================
 signal s_clk : std_logic := '0';
 signal s_rx  : std_logic := '1';
 signal s_start_detected : std_logic := '0';
 signal s_rx_bit_cnt  : std_logic_vector(3 downto 0) := (others=>'0');
 signal s_bit_cnt_rst : std_logic;
 signal s_baud_gen_en : std_logic;
 signal s_valid : std_logic;
 signal s_error : std_logic;

 constant TIME_PERIOD: time := 20 ns;
begin

-- ==== Device Under Test Instance
 dut: entity work.rx_fsm
  port map (
    i_clk => s_clk,
    i_rx  => s_rx,
    i_start_detected => s_start_detected,
    i_rx_bit_cnt => s_rx_bit_cnt,
    o_bit_cnt_rst=> s_bit_cnt_rst,
    o_baud_gen_en=> s_baud_gen_en,
    o_valid      => s_valid,
    o_error      => s_error
  );

-- === Clock Generation Process
 clk_gen: process
 begin
    s_clk <= '0';
    wait for TIME_PERIOD/2;
    s_clk <= '1';
    wait for TIME_PERIOD/2;
 end process clk_gen;


-- === Stimulus Process

 stim_proc: process
 begin
  
  wait for 10*TIME_PERIOD;
  drive_rx(s_clk, s_rx, s_start_detected, s_rx_bit_cnt, "1010101010");
  
 wait;
 end process stim_proc;

end architecture sim;