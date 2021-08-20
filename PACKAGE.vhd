

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package COMPONENTS is
    component ALARMCLOCK
    generic(FREUQUENCY : integer);
    port(
    RESET , CLK : in std_logic;
    H_IN1 : in std_logic_vector(1 downto 0);
    H_IN0,M_IN1,M_IN0: in std_logic_vector(3 downto 0);
    SET_TIME, SET_ALARM, STOP_ALARM, ALARM_ON, CLOCK_ON : in std_logic;
    ALARM : out std_logic;
    H_OUT1, H_OUT0, M_OUT1, M_OUT0, S_OUT1, S_OUT0: out std_logic_vector(6 downto 0)
        );
    end component;
    component BIN_TO_7SEGMENT
    port (
         B: in std_logic_vector(3 downto 0);
         SEGMENT: out std_logic_vector(6 downto 0)
    );
    end component;
    component FSM 
    port(
        RESET , CLK : in std_logic;
        SET_TIME, SET_ALARM, STOP_ALARM, ALARM_ON, CLOCK_ON : in std_logic;
        CURH, CURM, CURS, ALARM_H, ALARM_M: in integer;
        ALARM,SET,ALARMSET: out std_logic);
    end component;
end COMPONENTS;

package body COMPONENTS is
end package body;
