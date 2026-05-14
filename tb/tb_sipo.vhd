LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity tb_sipo is
end entity;

architecture sim of tb_sipo is

    constant TIME_PERIOD : time := 20 ns;

    signal s_clk   : std_logic := '0';
    signal s_rst   : std_logic := '1';
    signal s_bit   : std_logic := '0';
    signal s_shift : std_logic := '0';
    signal s_data  : std_logic_vector(7 downto 0);

    -- ===== procedure declaration

    procedure shift_bit(
        signal bit_line   : out std_logic;
        signal shift_line : out std_logic;
        constant val      : std_logic
    ) is
    begin

        bit_line <= val;
        wait for TIME_PERIOD;

        shift_line <= '1';
        wait for TIME_PERIOD;

        shift_line <= '0';
        wait for TIME_PERIOD;

    end procedure;

begin

-- ===== DUT

dut : entity work.sipo
    generic map(
        CWIDTH => 8
    )
    port map(
        i_clk   => s_clk,
        i_rst   => s_rst,
        i_bit   => s_bit,
        i_shift => s_shift,
        o_data  => s_data
    );

-- ===== Clock

clk_gen : process
begin
    s_clk <= '0';
    wait for TIME_PERIOD/2;

    s_clk <= '1';
    wait for TIME_PERIOD/2;
end process;

-- ===== Stimulus

sti_proc : process
begin

    -- reset
    s_rst <= '1';
    wait for 5*TIME_PERIOD;

    s_rst <= '0';
    wait for 5*TIME_PERIOD;

    -- send 10110011
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '1');

    wait for 10*TIME_PERIOD;

    -- send 10101010
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    shift_bit(s_bit, s_shift, '1');
    shift_bit(s_bit, s_shift, '0');
    wait;

end process;

end architecture sim;

