// Code your design here
module i2c_project(
input clk,rst,scl_in,sda_in,sda_dev_in,scl_dev,
//for transmitting or receving data to/from device 2 which is assigned virtual address of 49H
output reg sda_out1,
output reg scl_out1,
output reg sda_dev_out1,
//for transmitting or receving data to/from device 1 which is assigned virtual address of 48H
output reg sda_out2,
output reg scl_out2,
output reg sda_dev_out2,
//output register enable it will decide device 1 or device 2
output reg enable
);

reg [7:0]address_shift_reg;//to store address fetched from master and read or write bit
reg [7:0]data_shift_reg;// to store data which is coming from slave or master
reg [7:0]device_tx_reg;//to transmit data to slave device
reg [7:0]device_rx_reg;//to  receive data from slave device

reg rw_flag;//decide to read/write operation
reg [2:0]state;
reg state2;
reg state3;
reg [6:0]virtual_address=7'b1001001;//for device-2(49H)
reg [6:0]virtual_address2=7'b1001000;//for device-1(48H)

reg count;
reg prev_scl;
reg prev_sda;
//at final these registers value will be passed to the device as per enable signal
reg sda_out;
reg scl_out;
reg sda_dev_out;
//registers for counts of states
reg [3:0]cnt_state1;
reg [3:0]cnt_state2;
reg [3:0]cnt_state3;

always@(posedge clk or posedge rst)begin
if(rst)begin

address_shift_reg=8'd0;
data_shift_reg=8'd0;
device_rx_reg=8'd0;
device_tx_reg=8'd0;
rw_flag=0;
state=3'd0;
state2=0;
state3=0;
count=0;
cnt_state1=4'd0;
cnt_state2=4'd0;
cnt_state3=4'd0;
prev_scl=0;
prev_sda=0;
sda_dev_out=0;
scl_out=0;
sda_out=0;
sda_dev_out1=0;
scl_out1=0;
sda_out1=0;
sda_dev_out2=0;
scl_out2=0;
sda_out2=0;
enable=0;
end

else begin

if(state==3'd0)begin//Idle state begins
address_shift_reg=8'd0;
data_shift_reg=8'd0;
device_rx_reg=8'd0;
device_tx_reg=8'd0;

  if(count==0)begin
     prev_scl=scl_in;
	  prev_sda=sda_in;
	  count=count+1'b1;
  end
  else begin
     if((scl_in==1)&&(scl_in==prev_scl)&&(prev_sda==1)&&(sda_in==0))begin
	        sda_out=1;
			  scl_out=1;
			  sda_dev_out=1;
			  state=3'd1;//when scl should be 1 and prev_sda should be 1 and sda_in will be 0 then transition to state 1(address fetch)
			  count=0;
     end	
	  else begin
           prev_scl=scl_in;
		     prev_sda=sda_in;	  
	  end
  end
  
end

else if(state==3'd1)begin//address fetch
   
	if(scl_in==1 && prev_scl==0)begin
        
		if(cnt_state1<8)begin
	        address_shift_reg={address_shift_reg[6:0],sda_in};
			  cnt_state1=cnt_state1+4'd1;
			  sda_out=1;
			  scl_out=1;
			  sda_dev_out=1;
      end	
		else begin
           rw_flag=address_shift_reg[0];
			  if(address_shift_reg[7:1]==virtual_address)begin
			        sda_out=0;
					  enable=1;//device with 49H will be selected
					  if(rw_flag==0)begin
                      state=3'd2;	//write on slave					 
					  end
					  else begin
                      state=3'd3;	//read from slave					 
					  end
	        end	
			  else if(address_shift_reg[7:1]==virtual_address2)begin
			        sda_out=0;
					  enable=0;//device with 48H will be selected
					  if(rw_flag==0)begin
                      state=3'd2;	//write on slave					 
					  end
					  else begin
                      state=3'd3;	//read from slave					 
					  end
	        end	
			  else begin
			        sda_out=1;
					  state=3'd0;
			  end
			  cnt_state1=4'd0;
		end
		 
	end
	prev_scl=scl_in;
	if(enable==0)begin
            sda_out1=sda_out;
            sda_dev_out1=sda_dev_out;
            scl_out1=scl_out;				
		  end
		  else begin
		      sda_out2=sda_out;
            sda_dev_out2=sda_dev_out;
            scl_out2=scl_out;
		  end
end


else if(state==3'd2)begin//write on slave
    
	 if(scl_in==1 && prev_scl==0)begin
	     if(state2==0)begin
	         if(cnt_state2<8)begin
                 data_shift_reg={data_shift_reg[6:0],sda_in};
					  cnt_state2=cnt_state2+4'd1;
            end	
				else begin
                 device_tx_reg=data_shift_reg;
                 cnt_state2=4'd0;
                 state2=1;				     
			   end
		  end
		  else begin
		      if(cnt_state2<8)begin
                 sda_dev_out=device_tx_reg[7-cnt_state2];
			        cnt_state2=cnt_state2+4'd1;		  
				end
				else begin
                 if(sda_dev_in==0)
			            cnt_state2=0;
			        else
			            state=3'd4;//transition to stop stage				
				end
		  end
	end
		  prev_scl=scl_in;
		  if(enable==0)begin
            sda_out1=sda_out;
            sda_dev_out1=sda_dev_out;
            scl_out1=scl_out;				
		  end
		  else begin
		      sda_out2=sda_out;
            sda_dev_out2=sda_dev_out;
            scl_out2=scl_out;
		  end
	 
end


else if(state==3'd3)begin//read from slave
    
	 if(scl_in==1 && prev_scl==0)begin
	     if(state3==0)begin
	         if(cnt_state3<8)begin
                 device_rx_reg={device_rx_reg[6:0],sda_dev_in};
					  cnt_state3=cnt_state3+4'd1;
            end	
				else begin
                 data_shift_reg=device_rx_reg;
                 cnt_state3=4'd0;
                 state3=1;				     
			   end
		  end
		  else begin
		      if(cnt_state3<8)begin
                 sda_out=data_shift_reg[7-cnt_state2];
			        cnt_state3=cnt_state3+4'd1;		  
				end
				else begin
                 if(sda_in==0)
			            cnt_state3=0;
			        else
			            state=3'd4;//transition to stop stage				
				end
		  end
	end
		  prev_scl=scl_dev;
		  if(enable==0)begin
            sda_out1=sda_out;
            sda_dev_out1=sda_dev_out;
            scl_out1=scl_out;				
		  end
		  else begin
		      sda_out2=sda_out;
            sda_dev_out2=sda_dev_out;
            scl_out2=scl_out;
		  end
	 
end

else if(state==3'd4)begin//stop state
      address_shift_reg=8'd0;
		data_shift_reg=8'd0;
		device_rx_reg=8'd0;
		device_tx_reg=8'd0;
		if(count==0)begin
           prev_scl=scl_in;
			  scl_out=sda_in;
			  sda_dev_out=1;
			  state=3'd0;
			  count=0;  
		end
		else begin
           if((scl_in==1)&&(scl_in==prev_scl)&&(prev_sda==0)&&(sda_in==1))begin
                 sda_out=1;
		           scl_out=1;
		           sda_dev_out=1;
		           state=3'd0;
		           count=0;			  
			  end
			  else begin
			        prev_scl=scl_in;
					  prev_sda=sda_in;
			  end
			  
		end
end

end
end
endmodule






























































































