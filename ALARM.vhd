library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.COMPONENTS.all;

entity ALARMCLOCK is
generic(FREUQUENCY : integer:=10);
    port(
    RESET , CLK : in std_logic;
    H_IN1 : in std_logic_vector(1 downto 0);
    H_IN0,M_IN1,M_IN0: in std_logic_vector(3 downto 0);
    SET_TIME, SET_ALARM, STOP_ALARM, ALARM_ON, CLOCK_ON : in std_logic;
    ALARM : out std_logic;
    H_OUT1, H_OUT0, M_OUT1, M_OUT0, S_OUT1, S_OUT0: out std_logic_vector(6 downto 0)
 );
end ALARMCLOCK;

architecture Behavioral of ALARMCLOCK is
signal CURH,CURM,CURS,ALARM_H,ALARM_M,CLOCKS: integer;
signal SET,ALARMSET: std_logic:='0';
signal H_out1_b,H_out0_b,M_out1_b,M_out0_b,S_out1_b,S_out0_b: std_logic_vector(3 downto 0); 

begin
CLOCK : process(CLK,RESET,SET,ALARMSET,H_IN1,H_IN0,M_IN1,M_IN0)
begin
    if(SET = '1') then 
       CLOCKS <= 0;
	   CURH <= to_integer(unsigned(H_IN1))*10 + to_integer(unsigned(H_IN0));
       CURM <= to_integer(unsigned(M_IN1))*10 + to_integer(unsigned(M_IN0));
       CURS <= 0;
    end if;
    if(ALARMSET = '1') then
        ALARM_H <= to_integer(unsigned(H_IN1))*10 + to_integer(unsigned(H_IN0));
        ALARM_M <= to_integer(unsigned(M_IN1))*10 + to_integer(unsigned(M_IN0));
    end if;
    if(RESET = '1') then
	   CLOCKS <= 0;
	   CURH <= 0;
       CURM <= 0;
       CURS <= 0;
    elsif(CLK'event and CLK = '1') then
       if(CLOCK_ON = '0') then
           CLOCKS <= 0;
	       CURH <= 0;
           CURM <= 0;
           CURS <= 0; 
	   elsif(CLOCKS = FREUQUENCY-1) then--where the clock is happening
           	CLOCKS <= 0;
        	if(CURS < 59) then
                CURS <= CURS + 1;
		    else
			    CURM <= CURM + 1;
			    CURS <= 0;
		        if(CURM < 59) then
				    CURM <= CURM + 1;
			    else
				    CURH <= CURH + 1; 
				    CURM <= 0;
				    if(CURH < 24) then
					   CURH <= CURH + 1; 
                	else
					   CURH <= 0;
				    end if;
			     end if;
		    end if;
	    else
		     CLOCKS <= CLOCKS+1;
    end if; 
end if;
end process CLOCK;
--------------------
process(CURS)
    begin
    if(CURS>=50) then
        S_out1_b <= x"5";
    elsif(CURS>=40) then
        S_out1_b <= x"4";
    elsif(CURS>=30) then
        S_out1_b <= x"3";
    elsif(CURS>=20) then
        S_out1_b <= x"2";
    elsif(CURS>=10) then
        S_out1_b <= x"1";
    else
        S_out1_b <= x"0";
    end if;
end process;
process(CURM)
begin
if(CURM>=50) then
   M_out1_b <= x"5";
elsif(CURM>=40) then
   M_out1_b <= x"4";
elsif(CURM>=30) then
    M_out1_b <= x"3";
elsif(CURM>=20) then
    M_out1_b <= x"2";
elsif(CURM>=10) then
    M_out1_b <= x"1";
else
    M_out1_b <= x"0";
end if;
end process;
process(CURH)
begin
if(CURH>=20) then
   H_out1_b <= x"2";
elsif(CURH>=10) then
   H_out1_b <= x"1";
else
   H_out1_b <= x"0";
end if;
end process;
---------------------
FS : FSM port map(RESET=>RESET,CLK=>CLK,
    SET_TIME=>SET_TIME, SET_ALARM=>SET_ALARM, 
    STOP_ALARM=>STOP_ALARM, ALARM_ON=>ALARM_ON,
    CLOCK_ON=>CLOCK_ON,ALARM_H=>ALARM_H,ALARM_M=>ALARM_M,
    CURH=>CURH,CURM=>CURM,CURS=>CURS,
    ALARM=>ALARM,SET=>SET,ALARMSET=>ALARMSET);
S1 : BIN_TO_7SEGMENT port map (B => S_out1_b, SEGMENT => S_OUT1);
S_out0_b <= std_logic_vector(to_unsigned((CURS - to_integer(unsigned(S_out1_b))*10),4));
S0 : BIN_TO_7SEGMENT port map (B => S_out0_b, SEGMENT => S_OUT0); 
M1 : BIN_TO_7SEGMENT port map (B => M_out1_b, SEGMENT => M_OUT1);
M_out0_b <= std_logic_vector(to_unsigned((CURM - to_integer(unsigned(M_out1_b))*10),4));
M0 : BIN_TO_7SEGMENT port map (B => M_out0_b, SEGMENT => M_OUT0); 
H1 : BIN_TO_7SEGMENT port map (B => H_out1_b, SEGMENT => H_OUT1); 
H_out0_b <= std_logic_vector(to_unsigned((CURH - to_integer(unsigned(H_out1_b))*10),4));
H0 : BIN_TO_7SEGMENT port map (B => H_out0_b, SEGMENT => H_OUT0); 

end Behavioral;

library ieee;
use ieee.STD_LOGIC_1164.all;

entity FSM is
port(
    RESET , CLK : in std_logic;
    SET_TIME, SET_ALARM, STOP_ALARM, ALARM_ON, CLOCK_ON : in std_logic;
    CURH, CURM, CURS, ALARM_H, ALARM_M: in integer;
    ALARM, SET, ALARMSET: out std_logic);
end FSM;
architecture Behavioral of FSM is
type FSM_STATES is (START,WORK_NORMAL,SETUP_TIME,SETUP_ALARM,BUZZER_ON);
signal STATE,NEXT_STATE: FSM_STATES;
---------------------------
begin
FSM_FF : process(CLK,RESET)
    begin
    if(RESET = '1') then
        STATE <= START;
	elsif(CLK'event and CLK = '1') then
	    STATE <= NEXT_STATE;
	end if;
end process FSM_FF;

FSM_LOGIC: process(STATE,CLOCK_ON,SET_TIME,SET_ALARM,ALARM_ON,STOP_ALARM,CURH,CURM,CURS,ALARM_M,ALARM_H)
variable TEN_SECONDS: integer :=10;          
begin
    case(STATE) is
        when START =>
            ALARM <= '0'; 
            if(CLOCK_ON = '1') then
                NEXT_STATE <= WORK_NORMAL;
            end if;
        when WORK_NORMAL => 
            ALARM <= '0';
            if(SET_TIME = '1') then
                NEXT_STATE <= SETUP_TIME;
            elsif(SET_ALARM = '1') then
                NEXT_STATE <= SETUP_ALARM;
            elsif(ALARM_ON = '1' and CURH = ALARM_H and CURM = ALARM_M and CURS = 0) then
                NEXT_STATE <= BUZZER_ON;
            elsif(CLOCK_ON = '0') then
                NEXT_STATE <= START;
	        end if;
        when SETUP_TIME => 
            SET <= '1';
            if(SET_TIME = '0') then
                NEXT_STATE <= WORK_NORMAL;
		        SET <= '0';
            end if;
        when SETUP_ALARM =>
            ALARMSET <= '1';
            if(SET_ALARM = '0') then
                NEXT_STATE <= WORK_NORMAL;
                ALARMSET <= '0';
            end if;
        when BUZZER_ON =>
            if(ALARM_ON = '0' or STOP_ALARM = '1' or (CURH = ALARM_H and CURM = ALARM_M and CURS > TEN_SECONDS)) then
                ALARM <= '0';
                NEXT_STATE <= WORK_NORMAL;
            elsif(CURH = ALARM_H and CURM = ALARM_M and CURS < TEN_SECONDS) then
                ALARM <= '1';
                NEXT_STATE <= BUZZER_ON;
            end if;
         
        end case;  
    end process FSM_LOGIC;
end Behavioral;

library ieee;
use ieee.STD_LOGIC_1164.all;

entity BIN_TO_7SEGMENT is
port (
 B: in std_logic_vector(3 downto 0);
 SEGMENT: out std_logic_vector(6 downto 0)
);
end BIN_TO_7SEGMENT;

architecture BEHAVIOR of BIN_TO_7SEGMENT is
begin
process(B)
 begin
  case(B) is
    when "0000" => SEGMENT <= "0000001";     
    when "0001" => SEGMENT <= "1001111"; 
    when "0010" => SEGMENT <= "0010010"; 
    when "0011" => SEGMENT <= "0000110"; 
    when "0100" => SEGMENT <= "1001100"; 
    when "0101" => SEGMENT <= "0100100";  
    when "0110" => SEGMENT <= "0100000";  
    when "0111" => SEGMENT <= "0001111";
    when "1000" => SEGMENT <= "0000000";     
    when "1001" => SEGMENT <= "0000100"; 
    when others => SEGMENT <= "1111111";
end case;

 end process;
end BEHAVIOR;