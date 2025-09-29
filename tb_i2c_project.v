// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module tb_i2c_project;

  reg clk;
  reg rst;
  reg scl_in;
  reg sda_in;
  reg sda_dev_in;
  reg scl_dev;
  
  wire sda_out1;
  wire scl_out1;
  wire sda_dev_out1;
  wire sda_out2;
  wire scl_out2;
  wire sda_dev_out2;
  wire enable;
  
  i2c_project uut(
    .clk(clk),
    .rst(rst),
    .scl_in(scl_in),
    .sda_in(sda_in),
    .sda_dev_in(sda_dev_in),
    .scl_dev(scl_dev),
    .sda_out1(sda_out1),
    .scl_out1(scl_out1),
    .sda_dev_out1(sda_dev_out1),
    .sda_out2(sda_out2),
    .scl_out2(scl_out2),
    .sda_dev_out2(sda_dev_out2),
    .enable(enable)
  );
  
  always #2500 clk=~clk;//for 200 khz generation based on that we will get data rate of 100khz
  
  initial begin
    clk=1;
    scl_in=1;
    scl_dev=1;
    sda_dev_in=0;
    sda_in=0;
    rst=1;
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_i2c_project);
    $monitor("Time=%0t\tclk=%b rst=%b scl_in=%b sda_in=%b sda_out=%b scl_out=%b state=%d",$time,clk,rst,scl_in,sda_in,sda_out1,scl_out1,sda_dev_out1,sda_out2,scl_out2,sda_dev_out2,uut.state);
    #25;
    rst=0;
    #2500;
    scl_in=1;
    sda_in=1;
    #5000;
    sda_in=0;//start condition transition to address state
    #5000;//start of address fetch (1001001 & 1) read
    scl_in=0;
    sda_in=1;//1
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//2
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//3
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//4
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//5
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//6
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//7
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//8
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;//waiting to verify the address
    #5000;
    scl_in=1;
    
    //reading data from slave(10010010)
    #5000;
    scl_dev=0;
    sda_dev_in=1;//1
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=0;//2
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=0;//3
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=1;//4
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=0;//5
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=0;//6
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=1;//7
    #5000;
    scl_dev=1;
    #5000;
    scl_dev=0;
    sda_dev_in=0;//8
    #5000;
    scl_dev=1;
    //data transfer to master
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//0
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//1
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//2
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//3
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//4
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//5
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//6
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//7
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//8
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;//wait for acknowledgement
    sda_in=1;
    #5000;
    scl_dev=0;
    #5000;
    scl_dev=1;
    #5000;
    scl_in=0;
    sda_in=0;
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;
    #5000;
    scl_in=1;
    #5000;
    sda_in=0;
    #5000;
    sda_in=1;//to trigger stop condition and transition to idle state
    
    //to write on device 1 (48H)
    
    #5000;
    scl_in=1;
    sda_in=1;
    #5000;
    sda_in=0;//start condition transition to address fetch
    //address fetch(1001000)(48H) and (0)for write operation on slave
    #5000;
    scl_in=0;
    sda_in=1;//1
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//2
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//3
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//4
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//5
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//6
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//7
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//8 (r/w flag)
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;//acknowledgement
    #5000;
    scl_in=1;
    //provide data to write (10010010)
    #5000;
    scl_in=0;
    sda_in=1;//1
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//2
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//3
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//4
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//5
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//6
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=1;//7
    #5000;
    scl_in=1;
    #5000;
    scl_in=0;
    sda_in=0;//8
    #5000;
    scl_in=1;//0
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//1
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//2
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//3
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//4
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//5
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//6
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//7
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//8
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;//9 wait for acknowledgement
    sda_dev_in=1;
    #5000;
    scl_in=0;
    #5000;
    scl_in=1;
    #5000;
    //to generate stop condition
    scl_in=0;
    sda_in=0;
    #5000;
    scl_in=1;
    #5000;
    sda_in=1;
    #10000;
    $display("testbench simulated");
    $finish;
  end
endmodule
    








    
    







    
    
    
    
    
