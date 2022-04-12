library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity spi_slave_reg_tb is
end entity;

architecture tb of spi_slave_reg_tb is

    component spi_master 
        generic(
            CLK_DIV   : natural := 40;
            REG_NBITS : natural := 8);
        port(
            iClk     : in std_logic;
            iRst_n   : in std_logic;
            iData    : in std_logic_vector(REG_NBITS-1 downto 0);
            iReq     : in std_logic;
            spi_clk  : out std_logic;
            spi_mosi : out std_logic;
            spi_cs_n : out std_logic);
    end component;

    component spi_slave_reg 
        generic(
            REG_NBITS : natural := 8);
        port(
            iClk     : in std_logic;
            iRst_n   : in std_logic;
            spi_clk  : in std_logic;
            spi_mosi : in std_logic;
            spi_cs_n : in std_logic;
            oReg     : out std_logic_vector(REG_NBITS-1 downto 0));
    end component;

    constant C_CLK_PER   : time    := 20.83 ns;
    constant C_CLK_DIV   : natural := 40;
    constant C_REG_NBITS : natural := 8;

    signal sim_clk       : std_logic := '0';
    signal sim_rst_n     : std_logic := '0';
    signal sim_stop      : boolean 	:= FALSE;
    signal sim_data      : std_logic_vector(7 downto 0) := (others=>'0');
    signal sim_req       : std_logic := '0';

    signal spi_clk       : std_logic := '0';
    signal spi_mosi      : std_logic := '0';
    signal spi_cs_n      : std_logic := '1';

    signal spi_out_reg   : std_logic_vector(7 downto 0) := (others=>'0');


begin

    I_SPI_MASTER: spi_master 
    generic map(
        CLK_DIV   => C_CLK_DIV,
        REG_NBITS => C_REG_NBITS)
    port map(
        iClk     => sim_clk,
        iRst_n   => sim_rst_n,
        iData    => sim_data,
        iReq     => sim_req,
        
        spi_clk  => spi_clk,
        spi_mosi => spi_mosi,
        spi_cs_n => spi_cs_n);

    DUT: spi_slave_reg
    generic map(
        REG_NBITS => C_REG_NBITS)
    port map(
        iClk     => sim_clk,
        iRst_n   => sim_rst_n,
        spi_clk  => spi_clk,
        spi_mosi => spi_mosi,
        spi_cs_n => spi_cs_n,
        oReg     => spi_out_reg);


    CLK_STIM : sim_clk 	<= not sim_clk after C_CLK_PER/2 when not sim_stop;

    STIM_PROC: process

        procedure init is
        begin
            sim_rst_n 		<= '0';
            wait for 4*C_CLK_PER;
            sim_rst_n		<= '1';
        end procedure init;

        procedure load(
            constant data    : std_logic_vector(7 downto 0)) is
        begin
            sim_data(7 downto 0)    <= data(7 downto 0);
            sim_req                 <= '1';
            wait for C_CLK_PER;
            sim_req                 <= '0';
        end procedure load;

    begin

        init;
        wait for 10*C_CLK_PER;

        load("10010110");

        wait;
    end process STIM_PROC;

end architecture tb;