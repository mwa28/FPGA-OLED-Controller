library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oled_controller_ip_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7
	);
	port (
		-- Users to add ports here
        oled_sdin   : out std_logic;
        oled_sclk   : out std_logic;
        oled_dc     : out std_logic;
        oled_res    : out std_logic;
        oled_vbat   : out std_logic;
        oled_vdd    : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end oled_controller_ip_v1_0;

architecture arch_imp of oled_controller_ip_v1_0 is

	-- component declaration
	component oled_ctrl is
            port (  clk         : in std_logic;
                    rst         : in std_logic;
                    data_in     : in std_logic_vector(511 downto 0);
                    oled_sdin   : out std_logic;
                    oled_sclk   : out std_logic;
                    oled_dc     : out std_logic;
                    oled_res    : out std_logic;
                    oled_vbat   : out std_logic;
                    oled_vdd    : out std_logic);
    end component;
	component oled_controller_ip_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
		OLED_out: out std_logic_vector(514 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component oled_controller_ip_v1_0_S00_AXI;
    signal s_AXI_to_PL: std_logic_vector(514 downto 0);
begin

-- Instantiation of Axi Bus Interface S00_AXI
oled_controller_ip_v1_0_S00_AXI_inst : oled_controller_ip_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    OLED_out => s_AXI_to_PL,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
    U1: oled_ctrl port map (
        clk => s00_axi_aclk,
        rst => s00_axi_aresetn,
        data_in => s_AXI_to_PL(511 downto 0),
        oled_sdin => oled_sdin,
        oled_sclk => oled_sclk,
        oled_dc => oled_dc,
        oled_res => oled_res,
        oled_vbat => oled_vbat,
        oled_vdd => oled_vdd
        );
	-- User logic ends

end arch_imp;
_______________________________________________________________________

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oled_controller_ip_v1_0_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
	);
	port (
		-- Users to add ports here
        OLED_out: out std_logic_vector(514 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end oled_controller_ip_v1_0_S00_AXI;

architecture arch_imp of oled_controller_ip_v1_0_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 4;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 17
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg16	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	      slv_reg15 <= (others => '0');
	      slv_reg16 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"00000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 10
	                slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 11
	                slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 12
	                slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 13
	                slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 14
	                slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 15
	                slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 16
	                slv_reg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg1 <= slv_reg1;
	            slv_reg2 <= slv_reg2;
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	            slv_reg15 <= slv_reg15;
	            slv_reg16 <= slv_reg16;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"00000" =>
	        reg_data_out <= slv_reg0;
	      when b"00001" =>
	        reg_data_out <= slv_reg1;
	      when b"00010" =>
	        reg_data_out <= slv_reg2;
	      when b"00011" =>
	        reg_data_out <= slv_reg3;
	      when b"00100" =>
	        reg_data_out <= slv_reg4;
	      when b"00101" =>
	        reg_data_out <= slv_reg5;
	      when b"00110" =>
	        reg_data_out <= slv_reg6;
	      when b"00111" =>
	        reg_data_out <= slv_reg7;
	      when b"01000" =>
	        reg_data_out <= slv_reg8;
	      when b"01001" =>
	        reg_data_out <= slv_reg9;
	      when b"01010" =>
	        reg_data_out <= slv_reg10;
	      when b"01011" =>
	        reg_data_out <= slv_reg11;
	      when b"01100" =>
	        reg_data_out <= slv_reg12;
	      when b"01101" =>
	        reg_data_out <= slv_reg13;
	      when b"01110" =>
	        reg_data_out <= slv_reg14;
	      when b"01111" =>
	        reg_data_out <= slv_reg15;
	      when b"10000" =>
	        reg_data_out <= slv_reg16;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here
        OLED_out(31 downto 0) <= slv_reg0;
        OLED_out(63 downto 32) <= slv_reg1;
        OLED_out(95 downto 64) <= slv_reg2;
        OLED_out(127 downto 96) <= slv_reg3;
        OLED_out(159 downto 128) <= slv_reg4;
        OLED_out(191 downto 160) <= slv_reg5;
        OLED_out(223 downto 192) <= slv_reg6;
        OLED_out(255 downto 224) <= slv_reg7;
        OLED_out(287 downto 256) <= slv_reg8;
        OLED_out(319 downto 288) <= slv_reg9;
        OLED_out(351 downto 320) <= slv_reg10;
        OLED_out(383 downto 352) <= slv_reg11;
        OLED_out(415 downto 384) <= slv_reg12;
        OLED_out(447 downto 416) <= slv_reg13;
        OLED_out(479 downto 448) <= slv_reg14;
        OLED_out(511 downto 480) <= slv_reg15;
        OLED_out(514 downto 512) <= slv_reg16(2 downto 0);   
	-- User logic ends

end arch_imp;
_______________________________________________________________________
--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: Top level controller that controls the OLED display.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity oled_ctrl is
    port (  clk         : in std_logic;
            rst         : in std_logic;
            data_in     : in std_logic_vector(511 downto 0);
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic);
end oled_ctrl;

architecture behavioral of oled_ctrl is

    component oled_init is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                oled_res    : out std_logic;
                oled_vbat   : out std_logic;
                oled_vdd    : out std_logic;
                fin         : out std_logic);
    end component;

    component oled_ex is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                data_in     : in std_logic_vector(511 downto 0);
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                fin         : out std_logic);
    end component;

    type states is (Idle, OledInitialize, OledExample, Done);

    signal current_state : states := Idle;

    signal init_en          : std_logic := '0';
    signal init_done        : std_logic;
    signal init_sdata       : std_logic;
    signal init_spi_clk     : std_logic;
    signal init_dc          : std_logic;

    signal example_en       : std_logic := '0';
    signal example_sdata    : std_logic;
    signal example_spi_clk  : std_logic;
    signal example_dc       : std_logic;
    signal example_done     : std_logic;

begin

    Initialize: oled_init port map (clk,
                                    rst,
                                    init_en,
                                    init_sdata,
                                    init_spi_clk,
                                    init_dc,
                                    oled_res,
                                    oled_vbat,
                                    oled_vdd,
                                    init_done);

    Example: oled_ex port map ( clk,
                                rst,
                                data_in,
                                example_en,
                                example_sdata,
                                example_spi_clk,
                                example_dc,
                                example_done);

    -- MUXes to indicate which outputs are routed out depending on which block is enabled
    oled_sdin <= init_sdata when current_state = OledInitialize else example_sdata;
    oled_sclk <= init_spi_clk when current_state = OledInitialize else example_spi_clk;
    oled_dc <= init_dc when current_state = OledInitialize else example_dc;
    -- End output MUXes

    -- MUXes that enable blocks when in the proper states
    init_en <= '1' when current_state = OledInitialize else '0';
    example_en <= '1' when current_state = OledExample else '0';
    -- End enable MUXes

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= Idle;
            else
                case current_state is
                    when Idle =>
                        current_state <= OledInitialize;
                    -- Go through the initialization sequence
                    when OledInitialize =>
                        if init_done = '1' then
                            current_state <= OledExample;
                        end if;
                    -- Do example and do nothing when finished
                    when OledExample =>
                        if example_done = '1' then
                            current_state <= Done;
                        end if;
                    -- Do nthing
                    when Done =>
                        current_state <= Done;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process;

end behavioral;

_______________________________________________________________________

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
_______________________________________________________________________

--
-- Written by Michael Mattioli
--
-- Description: ROM containing ASCII character data.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ascii_rom is
    port (  clk     : in std_logic; -- System clock
            addr    : in std_logic_vector (10 downto 0); -- Memory address
            dout    : out std_logic_vector (7 downto 0)); -- Data from memory
end ascii_rom;

architecture behavioral of ascii_rom is

    -- 1024 elements, 8 bits each
    type memory is array (0 to 1023) of std_logic_vector (7 downto 0);

    -- ASCII character data
    constant rom_data : memory := ( x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"5f", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"03", x"00", x"03", x"00", x"00", x"00",
                                    x"64", x"3c", x"26", x"64", x"3c", x"26", x"24", x"00",
                                    x"26", x"49", x"49", x"7f", x"49", x"49", x"32", x"00",
                                    x"42", x"25", x"12", x"08", x"24", x"52", x"21", x"00",
                                    x"20", x"50", x"4e", x"55", x"22", x"58", x"28", x"00",
                                    x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"1c", x"22", x"41", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"41", x"22", x"1c", x"00", x"00",
                                    x"00", x"15", x"15", x"0e", x"0e", x"15", x"15", x"00",
                                    x"00", x"08", x"08", x"3e", x"08", x"08", x"00", x"00",
                                    x"00", x"00", x"00", x"50", x"30", x"00", x"00", x"00",
                                    x"00", x"08", x"08", x"08", x"08", x"08", x"00", x"00",
                                    x"00", x"00", x"00", x"40", x"00", x"00", x"00", x"00",
                                    x"40", x"20", x"10", x"08", x"04", x"02", x"01", x"00",
                                    x"00", x"3e", x"41", x"41", x"41", x"3e", x"00", x"00",
                                    x"00", x"00", x"41", x"7f", x"40", x"00", x"00", x"00",
                                    x"00", x"42", x"61", x"51", x"49", x"6e", x"00", x"00",
                                    x"00", x"22", x"41", x"49", x"49", x"36", x"00", x"00",
                                    x"00", x"18", x"14", x"12", x"7f", x"10", x"00", x"00",
                                    x"00", x"27", x"49", x"49", x"49", x"71", x"00", x"00",
                                    x"00", x"3c", x"4a", x"49", x"48", x"70", x"00", x"00",
                                    x"00", x"43", x"21", x"11", x"0d", x"03", x"00", x"00",
                                    x"00", x"36", x"49", x"49", x"49", x"36", x"00", x"00",
                                    x"00", x"06", x"09", x"49", x"29", x"1e", x"00", x"00",
                                    x"00", x"00", x"00", x"12", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"52", x"30", x"00", x"00", x"00",
                                    x"00", x"00", x"08", x"14", x"14", x"22", x"00", x"00",
                                    x"00", x"14", x"14", x"14", x"14", x"14", x"14", x"00",
                                    x"00", x"00", x"22", x"14", x"14", x"08", x"00", x"00",
                                    x"00", x"02", x"01", x"59", x"05", x"02", x"00", x"00",
                                    x"3e", x"41", x"5d", x"55", x"4d", x"51", x"2e", x"00",
                                    x"40", x"7c", x"4a", x"09", x"4a", x"7c", x"40", x"00",
                                    x"41", x"7f", x"49", x"49", x"49", x"49", x"36", x"00",
                                    x"1c", x"22", x"41", x"41", x"41", x"41", x"22", x"00",
                                    x"41", x"7f", x"41", x"41", x"41", x"22", x"1c", x"00",
                                    x"41", x"7f", x"49", x"49", x"5d", x"41", x"63", x"00",
                                    x"41", x"7f", x"49", x"09", x"1d", x"01", x"03", x"00",
                                    x"1c", x"22", x"41", x"49", x"49", x"3a", x"08", x"00",
                                    x"41", x"7f", x"08", x"08", x"08", x"7f", x"41", x"00",
                                    x"00", x"41", x"41", x"7F", x"41", x"41", x"00", x"00",
                                    x"30", x"40", x"41", x"41", x"3F", x"01", x"01", x"00",
                                    x"41", x"7f", x"08", x"0c", x"12", x"61", x"41", x"00",
                                    x"41", x"7f", x"41", x"40", x"40", x"40", x"60", x"00",
                                    x"41", x"7f", x"42", x"0c", x"42", x"7f", x"41", x"00",
                                    x"41", x"7f", x"42", x"0c", x"11", x"7f", x"01", x"00",
                                    x"1c", x"22", x"41", x"41", x"41", x"22", x"1c", x"00",
                                    x"41", x"7f", x"49", x"09", x"09", x"09", x"06", x"00",
                                    x"0c", x"12", x"21", x"21", x"61", x"52", x"4c", x"00",
                                    x"41", x"7f", x"09", x"09", x"19", x"69", x"46", x"00",
                                    x"66", x"49", x"49", x"49", x"49", x"49", x"33", x"00",
                                    x"03", x"01", x"41", x"7f", x"41", x"01", x"03", x"00",
                                    x"01", x"3f", x"41", x"40", x"41", x"3f", x"01", x"00",
                                    x"01", x"0f", x"31", x"40", x"31", x"0f", x"01", x"00",
                                    x"01", x"1f", x"61", x"14", x"61", x"1f", x"01", x"00",
                                    x"41", x"41", x"36", x"08", x"36", x"41", x"41", x"00",
                                    x"01", x"03", x"44", x"78", x"44", x"03", x"01", x"00",
                                    x"43", x"61", x"51", x"49", x"45", x"43", x"61", x"00",
                                    x"00", x"00", x"7f", x"41", x"41", x"00", x"00", x"00",
                                    x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"00",
                                    x"00", x"00", x"41", x"41", x"7f", x"00", x"00", x"00",
                                    x"00", x"04", x"02", x"01", x"01", x"02", x"04", x"00",
                                    x"00", x"40", x"40", x"40", x"40", x"40", x"40", x"00",
                                    x"00", x"01", x"02", x"00", x"00", x"00", x"00", x"00",
                                    x"00", x"34", x"4a", x"4a", x"4a", x"3c", x"40", x"00",
                                    x"00", x"41", x"3f", x"48", x"48", x"48", x"30", x"00",
                                    x"00", x"3c", x"42", x"42", x"42", x"24", x"00", x"00",
                                    x"00", x"30", x"48", x"48", x"49", x"3f", x"40", x"00",
                                    x"00", x"3c", x"4a", x"4a", x"4a", x"2c", x"00", x"00",
                                    x"00", x"00", x"48", x"7e", x"49", x"09", x"00", x"00",
                                    x"00", x"26", x"49", x"49", x"49", x"3f", x"01", x"00",
                                    x"41", x"7f", x"48", x"04", x"44", x"78", x"40", x"00",
                                    x"00", x"00", x"44", x"7d", x"40", x"00", x"00", x"00",
                                    x"00", x"00", x"40", x"44", x"3d", x"00", x"00", x"00",
                                    x"41", x"7f", x"10", x"18", x"24", x"42", x"42", x"00",
                                    x"00", x"40", x"41", x"7f", x"40", x"40", x"00", x"00",
                                    x"42", x"7e", x"02", x"7c", x"02", x"7e", x"40", x"00",
                                    x"42", x"7e", x"44", x"02", x"42", x"7c", x"40", x"00",
                                    x"00", x"3c", x"42", x"42", x"42", x"3c", x"00", x"00",
                                    x"00", x"41", x"7f", x"49", x"09", x"09", x"06", x"00",
                                    x"00", x"06", x"09", x"09", x"49", x"7f", x"41", x"00",
                                    x"00", x"42", x"7e", x"44", x"02", x"02", x"04", x"00",
                                    x"00", x"64", x"4a", x"4a", x"4a", x"36", x"00", x"00",
                                    x"00", x"04", x"3f", x"44", x"44", x"20", x"00", x"00",
                                    x"00", x"02", x"3e", x"40", x"40", x"22", x"7e", x"40",
                                    x"02", x"0e", x"32", x"40", x"32", x"0e", x"02", x"00",
                                    x"02", x"1e", x"62", x"18", x"62", x"1e", x"02", x"00",
                                    x"42", x"62", x"14", x"08", x"14", x"62", x"42", x"00",
                                    x"01", x"43", x"45", x"38", x"05", x"03", x"01", x"00",
                                    x"00", x"46", x"62", x"52", x"4a", x"46", x"62", x"00",
                                    x"00", x"00", x"08", x"36", x"41", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"7f", x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"41", x"36", x"08", x"00", x"00",
                                    x"00", x"18", x"08", x"08", x"10", x"10", x"18", x"00",
                                    x"AA", x"55", x"AA", x"55", x"AA", x"55", x"AA", x"55");

begin

    process (clk)
    begin
        if rising_edge(clk) then
            dout <= rom_data(conv_integer(addr));
        end if;
    end process;

end behavioral;
_______________________________________________________________________

--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: Creates a delay of delay_ms ms.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity delay is
    port (  clk         : in std_logic; -- System clock
            rst         : in std_logic;  -- Global synchronous reset
            delay_ms    : in std_logic_vector (11 downto 0); -- Amount of ms to delay
            delay_en    : in std_logic; -- Delay enable
            delay_fin   : out std_logic); -- Delay finish flag
end delay;

architecture behavioral of delay is

    type states is (Idle, Hold, Done);

    signal current_state : states := Idle; -- Signal for state machine
    signal clk_counter : std_logic_vector(16 downto 0) := (others => '0'); -- Counts up on every rising edge of clk
    signal ms_counter : std_logic_vector (11 downto 0) := (others => '0'); -- Counts up when clk_counter = 100,000

begin
    -- delay_fin goes high when delay is done
    delay_fin <= '1' when (current_state = Done and delay_en = '1') else '0';

    -- State machine for Delay block
    state_machine : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- When rst is asserted switch to Idle (synchronous)
                current_state <= Idle;
            else
                case current_state is
                    when Idle =>
                        if delay_en = '1' then -- Start delay on delay_en
                            current_state <= Hold;
                        end if;
                    when Hold =>
                        if ms_counter = delay_ms then -- Stay until delay_ms has occured
                            current_state <= Done;
                        end if;
                    when Done =>
                        if delay_en = '0' then -- Wait until delay_en is deasserted to go to Idle
                            current_state <= Idle;
                        end if;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process state_machine;


    -- Creates ms_counter that counts at 1KHz
    clk_div : process (clk)
    begin
        if rising_edge(clk) then
            if current_state = Hold then
                if clk_counter = "11000011010100000" then -- 100,000
                    clk_counter <= (others => '0');
                    ms_counter <= ms_counter + 1; -- Increments at 1KHz
                else
                    clk_counter <= clk_counter + 1;
                end if;
            else -- If not in the hold state reset counters
                clk_counter <= (others => '0');
                ms_counter <= (others => '0');
            end if;
        end if;
    end process;

end behavioral;

_______________________________________________________________________

--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: SPI block that sends SPI data formatted oled_sclk active low with sdout changing
-- on the falling edge.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity spi_ctrl is
    Port ( clk          : in std_logic; -- System clok (100MHz)
           rst          : in std_logic; -- Global synchronous reset
           en           : in std_logic; -- Block enable pin
           sdata        : in std_logic_vector (7 downto 0); -- Byte to be sent
           sdout        : out std_logic; -- Serial data out
           oled_sclk    : out std_logic; -- OLED serial clock
           fin          : out std_logic); -- Finish flag for block
end spi_ctrl;

architecture behavioral of spi_ctrl is

    type states is (Idle, Send, Done);

    signal current_state : states := Idle; -- Signal for state machine

    signal shift_register   : std_logic_vector (7 downto 0); -- Shift register to shift out sdata saved when en was set
    signal shift_counter    : std_logic_vector (3 downto 0); -- Keeps track how many bits were sent
    signal clk_divided      : std_logic := '1'; -- Used as oled_sclk
    signal counter          : std_logic_vector (4 downto 0) := (others => '0'); -- Count clocks to be used to divide clk
    signal temp_sdata       : std_logic := '1'; -- Tied to sdout

    signal falling : std_logic := '0'; -- Signal indicating that the clk has just fell

begin

    clk_divided <= not counter(4); -- oled_sclk = clk / 32
    oled_sclk <= clk_divided;
    sdout <= temp_sdata;
    fin <= '1' when current_state = Done else '0';

    state_machine : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- Synchronous rst
                current_state <= Idle;
            else
                case current_state is
                    when Idle => -- Wait for en to go high
                        if en = '1' then
                            current_state <= Send;
                        end if;
                    when Send => -- Start sending bits, transition out when all bits are sent and oled_sclk is high
                        if shift_counter = "1000" and falling = '0' then
                            current_state <= Done;
                        end if;
                    when Done => -- Finish SPI transimission wait for en to go low
                        if en = '0' then
                            current_state <= Idle;
                        end if;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process state_machine;

    clk_div : process (clk)
    begin
        if rising_edge(clk) then
            if current_state = Send then -- Start clock counter when in send state
                counter <= counter + 1;
            else -- Reset clock counter when not in send state
                counter <= (others => '0');
            end if;
        end if;
    end process clk_div;

    spi_send_byte : process (clk) -- Sends SPI data formatted oled_sclk active low with sdout changing on the falling edge
    begin
        if rising_edge(clk) then
            if current_state = Idle then
                shift_counter <= (others => '0');
                shift_register <= sdata; -- Keeps placing sdata into shift_register so that when state goes to send it has the latest sdata
                temp_sdata <= '1';
            elsif current_state = Send then
                if clk_divided = '0' and falling = '0' then -- If on the falling edge of clk_divided
                    falling <= '1'; -- Indicate that it is passed the falling edge
                    temp_sdata <= shift_register(7); -- Send out the MSB
                    shift_register <= shift_register(6 downto 0) & '0'; -- Shift through sdata
                    shift_counter <= shift_counter + 1; -- Keep track of what bit it is on
                elsif clk_divided = '1' then -- On oled_sclk high reset the falling flag
                    falling <= '0';
                end if;
            end if;
        end if;
    end process spi_send_byte;

end behavioral;
_______________________________________________________________________

/* Definition for CPU ID */
#define XPAR_CPU_ID 0

/* Definitions for peripheral PS7_CORTEXA9_0 */
#define XPAR_PS7_CORTEXA9_0_CPU_CLK_FREQ_HZ 666666687


/******************************************************************/

/* Canonical definitions for peripheral PS7_CORTEXA9_0 */
#define XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ 666666687


/******************************************************************/

#include "xparameters_ps.h"

#define STDIN_BASEADDRESS 0xE0001000
#define STDOUT_BASEADDRESS 0xE0001000

/******************************************************************/


/* Definitions for peripheral PS7_DDR_0 */
#define XPAR_PS7_DDR_0_S_AXI_BASEADDR 0x00100000
#define XPAR_PS7_DDR_0_S_AXI_HIGHADDR 0x1FFFFFFF


/******************************************************************/

/* Definitions for driver DEVCFG */
#define XPAR_XDCFG_NUM_INSTANCES 1

/* Definitions for peripheral PS7_DEV_CFG_0 */
#define XPAR_PS7_DEV_CFG_0_DEVICE_ID 0
#define XPAR_PS7_DEV_CFG_0_BASEADDR 0xF8007000
#define XPAR_PS7_DEV_CFG_0_HIGHADDR 0xF80070FF


/******************************************************************/

/* Canonical definitions for peripheral PS7_DEV_CFG_0 */
#define XPAR_XDCFG_0_DEVICE_ID XPAR_PS7_DEV_CFG_0_DEVICE_ID
#define XPAR_XDCFG_0_BASEADDR 0xF8007000
#define XPAR_XDCFG_0_HIGHADDR 0xF80070FF


/******************************************************************/

/* Definitions for driver DMAPS */
#define XPAR_XDMAPS_NUM_INSTANCES 2

/* Definitions for peripheral PS7_DMA_NS */
#define XPAR_PS7_DMA_NS_DEVICE_ID 0
#define XPAR_PS7_DMA_NS_BASEADDR 0xF8004000
#define XPAR_PS7_DMA_NS_HIGHADDR 0xF8004FFF


/* Definitions for peripheral PS7_DMA_S */
#define XPAR_PS7_DMA_S_DEVICE_ID 1
#define XPAR_PS7_DMA_S_BASEADDR 0xF8003000
#define XPAR_PS7_DMA_S_HIGHADDR 0xF8003FFF


/******************************************************************/

/* Canonical definitions for peripheral PS7_DMA_NS */
#define XPAR_XDMAPS_0_DEVICE_ID XPAR_PS7_DMA_NS_DEVICE_ID
#define XPAR_XDMAPS_0_BASEADDR 0xF8004000
#define XPAR_XDMAPS_0_HIGHADDR 0xF8004FFF

/* Canonical definitions for peripheral PS7_DMA_S */
#define XPAR_XDMAPS_1_DEVICE_ID XPAR_PS7_DMA_S_DEVICE_ID
#define XPAR_XDMAPS_1_BASEADDR 0xF8003000
#define XPAR_XDMAPS_1_HIGHADDR 0xF8003FFF


/******************************************************************/

/* Definitions for driver EMACPS */
#define XPAR_XEMACPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_ETHERNET_0 */
#define XPAR_PS7_ETHERNET_0_DEVICE_ID 0
#define XPAR_PS7_ETHERNET_0_BASEADDR 0xE000B000
#define XPAR_PS7_ETHERNET_0_HIGHADDR 0xE000BFFF
#define XPAR_PS7_ETHERNET_0_ENET_CLK_FREQ_HZ 125000000
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV1 1
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV1 5
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV1 50


/******************************************************************/

/* Canonical definitions for peripheral PS7_ETHERNET_0 */
#define XPAR_XEMACPS_0_DEVICE_ID XPAR_PS7_ETHERNET_0_DEVICE_ID
#define XPAR_XEMACPS_0_BASEADDR 0xE000B000
#define XPAR_XEMACPS_0_HIGHADDR 0xE000BFFF
#define XPAR_XEMACPS_0_ENET_CLK_FREQ_HZ 125000000
#define XPAR_XEMACPS_0_ENET_SLCR_1000Mbps_DIV0 8
#define XPAR_XEMACPS_0_ENET_SLCR_1000Mbps_DIV1 1
#define XPAR_XEMACPS_0_ENET_SLCR_100Mbps_DIV0 8
#define XPAR_XEMACPS_0_ENET_SLCR_100Mbps_DIV1 5
#define XPAR_XEMACPS_0_ENET_SLCR_10Mbps_DIV0 8
#define XPAR_XEMACPS_0_ENET_SLCR_10Mbps_DIV1 50


/******************************************************************/


/* Definitions for peripheral PS7_AFI_0 */
#define XPAR_PS7_AFI_0_S_AXI_BASEADDR 0xF8008000
#define XPAR_PS7_AFI_0_S_AXI_HIGHADDR 0xF8008FFF


/* Definitions for peripheral PS7_AFI_1 */
#define XPAR_PS7_AFI_1_S_AXI_BASEADDR 0xF8009000
#define XPAR_PS7_AFI_1_S_AXI_HIGHADDR 0xF8009FFF


/* Definitions for peripheral PS7_AFI_2 */
#define XPAR_PS7_AFI_2_S_AXI_BASEADDR 0xF800A000
#define XPAR_PS7_AFI_2_S_AXI_HIGHADDR 0xF800AFFF


/* Definitions for peripheral PS7_AFI_3 */
#define XPAR_PS7_AFI_3_S_AXI_BASEADDR 0xF800B000
#define XPAR_PS7_AFI_3_S_AXI_HIGHADDR 0xF800BFFF


/* Definitions for peripheral PS7_DDRC_0 */
#define XPAR_PS7_DDRC_0_S_AXI_BASEADDR 0xF8006000
#define XPAR_PS7_DDRC_0_S_AXI_HIGHADDR 0xF8006FFF


/* Definitions for peripheral PS7_GLOBALTIMER_0 */
#define XPAR_PS7_GLOBALTIMER_0_S_AXI_BASEADDR 0xF8F00200
#define XPAR_PS7_GLOBALTIMER_0_S_AXI_HIGHADDR 0xF8F002FF


/* Definitions for peripheral PS7_GPV_0 */
#define XPAR_PS7_GPV_0_S_AXI_BASEADDR 0xF8900000
#define XPAR_PS7_GPV_0_S_AXI_HIGHADDR 0xF89FFFFF


/* Definitions for peripheral PS7_INTC_DIST_0 */
#define XPAR_PS7_INTC_DIST_0_S_AXI_BASEADDR 0xF8F01000
#define XPAR_PS7_INTC_DIST_0_S_AXI_HIGHADDR 0xF8F01FFF


/* Definitions for peripheral PS7_IOP_BUS_CONFIG_0 */
#define XPAR_PS7_IOP_BUS_CONFIG_0_S_AXI_BASEADDR 0xE0200000
#define XPAR_PS7_IOP_BUS_CONFIG_0_S_AXI_HIGHADDR 0xE0200FFF


/* Definitions for peripheral PS7_L2CACHEC_0 */
#define XPAR_PS7_L2CACHEC_0_S_AXI_BASEADDR 0xF8F02000
#define XPAR_PS7_L2CACHEC_0_S_AXI_HIGHADDR 0xF8F02FFF


/* Definitions for peripheral PS7_OCMC_0 */
#define XPAR_PS7_OCMC_0_S_AXI_BASEADDR 0xF800C000
#define XPAR_PS7_OCMC_0_S_AXI_HIGHADDR 0xF800CFFF


/* Definitions for peripheral PS7_PL310_0 */
#define XPAR_PS7_PL310_0_S_AXI_BASEADDR 0xF8F02000
#define XPAR_PS7_PL310_0_S_AXI_HIGHADDR 0xF8F02FFF


/* Definitions for peripheral PS7_PMU_0 */
#define XPAR_PS7_PMU_0_S_AXI_BASEADDR 0xF8891000
#define XPAR_PS7_PMU_0_S_AXI_HIGHADDR 0xF8891FFF
#define XPAR_PS7_PMU_0_PMU1_S_AXI_BASEADDR 0xF8893000
#define XPAR_PS7_PMU_0_PMU1_S_AXI_HIGHADDR 0xF8893FFF


/* Definitions for peripheral PS7_QSPI_LINEAR_0 */
#define XPAR_PS7_QSPI_LINEAR_0_S_AXI_BASEADDR 0xFC000000
#define XPAR_PS7_QSPI_LINEAR_0_S_AXI_HIGHADDR 0xFCFFFFFF


/* Definitions for peripheral PS7_RAM_0 */
#define XPAR_PS7_RAM_0_S_AXI_BASEADDR 0x00000000
#define XPAR_PS7_RAM_0_S_AXI_HIGHADDR 0x0003FFFF


/* Definitions for peripheral PS7_RAM_1 */
#define XPAR_PS7_RAM_1_S_AXI_BASEADDR 0xFFFC0000
#define XPAR_PS7_RAM_1_S_AXI_HIGHADDR 0xFFFFFFFF


/* Definitions for peripheral PS7_SCUC_0 */
#define XPAR_PS7_SCUC_0_S_AXI_BASEADDR 0xF8F00000
#define XPAR_PS7_SCUC_0_S_AXI_HIGHADDR 0xF8F000FC


/* Definitions for peripheral PS7_SLCR_0 */
#define XPAR_PS7_SLCR_0_S_AXI_BASEADDR 0xF8000000
#define XPAR_PS7_SLCR_0_S_AXI_HIGHADDR 0xF8000FFF


/******************************************************************/

/* Definitions for driver GPIOPS */
#define XPAR_XGPIOPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_GPIO_0 */
#define XPAR_PS7_GPIO_0_DEVICE_ID 0
#define XPAR_PS7_GPIO_0_BASEADDR 0xE000A000
#define XPAR_PS7_GPIO_0_HIGHADDR 0xE000AFFF


/******************************************************************/

/* Canonical definitions for peripheral PS7_GPIO_0 */
#define XPAR_XGPIOPS_0_DEVICE_ID XPAR_PS7_GPIO_0_DEVICE_ID
#define XPAR_XGPIOPS_0_BASEADDR 0xE000A000
#define XPAR_XGPIOPS_0_HIGHADDR 0xE000AFFF


/******************************************************************/

/* Definitions for driver OLED_CONTROLLER_IP */
#define XPAR_OLED_CONTROLLER_IP_NUM_INSTANCES 1

/* Definitions for peripheral OLED_CONTROLLER_IP_0 */
#define XPAR_OLED_CONTROLLER_IP_0_DEVICE_ID 0
#define XPAR_OLED_CONTROLLER_IP_0_S00_AXI_BASEADDR 0x43C00000
#define XPAR_OLED_CONTROLLER_IP_0_S00_AXI_HIGHADDR 0x43C0FFFF


/******************************************************************/

/* Definitions for driver QSPIPS */
#define XPAR_XQSPIPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_QSPI_0 */
#define XPAR_PS7_QSPI_0_DEVICE_ID 0
#define XPAR_PS7_QSPI_0_BASEADDR 0xE000D000
#define XPAR_PS7_QSPI_0_HIGHADDR 0xE000DFFF
#define XPAR_PS7_QSPI_0_QSPI_CLK_FREQ_HZ 200000000
#define XPAR_PS7_QSPI_0_QSPI_MODE 0


/******************************************************************/

/* Canonical definitions for peripheral PS7_QSPI_0 */
#define XPAR_XQSPIPS_0_DEVICE_ID XPAR_PS7_QSPI_0_DEVICE_ID
#define XPAR_XQSPIPS_0_BASEADDR 0xE000D000
#define XPAR_XQSPIPS_0_HIGHADDR 0xE000DFFF
#define XPAR_XQSPIPS_0_QSPI_CLK_FREQ_HZ 200000000
#define XPAR_XQSPIPS_0_QSPI_MODE 0


/******************************************************************/

/* Definitions for driver SCUGIC */
#define XPAR_XSCUGIC_NUM_INSTANCES 1

/* Definitions for peripheral PS7_SCUGIC_0 */
#define XPAR_PS7_SCUGIC_0_DEVICE_ID 0
#define XPAR_PS7_SCUGIC_0_BASEADDR 0xF8F00100
#define XPAR_PS7_SCUGIC_0_HIGHADDR 0xF8F001FF
#define XPAR_PS7_SCUGIC_0_DIST_BASEADDR 0xF8F01000


/******************************************************************/

/* Canonical definitions for peripheral PS7_SCUGIC_0 */
#define XPAR_SCUGIC_0_DEVICE_ID 0
#define XPAR_SCUGIC_0_CPU_BASEADDR 0xF8F00100
#define XPAR_SCUGIC_0_CPU_HIGHADDR 0xF8F001FF
#define XPAR_SCUGIC_0_DIST_BASEADDR 0xF8F01000


/******************************************************************/

/* Definitions for driver SCUTIMER */
#define XPAR_XSCUTIMER_NUM_INSTANCES 1

/* Definitions for peripheral PS7_SCUTIMER_0 */
#define XPAR_PS7_SCUTIMER_0_DEVICE_ID 0
#define XPAR_PS7_SCUTIMER_0_BASEADDR 0xF8F00600
#define XPAR_PS7_SCUTIMER_0_HIGHADDR 0xF8F0061F


/******************************************************************/

/* Canonical definitions for peripheral PS7_SCUTIMER_0 */
#define XPAR_XSCUTIMER_0_DEVICE_ID XPAR_PS7_SCUTIMER_0_DEVICE_ID
#define XPAR_XSCUTIMER_0_BASEADDR 0xF8F00600
#define XPAR_XSCUTIMER_0_HIGHADDR 0xF8F0061F


/******************************************************************/

/* Definitions for driver SCUWDT */
#define XPAR_XSCUWDT_NUM_INSTANCES 1

/* Definitions for peripheral PS7_SCUWDT_0 */
#define XPAR_PS7_SCUWDT_0_DEVICE_ID 0
#define XPAR_PS7_SCUWDT_0_BASEADDR 0xF8F00620
#define XPAR_PS7_SCUWDT_0_HIGHADDR 0xF8F006FF


/******************************************************************/

/* Canonical definitions for peripheral PS7_SCUWDT_0 */
#define XPAR_SCUWDT_0_DEVICE_ID XPAR_PS7_SCUWDT_0_DEVICE_ID
#define XPAR_SCUWDT_0_BASEADDR 0xF8F00620
#define XPAR_SCUWDT_0_HIGHADDR 0xF8F006FF


/******************************************************************/

/* Definitions for driver SDPS */
#define XPAR_XSDPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_SD_0 */
#define XPAR_PS7_SD_0_DEVICE_ID 0
#define XPAR_PS7_SD_0_BASEADDR 0xE0100000
#define XPAR_PS7_SD_0_HIGHADDR 0xE0100FFF
#define XPAR_PS7_SD_0_SDIO_CLK_FREQ_HZ 50000000
#define XPAR_PS7_SD_0_HAS_CD 1
#define XPAR_PS7_SD_0_HAS_WP 1


/******************************************************************/

/* Canonical definitions for peripheral PS7_SD_0 */
#define XPAR_XSDPS_0_DEVICE_ID XPAR_PS7_SD_0_DEVICE_ID
#define XPAR_XSDPS_0_BASEADDR 0xE0100000
#define XPAR_XSDPS_0_HIGHADDR 0xE0100FFF
#define XPAR_XSDPS_0_SDIO_CLK_FREQ_HZ 50000000
#define XPAR_XSDPS_0_HAS_CD 1
#define XPAR_XSDPS_0_HAS_WP 1


/******************************************************************/

/* Definitions for driver TTCPS */
#define XPAR_XTTCPS_NUM_INSTANCES 3

/* Definitions for peripheral PS7_TTC_0 */
#define XPAR_PS7_TTC_0_DEVICE_ID 0
#define XPAR_PS7_TTC_0_BASEADDR 0XF8001000
#define XPAR_PS7_TTC_0_TTC_CLK_FREQ_HZ 111111115
#define XPAR_PS7_TTC_0_TTC_CLK_CLKSRC 0
#define XPAR_PS7_TTC_1_DEVICE_ID 1
#define XPAR_PS7_TTC_1_BASEADDR 0XF8001004
#define XPAR_PS7_TTC_1_TTC_CLK_FREQ_HZ 111111115
#define XPAR_PS7_TTC_1_TTC_CLK_CLKSRC 0
#define XPAR_PS7_TTC_2_DEVICE_ID 2
#define XPAR_PS7_TTC_2_BASEADDR 0XF8001008
#define XPAR_PS7_TTC_2_TTC_CLK_FREQ_HZ 111111115
#define XPAR_PS7_TTC_2_TTC_CLK_CLKSRC 0


/******************************************************************/

/* Canonical definitions for peripheral PS7_TTC_0 */
#define XPAR_XTTCPS_0_DEVICE_ID XPAR_PS7_TTC_0_DEVICE_ID
#define XPAR_XTTCPS_0_BASEADDR 0xF8001000
#define XPAR_XTTCPS_0_TTC_CLK_FREQ_HZ 111111115
#define XPAR_XTTCPS_0_TTC_CLK_CLKSRC 0

#define XPAR_XTTCPS_1_DEVICE_ID XPAR_PS7_TTC_1_DEVICE_ID
#define XPAR_XTTCPS_1_BASEADDR 0xF8001004
#define XPAR_XTTCPS_1_TTC_CLK_FREQ_HZ 111111115
#define XPAR_XTTCPS_1_TTC_CLK_CLKSRC 0

#define XPAR_XTTCPS_2_DEVICE_ID XPAR_PS7_TTC_2_DEVICE_ID
#define XPAR_XTTCPS_2_BASEADDR 0xF8001008
#define XPAR_XTTCPS_2_TTC_CLK_FREQ_HZ 111111115
#define XPAR_XTTCPS_2_TTC_CLK_CLKSRC 0


/******************************************************************/

/* Definitions for driver UARTPS */
#define XPAR_XUARTPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_UART_1 */
#define XPAR_PS7_UART_1_DEVICE_ID 0
#define XPAR_PS7_UART_1_BASEADDR 0xE0001000
#define XPAR_PS7_UART_1_HIGHADDR 0xE0001FFF
#define XPAR_PS7_UART_1_UART_CLK_FREQ_HZ 50000000
#define XPAR_PS7_UART_1_HAS_MODEM 0


/******************************************************************/

/* Canonical definitions for peripheral PS7_UART_1 */
#define XPAR_XUARTPS_0_DEVICE_ID XPAR_PS7_UART_1_DEVICE_ID
#define XPAR_XUARTPS_0_BASEADDR 0xE0001000
#define XPAR_XUARTPS_0_HIGHADDR 0xE0001FFF
#define XPAR_XUARTPS_0_UART_CLK_FREQ_HZ 50000000
#define XPAR_XUARTPS_0_HAS_MODEM 0


/******************************************************************/

/* Definitions for driver USBPS */
#define XPAR_XUSBPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_USB_0 */
#define XPAR_PS7_USB_0_DEVICE_ID 0
#define XPAR_PS7_USB_0_BASEADDR 0xE0002000
#define XPAR_PS7_USB_0_HIGHADDR 0xE0002FFF


/******************************************************************/

/* Canonical definitions for peripheral PS7_USB_0 */
#define XPAR_XUSBPS_0_DEVICE_ID XPAR_PS7_USB_0_DEVICE_ID
#define XPAR_XUSBPS_0_BASEADDR 0xE0002000
#define XPAR_XUSBPS_0_HIGHADDR 0xE0002FFF


/******************************************************************/

/* Definitions for driver XADCPS */
#define XPAR_XADCPS_NUM_INSTANCES 1

/* Definitions for peripheral PS7_XADC_0 */
#define XPAR_PS7_XADC_0_DEVICE_ID 0
#define XPAR_PS7_XADC_0_BASEADDR 0xF8007100
#define XPAR_PS7_XADC_0_HIGHADDR 0xF8007120


/******************************************************************/

/* Canonical definitions for peripheral PS7_XADC_0 */
#define XPAR_XADCPS_0_DEVICE_ID XPAR_PS7_XADC_0_DEVICE_ID
#define XPAR_XADCPS_0_BASEADDR 0xF8007100
#define XPAR_XADCPS_0_HIGHADDR 0xF8007120


/******************************************************************/

_______________________________________________________________________


#ifndef OLED_CONTROLLER_IP_H
#define OLED_CONTROLLER_IP_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG0_OFFSET 0
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG1_OFFSET 4
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG2_OFFSET 8
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG3_OFFSET 12
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG4_OFFSET 16
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG5_OFFSET 20
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG6_OFFSET 24
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG7_OFFSET 28
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG8_OFFSET 32
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG9_OFFSET 36
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG10_OFFSET 40
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG11_OFFSET 44
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG12_OFFSET 48
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG13_OFFSET 52
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG14_OFFSET 56
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG15_OFFSET 60
#define OLED_CONTROLLER_IP_S00_AXI_SLV_REG16_OFFSET 64


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a OLED_CONTROLLER_IP register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the OLED_CONTROLLER_IPdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void OLED_CONTROLLER_IP_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define OLED_CONTROLLER_IP_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a OLED_CONTROLLER_IP register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the OLED_CONTROLLER_IP device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 OLED_CONTROLLER_IP_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define OLED_CONTROLLER_IP_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the OLED_CONTROLLER_IP instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus OLED_CONTROLLER_IP_Reg_SelfTest(void * baseaddr_p);

void OLED_clear(void);

int oled_print_str(char *c, int row, int col, int invert);


int oled_print_char(char c, int row, int col, int invert);

#endif // OLED_CONTROLLER_IP_H
_______________________________________________________________________

#include "xparameters.h"
#include "xil_io.h"
#include <string.h>
#include "oled_controller_ip.h"

/* 	Define the base memory address of the ZedboardOLED IP core */
#define OLED_BASE XPAR_OLED_CONTROLLER_IP_0_S00_AXI_BASEADDR

void OLED_clear(void)
{
	int i,j=0;
	for (i=0; i<=512; i+=32)
		{
			for (j=0; j<=32; j+=8)
			{
				OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), ' ');
			}
		}
}

int oled_print_str(char *c, int row, int col, int invert)
{
	int i,j,k,rem,spacesNum=0;
	if (strlen(c) != 64)
	{
		rem = 64 - strlen(c);
		if (rem > 0)
		{
			char spaces[rem];
			char str2[strlen(spaces)];
			char str1[strlen(c)];
			for(spacesNum = 0; spacesNum <= rem; spacesNum++)
			{
				spaces[spacesNum] = ' ';
			}
			strcpy(str1, c);
			strcpy(str2, spaces);
			strcat(str1, str2);

			for (i=0; i<=512; i+=32)
					{
						for (j=0; j<=32; j+=8)
						{
							OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), str1[k++]);
						}
					}
		}
		else return -1;
	}

	return 1;
}

int oled_print_char(char c, int row, int col, int invert)
{
	int i,j=0;
	OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (row*32+col*8), c);
	for (i=0; i<=512; i+=32)
	{
		for (j=0; j<=32; j+=8)
		{
			if(i*32+j*8 != row*32+col*8)
				OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), ' ');
		}
	}
	return 1;

}

_______________________________________________________________________

#include "functions.h"
#include <stdio.h>

int main(void)
{
	OLED_clear();
	oled_print_char('c', 1, 1, 0);
	printf("done");
	return 1;
}

_______________________________________________________________________

# OLED display
set_property PACKAGE_PIN U10  [get_ports {oled_dc}];  # "OLED-DC"
set_property PACKAGE_PIN U9   [get_ports {oled_res}];  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports {oled_sclk}];  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports {oled_sdin}];  # "OLED-SDIN"
set_property PACKAGE_PIN U11  [get_ports {oled_vbat}];  # "OLED-VBAT"
set_property PACKAGE_PIN U12  [get_ports {oled_vdd}];  # "OLED-VDD"

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];

