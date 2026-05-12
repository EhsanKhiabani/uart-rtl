-- ==========================================================
-- ===============   UART TX Finite State Machine   =========
-- ===============          UART Project           =========
-- ==========================================================
--
-- Description:
-- ----------------------------------------------------------
-- This module implements the control unit (FSM) of a UART
-- transmitter. It generates control signals for the TX
-- datapath (PISO shift register).
--
-- Frame format:
--   ? 1 Start bit
--   ? 8 Data bits
--   ? 1 Stop bit
-- Total: 10 bits per frame
--
-- The baud signal (i_baud) is used as a clock enable pulse.
-- Data shifting occurs only when i_baud = '1'.
--
-- Outputs:
--   o_ready : Indicates transmitter is idle and ready
--   o_load  : Loads parallel frame into shift register
--   o_shift : Shifts one bit on each baud tick
--   o_rst   : Resets/initializes datapath when required
-- ==========================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tx_fsm is
 port(
  i_clk  : in std_logic;  -- System clock
  i_baud : in std_logic;  -- Baud tick (clock enable pulse)
  i_send : in std_logic;  -- Start transmission request

  o_ready: out std_logic; -- High when transmitter is idle
  o_load : out std_logic -- Load enable for PISO register
 );
end entity tx_fsm;
 

architecture behavioral of tx_fsm is

 -- FSM state definition
 type tx_state_t is (idle, load_frame, send_frame, done);

 -- State registers
 signal current_state: tx_state_t := idle;
 signal next_state   : tx_state_t := idle;

 -- Internal control signals
 signal s_ready: std_logic := '1';
 signal s_load : std_logic := '0';

 -- Bit counter (counts transmitted bits)
 -- Range 0 to 10 ? total 10 bits in UART frame
 signal s_cnt  : integer range 0 to 11 := 0;

begin

 ----------------------------------------------------------------
 -- Sequential Process
 -- --------------------------------------------------------------
 -- ? Updates current state on rising clock edge
 -- ? Implements synchronous bit counter
 -- ? Counter increments only in send_frame state
 -- ? Counter advances only when i_baud = '1'
 ----------------------------------------------------------------
 state_controller: process(i_clk)
 begin
  if i_clk'event and i_clk='1' then
  
   -- State register update
   current_state <= next_state;

   -- Bit counter logic
   if current_state = send_frame then
    if i_baud = '1' and s_cnt < 11 then
     s_cnt <= s_cnt + 1;
    end if;
   else
    -- Reset counter when not transmitting
    s_cnt <= 0;
   end if;

  end if;
 end process state_controller;


 ----------------------------------------------------------------
 -- Combinational Process
 -- --------------------------------------------------------------
 -- ? Determines next_state
 -- ? Generates control signals
 -- ? Default assignments prevent latch inference
 ----------------------------------------------------------------
 state_machine: process(current_state, i_baud, i_send, s_cnt) 
 begin

  -- Default assignments (important to avoid latches)
  next_state <= current_state;
  s_ready <= '1';
  s_load  <= '0';
  
  case current_state is

   ------------------------------------------------------------
   when idle =>
   -- Wait for transmission request
   ------------------------------------------------------------
    if i_send = '1' then
     next_state <= load_frame;
    end if;


   ------------------------------------------------------------
   when load_frame =>
   -- One-cycle state to latch frame into PISO register
   ------------------------------------------------------------
     next_state <= send_frame;
     s_ready <= '0';
     s_load  <= '1';  -- Load frame into shift register


   ------------------------------------------------------------
   when send_frame =>
   -- Transmit 10 bits (start + data + stop)
   ------------------------------------------------------------ 
     if s_cnt > 10 then
       next_state <= done;  -- Transmission complete
     end if;
     s_ready <= '0';

   ------------------------------------------------------------
   when done =>
   -- Transmission completed
   -- Return to idle state
   ------------------------------------------------------------
     next_state <= idle;
     s_ready <= '0';

  end case;

 end process state_machine;


 -- Output assignments
 o_ready <= s_ready;
 o_load  <= s_load;


end architecture behavioral;
