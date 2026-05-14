LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity rx_fsm IS
port (
    i_clk : in std_logic;

    -- Serial RX input line
    i_rx         : in std_logic;

    -- Asserted when a falling edge on RX line is detected (start bit)
    i_start_detected : in std_logic;

    -- Current value of the RX bit counter
    i_rx_bit_cnt : in std_logic_vector(3 downto 0);

    -- Resets the RX bit counter
    o_bit_cnt_rst : out std_logic;

    -- Enables the baud tick generator during reception
    o_baud_gen_en : out std_logic;

    -- 
    -- Asserted when a valid frame is received
    o_valid : out std_logic;

    -- Asserted when a frame error occurs
    o_error : out std_logic
);
end entity;

architecture behavioral of rx_fsm is

 type rx_state_t is (idle, sync_baud, start_check,frame_receive, stop_check, data_valid, error);

 signal s_curr_state : rx_state_t := idle;
 signal s_next_state : rx_state_t := idle;

begin

-- =========================================
-- ==== Sequential Section             =====
-- ==== Updates the current FSM state  =====
-- =========================================

seq_proc : process(i_clk)
begin
    if rising_edge(i_clk) then
        s_curr_state <= s_next_state;
    end if;
end process seq_proc;


-- ============================================
-- ==== Combinational Section              ====
-- ==== Determines the next FSM state      ====
-- ==== and generates output control       ====
-- ==== signals based on the current state ====
-- ============================================
comb_proc : process(all)
begin
  
  -- === Default Assignment
  o_bit_cnt_rst <= '1';
  o_baud_gen_en <= '0';
  o_valid <= '0';
  o_error <= '0';
  s_next_state <= s_curr_state;

  -- === state machine engine

  case s_curr_state is
    

    when idle => 
      if i_start_detected='1' then
        s_next_state <= sync_baud;
      end if;

    

    when sync_baud =>
      o_baud_gen_en <= '1';
      s_next_state <= start_check;

    when start_check =>    
      o_bit_cnt_rst <= '0';
      o_baud_gen_en <= '1';
      if unsigned(i_rx_bit_cnt) = 1 then
        if i_rx='0' then
          s_next_state <= frame_receive;
        else
          s_next_state <= error;
        end if;
      end if;
    when frame_receive =>
      o_bit_cnt_rst <= '0';
      o_baud_gen_en <= '1';
      if unsigned(i_rx_bit_cnt) = 10 then
        s_next_state <= stop_check;
      end if;

    when stop_check =>
      if i_rx = '1' then 
        s_next_state <= data_valid;
      else
        s_next_state <= error;
      end if;

    when data_valid =>
      o_valid <= '1';
      s_next_state <= idle;
    
    when error =>
      o_error <= '1';
      s_next_state <= idle;
    
  end case;
  

end process;

end architecture behavioral;

