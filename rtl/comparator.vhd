LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity comparator is
 generic ( CWIDTH : natural :=8 );
 port(
	in1 : in std_logic_vector(CWIDTH-1 downto 0);
	in2 : in std_logic_vector(CWIDTH-1 downto 0);
	
	o   : out std_logic	
 );
end entity comparator;

architecture behavioral of comparator is
begin
 
 comp: process(in1, in2)
 begin
  if in1 > in2 then 
    o <= '1';
  else
    o <= '0';
  end if;
 end process;


end behavioral;