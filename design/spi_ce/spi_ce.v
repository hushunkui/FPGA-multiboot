module	spi_ce(
		input		wire			sclk	,
		input		wire			rst_n	,
		input		wire			key_in,
		//input		wire			key_flag,
		output	wire			cs_n	,
		output	wire			sck		,
		output	wire			ce_end_flag,
		output	wire			sdi		
);

wire	key_flag;
wire	se_end	;
wire	se_start;

key_debounce	U1(
.rst_n	(rst_n),
.sclk		(sclk	),
.key		(key_in	),
.key_flag   (key_flag )

);
						
//se_ctrl����
se_ctrl	U2(
.sclk			(sclk			),
.rst_n		(rst_n		)	,
.se_start	(se_start	),
.se_end		(se_end		),
.cs_n			(cs_n			),
.sck			(sck			)	,
.sdi      (sdi      )
);

se_start	U3(
.sclk					(sclk				),
.rst_n				(rst_n			),
.se_end				(se_end			),
.key_flag			(key_flag		),
.ce_end_flag	(ce_end_flag),
.se_start			(se_start		)
		
);

endmodule