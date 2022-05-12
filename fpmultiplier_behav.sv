module fpmultiplier_behav (output logic [31:0] product, output logic ready,
                      input logic [31:0] a, input logic clock, nreset);
                     
enum {start, loada, loadb} state; // to allow inputs to be loaded in succession

shortreal rproduct, ra; // shortreal is 32 bit floating point

always @(*)
  sum = $shortrealtobits(rproduct); // converts real to bits
  
always @(*)
  ra = $bitstoshortreal(a); // converts bits to real

always @(posedge clock, negedge nreset)

if (~nreset)
  begin
  rproduct <= 0;
  //ready <= '0;
  state <= start;
  end
else
  begin
  //ready <= 0;
  case (state) // This is a state machine, but there are other ways to do this
    start : begin
            //ready <= '1; 
            state <= loada;
            end
    loada : begin
            rproduct <= ra;
            state <= loadb;
            end
    loadb : begin
            rproduct <= rproduct * ra;
            state <= start;
            end

  endcase
  end
  
  always @(*)
    ready = (state == start);
  
endmodule
