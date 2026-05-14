library ieee;
use ieee.std_logic_1164.all;

entity falling_edge_detector is
    port (
        i_clk          : in  std_logic;
        i_signal       : in  std_logic;
        o_falling_edge : out std_logic
    );
end entity falling_edge_detector;

architecture rtl of falling_edge_detector is

    signal s_prev : std_logic;

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then

            if (s_prev = '1' and i_signal = '0') then
                o_falling_edge <= '1';
            else
                o_falling_edge <= '0';
            end if;

            s_prev <= i_signal;

        end if;
    end process;

end architecture rtl;
