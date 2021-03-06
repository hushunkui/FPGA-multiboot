module	se_ctrl(
		input			wire			sclk			,
		input			wire			rst_n			,
		input			wire			se_start	,
		output		reg				se_end		,
		output		reg				cs_n			,
		output		reg				sck				,
		output		reg				sdi
);
reg				div_4		;
reg[1:0]	cnt_4		;
reg[4:0]	cnt_32	;
reg[3:0]	cnt			;
reg[2:0]	bit_cnt	;
reg				flag		;
reg[7:0]	ADDR1_INST;
parameter		WREN_INST				=	8'b0000_0110	;
parameter		SE_INST					=	8'b1101_1000	;
parameter		ADDR1_RST			=	8'h40	;//扇区地址 
//parameter		ADDR1_INST			=	8'b0000_0000	;//扇区地址 
parameter		ADDR2_INST			=	8'b0000_0000	;//页地址   
parameter		ADDR3_INST			=	8'b0000_0000	;//字节地址 
parameter		DELAY0		=	4'd0;
parameter		WREN 			=	4'd1;
parameter		DELAY1		=	4'd2;
parameter		DELAY2		=	4'd3;
parameter		DELAY3		=	4'd4;	
parameter		SE				=	4'd5;
parameter		ADDR1			=	4'd6;
parameter		ADDR2			=	4'd7;
parameter		ADDR3			=	4'd8;
parameter		DELAY4		=	4'd9;

//扇区地址定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			ADDR1_INST	<=	ADDR1_RST;
		else	if(se_end==1)
			ADDR1_INST	<=	ADDR1_INST+1;
		else	
			ADDR1_INST	<=	ADDR1_INST;
			
//se_end
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			se_end	<=	0;
		else	if(cnt==DELAY4&&cnt_32==31)
			se_end	<=	1;
		else	
			se_end	<=	0;
/************************四分频时钟定义*********************/
//cnt_4定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			cnt_4	<=	0;
		else	if(cnt_4==3)
			cnt_4	<=	0;
		else
			cnt_4	<=	cnt_4	+	1;

//div_4定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			div_4	<=	0;
		else	if(cnt_4<=1)
			div_4	<=	1;
		else	if(cnt_4>1)
			div_4	<=	0;
//flag定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				flag	<=	0;
		else	if(se_start==1)
				flag	<=	1;
		else	if(cnt==DELAY4&&cnt_32==31)
				flag	<=	0;		
				
//cnt_32定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			cnt_32	<=	0;
		else	if(cnt_32==31)
			cnt_32	<=	0;
		else	if(flag==1)
			cnt_32	<=	cnt_32	+	1;
			
//cnt定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			cnt	<=	0;
		else	if(cnt==9&&cnt_32==31)
			cnt	<=	0;
		else	if(cnt_32==31)
			cnt	<=	cnt	+	1;
			
//cs_n定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			cs_n	<=	1;
		else	if(se_start==1)
			cs_n	<=	0;
		else	if(cnt==DELAY1&&cnt_32==31)
			cs_n	<=	1;
		else	if(cnt==DELAY2&&cnt_32==31)
			cs_n	<=	0;
		else	if(cnt==DELAY4&&cnt_32==31)
			cs_n	<=	1;
		else
			cs_n	<=	cs_n;
			
//sck定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			sck	<=	0;
		else	if(cnt==WREN||cnt==SE||cnt==ADDR1||cnt==ADDR2||cnt==ADDR3)
			sck	<=	div_4	;
		else	
			sck	<=	0;
			
//bit_cnt定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			bit_cnt	<=	0;
		else	if(bit_cnt==7&&cnt_4==3)
			bit_cnt	<=	0;
		else	if(sck==1&&cnt_4==3)
			bit_cnt	<=	bit_cnt	+	1;
//sdi定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			sdi	<=	0;
		else	if(cnt==WREN)
			sdi	<=	WREN_INST[7-bit_cnt];
		else	if(cnt==SE)
			sdi	<=	SE_INST[7-bit_cnt]	;
		else	if(cnt==ADDR1)
			sdi	<=	ADDR1_INST[7-bit_cnt];	
		else	if(cnt==ADDR2)
			sdi	<=	ADDR2_INST[7-bit_cnt];	
		else	if(cnt==ADDR3)
			sdi	<=	ADDR3_INST[7-bit_cnt];	
			
			
endmodule
		
			
			



