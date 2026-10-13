// Generated input agent monitor coverage extension, sample once per transaction.
// The 4x4 cross has 16 legal input combinations.
covergroup sa_input_cross with function sample(bit [1:0] ina, bit [1:0] inb);
  cp_a: coverpoint ina {bins all[]={[0:3]};}
  cp_b: coverpoint inb {bins all[]={[0:3]};}
  cross_ab: cross cp_a, cp_b;
endgroup
