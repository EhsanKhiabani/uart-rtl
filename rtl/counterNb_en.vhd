-- module Description
-- N-bit Counter with synchronous Reset

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity counterNb_en is
	generic ( CWIDTH : natural :=8 );
	port (
		i_clk : in std_logic;

		i_rst : in std_logic;
                i_en  : in std_logic; 
                i_preload: in std_logic_vector(CWIDTH-1 downto 0);

		o_cnt :out std_logic_vector(CWIDTH-1 downto 0)

	);
end entity counterNb_en;


architecture behavioral of counterNb_en is
	signal s_cnt : unsigned(CWIDTH-1 downto 0):= (others => '0');
	signal s_en  : std_logic := '0';
begin
	

 -- ==== counter main body
 counter: process(i_clk) 
 begin
    if (i_clk'event and i_clk = '1') then
      s_en <= i_en;
      if (i_rst = '1') then 

	s_cnt <= (others=>'0'); -- reset counter 

      elsif (s_en='0' and i_en='1') then 

        -- preload on enable rising edge 
        s_cnt <= unsigned(i_preload); 

      elsif i_en= '1' then
        -- count up while enabled
        s_cnt <= s_cnt + 1;     

      end if;
    end if;
 end process;
	
 o_cnt <= std_logic_vector(s_cnt);

end architecture behavioral;