-- module Description
-- N-bit Counter with synchronous Reset

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity counterNb is
	generic ( CWIDTH : natural :=8 );
	port (
		i_clk : in std_logic;

		i_rst : in std_logic;

		o_cnt :out std_logic_vector(CWIDTH-1 downto 0)

	);
end entity counterNb;


architecture behavioral of counterNb is
	signal s_cnt : unsigned(CWIDTH-1 downto 0):= (others => '0');
begin
	
	counter: process(i_clk) 
		begin
		if (i_clk'event and i_clk = '1') then
			if (i_rst = '1') then 
				s_cnt <= (others=>'0'); -- reset counter 
			else
				s_cnt <= s_cnt + 1;     -- count up
			end if;
		end if;
	end process;
	
	o_cnt <= std_logic_vector(s_cnt);

end architecture behavioral;