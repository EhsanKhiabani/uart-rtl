-- ==========================================================
-- ===============   UART TX Finite State Machine   =========
-- ===============          UART Project           =========
-- ==========================================================


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tx_fsm is 
  port (
   i_clk  : in std_logic;
   i_send : in std_logic;
   i_tx_bit_cnt : in std_logic_vector( 3 downto 0);

   o_ready: out std_logic;
   o_load_frame : out std_logic;
   o_tx_cnt_rst : out std_logic
   
  );
end entity tx_fsm;

architecture behavioral of tx_fsm is
 type tx_state_t is (idle, load_frame, send_frame, done);
 
 signal curr_state : tx_state_t := idle;
 signal next_state : tx_state_t := idle;
begin

 -- ============================
 -- ==== Sequential Section ====
 -- ============================
 seq_proc: process(i_clk)
 begin

   if rising_edge(i_clk) then
     curr_state <= next_state;
   end if;

 end process seq_proc;



 -- ==============================
 -- ==== Combinational Section ===
 -- ============================== 
 comb_proc: process(all)
 begin
 
 -- ===== default assignment
 next_state <= curr_state;

 o_load_frame <= '0';
 o_ready      <= '1';
 o_tx_cnt_rst <= '1';


 case curr_state is 

     when idle =>
        if i_send='1' then
           next_state <= load_frame;
        end if;
     when load_frame =>
        o_load_frame <= '1';
	next_state <= send_frame;
     when send_frame =>
        o_tx_cnt_rst <= '0';
	o_ready <= '0';
	if unsigned(i_tx_bit_cnt)=10 then
           next_state <= done;
        end if;
     when done =>
        o_tx_cnt_rst <= '1';
        next_state <= idle;
 end case;

 end process comb_proc;

end architecture behavioral;
