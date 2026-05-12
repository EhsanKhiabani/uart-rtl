LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity rate_selector is
	port (
		i_rate_sel : in std_logic_vector(1 downto 0);

		o_setpoint :out std_logic_vector(15 downto 0)

	);
end entity rate_selector;

architecture behavioral of rate_selector is
begin
	
	setpoint: process(i_rate_sel) 
	begin
		case i_rate_sel is
			when "00" =>   o_setpoint<=x"28B1"; -- 4800	
			when "01" =>   o_setpoint<=x"1458"; -- 9600
			when "10" =>   o_setpoint<=x"0C90"; -- 14400
			when "11" =>   o_setpoint<=x"0A2C"; -- 19200
			when others => o_setpoint<=x"0000";
		end case;
	end process;

end architecture behavioral;