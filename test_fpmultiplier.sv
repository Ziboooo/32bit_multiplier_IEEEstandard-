module test_fpmultiplier;

logic [31:0] product; 
logic ready;
logic [31:0] a;
logic clock, nreset;
shortreal reala, realproduct;


fpmultiplier a1 (.*);
logic [47:0] test;


initial
  begin
  nreset = '1;
  clock = '0;
  test = {{25{1'b0}},1'b1,{22{1'b0}}}; 
  #5ns nreset = '1;
  #5ns nreset = '0;
  #5ns nreset = '1;
  forever #5ns clock = ~clock;
  end
  
initial
  begin
  @(posedge clock); // wait for clock to start
  @(posedge ready); // wait for ready


  @(posedge clock); //wait for next clock tick
  reala = -1.5;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = 1.75;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
  $display("%f\n", realproduct);


  @(posedge clock); //wait for next clock tick
  reala = -1.5;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = 1.75;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
 $display("%f\n", realproduct);


  @(posedge clock); //wait for next clock tick
  reala = 68868;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = 0;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
 $display("%f\n", realproduct);


  @(posedge clock); //wait for next clock tick
  reala = 68868;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = -0;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
 $display("%f\n", realproduct);


  @(posedge clock); //wait for next clock tick
  reala = -68868;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = -0;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
 $display("%f\n", realproduct);

  // a = infinite
  @(posedge clock);
  a=32'b11111111100000000000000000000000;
  @(posedge clock);
  a=2.0;
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
  $display("%f\n", realproduct);

 
 // a = infinite and 0
  @(posedge clock);
  a=32'b01111111100000000000000000000000;
  @(posedge clock);
  a=0;
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
  $display("%f\n", realproduct);


  //a=NaN
   @(posedge clock);
  a=32'b11111111100000000000000000010000;
  @(posedge clock);
  a=-2.0;
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
  $display("%f\n", realproduct);


  //a=0
  @(posedge clock);
  a=32'b11111111100000000000000000010000;
  @(posedge clock);
  a=0;
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
  $display("%f\n", realproduct);


  @(posedge clock); //wait for next clock tick
  reala = -1.5;
  a = $shortrealtobits(reala);
  @(posedge clock);
  reala = 1.75;
  a = $shortrealtobits(reala);
  @(posedge ready);
  realproduct = $bitstoshortreal(product);
 $display("%f\n", realproduct);
end
endmodule
 