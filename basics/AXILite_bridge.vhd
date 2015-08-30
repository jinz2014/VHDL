-- convert the user interface to AXI lite interface
--
-- based on a verilog design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; use ieee.std_logic_unsigned.all; 

entity bridge is
generic (
  DWIDTH : natural := 32;
  RWIDTH : natural := 4
);
port (
  -- AXI interconnect
  m_axi_clk:		out std_logic; 

  m_axi_awaddr:		out std_logic_vector(31 downto 0); 
  m_axi_awvalid:	out std_logic;
  m_axi_awready:	in std_logic;
  
  m_axi_wdata:		out std_logic_vector(31 downto 0); 
  m_axi_wstrb:		out std_logic_vector(RWIDTH-1 downto 0);
  m_axi_wlast:		out std_logic;
  m_axi_wvalid:		out std_logic;
  m_int_wready:		out std_logic;

  m_axi_bresp:		in  std_logic_vector(1 downto 0); 
  m_axi_bvalid:		in  std_logic;
  m_axi_bready:		out std_logic;

  -- user interface
  clk :    		in std_logic;
  rst :    		in std_logic;
  user_error_reg :      out std_logic_vector(3 downto 0);
  targ_wr_req :		in std_logic;
  -- the upstream is ready (it may be low after targ_wr_req is asserted)
  targ_wr_core_ready :	in std_logic;
  targ_wr_user_ready :	out std_logic;
  targ_wr_addr :	in std_logic_vector(31 downto 0);
  targ_wr_data :	in std_logic_vector(DWIDTH-1 downto 0);
  targ_wr_be :		in std_logic_vector(RWIDTH-1 downto 0);
  targ_wr_en :		in std_logic
  );
end;

architecture rtl of bridge is
  type wr_states is (IDLE_WR, WAIT_WR_EN, WAIT_WR_DONE);
  signal wr_state 	: wr_states;
  signal wr_done  	: std_logic;
  signal user_wr_error  : std_logic_vector(1 downto 0);
  signal int_wr_req	: std_logic;
  signal int_wr_req_r	: std_logic;
  signal axi_wr_req	: std_logic;
  signal wr_addr  	: std_logic_vector(31 downto 0);
  signal wr_data  	: std_logic_vector(DWIDTH-1 downto 0);
  signal wr_be    	: std_logic_vector(RWIDTH-1 downto 0);

-- user interface signal sequence
-- wr_req -> wr_en 
begin
  process (clk) begin
    if (rising_edge(clk)) then
      if (rst) then
        wr_state <= IDLE_WR;
      else 
        case wr_state is
          when IDLE_WR =>
            if (targ_wr_req) then
              wr_state <= WAIT_WR_EN;
            end if;
          when WAIT_WR_EN =>
            if (targ_wr_en) then
              wr_state <= WAIT_WR_DONE;
            end if;
          when WAIT_WR_DONE =>
            if (wr_done and targ_wr_req) then
              wr_state <= WAIT_WR_EN;
            elsif (wr_done) then
              wr_state <= IDLE_WR;
           end if;
          when others =>
              wr_state <= IDLE_WR;
        end case;
      end if;
    end if;
  end process;

  process (clk) begin
    if (rising_edge(clk)) then
      if (rst) then
        targ_wr_user_ready_int <= '0';
      elsif (targ_wr_user_ready_int and targ_wr_core_ready and targ_wr_req) then
        targ_wr_user_ready_int <= '0';
      elsif (( (wr_state = IDLE_WR) or (wr_state = WAIT_WR_DONE and wr_done = '1')) and targ_wr_req = '1') then
        targ_wr_user_ready_int <= '1';
      end if;
    end if;
  end process;

  process (clk) begin
    if (rising_edge(clk)) then
      if (rst) then
        int_wr_req   <= '0'  ;
       elsif (wr_state = WAIT_WR_EN and targ_wr_en = '1') then
        int_wr_req   <= '1'  ;
       elsif (wr_done) then
        int_wr_req   <= '0'  ;
       end if;
    end if;
  end process;

  -- user interface spec
  process (clk) begin
    if (rising_edge(clk)) then
       if (targ_wr_en = '1') then
         wr_be   <= targ_wr_be  ;
         wr_data <= targ_wr_data;
         wr_addr <= X"0000" & targ_wr_addr(13 downto 0) & "00";
       end if;
    end if;
  end process;

  process (clk) begin
    if (rising_edge(clk)) then
       int_wr_req_r  <= int_wr_req;
    end if;
  end process;

  -- asserted one cycle
  axi_wr_req <= not int_wr_req_r and int_wr_req;


  process (clk) begin
    if (rising_edge(clk)) then
       if (axi_wr_req) then
         m_axi_wstrb  <= wr_be  ;
         m_axi_wdata  <= wr_data;
         m_axi_awaddr <= wr_addr;
       end if;
    end if;
  end process;

  -- keep awvalid, wvalid and wlast asserted until the AXI downstream is
  -- ready to accept the write address or data
  process (clk) begin
    if (rising_edge(clk)) then
       if (axi_wr_req) then
         m_axi_awvalid <= not m_axi_awready and m_axi_awvalid;
         m_axi_wvalid  <= not m_axi_awready and m_axi_wvalid;
         m_axi_wlast   <= not m_axi_awready and m_axi_wlast;
       end if;
    end if;
  end process;

  process (clk) begin
    if (rising_edge(clk)) then
      if (rst) then
        wr_done <= '0';
        user_wr_error <= (others => '0');
      elsif (int_wr_req and m_axi_bvalid) then
        wr_done <= '1';
        user_wr_error <= m_axi_bresp;
      else
        wr_done <= '0';
      end if;
    end if;
  end process;

  m_axi_bready <= '0';
  user_error_reg(1 downto 0) <= user_wr_error;

end rtl;
