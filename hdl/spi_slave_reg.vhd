library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_slave_reg is
    generic(
        REG_NBITS : natural := 8);
    port(
        iClk     : in std_logic;
        iRst_n   : in std_logic;
        
        spi_clk  : in std_logic;
        spi_mosi : in std_logic;
        spi_cs   : in std_logic;

        oReg     : out std_logic_vector(REG_NBITS-1 downto 0));
    
end entity spi_slave_reg;