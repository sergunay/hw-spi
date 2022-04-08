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
        spi_cs_n : in std_logic;

        oReg     : out std_logic_vector(REG_NBITS-1 downto 0));
end entity spi_slave_reg;

architecture rtl of spi_slave_reg is

    signal spi_clk_d   : std_logic := '0';
    signal spi_clk_2d  : std_logic := '0';

    signal spi_mosi_d  : std_logic := '0';
    signal spi_mosi_2d : std_logic := '0';

    signal spi_csn_d   : std_logic := '0';
    signal spi_csn_2d  : std_logic := '0';

    signal spi_clk_rise : std_logic := '0';
    signal spi_clk_fall : std_logic := '0';

    signal spi_csn_rise : std_logic := '0';
    signal spi_csn_fall : std_logic := '0';

	signal data_reg     : std_logic_vector(8 downto 0) := (others=>'0');
    signal out_reg      : std_logic_vector(7 downto 0) := (others=>'0');

begin


    SPI_IN_REG: process(iClk)
	begin
		if rising_edge (iClk) then
			if iRst_n = '0' then
				spi_clk_d   <=  '0';
                spi_clk_2d  <=  '0';
                spi_mosi_d  <=  '0';
                spi_mosi_2d <=  '0';
                spi_csn_d   <=  '0';
                spi_csn_2d  <=  '0';
			else
				spi_clk_d   <=  spi_clk;
                spi_clk_2d  <=  spi_clk_d;
                spi_mosi_d  <=  spi_mosi;
                spi_mosi_2d <=  spi_mosi_d;
                spi_csn_d   <=  spi_cs_n;
                spi_csn_2d  <=  spi_csn_d;
			end if;
		end if;
	end process SPI_IN_REG;

    spi_clk_rise <= '1' when spi_clk_2d = '0' and spi_clk_d = '1' else
                    '0';

    spi_clk_fall <= '1' when spi_clk_2d = '1' and spi_clk_d = '0' else
                    '0';

    spi_csn_rise <= '1' when spi_csn_2d = '0' and spi_csn_d = '1' else
                    '0';
    
    spi_csn_fall <= '1' when spi_csn_2d = '1' and spi_csn_d = '0' else
                    '0';
                    
    -- SReg
	SHIFT_REG_PROC: process(iClk)
	begin
		if rising_edge(iClk) then
			if iRst_n = '0'then
				data_reg <= (others=>'0');
			elsif spi_clk_rise = '1' then
				data_reg(8) <= spi_mosi_d;
            elsif spi_clk_fall = '1' then
                data_reg <= '0' & data_reg(8 downto 1);
			end if;
		end if;
	end process SHIFT_REG_PROC;

    OUT_LATCH_PROC: process(iClk)
	begin
		if rising_edge(iClk) then
			if iRst_n = '0' then
				out_reg <= (others => '0');
			elsif spi_csn_rise = '1' then
				out_reg <= data_reg(7 downto 0);
			end if;
		end if;
	end process OUT_LATCH_PROC;
    
    oReg <= out_reg;

end architecture rtl;