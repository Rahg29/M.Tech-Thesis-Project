`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2018 04:21:34
// Design Name: 
// Module Name: DIM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dim(
input clk,
output reg signed [15:0] out_neuron
);

reg [127:0] Act_Index;
reg [127:0] Weight_Index;
reg signed [8:0] Activation [0:127];
reg signed [1:0] Weight [0:127];
reg [6:0] Inc_Act [0:127];
reg [6:0] Inc_Weight [0:127];
reg signed [8:0] Act_element [0:100];
reg signed [1:0] Weight_element [0:100];
reg [127:0] and_op;
integer i= 0, c= 0, f= 0, e= 0, g= 0, reset = 1;
reg signed [15:0] y= 16'd0;
reg [1:0]Pres_state;
reg [1:0] Next_state;


parameter S0=2'd0;
parameter S1=2'd1;
parameter S2=2'd2;
parameter S3=2'd3;

always @(posedge clk)
begin
    if (reset == 1'd1)
    Pres_state = S0;
    
    else
    Pres_state = Next_state;
end


always @(posedge clk)
begin

case(Pres_state)

S0:begin

reset=0;

$readmemb("DIM_act.mif", Activation);
$readmemb("DIM_weight.mif", Weight);

Next_state = S1;

end


S1:begin
    //out_neuron[15:0] = i;
    if (i<=127)
    begin
        if(Weight[i] == 2'd0 && Activation[i] == 9'd0)
        begin
        Weight_Index[i] = 1'b0;
        Act_Index[i] = 1'b0;
        c = c + Act_Index[i];
        f = f + Weight_Index[i];
        Inc_Act[i] = c;
        Inc_Weight[i] = f;
        i = i+1;
        Next_state = S1;
        end
        
        else if(Weight[i] == 2'd0)
        begin
        Weight_Index[i] = 1'b0;
        Act_element[e] = Activation[i];
        Act_Index[i] = 1'b1;
        c = c + Act_Index[i];
        f = f + Weight_Index[i];
        Inc_Act[i] = c;
        Inc_Weight[i] = f;
        i = i+1;
        e = e+1;
        Next_state = S1;
        end
        
        else if(Activation[i] == 9'd0)
        begin
        Act_Index[i] = 1'b0;
        Weight_Index[i] = 1'b1;
        Weight_element[g] = Weight[i];
        c = c + Act_Index[i];
        f = f + Weight_Index[i];
        Inc_Act[i] = c;
        Inc_Weight[i] = f;
        g = g+1;
        i = i+1;
        Next_state = S1;
        end
        
        else
        begin
        Act_element[e] = Activation[i];
        Weight_element[g] = Weight[i];
        Act_Index[i] = 1'b1;
        Weight_Index[i] = 1'b1;
        c = c + Act_Index[i];
        f = f + Weight_Index[i];
        Inc_Act[i] = c;
        Inc_Weight[i] = f;
        i = i+1;
        e = e+1;
        g = g+1;
        Next_state = S1;
        end
    end

    else
    Next_state = S2;

end

S2:
    begin
    and_op = Act_Index & Weight_Index;
    i=0;
    Next_state = S3;
    end

S3:
begin
    if (i<=127)
    begin
        if(and_op[i] == 1'b1)
        begin
        y = y + Weight_element[Inc_Weight[i]-1] * Act_element[Inc_Act[i]-1];
        i = i+1;
        Next_state = S3;
        end
        
        else
        begin
        i = i+1;
        Next_state = S3;
        end
    end
    
    else
    out_neuron[15:0] = y[15:0];

end

endcase
end

endmodule