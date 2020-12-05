`timescale 1ns / 1ps

// StickIt! LED Digits with PMOD header
// https://xess.com/manuals/StickIt-LedDigits-manual-v2_0.pdf
// PMOD pins should be connected to S like this (e.g. in xdc):
//   PMOD[0] -> S[0]
//   PMOD[1] -> S[2]
//   PMOD[2] -> S[4]
//   PMOD[3] -> S[6]
//   PMOD[7] -> S[1]
//   PMOD[8] -> S[2]
//   PMOD[9] -> S[5]
//   PMOD[10] -> S[7]

// CLK: scan input, something around 500 KHz
// RESET: reset
// VALUE: 32-bit value to show on 8 displays
// S: Charlieplexing output to connect to PMOD header on Stickit 

module stickit(
    input wire CLK,
    input wire RESET,
    input wire [31:0] VALUE,
    output reg [7:0] S 
    );
    
    // state regs, scanning each led
    reg [2:0] led;
    reg [2:0] led_next;
    
    // states
    localparam [2:0] 
        led1 = 0,
        led2 = 1,
        led3 = 2,
        led4 = 3,
        led5 = 4,
        led6 = 5,
        led7 = 6,
        led8 = 7;
    
    // digits 0 to F
    localparam d0 = 7'bZ000000;
    localparam d1 = 7'bZZZZ00Z;
    localparam d2 = 7'b0Z00Z00;
    localparam d3 = 7'b0ZZ0000;
    localparam d4 = 7'b00ZZ00Z;
    localparam d5 = 7'b00Z00Z0;
    localparam d6 = 7'b00000Z0;
    localparam d7 = 7'bZZZZ000;
    localparam d8 = 7'b0000000;
    localparam d9 = 7'b00Z0000;
    localparam da = 7'b000Z000;
    localparam db = 7'b00000ZZ;
    localparam dc = 7'bZ000ZZ0;
    localparam dd = 7'b0Z0000Z;
    localparam de = 7'b0000ZZ0;
    localparam df = 7'b000ZZZ0;
        
    // state register
    always @ (posedge CLK)
    begin
        if (RESET == 1)
        begin
            led <= led1;
        end
        else
        begin
            led <= led_next;
        end
    end
    
    // next state
    always @ (*)
    begin
        case (led)
            led1: led_next = led2;
            led2: led_next = led3;
            led3: led_next = led4;
            led4: led_next = led5;
            led5: led_next = led6;
            led6: led_next = led7;
            led7: led_next = led8;
            led8: led_next = led1;
            default: led_next = led1;
        endcase
    end
    
    // outputs
    
    // sval is part of the value to be displayed on LED currently being scanned 
    reg [3:0] sval;
    
    always @ (*)
    begin
        case (led)
            led1: sval = VALUE[3:0];
            led2: sval = VALUE[7:4];
            led3: sval = VALUE[11:8];
            led4: sval = VALUE[15:12];
            led5: sval = VALUE[19:16];
            led6: sval = VALUE[23:20];
            led7: sval = VALUE[27:24];
            led8: sval = VALUE[31:28];
        endcase
    end

    // assignment below has to be done to S
    // if S is assigned in a different block, tri-state output buffer is not inferred
    always @ (posedge CLK)
    begin
        if (RESET == 1)
        begin
            S <= 8'bZZZZZZZ1;
        end
        else
        begin
            case (led)
                led1: 
                begin
                    case (sval)
                        0: S <= {d0[6:0], 1'b1};
                        1: S <= {d1[6:0], 1'b1};
                        2: S <= {d2[6:0], 1'b1};
                        3: S <= {d3[6:0], 1'b1};
                        4: S <= {d4[6:0], 1'b1};
                        5: S <= {d5[6:0], 1'b1};
                        6: S <= {d6[6:0], 1'b1};
                        7: S <= {d7[6:0], 1'b1};
                        8: S <= {d8[6:0], 1'b1};
                        9: S <= {d9[6:0], 1'b1};
                        10: S <= {da[6:0], 1'b1};
                        11: S <= {db[6:0], 1'b1};
                        12: S <= {dc[6:0], 1'b1};
                        13: S <= {dd[6:0], 1'b1};
                        14: S <= {de[6:0], 1'b1};
                        15: S <= {df[6:0], 1'b1};
                    endcase
                end
                
                led2:
                begin
                    case (sval)
                        0: S <= {d0[6:1], 1'b1, d0[0:0]};
                        1: S <= {d1[6:1], 1'b1, d1[0:0]};
                        2: S <= {d2[6:1], 1'b1, d2[0:0]};
                        3: S <= {d3[6:1], 1'b1, d3[0:0]};
                        4: S <= {d4[6:1], 1'b1, d4[0:0]};
                        5: S <= {d5[6:1], 1'b1, d5[0:0]};
                        6: S <= {d6[6:1], 1'b1, d6[0:0]};
                        7: S <= {d7[6:1], 1'b1, d7[0:0]};
                        8: S <= {d8[6:1], 1'b1, d8[0:0]};
                        9: S <= {d9[6:1], 1'b1, d9[0:0]};
                        10: S <= {da[6:1], 1'b1, da[0:0]};
                        11: S <= {db[6:1], 1'b1, db[0:0]};
                        12: S <= {dc[6:1], 1'b1, dc[0:0]};
                        13: S <= {dd[6:1], 1'b1, dd[0:0]};
                        14: S <= {de[6:1], 1'b1, de[0:0]};
                        15: S <= {df[6:1], 1'b1, df[0:0]};
                    endcase
                end
                
                led3:
                begin
                    case (sval)
                        0: S <= {d0[6:2], 1'b1, d0[1:0]};
                        1: S <= {d1[6:2], 1'b1, d1[1:0]};
                        2: S <= {d2[6:2], 1'b1, d2[1:0]};
                        3: S <= {d3[6:2], 1'b1, d3[1:0]};
                        4: S <= {d4[6:2], 1'b1, d4[1:0]};
                        5: S <= {d5[6:2], 1'b1, d5[1:0]};
                        6: S <= {d6[6:2], 1'b1, d6[1:0]};
                        7: S <= {d7[6:2], 1'b1, d7[1:0]};
                        8: S <= {d8[6:2], 1'b1, d8[1:0]};
                        9: S <= {d9[6:2], 1'b1, d9[1:0]};
                        10: S <= {da[6:2], 1'b1, da[1:0]};
                        11: S <= {db[6:2], 1'b1, db[1:0]};
                        12: S <= {dc[6:2], 1'b1, dc[1:0]};
                        13: S <= {dd[6:2], 1'b1, dd[1:0]};
                        14: S <= {de[6:2], 1'b1, de[1:0]};
                        15: S <= {df[6:2], 1'b1, df[1:0]};
                    endcase
                end
                
                led4:
                begin
                    case (sval)
                        0: S <= {d0[6:3], 1'b1, d0[2:0]};
                        1: S <= {d1[6:3], 1'b1, d1[2:0]};
                        2: S <= {d2[6:3], 1'b1, d2[2:0]};
                        3: S <= {d3[6:3], 1'b1, d3[2:0]};
                        4: S <= {d4[6:3], 1'b1, d4[2:0]};
                        5: S <= {d5[6:3], 1'b1, d5[2:0]};
                        6: S <= {d6[6:3], 1'b1, d6[2:0]};
                        7: S <= {d7[6:3], 1'b1, d7[2:0]};
                        8: S <= {d8[6:3], 1'b1, d8[2:0]};
                        9: S <= {d9[6:3], 1'b1, d9[2:0]};
                        10: S <= {da[6:3], 1'b1, da[2:0]};
                        11: S <= {db[6:3], 1'b1, db[2:0]};
                        12: S <= {dc[6:3], 1'b1, dc[2:0]};
                        13: S <= {dd[6:3], 1'b1, dd[2:0]};
                        14: S <= {de[6:3], 1'b1, de[2:0]};
                        15: S <= {df[6:3], 1'b1, df[2:0]};
                    endcase
                end
                
                led5:
                begin
                    case (sval)
                        0: S <= {d0[6:4], 1'b1, d0[3:0]};
                        1: S <= {d1[6:4], 1'b1, d1[3:0]};
                        2: S <= {d2[6:4], 1'b1, d2[3:0]};
                        3: S <= {d3[6:4], 1'b1, d3[3:0]};
                        4: S <= {d4[6:4], 1'b1, d4[3:0]};
                        5: S <= {d5[6:4], 1'b1, d5[3:0]};
                        6: S <= {d6[6:4], 1'b1, d6[3:0]};
                        7: S <= {d7[6:4], 1'b1, d7[3:0]};
                        8: S <= {d8[6:4], 1'b1, d8[3:0]};
                        9: S <= {d9[6:4], 1'b1, d9[3:0]};
                        10: S <= {da[6:4], 1'b1, da[3:0]};
                        11: S <= {db[6:4], 1'b1, db[3:0]};
                        12: S <= {dc[6:4], 1'b1, dc[3:0]};
                        13: S <= {dd[6:4], 1'b1, dd[3:0]};
                        14: S <= {de[6:4], 1'b1, de[3:0]};
                        15: S <= {df[6:4], 1'b1, df[3:0]};
                    endcase
                end
                
                led6:
                begin
                    case (sval)
                        0: S <= {d0[6:5], 1'b1, d0[4:0]};
                        1: S <= {d1[6:5], 1'b1, d1[4:0]};
                        2: S <= {d2[6:5], 1'b1, d2[4:0]};
                        3: S <= {d3[6:5], 1'b1, d3[4:0]};
                        4: S <= {d4[6:5], 1'b1, d4[4:0]};
                        5: S <= {d5[6:5], 1'b1, d5[4:0]};
                        6: S <= {d6[6:5], 1'b1, d6[4:0]};
                        7: S <= {d7[6:5], 1'b1, d7[4:0]};
                        8: S <= {d8[6:5], 1'b1, d8[4:0]};
                        9: S <= {d9[6:5], 1'b1, d9[4:0]};
                        10: S <= {da[6:5], 1'b1, da[4:0]};
                        11: S <= {db[6:5], 1'b1, db[4:0]};
                        12: S <= {dc[6:5], 1'b1, dc[4:0]};
                        13: S <= {dd[6:5], 1'b1, dd[4:0]};
                        14: S <= {de[6:5], 1'b1, de[4:0]};
                        15: S <= {df[6:5], 1'b1, df[4:0]};
                    endcase
                end
                
                led7:
                begin
                    case (sval)
                        0: S <= {d0[6:6], 1'b1, d0[5:0]};
                        1: S <= {d1[6:6], 1'b1, d1[5:0]};
                        2: S <= {d2[6:6], 1'b1, d2[5:0]};
                        3: S <= {d3[6:6], 1'b1, d3[5:0]};
                        4: S <= {d4[6:6], 1'b1, d4[5:0]};
                        5: S <= {d5[6:6], 1'b1, d5[5:0]};
                        6: S <= {d6[6:6], 1'b1, d6[5:0]};
                        7: S <= {d7[6:6], 1'b1, d7[5:0]};
                        8: S <= {d8[6:6], 1'b1, d8[5:0]};
                        9: S <= {d9[6:6], 1'b1, d9[5:0]};
                        10: S <= {da[6:6], 1'b1, da[5:0]};
                        11: S <= {db[6:6], 1'b1, db[5:0]};
                        12: S <= {dc[6:6], 1'b1, dc[5:0]};
                        13: S <= {dd[6:6], 1'b1, dd[5:0]};
                        14: S <= {de[6:6], 1'b1, de[5:0]};
                        15: S <= {df[6:6], 1'b1, df[5:0]};
                    endcase
                end
                
                led8:
                begin
                    case (sval)
                        0: S <= {1'b1, d0[6:0]};
                        1: S <= {1'b1, d1[6:0]};
                        2: S <= {1'b1, d2[6:0]};
                        3: S <= {1'b1, d3[6:0]};
                        4: S <= {1'b1, d4[6:0]};
                        5: S <= {1'b1, d5[6:0]};
                        6: S <= {1'b1, d6[6:0]};
                        7: S <= {1'b1, d7[6:0]};
                        8: S <= {1'b1, d8[6:0]};
                        9: S <= {1'b1, d9[6:0]};
                        10: S <= {1'b1, da[6:0]};
                        11: S <= {1'b1, db[6:0]};
                        12: S <= {1'b1, dc[6:0]};
                        13: S <= {1'b1, dd[6:0]};
                        14: S <= {1'b1, de[6:0]};
                        15: S <= {1'b1, df[6:0]};
                    endcase
                end
                
            endcase
        end              
    end
    
endmodule
