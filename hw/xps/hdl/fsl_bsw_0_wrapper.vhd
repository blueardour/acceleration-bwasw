-------------------------------------------------------------------------------
-- fsl_bsw_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library fsl_bsw_v1_00_a;
use fsl_bsw_v1_00_a.all;

entity fsl_bsw_0_wrapper is
  port (
    bsw_clk : in std_logic;
    bsw_rst : in std_logic;
    s1 : in std_logic_vector(2 downto 0);
    s2 : in std_logic_vector(2 downto 0);
    v1 : in std_logic;
    v2 : in std_logic;
    ack1 : out std_logic;
    ack2 : out std_logic;
    FSL_Clk : in std_logic;
    FSL_Rst : in std_logic;
    FSL_S_Clk : in std_logic;
    FSL_S_Read : out std_logic;
    FSL_S_Data : in std_logic_vector(0 to 31);
    FSL_S_Control : in std_logic;
    FSL_S_Exists : in std_logic;
    FSL_M_Clk : in std_logic;
    FSL_M_Write : out std_logic;
    FSL_M_Data : out std_logic_vector(0 to 31);
    FSL_M_Control : out std_logic;
    FSL_M_Full : in std_logic
  );
end fsl_bsw_0_wrapper;

architecture STRUCTURE of fsl_bsw_0_wrapper is

  component fsl_bsw is
    port (
      bsw_clk : in std_logic;
      bsw_rst : in std_logic;
      s1 : in std_logic_vector(2 downto 0);
      s2 : in std_logic_vector(2 downto 0);
      v1 : in std_logic;
      v2 : in std_logic;
      ack1 : out std_logic;
      ack2 : out std_logic;
      FSL_Clk : in std_logic;
      FSL_Rst : in std_logic;
      FSL_S_Clk : in std_logic;
      FSL_S_Read : out std_logic;
      FSL_S_Data : in std_logic_vector(0 to 31);
      FSL_S_Control : in std_logic;
      FSL_S_Exists : in std_logic;
      FSL_M_Clk : in std_logic;
      FSL_M_Write : out std_logic;
      FSL_M_Data : out std_logic_vector(0 to 31);
      FSL_M_Control : out std_logic;
      FSL_M_Full : in std_logic
    );
  end component;

begin

  fsl_bsw_0 : fsl_bsw
    port map (
      bsw_clk => bsw_clk,
      bsw_rst => bsw_rst,
      s1 => s1,
      s2 => s2,
      v1 => v1,
      v2 => v2,
      ack1 => ack1,
      ack2 => ack2,
      FSL_Clk => FSL_Clk,
      FSL_Rst => FSL_Rst,
      FSL_S_Clk => FSL_S_Clk,
      FSL_S_Read => FSL_S_Read,
      FSL_S_Data => FSL_S_Data,
      FSL_S_Control => FSL_S_Control,
      FSL_S_Exists => FSL_S_Exists,
      FSL_M_Clk => FSL_M_Clk,
      FSL_M_Write => FSL_M_Write,
      FSL_M_Data => FSL_M_Data,
      FSL_M_Control => FSL_M_Control,
      FSL_M_Full => FSL_M_Full
    );

end architecture STRUCTURE;

