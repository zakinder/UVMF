-- VHDL-2008 translation of original sa.v.
-- No reset: initial signal/variable values reproduce the Verilog initial block.
-- Port result_o replaces Verilog port "out" because OUT is a VHDL keyword.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sa is
  port (
    clk      : in  std_logic;
    en_i     : in  std_logic;
    ina      : in  std_logic;
    inb      : in  std_logic;
    en_o     : out std_logic := '0';
    result_o : out std_logic := '0'
  );
end entity sa;

architecture rtl of sa is
begin
  serial_adder_p : process (clk)
    variable counter  : integer := 0;
    variable state    : integer range 0 to 2 := 0;
    variable temp_a   : unsigned(1 downto 0) := (others => '0');
    variable temp_b   : unsigned(1 downto 0) := (others => '0');
    variable temp_out : unsigned(2 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      -- Original RTL can restart operation whenever en_i is asserted.
      if en_i = '1' then
        state := 1;
      end if;

      case state is
        when 1 =>
          -- MSB first, two samples. Variables enforce sequential updates,
          -- matching blocking assignments in the source Verilog.
          temp_a := shift_left(temp_a, 1);
          temp_a(0) := ina;
          temp_b := shift_left(temp_b, 1);
          temp_b(0) := inb;
          counter := counter + 1;
          if counter = 2 then
            temp_out := resize(temp_a, 3) + resize(temp_b, 3);
            state := 2;
          end if;

        when 2 =>
          -- The source updates output ports with nonblocking assignments.
          result_o <= temp_out(2);
          temp_out := shift_left(temp_out, 1);
          counter := counter + 1;
          if counter = 3 then
            en_o <= '1';
          end if;
          if counter = 4 then
            en_o <= '0';
          end if;
          if counter = 6 then
            counter := 0;
            result_o <= '0';
            state := 0;
          end if;

        when others =>
          null;
      end case;
    end if;
  end process;
end architecture rtl;
