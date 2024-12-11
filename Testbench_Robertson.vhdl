ENTITY Testbench_Robertson IS
END ENTITY Testbench_Robertson;

ARCHITECTURE Behavioral OF Testbench_Robertson IS
  COMPONENT Robertson_Multiplier
    GENERIC (
      n : INTEGER := 8  
    );
    PORT (
      clock       : IN  BIT;
      reset       : IN  BIT;
      start       : IN  BIT;
      multiplier  : IN  BIT_VECTOR(n-1 DOWNTO 0);
      multiplicand: IN  BIT_VECTOR(n-1 DOWNTO 0);
      result      : OUT BIT_VECTOR(2*n-1 DOWNTO 0);
      done        : OUT BIT
    );
  END COMPONENT;

  -- signals for testing
  SIGNAL clock       : BIT := '0';
  SIGNAL reset       : BIT := '0';
  SIGNAL start       : BIT := '0';
  SIGNAL multiplier  : BIT_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL multiplicand: BIT_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); 
  SIGNAL result      : BIT_VECTOR(15 DOWNTO 0); 
  SIGNAL done        : BIT;

BEGIN
  -- clock generation process
  PROCESS
  BEGIN
    WAIT FOR 5 ns;
    clock <= NOT clock;
  END PROCESS;

  -- instantiate the Robertson Multiplier
  uut: Robertson_Multiplier
    GENERIC MAP (
      n => 8 
    )
    PORT MAP (
      clock       => clock,
      reset       => reset,
      start       => start,
      multiplier  => multiplier,
      multiplicand=> multiplicand,
      result      => result,
      done        => done
    );

  PROCESS
  BEGIN
    -- reset the system
    reset <= '1';
    WAIT FOR 10 ns;
    reset <= '0';

    -- case 1: simple multiplication
    
    multiplicand <= "00000111"; -- 3 
    multiplier <= "00000101";   -- 5 
    wait for 10 ns;
    start <= '1';
    WAIT FOR 30 ns;
    start <= '0';
--    WAIT UNTIL done = '1';
    WAIT FOR 20 ns; -- wait to observe results


    WAIT;
  END PROCESS;
END ARCHITECTURE Behavioral;
