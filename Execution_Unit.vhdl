ENTITY Execution_Unit IS
  GENERIC (
    n : INTEGER := 8 
  );
  PORT (
    operand_a   : IN  BIT_VECTOR(n-1 DOWNTO 0);  -- operand A
    operand_b   : IN  BIT_VECTOR(n-1 DOWNTO 0);  -- operand B
    operation   : IN  BIT_VECTOR(1 DOWNTO 0);    -- operation selector
    result      : OUT BIT_VECTOR(2*n-1 DOWNTO 0);   -- result
    Q0		: OUT BIT
  );
END ENTITY Execution_Unit;

ARCHITECTURE Behavioral OF Execution_Unit IS
  SIGNAL temp_result_s : BIT_VECTOR(2*n-1 DOWNTO 0); -- temporary result
BEGIN
  PROCESS (operand_a, operand_b, operation)
	VARIABLE temp_result : BIT_VECTOR(2*n-1 DOWNTO 0);
    VARIABLE temp_a : BIT_VECTOR(n-1 DOWNTO 0); 
    VARIABLE temp_b : BIT_VECTOR(n-1 DOWNTO 0); 
    VARIABLE carry  : BIT := '0';               -- carry for addition
    VARIABLE sum    : BIT_VECTOR(n-1 DOWNTO 0); 
  BEGIN
    --temp_a := operand_a;
    -- initial carry

    CASE operation IS
      WHEN "00" => -- right shift
	Q0 <= temp_result(0);
	temp_result := temp_result srl 1;
--        temp_result(n-1 DOWNTO 1) <= temp_a(n-2 DOWNTO 0); 
--        temp_result(0) <= '0'; 
      WHEN "10" => -- addition with carry
	temp_a := temp_result(2*n-1 DOWNTO n);
	carry := '0';
        FOR i IN 0 TO n-1 LOOP
          sum(i) := (temp_a(i) XOR temp_b(i)) XOR carry;
          carry := (temp_a(i) AND temp_b(i)) OR (temp_a(i) AND carry) OR (temp_b(i) AND carry);
        END LOOP;
        temp_result(2*n-1 DOWNTO n) := sum;
      WHEN "01" =>
	temp_result(n-1 DOWNTO 0) := operand_a;
    	temp_b := operand_b;
    	carry := '0'; 
        --temp_result <= (OTHERS => '0'); -- default to all zeros
	WHEN OTHERS =>
		null;
    END CASE;
	Q0 <= temp_result(0);
    temp_result_s <= temp_result;
  END PROCESS;

  result <= temp_result_s;
END ARCHITECTURE Behavioral;
