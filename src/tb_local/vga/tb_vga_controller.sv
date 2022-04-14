module tb_vga_controller();
    
    logic iclk, irstn, ivalid, ix, iy;
    logic VGA_HS, VGA_VS;
    logic [3:0] ipixel_data, VGA_R, VGA_G, VGA_B; 

    vga_controller dut(.*);

    initial begin
        iclk = 1'b0;
        forever
            #1 iclk = ~iclk;
    end

    initial begin
        #10000000;
        $display("timeout");
        $finish;
    end

endmodule
