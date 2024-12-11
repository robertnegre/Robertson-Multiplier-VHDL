ENTITY Robertson_Multiplier IS
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
END ENTITY Robertson_Multiplier;

ARCHITECTURE Behavioral OF Robertson_Multiplier IS
  -- signals for internal communication
  SIGNAL operation   : BIT_VECTOR(1 DOWNTO 0);  -- operation command from CU to EU
  SIGNAL eu_result   : BIT_VECTOR(2*n-1 DOWNTO 0);  -- result from the EU
  SIGNAL Q0 : BIT;

  COMPONENT Control_Unit
    GENERIC (
      n : INTEGER := 8  
    );
    PORT (
      clock       : IN  BIT;
      reset       : IN  BIT;
      start       : IN  BIT;
      multiplier  : IN  BIT_VECTOR(n-1 DOWNTO 0);
      Q0	  : IN BIT;
      done        : OUT BIT;
      operation   : OUT BIT_VECTOR(1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Execution_Unit
    GENERIC (
      n : INTEGER := 8 
    );
    PORT (
      operand_a   : IN  BIT_VECTOR(n-1 DOWNTO 0);  
      operand_b   : IN  BIT_VECTOR(n-1 DOWNTO 0);  
      operation   : IN  BIT_VECTOR(1 DOWNTO 0);    
      result      : OUT BIT_VECTOR(2*n-1 DOWNTO 0);
      Q0	  : OUT BIT  
    );
  END COMPONENT;

BEGIN
  CU: Control_Unit
    GENERIC MAP (
      n => n  -- pass the bit width to the Control Unit
    )
    PORT MAP (
      clock       => clock,
      reset       => reset,
      start       => start,
      multiplier  => multiplier,
      done        => done,
      operation   => operation,
      Q0 	  => Q0

    );

  EU: Execution_Unit
    GENERIC MAP (
      n => n  -- pass the bit width to the Execution Unit
    )
    PORT MAP (
      operand_a   => multiplicand, -- first operand is the multiplicand
      operand_b   => multiplier,   -- second operand is the multiplier
      operation   => operation,    -- command from the Control Unit
      result      => eu_result,     -- result output
      Q0 	  => Q0
    );

  -- connect the result from the EU to the top-level output
  result <= eu_result;
END ARCHITECTURE Behavioral;
