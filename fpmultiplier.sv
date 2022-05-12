module fpmultiplier (output logic [31:0] product, output logic ready,
		input logic [31:0] a, input logic clock, nreset);


enum {activation, start, loada, loadb, check, special, regularcalculation,carries, final_output}state;


logic [31:0] multi_a, multi_b;
logic [47:0] manti_48bit;
logic [22:0] manti_23bit; 
logic [7:0] expon; 
logic sign;

logic infinite_a,NaN_a,zero_a,infinite_b,NaN_b,zero_b; 

assign  infinite_a = (multi_a[30:23]==8'b11111111)&&(multi_a[22:0]==0);
assign  NaN_a = (multi_a[30:23]==8'b11111111)&&(multi_a[22:0]!=0);
assign  zero_a = (multi_a[30:23]==0)&&(multi_a[22:0]==0);
assign  infinite_b = (multi_b[30:23]==8'b11111111)&&(multi_b[22:0]==0);
assign  NaN_b = (multi_b[30:23]==8'b11111111)&&(multi_b[22:0]!=0);
assign  zero_b = (multi_b[30:23]==0)&&(multi_b[22:0]==0); 


always_ff @(posedge clock, negedge nreset)

if (~nreset)
  begin 
  product <=0;
  multi_a <= 0;
  multi_b <= 0;
  state <= start;
  ready <= 0;
  end
else

begin 
  case (state)
    activation:
           begin
           ready <=1;
           end
    start: 
           begin
           ready <= 0;
           state <= loada;
           end
    loada: 
           begin 
           multi_a <= a;
           state <= loadb;
           end
    loadb: 
           begin
           multi_b <= a;
           state <= check;        
           end
    check:
           begin
           sign <= multi_a[31]^multi_b[31];
           if(NaN_a||infinite_a||zero_a||NaN_b||infinite_b||zero_b)
           state <= special;
           else
           state <= regularcalculation;
           end
    special:
           begin
            state <= final_output;
            if (NaN_a||NaN_b) 
              begin
              expon <= 8'b11111111;
              manti_23bit <= 1;
  
              end
            else if (infinite_a||infinite_b) 
              begin
              if (zero_a|zero_b)  
                begin
                expon <= 8'b11111111;
                manti_23bit <= 1;  
    
                end
              else 
                begin
                expon <= 8'b11111111;
                manti_23bit <= 0;
         
                end
              end
            else 
              begin 
              expon <= 8'b00000000;
              manti_23bit <= 0;
             
              end
           end
    regularcalculation:
           begin
           state <= carries;
           sign <= multi_a[31]^multi_b[31];
           manti_48bit <= {1'b1, {multi_a[22:0]}}*{1'b1, {multi_b[22:0]}};
           expon <= multi_a[30:23]+multi_b[30:23]-127; 
   
           end 
    carries:
           begin 
           state <= final_output;
          
           if (manti_48bit[47]==1)  
             begin
             expon <= expon + 1'b1; 
             manti_48bit <= manti_48bit>>1|{{25{1'b0}},1'b1,{22{1'b0}}}; 
             end
           else
             begin  
             manti_48bit <= manti_48bit|{{25{1'b0}},1'b1,{22{1'b0}}}; 
             end
           end
    final_output:
           begin 
           ready <= 1;
           state <= start;        

           if (NaN_a||infinite_a||zero_a||NaN_b||infinite_b||zero_b)
             product <= {sign,expon,manti_23bit};
           else if (manti_48bit[47]==1)
             product <= {sign,expon+1'b1,manti_48bit[46:24]};
           else 
             product <= {sign,expon,manti_48bit[45:23]};
           end 
  endcase
end



/*always_comb
  ready = (state == start); */
endmodule