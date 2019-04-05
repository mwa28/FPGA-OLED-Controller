--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: Demo for the OLED display. First displays the alphabet for ~4 seconds and then
-- clears the display, waits for a ~1 second and then displays "Hello world!".
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity oled_ex is
    port (  clk         : in std_logic; -- System clock
            rst         : in std_logic; -- Global synchronous reset
            data_in     : in std_logic_vector(511 downto 0);
            en          : in std_logic; -- Block enable pin
            sdout       : out std_logic; -- SPI data out
            oled_sclk   : out std_logic; -- SPI clock
            oled_dc     : out std_logic; -- Data/Command controller
            fin         : out std_logic); -- Finish flag for block
end oled_ex;

architecture behavioral of oled_ex is

    -- SPI controller
    component spi_ctrl
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdata       : in std_logic_vector (7 downto 0);
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                fin         : out std_logic);
    end component;

    -- delay controller
    component delay
        port (  clk         : in std_logic;
                rst         : in std_logic;
                delay_ms    : in std_logic_vector (11 downto 0);
                delay_en    : in std_logic;
                delay_fin   : out std_logic);
    end component;

    -- character library, latency = 1
    component ascii_rom
        port (  clk    : in std_logic; -- System clock
                addr   : in std_logic_vector (10 downto 0); -- First 8 bits is the ASCII value of the character, the last 3 bits are the parts of the char
                dout   : out std_logic_vector (7 downto 0)); -- Data byte out
    end component;

    -- States for state machine
    type states is (Idle,
                    ClearDC,
                    SetPage,
                    PageNum,
                    LeftColumn1,
                    LeftColumn2,
                    SetDC,
                    Alphabet,
                    Wait1,
                    ClearScreen,
                    Wait2,
                    HelloWorldScreen,
                    ReadRegisters,
                    Wait3,
                    UpdateScreen,
                    SendChar1,
                    SendChar2,
                    SendChar3,
                    SendChar4,
                    SendChar5,
                    SendChar6,
                    SendChar7,
                    SendChar8,
                    ReadMem,
                    ReadMem2,
                    Done,
                    Transition1,
                    Transition2,
                    Transition3,
                    Transition4,
                    Transition5);

    type oled_mem is array (0 to 3, 0 to 15) of std_logic_vector (7 downto 0);

    -- Variable that contains what the screen will be after the next UpdateScreen state
    signal current_screen : oled_mem;

    -- Constant that contains the screen filled with the Alphabet and numbers
    constant alphabet_screen : oled_mem := ((x"41", x"42", x"43", x"44", x"45", x"46", x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F", x"50"),
                                            (x"51", x"52", x"53", x"54", x"55", x"56", x"57", x"58", x"59", x"5A", x"61", x"62", x"63", x"64", x"65", x"66"),
                                            (x"67", x"68", x"69", x"6A", x"6B", x"6C", x"6D", x"6E", x"6F", x"70", x"71", x"72", x"73", x"74", x"75", x"76"),
                                            (x"77", x"78", x"79", x"7A", x"30", x"31", x"32", x"33", x"34", x"35", x"36", x"37", x"38", x"39", x"7F", x"7F"));

    -- Constant that fills the screen with blank (spaces) entries
    constant clear_screen : oled_mem := (   (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
                                            (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
                                            (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
                                            (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"));

    -- Constant that holds "Hello world!"
    constant hello_world_screen : oled_mem := ( (x"48", x"65", x"6c", x"6c", x"6f", x"20", x"77", x"6f", x"72", x"6c", x"64", x"21", x"20", x"20", x"20", x"20"),
                                                (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
                                                (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
                                                (x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"));

    -- Current overall state of the state machine
    signal current_state : states := Idle;

    -- State to go to after the SPI transmission is finished
    signal after_state : states;

    -- State to go to after the set page sequence
    signal after_page_state : states;

    -- State to go to after sending the character sequence
    signal after_char_state : states;

    -- State to go to after the UpdateScreen is finished
    signal after_update_state : states;

    -- Contains the value to be outputted to oled_dc
    signal temp_dc : std_logic := '0';

    -- Used in the Delay controller block
    signal temp_delay_ms : std_logic_vector (11 downto 0); -- Amount of ms to delay
    signal temp_delay_en : std_logic := '0'; -- Enable signal for the Delay block
    signal temp_delay_fin : std_logic; -- Finish signal for the Delay block

    -- Used in the SPI controller block
    signal temp_spi_en : std_logic := '0'; -- Enable signal for the SPI block
    signal temp_sdata : std_logic_vector (7 downto 0) := (others => '0'); -- Data to be sent out on SPI
    signal temp_spi_fin : std_logic; -- Finish signal for the SPI block

    signal temp_char : std_logic_vector (7 downto 0) := (others => '0'); -- Contains ASCII value for character
    signal temp_addr : std_logic_vector (10 downto 0) := (others => '0'); -- Contains address to byte needed in memory
    signal temp_dout : std_logic_vector (7 downto 0); -- Contains byte outputted from memory
    signal temp_page : std_logic_vector (1 downto 0) := (others => '0'); -- Current page
    signal temp_index : integer range 0 to 15 := 0; -- Current character on page


begin

    oled_dc <= temp_dc;

    -- "Example" finish flag only high when in done state
    fin <= '1' when current_state = Done else '0';

    -- Instantiate SPI controller
    spi_comp: spi_ctrl port map (   clk => clk,
                                    rst => rst,
                                    en => temp_spi_en,
                                    sdata => temp_sdata,
                                    sdout => sdout,
                                    oled_sclk => oled_sclk,
                                    fin => temp_spi_fin);

    -- Instantiate delay
    delay_comp: delay port map (clk => clk,
                                rst => rst,
                                delay_ms => temp_delay_ms,
                                delay_en => temp_delay_en,
                                delay_fin => temp_delay_fin);

    -- Instantiate ASCII character library
    char_lib_comp : ascii_rom port map (clk => clk,
                                        addr => temp_addr,
                                        dout => temp_dout);

    process (clk)
    begin
        if rising_edge(clk) then
            case current_state is
                -- Idle until en pulled high than intialize Page to 0 and go to state alphabet afterwards
                when Idle =>
                    if en = '1' then
                        current_state <= ClearDC;
                        after_page_state <= Alphabet;
                        temp_page <= "00";
                    end if;
                -- Set current_screen to constant alphabet_screen and update the screen; go to state Wait1 afterwards
                when Alphabet =>
                    current_screen <= alphabet_screen;
                    current_state <= UpdateScreen;
                    after_update_state <= Wait1;
                -- Wait 4ms and go to ClearScreen
                when Wait1 =>
                    temp_delay_ms <= "111110100000"; -- 4000
                    after_state <= ClearScreen;
                    current_state <= Transition3; -- Transition3 = delay transition states
                -- Set current_screen to constant clear_screen and update the screen; go to state Wait2 afterwards
                when ClearScreen =>
                    current_screen <= clear_screen;
                    after_update_state <= Wait2;
                    current_state <= UpdateScreen;
                -- Wait 1ms and go to HelloWorldScreen
                when Wait2 =>
                    temp_delay_ms <= "001111101000"; -- 1000
                    after_state <= HelloWorldScreen;
                    current_state <= Transition3; -- Transition3 = delay transition states
                -- Set currentScreen to constant hello_world_screen and update the screen; go to state Done afterwards
                when HelloWorldScreen =>
                    current_screen <= hello_world_screen;
                    after_update_state <= Wait3;
                    current_state <= UpdateScreen;
                when Wait3 =>
                    temp_delay_ms <= "111110100000"; -- 1000
                    after_state <= ReadRegisters;
                    current_state <= Transition3; -- Transition3 = delay transition states
               when ReadRegisters =>
                           current_screen(0,0) <= data_in(7 downto 0) ;
                           current_screen(0,1) <= data_in(15 downto 8) ;
                           current_screen(0,2) <= data_in(23 downto 16) ;
                           current_screen(0,3) <= data_in(31 downto 24) ;
                           current_screen(0,4) <= data_in(39 downto 32) ;
                           current_screen(0,5) <= data_in(47 downto 40) ;
                           current_screen(0,6) <= data_in(55 downto 48) ;
                           current_screen(0,7) <= data_in(63 downto 56) ;
                           current_screen(0,8) <= data_in(71 downto 64) ;
                           current_screen(0,9) <= data_in(79 downto 72) ;
                           current_screen(0,10) <= data_in(87 downto 80);
                           current_screen(0,11) <= data_in(95 downto 88) ;
                           current_screen(0,12) <= data_in(103 downto 96) ;
                           current_screen(0,13) <= data_in(111 downto 104) ;
                           current_screen(0,14) <= data_in(119 downto 112) ;
                           current_screen(0,15) <= data_in(127 downto 120) ;
                                   
                           current_screen(1,0) <= data_in(135 downto 128) ;
                           current_screen(1,1) <= data_in(143 downto 136) ;
                           current_screen(1,2) <= data_in(151 downto 144) ;
                           current_screen(1,3) <= data_in(159 downto 152) ;
                           current_screen(1,4) <= data_in(167 downto 160) ;
                           current_screen(1,5) <= data_in(175 downto 168) ;
                           current_screen(1,6) <= data_in(183 downto 176) ;
                           current_screen(1,7) <= data_in(191 downto 184) ;
                           current_screen(1,8) <= data_in(199 downto 192) ;
                           current_screen(1,9) <= data_in(207 downto 200) ;
                           current_screen(1,10) <= data_in(215 downto 208);
                           current_screen(1,11) <= data_in(223 downto 216) ;
                           current_screen(1,12) <= data_in(231 downto 224) ;
                           current_screen(1,13) <= data_in(239 downto 232) ;
                           current_screen(1,14) <= data_in(247 downto 240) ;
                           current_screen(1,15) <= data_in(255 downto 248) ;
                                       
                           current_screen(2,0) <= data_in(263 downto 256) ;
                           current_screen(2,1) <= data_in(271 downto 264) ;
                           current_screen(2,2) <= data_in(279 downto 272) ;
                           current_screen(2,3) <= data_in(287 downto 280) ;
                           current_screen(2,4) <= data_in(295 downto 288) ;
                           current_screen(2,5) <= data_in(303 downto 296) ;
                           current_screen(2,6) <= data_in(311 downto 304) ;
                           current_screen(2,7) <= data_in(319 downto 312) ;
                           current_screen(2,8) <= data_in(327 downto 320) ;
                           current_screen(2,9) <= data_in(335 downto 328);
                           current_screen(2,10) <= data_in(343 downto 336) ;
                           current_screen(2,11) <= data_in(351 downto 344) ;
                           current_screen(2,12) <= data_in(359 downto 352) ;
                           current_screen(2,13) <= data_in(367 downto 360) ;
                           current_screen(2,14) <= data_in(375 downto 368) ;
                           current_screen(2,15) <= data_in(383 downto 376) ;
                                   
                           current_screen(3,0) <= data_in(391 downto 384) ;
                           current_screen(3,1) <= data_in(399 downto 392) ;
                           current_screen(3,2) <= data_in(407 downto 400) ;
                           current_screen(3,3) <= data_in(415 downto 408) ;
                           current_screen(3,4) <= data_in(423 downto 416) ;
                           current_screen(3,5) <= data_in(431 downto 424) ;
                           current_screen(3,6) <= data_in(439 downto 432) ;
                           current_screen(3,7) <= data_in(447 downto 440) ;
                           current_screen(3,8) <= data_in(455 downto 448);
                           current_screen(3,9) <= data_in(463 downto 456) ;
                           current_screen(3,10) <= data_in(471 downto 464) ;
                           current_screen(3,11) <= data_in(479 downto 472) ;
                           current_screen(3,12) <= data_in(487 downto 480) ;
                           current_screen(3,13) <= data_in(495 downto 488) ;
                           current_screen(3,14) <= data_in(503 downto 496) ;
                           current_screen(3,15) <= data_in(511 downto 504) ;
                           current_state <= UpdateScreen;
                           after_update_state <= Done;
                           
                -- Do nothing until en is deassertted and then current_state is Idle
                when Done            =>
                    if en = '0' then
                        current_state <= Idle;
                    end if;

                -- UpdateScreen State
                -- 1. Gets ASCII value from current_screen at the current page and the current spot
                --    of the page
                -- 2. If on the last character of the page transition update the page number, if on
                --    the last page(3) then the updateScreen go to "after_update_state" after
                when UpdateScreen =>
                    temp_char <= current_screen(conv_integer(temp_page), temp_index);
                    if temp_index = 15 then
                        temp_index <= 0;
                        temp_page <= temp_page + 1;
                        after_char_state <= ClearDC;
                        if temp_page = "11" then
                            after_page_state <= after_update_state;
                        else
                            after_page_state <= UpdateScreen;
                        end if;
                    else
                        temp_index <= temp_index + 1;
                        after_char_state <= UpdateScreen;
                    end if;
                    current_state <= SendChar1;

                -- Update Page states
                -- 1. Sets oled_dc to command mode
                -- 2. Sends the SetPage Command
                -- 3. Sends the Page to be set to
                -- 4. Sets the start pixel to the left column
                -- 5. Sets oled_dc to data mode
                when ClearDC =>
                    temp_dc <= '0';
                    current_state <= SetPage;
                when SetPage =>
                    temp_sdata <= "00100010";
                    after_state <= PageNum;
                    current_state <= Transition1;
                when PageNum =>
                    temp_sdata <= "000000" & temp_page;
                    after_state <= LeftColumn1;
                    current_state <= Transition1;
                when LeftColumn1 =>
                    temp_sdata <= "00000000";
                    after_state <= LeftColumn2;
                    current_state <= Transition1;
                when LeftColumn2 =>
                    temp_sdata <= "00010000";
                    after_state <= SetDC;
                    current_state <= Transition1;
                when SetDC =>
                    temp_dc <= '1';
                    current_state <= after_page_state;
                -- End update Page states

                -- Send character states
                -- 1. Sets the address to ASCII value of character with the counter appended to the
                --    end
                -- 2. Waits a clock cycle for the data to get ready by going to ReadMem and ReadMem2
                --    states
                -- 3. Send the byte of data given by the ROM
                -- 4. Repeat 7 more times for the rest of the character bytes
                when SendChar1 =>
                    temp_addr <= temp_char & "000";
                    after_state <= SendChar2;
                    current_state <= ReadMem;
                when SendChar2 =>
                    temp_addr <= temp_char & "001";
                    after_state <= SendChar3;
                    current_state <= ReadMem;
                when SendChar3 =>
                    temp_addr <= temp_char & "010";
                    after_state <= SendChar4;
                    current_state <= ReadMem;
                when SendChar4 =>
                    temp_addr <= temp_char & "011";
                    after_state <= SendChar5;
                    current_state <= ReadMem;
                when SendChar5 =>
                    temp_addr <= temp_char & "100";
                    after_state <= SendChar6;
                    current_state <= ReadMem;
                when SendChar6 =>
                    temp_addr <= temp_char & "101";
                    after_state <= SendChar7;
                    current_state <= ReadMem;
                when SendChar7 =>
                    temp_addr <= temp_char & "110";
                    after_state <= SendChar8;
                    current_state <= ReadMem;
                when SendChar8 =>
                    temp_addr <= temp_char & "111";
                    after_state <= after_char_state;
                    current_state <= ReadMem;
                when ReadMem =>
                    current_state <= ReadMem2;
                when ReadMem2 =>
                    temp_sdata <= temp_dout;
                    current_state <= Transition1;
                -- End send character states

                -- SPI transitions
                -- 1. Set en to 1
                -- 2. Waits for spi_ctrl to finish
                -- 3. Goes to clear state (Transition5)
                when Transition1 =>
                    temp_spi_en <= '1';
                    current_state <= Transition2;
                when Transition2 =>
                    if temp_spi_fin = '1' then
                        current_state <= Transition5;
                    end if;
                -- End SPI transitions

                -- Delay transitions
                -- 1. Set delay_en to 1
                -- 2. Waits for delay to finish
                -- 3. Goes to Clear state (Transition5)
                when Transition3 =>
                    temp_delay_en <= '1';
                    current_state <= Transition4;
                when Transition4 =>
                    if temp_delay_fin = '1' then
                        current_state <= Transition5;
                    end if;
                -- End Delay transitions

                -- Clear transition
                -- 1. Sets both delay_en and en to 0
                -- 2. Go to after state
                when Transition5 =>
                    temp_spi_en <= '0';
                    temp_delay_en <= '0';
                    current_state <= after_state;
                -- End Clear transition

                when others =>
                    current_state <= Idle;
            end case;
        end if;
    end process;

end behavioral;
