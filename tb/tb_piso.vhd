LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_piso is
end entity tb_piso;

architecture tb of tb_piso is
 signal s_data: std_logic_vector(9 downto 0) := "0000000000";
 signal s_clk: std_logic := '0';
 signal s_baud_tick: std_logic := '0';
 signal s_load :std_logic := '0';
 signal s_rst: std_logic := '1';
 signal s_bit:std_logic := '0';
begin


  uut: entity work.piso
   generic map (
     CWIDTH => 10,
     LEFT_SHIFT => false    
   )
   port map (
    i_clk => s_clk,
    i_data=> s_data,
    i_load=> s_load,
    i_shift => s_baud_tick,
    i_rst   => s_rst,
    o_bit   => s_bit  
   );
  -- process to generate clk signal
  clk_gen: process
  begin
   s_clk <= not s_clk;
   wait for 10 ns;
  end process clk_gen;


  -- process to generate baud tick every 100 clk cycle
  baud_tick: process(s_clk)
   variable v_cnt: integer := 0;
  begin
   if rising_edge(s_clk) then
    if v_cnt< 100 then
     v_cnt := v_cnt + 1;
     s_baud_tick <= '0';
    else
     v_cnt := 0;
     s_baud_tick <= '1';
    end if;
   end if;
  end process baud_tick;


  -- process to check tx process
  tx_procss: process
  begin
   s_data(0) <= '0'; -- start bit
   s_data(9) <= '1'; -- stop bit
   s_data(8 downto 1) <= "01001101";
   wait for 100 ns;
   s_rst <= '0';
   wait for 100 ns;
   s_load <= '1';
   wait for 100 ns;
   s_load <= '0';
   wait for 30 us;
   s_data(0) <= '0'; -- start bit
   s_data(9) <= '1'; -- stop bit
   s_data(8 downto 1) <= "11100110";
   wait for 100 ns;
   s_rst <= '0';
   wait for 100 ns;
   s_load <= '1';
   wait for 100 ns;
   s_load <= '0';
   wait;
  end process tx_procss;

  
end architecture tb;