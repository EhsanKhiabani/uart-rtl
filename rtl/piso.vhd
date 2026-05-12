-- ============================================================
--  PISO (Parallel In Serial Out) Shift Register
--  Generic, configurable shift direction
-- ============================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- =========================
-- Entity Declaration
-- =========================
entity piso is
 generic(
  -- Width of the register (number of bits)
  CWIDTH : natural := 8;

  -- Shift direction selector
  -- true  -> Left shift
  -- false -> Right shift
  LEFT_SHIFT : boolean := false
 );
 port(
  -- Parallel input data to be loaded into register
  i_data  : in std_logic_vector(CWIDTH-1 downto 0);

  -- Clock input (synchronous design)
  i_clk   : in std_logic;

  -- Load control: when '1', loads i_data into register
  i_load  : in std_logic;

  -- Shift enable: when '1', performs one shift operation
  i_shift : in std_logic;

  -- Synchronous reset: clears register to zero
  i_rst   : in std_logic;

  -- Serial output bit
  o_bit   : out std_logic
 );
end entity piso;

-- =========================
-- Architecture Definition
-- =========================
architecture behavioral of piso is

 -- Internal shift register storage
 -- Initialized to zero for defined simulation startup
 signal s_register : std_logic_vector(CWIDTH-1 downto 0) := (others=>'1');
 signal s_obit : std_logic := '1'; 
begin
 
 -- Main sequential process (clocked)
 main_body: process(i_clk)
 begin
  -- Rising edge detection (positive edge triggered)
  if(i_clk'event and i_clk='1') then

   -- Synchronous reset
   -- Highest priority: clears register
   if(i_rst = '1') then
    s_register <= (others=>'1');

   else
    -- Load operation has priority over shift
    -- When i_load is asserted, parallel data is captured
    if i_load='1' then 
     s_register <= i_data;

    -- Shift operation (Left shift mode)
    -- MSB is shifted out, '0' is shifted in at LSB
    elsif i_shift='1' and LEFT_SHIFT=true then
     s_register <= s_register(CWIDTH-2 downto 0) & '1';
      s_obit <= s_register(CWIDTH-1);
    -- Shift operation (Right shift mode)
    -- LSB is shifted out, '0' is shifted in at MSB
    elsif i_shift='1' and LEFT_SHIFT=false then
     s_register <= '1' & s_register(CWIDTH-1 downto 1);
      s_obit <= s_register(0);
    -- If neither load nor shift is active,
    -- register keeps its previous value
    else
     -- nothing to do
    end if;
   end if;
  end if;
 end process main_body;

 -- Serial output selection
 -- If LEFT_SHIFT = true:
 --    MSB is output (typical MSB-first transmission)
 -- If LEFT_SHIFT = false:
 --    LSB is output (typical UART LSB-first transmission)
-- o_bit <= s_register(CWIDTH-1) when LEFT_SHIFT= true 
--          else s_register(0);
 o_bit <= s_obit;
end architecture behavioral;
