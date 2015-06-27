-------------------------------------------------------------------------------
-- fsl_fifo_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library fsl_fifo_v1_00_a;
use fsl_fifo_v1_00_a.all;

entity fsl_fifo_0_wrapper is
  port (
    rd_clk : in std_logic;
    rd_en : in std_logic;
    dout : out std_logic_vector(2 downto 0);
    empty : out std_logic;
    FSL_Clk : in std_logic;
    FSL_Rst : in std_logic;
    FSL_S_Clk : in std_logic;
    FSL_S_Read : out std_logic;
    FSL_S_Data : in std_logic_vector(31 downto 0);
    FSL_S_Control : in std_logic;
    FSL_S_Exists : in std_logic
  );
end fsl_fifo_0_wrapper;

architecture STRUCTURE of fsl_fifo_0_wrapper is

  component fsl_fifo is
    port (
      rd_clk : in std_logic;
      rd_en : in std_logic;
      dout : out std_logic_vector(2 downto 0);
      empty : out std_logic;
      FSL_Clk : in std_logic;
      FSL_Rst : in std_logic;
      FSL_S_Clk : in std_logic;
      FSL_S_Read : out std_logic;
      FSL_S_Data : in std_logic_vector(31 downto 0);
      FSL_S_Control : in std_logic;
      FSL_S_Exists : in std_logic
    );
  end component;

begin

  fsl_fifo_0 : fsl_fifo
    port map (
      rd_clk => rd_clk,
      rd_en => rd_en,
      dout => dout,
      empty => empty,
      FSL_Clk => FSL_Clk,
      FSL_Rst => FSL_Rst,
      FSL_S_Clk => FSL_S_Clk,
      FSL_S_Read => FSL_S_Read,
      FSL_S_Data => FSL_S_Data,
      FSL_S_Control => FSL_S_Control,
      FSL_S_Exists => FSL_S_Exists
    );

end architecture STRUCTURE;

