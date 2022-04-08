library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity spi_slave_reg_tb is
end entity;

architecture tb of uart_tx_tb is
    component spi_slave_reg 
        generic(
            REG_NBITS : natural := 8);
        port(
            iClk     : in std_logic;
            iRst_n   : in std_logic;
            
            spi_clk  : in std_logic;
            spi_mosi : in std_logic;
            spi_cs   : in std_logic;
    
            oReg     : out std_logic_vector(REG_NBITS-1 downto 0));
    end component;
    constant C_CLK_PER   : time    := 83.33 ns;