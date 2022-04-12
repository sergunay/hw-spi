library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
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
end entity spi_master;

architecture rtl of spi_master is

    constant C_1		    : natural := CLK_DIV/4;
    constant C_2		    : natural := CLK_DIV*3/4;
    constant C_M		    : natural := CLK_DIV/2;

    -- Shift register with parallel load
    signal data_reg        : std_logic_vector(7 downto 0) := (others=>'0');
    signal data_shift      : std_logic := '0';
    signal data_tx         : std_logic := '0'; -- data_reg(0)

    signal cnt_rst         : std_logic := '0';
    signal clk_ovf         : std_logic := '0';

    signal spi_clk_int     : std_logic := '0';

    signal clk_cnt 		   : unsigned(7 downto 0)  := (others=>'0');

    -- Data bit down counter
    signal dbit_cnt_reg    : unsigned(3 downto 0) := (others=>'0');
    signal dbit_cnt_dec    : std_logic := '0';
    signal dbit_cnt_ovf    : std_logic := '0';

    type fsm_states is(
        ST_IDLE, 
        ST_START,
        ST_TX_DATA,
        ST_STOP);

    signal state_next, state_reg : fsm_states := ST_IDLE;

begin

    -- SRwPL
    DATA_SHIFT_PROC: process(iClk)
    begin
        if rising_edge(iClk) then
            if iRst_n = '0'then
                data_reg <= (others=>'0');
            elsif iReq = '1' then
                data_reg <= iData;
            elsif data_shift = '1' then
                data_reg <= '0' & data_reg(7 downto 1);
            end if;
        end if;
    end process DATA_SHIFT_PROC;

    data_tx <= data_reg(0);

    CLK_CNT_PROC: process(iClk)
    begin
        if rising_edge(iClk) then
            if iRst_n = '0' or cnt_rst = '1' or clk_ovf = '1' then
                clk_cnt	<= (others=>'0');
            else
                clk_cnt <= clk_cnt + 1;
            end if;
        end if;
    end process CLK_CNT_PROC;

    clk_ovf <= '1' when clk_cnt >= CLK_DIV else
               '0';
    
    spi_clk_int	<=  '1'	when clk_cnt > C_1 and clk_cnt <= C_2 else
                    '0';

    spi_clk <= spi_clk_int;

    -- CNTDN
    DBIT_CNTDN_PROC: process(iClk)
    begin
        if rising_edge(iClk) then
            if iRst_n = '0' or state_reg = ST_IDLE then
                dbit_cnt_reg <= to_unsigned(REG_NBITS-1, 4);
            elsif dbit_cnt_dec = '1' then
                dbit_cnt_reg <= dbit_cnt_reg - 1;
            end if;
        end if;
    end process DBIT_CNTDN_PROC;

    dbit_cnt_ovf <= '1' when dbit_cnt_reg = 0 else
                    '0';

    FSM_NSL: process(state_reg, iReq, clk_cnt, clk_ovf)
    begin
        state_next 	    <= state_reg;
        cnt_rst         <= '1';
        spi_cs_n        <= '1';
        spi_mosi        <= '0';
        dbit_cnt_dec    <= '0';
        data_shift      <= '0';

        case state_reg is
            

            when ST_IDLE    =>

                if iReq = '1' then
                    state_next <= ST_START;
                end if;

            ---------------------------------------------------

            when ST_START   =>

                spi_cs_n <= '0';
                cnt_rst  <= '0';

                if clk_cnt >= C_1 then
                    state_next 	<= ST_TX_DATA;
                    cnt_rst     <= '1';
                end if;

            ---------------------------------------------------

            when ST_TX_DATA	=>
                
                spi_cs_n    <= '0';
                cnt_rst     <= '0';
                spi_mosi    <= data_reg(0);  

                if clk_ovf = '1' then
                    
                    data_shift      <= '1';
                    dbit_cnt_dec    <= '1';

                    if dbit_cnt_ovf = '1' then
                        state_next	<= ST_STOP;
                    end if;
                end if;

            ---------------------------------------------------

            when ST_STOP  =>

                spi_cs_n    <= '0';
                cnt_rst     <= '0';
                spi_mosi    <= '0';

                if clk_cnt >= C_1 then
                    cnt_rst     <= '1';
                    state_next 	<= ST_IDLE;
                end if;


        end case;

    end process FSM_NSL;

    FSM_STATE_REG : process(iClk)
    begin
        if rising_edge(iClk) then
            if iRst_n = '0' then
                state_reg 		<= ST_IDLE;
            else
                state_reg 		<= state_next;
            end if;
        end if;
    end process FSM_STATE_REG;

end architecture rtl;