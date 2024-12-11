ENTITY Control_Unit IS
  GENERIC (
    n : INTEGER := 8 
  );
  PORT (
    clock       : IN  BIT;                  
    reset       : IN  BIT;                  
    start       : IN  BIT;                  
    multiplier  : IN  BIT_VECTOR(n-1 DOWNTO 0);
    Q0		: IN BIT;
    done        : OUT BIT;                  
    operation   : OUT BIT_VECTOR(1 DOWNTO 0)  
  );
END ENTITY Control_Unit;

ARCHITECTURE Behavioral OF Control_Unit IS
  TYPE state_type IS (INIT, CHECK_BIT, SHIFT, ADD, FINAL);
  SIGNAL current_state, next_state : state_type := INIT;
  SIGNAL bit_index_s : INTEGER RANGE 0 TO n-1 := 0; -- keeps track of which bit of the multiplier is being checked

BEGIN
  -- state transition
  PROCESS (clock, reset)
	
  BEGIN
    IF reset = '1' THEN
      current_state <= INIT;
    ELSIF clock'EVENT AND clock = '1' THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  PROCESS (current_state, start, multiplier)
	VARIABLE bit_index : INTEGER RANGE 0 TO n-1 := 0;
  BEGIN
    -- default values
    next_state <= current_state;
    operation <= "11";  
    done <= '0';        

    CASE current_state IS
      WHEN INIT =>
	operation <= "01";
        IF start = '1' THEN
          bit_index := 0; -- reset bit index
          next_state <= CHECK_BIT;
        END IF;

      WHEN CHECK_BIT =>
        IF bit_index < n THEN
          --IF multiplier(bit_index) = '1' THEN
	  IF Q0 = '1' THEN
            next_state <= ADD; -- if the bit is 1, perform addition
          ELSE
            next_state <= SHIFT; -- if the bit is 0, perform a left shift
          END IF;
        ELSE
          next_state <= FINAL; -- move to final state
        END IF;

      WHEN ADD =>
        operation <= "10"; -- addition
        next_state <= SHIFT; -- move to shift after addition

      WHEN SHIFT =>
  	operation <= "00"; -- left shift
  	-- increment bit_index only if within range
  	IF bit_index < n-1 THEN
    	  bit_index := bit_index + 1;
    	  next_state <= CHECK_BIT; 
  	ELSE
	  bit_index := 0; -- reset bit_index to 0
    	  next_state <= FINAL; 
  	END IF;
 
      WHEN FINAL =>
        done <= '1'; 
        next_state <= INIT; -- reset for the next operation

      WHEN OTHERS =>
        next_state <= INIT; -- default to reset state
    END CASE;
	bit_index_s <= bit_index;
  END PROCESS;
END ARCHITECTURE Behavioral;
