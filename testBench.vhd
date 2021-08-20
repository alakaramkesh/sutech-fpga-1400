library ieee;
use ieee.std_logic_1164.all;
use work.COMPONENTS.all;

entity TEST_ALARMCLOCK is
end TEST_ALARMCLOCK;

architecture Behavioral of TEST_ALARMCLOCK is

   signal CLK : std_logic := '1';
   signal RESET : std_logic:= '1';
   signal H_IN1 : std_logic_vector(1 downto 0) := (others => '0');
   signal H_IN0, M_IN1, M_IN0: std_logic_vector(3 downto 0) := (others => '0');
   signal ALARM : std_logic:= '0';
   signal SET_TIME, SET_ALARM, STOP_ALARM, ALARM_ON, CLOCK_ON: std_logic:= '0';
   signal H_OUT1, H_OUT0, M_OUT1, M_OUT0, S_OUT1, S_OUT0: std_logic_vector(6 downto 0);

   constant FREQ : integer := 10 ; --5 hz
   constant PERIODCLOCK : time := 1000 ms / FREQ; 
begin
   
   UNIT_TEST: ALARMCLOCK 
	generic map(FREUQUENCY => FREQ)
	port map (
          CLK => CLK,
          RESET => RESET,
          H_IN1 => H_IN1,
          H_IN0 => H_IN0,
          M_IN1 => M_IN1,
          M_IN0 => M_IN0,
          H_OUT1 => H_OUT1,
          H_OUT0 => H_OUT0,
          M_OUT1 => M_OUT1,
          M_OUT0 => M_OUT0,
          S_OUT1 => S_OUT1, 
          S_OUT0 => S_OUT0,
          SET_TIME => SET_TIME,
          SET_ALARM => SET_ALARM,
          STOP_ALARM => STOP_ALARM,
          ALARM_ON => ALARM_ON,
          CLOCK_ON => CLOCK_ON,
          ALARM => ALARM
          );
   
   CLK <= not CLK after PERIODCLOCK / 2; --rising and falling edges
   
   process is
   begin 
        CLOCK_ON <='0';
        RESET <= '1';
	    SET_ALARM <='0';
	    ALARM_ON<='0';
	    STOP_ALARM <='0';
        wait until rising_edge(Clk);
        CLOCK_ON<='1';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        RESET <= '0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        ---1 set 1 alarm
        H_IN1 <= "10";
        H_IN0 <= x"2";
        M_IN1 <= x"5";
        M_IN0 <= x"7";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        Set_Time<='1';-- set time 22:57
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "10";
        H_IN0 <= x"3";
        M_IN1 <= x"0";
        M_IN0 <= x"0";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='1';-- set Alarm 23:00
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        ALARM_ON <='1';
        wait for 3 min;
        wait for 7 sec;
        STOP_ALARM <='1';-- off alarm after 7 seconds
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        STOP_ALARM <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        ALARM_ON <='0';
        wait for 1 min;
        ---- 2 set
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "00";
        H_IN0 <= x"5";
        M_IN1 <= x"1";
        M_IN0 <= x"0";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <= '1';-- set time 05:10
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME<='0';
        wait for 5 min;
        CLOCK_ON <= '0';
        wait for 1 min;
        CLOCK_ON <= '1';
        ---3 set 2 alarm
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "01";
        H_IN0 <= x"0";
        M_IN1 <= x"0";
        M_IN0 <= x"0";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='1';-- set time 10:00
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "01";
        H_IN0 <= x"0";
        M_IN1 <= x"0";
        M_IN0 <= x"2";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='1';-- set Alarm 10:02
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        ALARM_ON <='1';
        wait for 3 min;-- alarm start and end after 10 sec
        ALARM_ON <='0';-- alarm off
        --- 4 set 3 alarm
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "01";
        H_IN0 <= x"1";
        M_IN1 <= x"5";
        M_IN0 <= x"2";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='1';-- set time 11:52
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='0';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "01";
        H_IN0 <= x"1";
        M_IN1 <= x"5";
        M_IN0 <= x"3";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='1';-- set Alarm 11:53
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_ALARM <='0';
        ALARM_ON <='1';
        wait for 2 min;-- alarm start and end after 10 sec
        ALARM_ON<='0';-- alarm off
        --- 5 set
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        H_IN1 <= "00";
        H_IN0 <= x"8";
        M_IN1 <= x"3";
        M_IN0 <= x"0";
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='1';-- set time 08:30
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        SET_TIME <='0';
        wait;
   end process;
end Behavioral;
