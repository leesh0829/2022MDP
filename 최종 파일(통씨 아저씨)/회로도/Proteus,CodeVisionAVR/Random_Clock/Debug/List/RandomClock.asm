
;CodeVisionAVR C Compiler V3.51 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x68
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x80

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _num=R4
	.DEF _num_msb=R5
	.DEF _tri=R6
	.DEF _tri_msb=R7
	.DEF _mode=R8
	.DEF _mode_msb=R9
	.DEF _brk=R10
	.DEF _brk_msb=R11
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x10,0x0,0x0,0x0

_0x3:
	.DB  0x10,0x20,0x80,0x40
_0x4:
	.DB  0xFE,0xFB,0xEF,0xBF
_0x5:
	.DB  0xFD,0xF7,0xDF,0x7F
_0x0:
	.DB  0x53,0x65,0x6C,0x65,0x63,0x74,0x20,0x6D
	.DB  0x6F,0x64,0x65,0x0,0x43,0x75,0x72,0x72
	.DB  0x65,0x63,0x74,0x20,0x6D,0x6F,0x64,0x65
	.DB  0x3A,0x20,0x31,0x36,0x0,0x43,0x75,0x72
	.DB  0x72,0x65,0x63,0x74,0x20,0x6D,0x6F,0x64
	.DB  0x65,0x3A,0x20,0x38,0x0,0x53,0x54,0x41
	.DB  0x52,0x54,0x20,0x47,0x41,0x4D,0x45,0x0
	.DB  0x30,0x20,0x53,0x57,0x20,0x69,0x73,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x62,0x6F,0x6D,0x62
	.DB  0x0,0x42,0x4F,0x4D,0x42,0x0,0x31,0x20
	.DB  0x53,0x57,0x20,0x69,0x73,0x20,0x6E,0x6F
	.DB  0x74,0x20,0x62,0x6F,0x6D,0x62,0x0,0x31
	.DB  0x20,0x53,0x57,0x20,0x69,0x73,0x20,0x62
	.DB  0x6F,0x6D,0x62,0x0,0x32,0x20,0x53,0x57
	.DB  0x20,0x69,0x73,0x20,0x6E,0x6F,0x74,0x20
	.DB  0x62,0x6F,0x6D,0x62,0x0,0x32,0x20,0x53
	.DB  0x57,0x20,0x69,0x73,0x20,0x62,0x6F,0x6D
	.DB  0x62,0x0,0x33,0x20,0x53,0x57,0x20,0x69
	.DB  0x73,0x20,0x6E,0x6F,0x74,0x20,0x62,0x6F
	.DB  0x6D,0x62,0x0,0x33,0x20,0x53,0x57,0x20
	.DB  0x69,0x73,0x20,0x62,0x6F,0x6D,0x62,0x0
	.DB  0x34,0x20,0x53,0x57,0x20,0x69,0x73,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x62,0x6F,0x6D,0x62
	.DB  0x0,0x34,0x20,0x53,0x57,0x20,0x69,0x73
	.DB  0x20,0x62,0x6F,0x6D,0x62,0x0,0x35,0x20
	.DB  0x53,0x57,0x20,0x69,0x73,0x20,0x6E,0x6F
	.DB  0x74,0x20,0x62,0x6F,0x6D,0x62,0x0,0x35
	.DB  0x20,0x53,0x57,0x20,0x69,0x73,0x20,0x62
	.DB  0x6F,0x6D,0x62,0x0,0x36,0x20,0x53,0x57
	.DB  0x20,0x69,0x73,0x20,0x6E,0x6F,0x74,0x20
	.DB  0x62,0x6F,0x6D,0x62,0x0,0x36,0x20,0x53
	.DB  0x57,0x20,0x69,0x73,0x20,0x62,0x6F,0x6D
	.DB  0x62,0x0,0x37,0x20,0x53,0x57,0x20,0x69
	.DB  0x73,0x20,0x6E,0x6F,0x74,0x20,0x62,0x6F
	.DB  0x6D,0x62,0x0,0x37,0x20,0x53,0x57,0x20
	.DB  0x69,0x73,0x20,0x62,0x6F,0x6D,0x62,0x0
	.DB  0x38,0x20,0x53,0x57,0x20,0x69,0x73,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x62,0x6F,0x6D,0x62
	.DB  0x0,0x38,0x20,0x53,0x57,0x20,0x69,0x73
	.DB  0x20,0x62,0x6F,0x6D,0x62,0x0,0x39,0x20
	.DB  0x53,0x57,0x20,0x69,0x73,0x20,0x6E,0x6F
	.DB  0x74,0x20,0x62,0x6F,0x6D,0x62,0x0,0x39
	.DB  0x20,0x53,0x57,0x20,0x69,0x73,0x20,0x62
	.DB  0x6F,0x6D,0x62,0x0,0x41,0x20,0x53,0x57
	.DB  0x20,0x69,0x73,0x20,0x6E,0x6F,0x74,0x20
	.DB  0x62,0x6F,0x6D,0x62,0x0,0x41,0x20,0x53
	.DB  0x57,0x20,0x69,0x73,0x20,0x62,0x6F,0x6D
	.DB  0x62,0x0,0x42,0x20,0x53,0x57,0x20,0x69
	.DB  0x73,0x20,0x6E,0x6F,0x74,0x20,0x62,0x6F
	.DB  0x6D,0x62,0x0,0x42,0x20,0x53,0x57,0x20
	.DB  0x69,0x73,0x20,0x62,0x6F,0x6D,0x62,0x0
	.DB  0x43,0x20,0x53,0x57,0x20,0x69,0x73,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x62,0x6F,0x6D,0x62
	.DB  0x0,0x43,0x20,0x53,0x57,0x20,0x69,0x73
	.DB  0x20,0x62,0x6F,0x6D,0x62,0x0,0x44,0x20
	.DB  0x53,0x57,0x20,0x69,0x73,0x20,0x6E,0x6F
	.DB  0x74,0x20,0x62,0x6F,0x6D,0x62,0x0,0x44
	.DB  0x20,0x53,0x57,0x20,0x69,0x73,0x20,0x62
	.DB  0x6F,0x6D,0x62,0x0,0x45,0x20,0x53,0x57
	.DB  0x20,0x69,0x73,0x20,0x6E,0x6F,0x74,0x20
	.DB  0x62,0x6F,0x6D,0x62,0x0,0x45,0x20,0x53
	.DB  0x57,0x20,0x69,0x73,0x20,0x62,0x6F,0x6D
	.DB  0x62,0x0,0x46,0x20,0x53,0x57,0x20,0x69
	.DB  0x73,0x20,0x6E,0x6F,0x74,0x20,0x62,0x6F
	.DB  0x6D,0x62,0x0,0x46,0x20,0x53,0x57,0x20
	.DB  0x69,0x73,0x20,0x62,0x6F,0x6D,0x62,0x0
	.DB  0x4D,0x52,0x20,0x54,0x4F,0x4E,0x47,0x0
	.DB  0x50,0x55,0x53,0x48,0x20,0x43,0x4F,0x4E
	.DB  0x54,0x49,0x4E,0x55,0x45,0x0,0x53,0x45
	.DB  0x4C,0x45,0x43,0x54,0x20,0x20,0x4D,0x4F
	.DB  0x44,0x45,0x0,0x20,0x20,0x20,0x20,0x31
	.DB  0x36,0x20,0x7C,0x20,0x20,0x38,0x0,0x47
	.DB  0x41,0x4D,0x45,0x20,0x52,0x45,0x41,0x44
	.DB  0x59,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _vertical
	.DW  _0x3*2

	.DW  0x04
	.DW  _red_led
	.DW  _0x4*2

	.DW  0x04
	.DW  _green_led
	.DW  _0x5*2

	.DW  0x0B
	.DW  _0x1B
	.DW  _0x0*2+45

	.DW  0x11
	.DW  _0x1B+11
	.DW  _0x0*2+56

	.DW  0x05
	.DW  _0x1B+28
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+33
	.DW  _0x0*2+78

	.DW  0x0D
	.DW  _0x1B+50
	.DW  _0x0*2+95

	.DW  0x05
	.DW  _0x1B+63
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+68
	.DW  _0x0*2+108

	.DW  0x0D
	.DW  _0x1B+85
	.DW  _0x0*2+125

	.DW  0x05
	.DW  _0x1B+98
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+103
	.DW  _0x0*2+138

	.DW  0x0D
	.DW  _0x1B+120
	.DW  _0x0*2+155

	.DW  0x05
	.DW  _0x1B+133
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+138
	.DW  _0x0*2+168

	.DW  0x0D
	.DW  _0x1B+155
	.DW  _0x0*2+185

	.DW  0x05
	.DW  _0x1B+168
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+173
	.DW  _0x0*2+198

	.DW  0x0D
	.DW  _0x1B+190
	.DW  _0x0*2+215

	.DW  0x05
	.DW  _0x1B+203
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+208
	.DW  _0x0*2+228

	.DW  0x0D
	.DW  _0x1B+225
	.DW  _0x0*2+245

	.DW  0x05
	.DW  _0x1B+238
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+243
	.DW  _0x0*2+258

	.DW  0x0D
	.DW  _0x1B+260
	.DW  _0x0*2+275

	.DW  0x05
	.DW  _0x1B+273
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+278
	.DW  _0x0*2+288

	.DW  0x0D
	.DW  _0x1B+295
	.DW  _0x0*2+305

	.DW  0x05
	.DW  _0x1B+308
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+313
	.DW  _0x0*2+318

	.DW  0x0D
	.DW  _0x1B+330
	.DW  _0x0*2+335

	.DW  0x05
	.DW  _0x1B+343
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+348
	.DW  _0x0*2+348

	.DW  0x0D
	.DW  _0x1B+365
	.DW  _0x0*2+365

	.DW  0x05
	.DW  _0x1B+378
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+383
	.DW  _0x0*2+378

	.DW  0x0D
	.DW  _0x1B+400
	.DW  _0x0*2+395

	.DW  0x05
	.DW  _0x1B+413
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+418
	.DW  _0x0*2+408

	.DW  0x0D
	.DW  _0x1B+435
	.DW  _0x0*2+425

	.DW  0x05
	.DW  _0x1B+448
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+453
	.DW  _0x0*2+438

	.DW  0x0D
	.DW  _0x1B+470
	.DW  _0x0*2+455

	.DW  0x05
	.DW  _0x1B+483
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+488
	.DW  _0x0*2+468

	.DW  0x0D
	.DW  _0x1B+505
	.DW  _0x0*2+485

	.DW  0x05
	.DW  _0x1B+518
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x1B+523
	.DW  _0x0*2+498

	.DW  0x0D
	.DW  _0x1B+540
	.DW  _0x0*2+515

	.DW  0x05
	.DW  _0x1B+553
	.DW  _0x0*2+73

	.DW  0x08
	.DW  _0x5A
	.DW  _0x0*2+528

	.DW  0x0E
	.DW  _0x5A+8
	.DW  _0x0*2+536

	.DW  0x0D
	.DW  _0x5A+22
	.DW  _0x0*2+550

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x500

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
        .equ __lcd_port = 0x1b //a포트로 사용
; 0000 0005     #endasm
;int keyMatrix(unsigned char in);

	.DSEG
;void reset(void);
;void manager(void);
;void modee()
; 0000 0016 {

	.CSEG
_modee:
; .FSTART _modee
; 0000 0017 if(PINF == 0xfe) //16모드 입력
	IN   R30,0x0
	CPI  R30,LOW(0xFE)
	BRNE _0x6
; 0000 0018 {
; 0000 0019 mode = 16; //모드에 16저장
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x0
; 0000 001A lcd_clear();
; 0000 001B lcd_gotoxy(0,0);
; 0000 001C lcd_putsf("Select mode");
; 0000 001D lcd_gotoxy(0,1);
; 0000 001E lcd_putsf("Currect mode: 16"); //선택한 모드를 lcd에 출력
	__POINTW2FN _0x0,12
	RCALL SUBOPT_0x1
; 0000 001F PORTB = 0x00;
; 0000 0020 PORTC = 0xff; // led 기본상태(off)
; 0000 0021 }
; 0000 0022 
; 0000 0023 if(PINF == 0xfd) //8모드 입력
_0x6:
	IN   R30,0x0
	CPI  R30,LOW(0xFD)
	BRNE _0x7
; 0000 0024 {
; 0000 0025 mode = 8; //모드에 8저장
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x0
; 0000 0026 lcd_clear();
; 0000 0027 lcd_gotoxy(0,0);
; 0000 0028 lcd_putsf("Select mode");
; 0000 0029 lcd_gotoxy(0,1);
; 0000 002A lcd_putsf("Currect mode: 8"); //선택한 모드 lcd에 출력
	__POINTW2FN _0x0,29
	RCALL SUBOPT_0x1
; 0000 002B PORTB = 0x00;
; 0000 002C PORTC = 0xff; //led 기본상태(off)
; 0000 002D }
; 0000 002E }
_0x7:
	RET
; .FEND
;void buzzer(void)
; 0000 0031 {
_buzzer:
; .FSTART _buzzer
; 0000 0032 PORTG = 0xfe;
	LDI  R30,LOW(254)
	RJMP _0x2080003
; 0000 0033 }
; .FEND
;void buzzer2(void)
; 0000 0036 {
_buzzer2:
; .FSTART _buzzer2
; 0000 0037 PORTG = 0xfd;
	LDI  R30,LOW(253)
	RJMP _0x2080003
; 0000 0038 }
; .FEND
;void buzzer_off(void)
; 0000 003B {
_buzzer_off:
; .FSTART _buzzer_off
; 0000 003C PORTG = 0xff;
	LDI  R30,LOW(255)
_0x2080003:
	STS  101,R30
; 0000 003D }
	RET
; .FEND
;int keyMatrix(unsigned char in)
; 0000 0041 {
_keyMatrix:
; .FSTART _keyMatrix
; 0000 0042 int key; //반환 값 저장
; 0000 0043 
; 0000 0044 switch (in) {  //입력을 받는것은 PIN
	RCALL __SAVELOCR4
	MOV  R19,R26
;	in -> R19
;	key -> R16,R17
	MOV  R30,R19
	LDI  R31,0
; 0000 0045 case 0x7e : key = 0;
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0xB
	__GETWRN 16,17,0
; 0000 0046 break;
	RJMP _0xA
; 0000 0047 case 0x7d : key = 1; // 0111 1110이면, 1을 return
_0xB:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0xC
	__GETWRN 16,17,1
; 0000 0048 break;
	RJMP _0xA
; 0000 0049 case 0x7b : key = 2; // 0111 1011이면, 2를 반환
_0xC:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0xD
	__GETWRN 16,17,2
; 0000 004A break;
	RJMP _0xA
; 0000 004B case 0x77 : key = 3;
_0xD:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0xE
	__GETWRN 16,17,3
; 0000 004C break;
	RJMP _0xA
; 0000 004D case 0xbe : key = 4;
_0xE:
	CPI  R30,LOW(0xBE)
	LDI  R26,HIGH(0xBE)
	CPC  R31,R26
	BRNE _0xF
	__GETWRN 16,17,4
; 0000 004E break;
	RJMP _0xA
; 0000 004F case 0xbd : key = 5;
_0xF:
	CPI  R30,LOW(0xBD)
	LDI  R26,HIGH(0xBD)
	CPC  R31,R26
	BRNE _0x10
	__GETWRN 16,17,5
; 0000 0050 break;
	RJMP _0xA
; 0000 0051 case 0xbb : key = 6;
_0x10:
	CPI  R30,LOW(0xBB)
	LDI  R26,HIGH(0xBB)
	CPC  R31,R26
	BRNE _0x11
	__GETWRN 16,17,6
; 0000 0052 break;
	RJMP _0xA
; 0000 0053 case 0xb7 : key = 7;
_0x11:
	CPI  R30,LOW(0xB7)
	LDI  R26,HIGH(0xB7)
	CPC  R31,R26
	BRNE _0x12
	__GETWRN 16,17,7
; 0000 0054 break;
	RJMP _0xA
; 0000 0055 case 0xde : key = 8;
_0x12:
	CPI  R30,LOW(0xDE)
	LDI  R26,HIGH(0xDE)
	CPC  R31,R26
	BRNE _0x13
	__GETWRN 16,17,8
; 0000 0056 break;
	RJMP _0xA
; 0000 0057 case 0xdd : key = 9;
_0x13:
	CPI  R30,LOW(0xDD)
	LDI  R26,HIGH(0xDD)
	CPC  R31,R26
	BRNE _0x14
	__GETWRN 16,17,9
; 0000 0058 break;
	RJMP _0xA
; 0000 0059 case 0xdb : key = 10;
_0x14:
	CPI  R30,LOW(0xDB)
	LDI  R26,HIGH(0xDB)
	CPC  R31,R26
	BRNE _0x15
	__GETWRN 16,17,10
; 0000 005A break;
	RJMP _0xA
; 0000 005B case 0xd7 : key = 11;
_0x15:
	CPI  R30,LOW(0xD7)
	LDI  R26,HIGH(0xD7)
	CPC  R31,R26
	BRNE _0x16
	__GETWRN 16,17,11
; 0000 005C break;
	RJMP _0xA
; 0000 005D case 0xee : key = 12;
_0x16:
	CPI  R30,LOW(0xEE)
	LDI  R26,HIGH(0xEE)
	CPC  R31,R26
	BRNE _0x17
	__GETWRN 16,17,12
; 0000 005E break;
	RJMP _0xA
; 0000 005F case 0xed : key = 13;
_0x17:
	CPI  R30,LOW(0xED)
	LDI  R26,HIGH(0xED)
	CPC  R31,R26
	BRNE _0x18
	__GETWRN 16,17,13
; 0000 0060 break;
	RJMP _0xA
; 0000 0061 case 0xeb : key = 14;
_0x18:
	CPI  R30,LOW(0xEB)
	LDI  R26,HIGH(0xEB)
	CPC  R31,R26
	BRNE _0x19
	__GETWRN 16,17,14
; 0000 0062 break;
	RJMP _0xA
; 0000 0063 case 0xe7 : key = 15;
_0x19:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0xA
	__GETWRN 16,17,15
; 0000 0064 break;
; 0000 0065 }
_0xA:
; 0000 0066 
; 0000 0067 return key; //key 리턴
	MOVW R30,R16
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 0068 
; 0000 0069 }
; .FEND
;void manager(void)
; 0000 006C {
_manager:
; .FSTART _manager
; 0000 006D int keyout; // 키매트릭스 신호
; 0000 006E int i; //for문
; 0000 006F unsigned char matrix; //PIND를 저장할 변수
; 0000 0070 
; 0000 0071 lcd_init(16);
	RCALL __SAVELOCR6
;	keyout -> R16,R17
;	i -> R18,R19
;	matrix -> R21
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0072 
; 0000 0073 lcd_gotoxy(3,1);
	RCALL SUBOPT_0x2
; 0000 0074 lcd_puts("START GAME"); //게임 시작
	__POINTW2MN _0x1B,0
	RCALL _lcd_puts
; 0000 0075 
; 0000 0076 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x3
; 0000 0077 
; 0000 0078 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0079 
; 0000 007A lcd_clear();
	RCALL _lcd_clear
; 0000 007B 
; 0000 007C /*if(mode == 16) {
; 0000 007D lcd_gotoxy(0,1);
; 0000 007E lcd_puts("0123456789ABCDEF"); //16모드일때 사용 가능한 스위치를 LCD에 출력
; 0000 007F lcd_gotoxy(0,0); // 위치를 안잡으면 lcd오류발생
; 0000 0080 }
; 0000 0081 else if(mode == 8) {
; 0000 0082 lcd_gotoxy(0,1);
; 0000 0083 lcd_puts("01234567"); //8모드일때 사용 가능한 스위치를 lcd에 출력
; 0000 0084 lcd_gotoxy(0,0); // 위치를 안잡으면 lcd오류발생
; 0000 0085 } */
; 0000 0086 
; 0000 0087 lcd_gotoxy(0,0); // 위치를 안잡으면 lcd오류발생
	RCALL SUBOPT_0x3
; 0000 0088 
; 0000 0089 buzzer();
	RCALL _buzzer
; 0000 008A 
; 0000 008B delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 008C 
; 0000 008D while(tri) { //tri가 1일때 반복
_0x1C:
	MOV  R0,R6
	OR   R0,R7
	BRNE PC+2
	RJMP _0x1E
; 0000 008E keyout = 0xfe; //keyout에 1111 1110 저장
	__GETWRN 16,17,254
; 0000 008F for(i = 0; i<=3; i++) { //4x4임으로 반복문을 4번 돌려줌, ex)3x3 -> i = 0; i<=2; i++
	__GETWRN 18,19,0
_0x20:
	__CPWRN 18,19,4
	BRLT PC+2
	RJMP _0x21
; 0000 0090 PORTD = keyout; //행 스캔 출력
	OUT  0x12,R16
; 0000 0091 matrix = PIND; //매트릭스에 PIND값 저장
	IN   R21,16
; 0000 0092 
; 0000 0093 
; 0000 0094 if(keyMatrix(matrix) == 0)  { //키매트릭스 함수의 switch문에 PIND값을 넣고, 리턴값이 0일때
	MOV  R26,R21
	RCALL _keyMatrix
	SBIW R30,0
	BRNE _0x22
; 0000 0095 if(keyMatrix(matrix) != num) { //리턴값이 난수값과 같지 않을때
	RCALL SUBOPT_0x4
	BREQ _0x23
; 0000 0096 PORTB = vertical[0]; //0번 스위치 해당하는 가로줄 호출
	LDS  R30,_vertical
	RCALL SUBOPT_0x5
; 0000 0097 PORTC = green_led[0]; //0번 스위치 해당하는 세로줄 호출
; 0000 0098 lcd_gotoxy(0,0);
; 0000 0099 lcd_puts("0 SW is not bomb"); //해당 스위치 위치를 lcd 출력
	__POINTW2MN _0x1B,11
	RCALL SUBOPT_0x6
; 0000 009A delay_us(500);
; 0000 009B //lcd_gotoxy(0, 1);
; 0000 009C //lcd_puts(" "); //lcd에 공백을 넣어 0번 스위치 비움
; 0000 009D }
; 0000 009E else { // sw번호 = num(난수)
	RJMP _0x24
_0x23:
; 0000 009F PORTB = vertical[0]; //0번 스위치 해당하는 가로줄 호출
	LDS  R30,_vertical
	RCALL SUBOPT_0x7
; 0000 00A0 PORTC = red_led[0]; //0번 스위치 붉은 부분에 해당하는 세로줄 호출
; 0000 00A1 lcd_clear();
; 0000 00A2 //lcd_gotoxy(0, 0);
; 0000 00A3 //delay_ms(500);
; 0000 00A4 //lcd_puts("0 SW is bomb"); //몇 번 스위치가 터졌는지 ㅣcd에 표시
; 0000 00A5 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 00A6 lcd_puts("BOMB");
	__POINTW2MN _0x1B,28
	RCALL SUBOPT_0x9
; 0000 00A7 buzzer2(); //buzzer on
; 0000 00A8 delay_ms(3000);
; 0000 00A9 buzzer_off(); //buzzer off
; 0000 00AA brk = 1; //리셋문 반복 방지
; 0000 00AB tri = 0; //while문 탈출
; 0000 00AC }
_0x24:
; 0000 00AD }
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 if(keyMatrix(matrix) == 1)  { //키매트릭스 함수의 리턴값이 1일때
_0x22:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x25
; 0000 00B1 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x26
; 0000 00B2 PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0xA
; 0000 00B3 PORTC = green_led[1];
; 0000 00B4 lcd_gotoxy(0, 0);
; 0000 00B5 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00B6 lcd_puts("1 SW is not bomb"); //해당 스위치 위치 출력
	__POINTW2MN _0x1B,33
	RCALL _lcd_puts
; 0000 00B7 //lcd_gotoxy(1, 1);
; 0000 00B8 //lcd_puts(" "); //lcd에서 1을 지움
; 0000 00B9 }
; 0000 00BA else {
	RJMP _0x27
_0x26:
; 0000 00BB PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0xC
; 0000 00BC PORTC = red_led[1];
; 0000 00BD lcd_clear();
; 0000 00BE lcd_gotoxy(0, 0);
; 0000 00BF delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00C0 lcd_puts("1 SW is bomb");
	__POINTW2MN _0x1B,50
	RCALL _lcd_puts
; 0000 00C1 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 00C2 lcd_puts("BOMB");
	__POINTW2MN _0x1B,63
	RCALL SUBOPT_0x9
; 0000 00C3 buzzer2();
; 0000 00C4 delay_ms(3000);
; 0000 00C5 buzzer_off();
; 0000 00C6 brk = 1;
; 0000 00C7 tri = 0;
; 0000 00C8 }
_0x27:
; 0000 00C9 }
; 0000 00CA 
; 0000 00CB 
; 0000 00CC if(keyMatrix(matrix) == 2)  {
_0x25:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
; 0000 00CD if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x29
; 0000 00CE PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0xD
; 0000 00CF PORTC = green_led[2];
; 0000 00D0 lcd_gotoxy(0, 0);
; 0000 00D1 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00D2 lcd_puts("2 SW is not bomb");
	__POINTW2MN _0x1B,68
	RCALL _lcd_puts
; 0000 00D3 //lcd_gotoxy(2, 1);
; 0000 00D4 //lcd_puts(" ");
; 0000 00D5 }
; 0000 00D6 else {
	RJMP _0x2A
_0x29:
; 0000 00D7 PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0xE
; 0000 00D8 PORTC = red_led[2];
; 0000 00D9 lcd_clear();
; 0000 00DA lcd_gotoxy(0, 0);
; 0000 00DB delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00DC lcd_puts("2 SW is bomb");
	__POINTW2MN _0x1B,85
	RCALL _lcd_puts
; 0000 00DD lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 00DE lcd_puts("BOMB");
	__POINTW2MN _0x1B,98
	RCALL SUBOPT_0x9
; 0000 00DF buzzer2();
; 0000 00E0 delay_ms(3000);
; 0000 00E1 buzzer_off();
; 0000 00E2 brk = 1;
; 0000 00E3 tri = 0;
; 0000 00E4 }
_0x2A:
; 0000 00E5 }
; 0000 00E6 
; 0000 00E7 if(keyMatrix(matrix) == 3)  {
_0x28:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00E8 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x2C
; 0000 00E9 PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0xF
; 0000 00EA PORTC = green_led[3];
; 0000 00EB lcd_gotoxy(0, 0);
; 0000 00EC delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00ED lcd_puts("3 SW is not bomb");
	__POINTW2MN _0x1B,103
	RCALL _lcd_puts
; 0000 00EE //lcd_gotoxy(3, 1);
; 0000 00EF //lcd_puts(" ");
; 0000 00F0 }
; 0000 00F1 else {
	RJMP _0x2D
_0x2C:
; 0000 00F2 PORTB = vertical[0];
	LDS  R30,_vertical
	RCALL SUBOPT_0x10
; 0000 00F3 PORTC = red_led[3];
; 0000 00F4 lcd_clear();
; 0000 00F5 lcd_gotoxy(0, 0);
; 0000 00F6 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 00F7 lcd_puts("3 SW is bomb");
	__POINTW2MN _0x1B,120
	RCALL _lcd_puts
; 0000 00F8 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 00F9 lcd_puts("BOMB");
	__POINTW2MN _0x1B,133
	RCALL SUBOPT_0x9
; 0000 00FA buzzer2();
; 0000 00FB delay_ms(3000);
; 0000 00FC buzzer_off();
; 0000 00FD brk = 1;
; 0000 00FE tri = 0;
; 0000 00FF }
_0x2D:
; 0000 0100 }
; 0000 0101 
; 0000 0102 if(keyMatrix(matrix) == 4)  {
_0x2B:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2E
; 0000 0103 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x2F
; 0000 0104 PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0x5
; 0000 0105 PORTC = green_led[0];
; 0000 0106 lcd_gotoxy(0, 0);
; 0000 0107 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0108 lcd_puts("4 SW is not bomb");
	__POINTW2MN _0x1B,138
	RCALL _lcd_puts
; 0000 0109 //lcd_gotoxy(4, 1);
; 0000 010A //lcd_puts(" ");
; 0000 010B }
; 0000 010C else {
	RJMP _0x30
_0x2F:
; 0000 010D PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0x7
; 0000 010E PORTC = red_led[0];
; 0000 010F lcd_clear();
; 0000 0110 lcd_gotoxy(0, 0);
	RCALL SUBOPT_0x3
; 0000 0111 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0112 lcd_puts("4 SW is bomb");
	__POINTW2MN _0x1B,155
	RCALL _lcd_puts
; 0000 0113 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 0114 lcd_puts("BOMB");
	__POINTW2MN _0x1B,168
	RCALL SUBOPT_0x9
; 0000 0115 buzzer2();
; 0000 0116 delay_ms(3000);
; 0000 0117 buzzer_off();
; 0000 0118 brk = 1;
; 0000 0119 tri = 0;
; 0000 011A }
_0x30:
; 0000 011B }
; 0000 011C 
; 0000 011D if(keyMatrix(matrix) == 5)  {
_0x2E:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x31
; 0000 011E if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x32
; 0000 011F PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0xA
; 0000 0120 PORTC = green_led[1];
; 0000 0121 lcd_gotoxy(0, 0);
; 0000 0122 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0123 lcd_puts("5 SW is not bomb");
	__POINTW2MN _0x1B,173
	RCALL _lcd_puts
; 0000 0124 //lcd_gotoxy(5, 1);
; 0000 0125 //lcd_puts(" ");
; 0000 0126 }
; 0000 0127 else {
	RJMP _0x33
_0x32:
; 0000 0128 PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0xC
; 0000 0129 PORTC = red_led[1];
; 0000 012A lcd_clear();
; 0000 012B lcd_gotoxy(0, 0);
; 0000 012C delay_us(500);
	RCALL SUBOPT_0xB
; 0000 012D lcd_puts("5 SW is bomb");
	__POINTW2MN _0x1B,190
	RCALL _lcd_puts
; 0000 012E lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 012F lcd_puts("BOMB");
	__POINTW2MN _0x1B,203
	RCALL SUBOPT_0x9
; 0000 0130 buzzer2();
; 0000 0131 delay_ms(3000);
; 0000 0132 buzzer_off();
; 0000 0133 brk = 1;
; 0000 0134 tri = 0;
; 0000 0135 }
_0x33:
; 0000 0136 }
; 0000 0137 
; 0000 0138 if(keyMatrix(matrix) == 6)  {
_0x31:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x34
; 0000 0139 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x35
; 0000 013A PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0xD
; 0000 013B PORTC = green_led[2];
; 0000 013C lcd_gotoxy(0, 0);
; 0000 013D delay_us(500);
	RCALL SUBOPT_0xB
; 0000 013E lcd_puts("6 SW is not bomb");
	__POINTW2MN _0x1B,208
	RCALL _lcd_puts
; 0000 013F //lcd_gotoxy(6, 1);
; 0000 0140 //lcd_puts(" ");
; 0000 0141 }
; 0000 0142 else {
	RJMP _0x36
_0x35:
; 0000 0143 PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0xE
; 0000 0144 PORTC = red_led[2];
; 0000 0145 lcd_clear();
; 0000 0146 lcd_gotoxy(0, 0);
; 0000 0147 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0148 lcd_puts("6 SW is bomb");
	__POINTW2MN _0x1B,225
	RCALL _lcd_puts
; 0000 0149 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 014A lcd_puts("BOMB");
	__POINTW2MN _0x1B,238
	RCALL SUBOPT_0x9
; 0000 014B buzzer2();
; 0000 014C delay_ms(3000);
; 0000 014D buzzer_off();
; 0000 014E brk = 1;
; 0000 014F tri = 0;
; 0000 0150 }
_0x36:
; 0000 0151 }
; 0000 0152 
; 0000 0153 if(keyMatrix(matrix) == 7)  {
_0x34:
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x37
; 0000 0154 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x38
; 0000 0155 PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0xF
; 0000 0156 PORTC = green_led[3];
; 0000 0157 lcd_gotoxy(0, 0);
; 0000 0158 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0159 lcd_puts("7 SW is not bomb");
	__POINTW2MN _0x1B,243
	RCALL _lcd_puts
; 0000 015A //lcd_gotoxy(7, 1);
; 0000 015B //lcd_puts(" ");
; 0000 015C }
; 0000 015D else {
	RJMP _0x39
_0x38:
; 0000 015E PORTB = vertical[1];
	__GETB1MN _vertical,1
	RCALL SUBOPT_0x10
; 0000 015F PORTC = red_led[3];
; 0000 0160 lcd_clear();
; 0000 0161 lcd_gotoxy(0, 0);
; 0000 0162 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0163 lcd_puts("7 SW is bomb");
	__POINTW2MN _0x1B,260
	RCALL _lcd_puts
; 0000 0164 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 0165 lcd_puts("BOMB");
	__POINTW2MN _0x1B,273
	RCALL SUBOPT_0x9
; 0000 0166 buzzer2();
; 0000 0167 delay_ms(3000);
; 0000 0168 buzzer_off();
; 0000 0169 brk = 1;
; 0000 016A tri = 0;
; 0000 016B }
_0x39:
; 0000 016C }
; 0000 016D 
; 0000 016E if(mode == 16) { //모드 16일때만 8번~15번 스위치를 누를 수 있게 설정
_0x37:
	RCALL SUBOPT_0x11
	BRNE _0x3A
; 0000 016F if(keyMatrix(matrix) == 8)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3B
; 0000 0170 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x3C
; 0000 0171 PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0x5
; 0000 0172 PORTC = green_led[0];
; 0000 0173 lcd_gotoxy(0, 0);
; 0000 0174 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0175 lcd_puts("8 SW is not bomb");
	__POINTW2MN _0x1B,278
	RCALL _lcd_puts
; 0000 0176 //lcd_gotoxy(8, 1);
; 0000 0177 //lcd_puts(" ");
; 0000 0178 }
; 0000 0179 else {
	RJMP _0x3D
_0x3C:
; 0000 017A PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0x7
; 0000 017B PORTC = red_led[0];
; 0000 017C lcd_clear();
; 0000 017D lcd_gotoxy(0, 0);
	RCALL SUBOPT_0x3
; 0000 017E delay_us(500);
	RCALL SUBOPT_0xB
; 0000 017F lcd_puts("8 SW is bomb");
	__POINTW2MN _0x1B,295
	RCALL _lcd_puts
; 0000 0180 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 0181 lcd_puts("BOMB");
	__POINTW2MN _0x1B,308
	RCALL SUBOPT_0x9
; 0000 0182 buzzer2();
; 0000 0183 delay_ms(3000);
; 0000 0184 buzzer_off();
; 0000 0185 brk = 1;
; 0000 0186 tri = 0;
; 0000 0187 }
_0x3D:
; 0000 0188 }
; 0000 0189 }
_0x3B:
; 0000 018A 
; 0000 018B 
; 0000 018C if(mode == 16) {
_0x3A:
	RCALL SUBOPT_0x11
	BRNE _0x3E
; 0000 018D if(keyMatrix(matrix) == 9)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x3F
; 0000 018E if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x40
; 0000 018F PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0xA
; 0000 0190 PORTC = green_led[1];
; 0000 0191 lcd_gotoxy(0, 0);
; 0000 0192 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0193 lcd_puts("9 SW is not bomb");
	__POINTW2MN _0x1B,313
	RCALL _lcd_puts
; 0000 0194 //lcd_gotoxy(9, 1);
; 0000 0195 //lcd_puts(" ");
; 0000 0196 }
; 0000 0197 else {
	RJMP _0x41
_0x40:
; 0000 0198 PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0xC
; 0000 0199 PORTC = red_led[1];
; 0000 019A lcd_clear();
; 0000 019B lcd_gotoxy(0, 0);
; 0000 019C delay_us(500);
	RCALL SUBOPT_0xB
; 0000 019D lcd_puts("9 SW is bomb");
	__POINTW2MN _0x1B,330
	RCALL _lcd_puts
; 0000 019E lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 019F lcd_puts("BOMB");
	__POINTW2MN _0x1B,343
	RCALL SUBOPT_0x9
; 0000 01A0 buzzer2();
; 0000 01A1 delay_ms(3000);
; 0000 01A2 buzzer_off();
; 0000 01A3 brk = 1;
; 0000 01A4 tri = 0;
; 0000 01A5 }
_0x41:
; 0000 01A6 }
; 0000 01A7 }
_0x3F:
; 0000 01A8 
; 0000 01A9 
; 0000 01AA if(mode == 16) {
_0x3E:
	RCALL SUBOPT_0x11
	BRNE _0x42
; 0000 01AB if(keyMatrix(matrix) == 10)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x43
; 0000 01AC if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x44
; 0000 01AD PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0xD
; 0000 01AE PORTC = green_led[2];
; 0000 01AF lcd_gotoxy(0, 0);
; 0000 01B0 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01B1 lcd_puts("A SW is not bomb");
	__POINTW2MN _0x1B,348
	RCALL _lcd_puts
; 0000 01B2 //lcd_gotoxy(10, 1);
; 0000 01B3 //lcd_puts(" ");
; 0000 01B4 }
; 0000 01B5 else {
	RJMP _0x45
_0x44:
; 0000 01B6 PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0xE
; 0000 01B7 PORTC = red_led[2];
; 0000 01B8 lcd_clear();
; 0000 01B9 lcd_gotoxy(0, 0);
; 0000 01BA delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01BB lcd_puts("A SW is bomb");
	__POINTW2MN _0x1B,365
	RCALL _lcd_puts
; 0000 01BC lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 01BD lcd_puts("BOMB");
	__POINTW2MN _0x1B,378
	RCALL SUBOPT_0x9
; 0000 01BE buzzer2();
; 0000 01BF delay_ms(3000);
; 0000 01C0 buzzer_off();
; 0000 01C1 brk = 1;
; 0000 01C2 tri = 0;
; 0000 01C3 }
_0x45:
; 0000 01C4 }
; 0000 01C5 }
_0x43:
; 0000 01C6 
; 0000 01C7 if(mode == 16) {
_0x42:
	RCALL SUBOPT_0x11
	BRNE _0x46
; 0000 01C8 if(keyMatrix(matrix) == 11)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x47
; 0000 01C9 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x48
; 0000 01CA PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0xF
; 0000 01CB PORTC = green_led[3];
; 0000 01CC lcd_gotoxy(0, 0);
; 0000 01CD delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01CE lcd_puts("B SW is not bomb");
	__POINTW2MN _0x1B,383
	RCALL _lcd_puts
; 0000 01CF //lcd_gotoxy(11, 1);
; 0000 01D0 //lcd_puts(" ");
; 0000 01D1 }
; 0000 01D2 else {
	RJMP _0x49
_0x48:
; 0000 01D3 PORTB = vertical[2];
	__GETB1MN _vertical,2
	RCALL SUBOPT_0x10
; 0000 01D4 PORTC = red_led[3];
; 0000 01D5 lcd_clear();
; 0000 01D6 lcd_gotoxy(0, 0);
; 0000 01D7 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01D8 lcd_puts("B SW is bomb");
	__POINTW2MN _0x1B,400
	RCALL _lcd_puts
; 0000 01D9 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 01DA lcd_puts("BOMB");
	__POINTW2MN _0x1B,413
	RCALL SUBOPT_0x9
; 0000 01DB buzzer2();
; 0000 01DC delay_ms(3000);
; 0000 01DD buzzer_off();
; 0000 01DE brk = 1;
; 0000 01DF tri = 0;
; 0000 01E0 }
_0x49:
; 0000 01E1 }
; 0000 01E2 }
_0x47:
; 0000 01E3 
; 0000 01E4 if(mode == 16) {
_0x46:
	RCALL SUBOPT_0x11
	BRNE _0x4A
; 0000 01E5 if(keyMatrix(matrix) == 12)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4B
; 0000 01E6 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x4C
; 0000 01E7 PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0x5
; 0000 01E8 PORTC = green_led[0];
; 0000 01E9 lcd_gotoxy(0, 0);
; 0000 01EA delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01EB lcd_puts("C SW is not bomb");
	__POINTW2MN _0x1B,418
	RCALL _lcd_puts
; 0000 01EC //lcd_gotoxy(12, 1);
; 0000 01ED //lcd_puts(" ");
; 0000 01EE }
; 0000 01EF else {
	RJMP _0x4D
_0x4C:
; 0000 01F0 PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0x7
; 0000 01F1 PORTC = red_led[0];
; 0000 01F2 lcd_clear();
; 0000 01F3 lcd_gotoxy(0, 0);
	RCALL SUBOPT_0x3
; 0000 01F4 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 01F5 lcd_puts("C SW is bomb");
	__POINTW2MN _0x1B,435
	RCALL _lcd_puts
; 0000 01F6 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 01F7 lcd_puts("BOMB");
	__POINTW2MN _0x1B,448
	RCALL SUBOPT_0x9
; 0000 01F8 buzzer2();
; 0000 01F9 delay_ms(3000);
; 0000 01FA buzzer_off();
; 0000 01FB brk = 1;
; 0000 01FC tri = 0;
; 0000 01FD }
_0x4D:
; 0000 01FE }
; 0000 01FF }
_0x4B:
; 0000 0200 
; 0000 0201 if(mode == 16) {
_0x4A:
	RCALL SUBOPT_0x11
	BRNE _0x4E
; 0000 0202 if(keyMatrix(matrix) == 13)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0203 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x50
; 0000 0204 PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0xA
; 0000 0205 PORTC = green_led[1];
; 0000 0206 lcd_gotoxy(0, 0);
; 0000 0207 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0208 lcd_puts("D SW is not bomb");
	__POINTW2MN _0x1B,453
	RCALL _lcd_puts
; 0000 0209 //lcd_gotoxy(13, 1);
; 0000 020A //lcd_puts(" ");
; 0000 020B }
; 0000 020C else {
	RJMP _0x51
_0x50:
; 0000 020D PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0xC
; 0000 020E PORTC = red_led[1];
; 0000 020F lcd_clear();
; 0000 0210 lcd_gotoxy(0, 0);
; 0000 0211 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0212 lcd_puts("D SW is bomb");
	__POINTW2MN _0x1B,470
	RCALL _lcd_puts
; 0000 0213 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 0214 lcd_puts("BOMB");
	__POINTW2MN _0x1B,483
	RCALL SUBOPT_0x9
; 0000 0215 buzzer2();
; 0000 0216 delay_ms(3000);
; 0000 0217 buzzer_off();
; 0000 0218 brk = 1;
; 0000 0219 tri = 0;
; 0000 021A }
_0x51:
; 0000 021B }
; 0000 021C }
_0x4F:
; 0000 021D 
; 0000 021E if(mode == 16) {
_0x4E:
	RCALL SUBOPT_0x11
	BRNE _0x52
; 0000 021F if(keyMatrix(matrix) == 14)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x53
; 0000 0220 if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x54
; 0000 0221 PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0xD
; 0000 0222 PORTC = green_led[2];
; 0000 0223 lcd_gotoxy(0, 0);
; 0000 0224 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0225 lcd_puts("E SW is not bomb");
	__POINTW2MN _0x1B,488
	RCALL _lcd_puts
; 0000 0226 //lcd_gotoxy(14, 1);
; 0000 0227 //lcd_puts(" ");
; 0000 0228 }
; 0000 0229 else {
	RJMP _0x55
_0x54:
; 0000 022A PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0xE
; 0000 022B PORTC = red_led[2];
; 0000 022C lcd_clear();
; 0000 022D lcd_gotoxy(0, 0);
; 0000 022E delay_us(500);
	RCALL SUBOPT_0xB
; 0000 022F lcd_puts("E SW is bomb");
	__POINTW2MN _0x1B,505
	RCALL _lcd_puts
; 0000 0230 lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 0231 lcd_puts("BOMB");
	__POINTW2MN _0x1B,518
	RCALL SUBOPT_0x9
; 0000 0232 buzzer2();
; 0000 0233 delay_ms(3000);
; 0000 0234 buzzer_off();
; 0000 0235 brk = 1;
; 0000 0236 tri = 0;
; 0000 0237 }
_0x55:
; 0000 0238 }
; 0000 0239 }
_0x53:
; 0000 023A 
; 0000 023B if(mode == 16) {
_0x52:
	RCALL SUBOPT_0x11
	BRNE _0x56
; 0000 023C if(keyMatrix(matrix) == 15)  {
	MOV  R26,R21
	RCALL _keyMatrix
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x57
; 0000 023D if(keyMatrix(matrix) != num) {
	RCALL SUBOPT_0x4
	BREQ _0x58
; 0000 023E PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0xF
; 0000 023F PORTC = green_led[3];
; 0000 0240 lcd_gotoxy(0, 0);
; 0000 0241 delay_us(500);
	RCALL SUBOPT_0xB
; 0000 0242 lcd_puts("F SW is not bomb");
	__POINTW2MN _0x1B,523
	RCALL _lcd_puts
; 0000 0243 //lcd_gotoxy(15, 1);
; 0000 0244 //lcd_puts(" ");
; 0000 0245 }
; 0000 0246 else {
	RJMP _0x59
_0x58:
; 0000 0247 PORTB = vertical[3];
	__GETB1MN _vertical,3
	RCALL SUBOPT_0x10
; 0000 0248 PORTC = red_led[3];
; 0000 0249 lcd_clear();
; 0000 024A lcd_gotoxy(0, 0);
; 0000 024B delay_us(500);
	RCALL SUBOPT_0xB
; 0000 024C lcd_puts("F SW is bomb");
	__POINTW2MN _0x1B,540
	RCALL _lcd_puts
; 0000 024D lcd_gotoxy(6, 1);
	RCALL SUBOPT_0x8
; 0000 024E lcd_puts("BOMB");
	__POINTW2MN _0x1B,553
	RCALL SUBOPT_0x9
; 0000 024F buzzer2();
; 0000 0250 delay_ms(3000);
; 0000 0251 buzzer_off();
; 0000 0252 brk = 1;
; 0000 0253 tri = 0;
; 0000 0254 }
_0x59:
; 0000 0255 }
; 0000 0256 }
_0x57:
; 0000 0257 
; 0000 0258 
; 0000 0259 delay_ms(1); //동시입력 방지
_0x56:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
; 0000 025A keyout = (keyout<<1) + 0x01;
	MOVW R30,R16
	LSL  R30
	ROL  R31
	ADIW R30,1
	MOVW R16,R30
; 0000 025B //스캔데이터 갱신 1110 -> 1101 -> 1011 -> 0111
; 0000 025C }
	__ADDWRN 18,19,1
	RJMP _0x20
_0x21:
; 0000 025D }
	RJMP _0x1C
_0x1E:
; 0000 025E }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x1B:
	.BYTE 0x22E
;void reset(void)
; 0000 0261 {

	.CSEG
_reset:
; .FSTART _reset
; 0000 0262 PORTB = 0x00;   PORTC = 0xff;   PORTG = 0xff;   PORTE = 0xff; PORTE = 0x00; DDRE = 0x00; DDRF = 0x00;//led, 부저 초기화
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x15,R30
	RCALL SUBOPT_0x12
	OUT  0x3,R30
	RCALL SUBOPT_0x13
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0263 num = 0; //난수 초기화
	CLR  R4
	CLR  R5
; 0000 0264 tri = 0; //tri 초기화
	CLR  R6
	CLR  R7
; 0000 0265 buzzer_off();
	RCALL _buzzer_off
; 0000 0266 lcd_init(16);   //lcd 16 x 2
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0267 lcd_clear();
	RCALL _lcd_clear
; 0000 0268 lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0269 lcd_puts("MR TONG");
	__POINTW2MN _0x5A,0
	RCALL SUBOPT_0x6
; 0000 026A delay_us(500);
; 0000 026B 
; 0000 026C lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 026D lcd_puts("PUSH CONTINUE");
	__POINTW2MN _0x5A,8
	RCALL _lcd_puts
; 0000 026E delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 026F while(PINF != 0xfb) continue; //start스위치를 누르면 진행
_0x5B:
	IN   R30,0x0
	CPI  R30,LOW(0xFB)
	BRNE _0x5B
; 0000 0270 lcd_clear();
	RCALL _lcd_clear
; 0000 0271 lcd_gotoxy(2, 0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0272 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0273 lcd_puts("SELECT  MODE"); //처음 상태 표시
	__POINTW2MN _0x5A,22
	RCALL _lcd_puts
; 0000 0274 lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0275 lcd_putsf("    16 |  8"); //16/8모드 선택
	__POINTW2FN _0x0,563
	RCALL _lcd_putsf
; 0000 0276 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0277 mode = 16;      //기본 상태 모드 16
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	MOVW R8,R30
; 0000 0278 while((PINF != 0xfb)) modee(); //start 스위치를 누를때까지 모드를 정하다가 start가 되는 순간 mode 모드 탈출 하고 동시에 당첨 번호 정함
_0x5E:
	IN   R30,0x0
	CPI  R30,LOW(0xFB)
	BREQ _0x60
	RCALL _modee
	RJMP _0x5E
_0x60:
; 0000 0279 lcd_clear();
	RCALL _lcd_clear
; 0000 027A lcd_gotoxy(3,1);
	RCALL SUBOPT_0x2
; 0000 027B lcd_putsf("GAME READY");
	__POINTW2FN _0x0,575
	RCALL _lcd_putsf
; 0000 027C lcd_gotoxy(0,0);
	RCALL SUBOPT_0x3
; 0000 027D switch(PINE & 0xF0){ //당첨 번호(num)
	IN   R30,0x1
	ANDI R30,LOW(0xF0)
; 0000 027E case 0x00: num = 0; break;
	CPI  R30,0
	BRNE _0x64
	CLR  R4
	CLR  R5
	RJMP _0x63
; 0000 027F case 0x10: num = 1; break;
_0x64:
	CPI  R30,LOW(0x10)
	BRNE _0x65
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x91
; 0000 0280 case 0x20: num = 2; break;
_0x65:
	CPI  R30,LOW(0x20)
	BRNE _0x66
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x91
; 0000 0281 case 0x30: num = 3; break;
_0x66:
	CPI  R30,LOW(0x30)
	BRNE _0x67
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x91
; 0000 0282 case 0x40: num = 4; break;
_0x67:
	CPI  R30,LOW(0x40)
	BRNE _0x68
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x91
; 0000 0283 case 0x50: num = 5; break;
_0x68:
	CPI  R30,LOW(0x50)
	BRNE _0x69
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x91
; 0000 0284 case 0x60: num = 6; break;
_0x69:
	CPI  R30,LOW(0x60)
	BRNE _0x6A
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x91
; 0000 0285 case 0x70: num = 7; break;
_0x6A:
	CPI  R30,LOW(0x70)
	BRNE _0x6B
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x91
; 0000 0286 case 0x80: num = 8; break;
_0x6B:
	CPI  R30,LOW(0x80)
	BRNE _0x6C
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x91
; 0000 0287 case 0x90: num = 9; break;
_0x6C:
	CPI  R30,LOW(0x90)
	BRNE _0x6D
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x91
; 0000 0288 case 0xA0: num = 10;break;
_0x6D:
	CPI  R30,LOW(0xA0)
	BRNE _0x6E
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x91
; 0000 0289 case 0xB0: num = 11;break;
_0x6E:
	CPI  R30,LOW(0xB0)
	BRNE _0x6F
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RJMP _0x91
; 0000 028A case 0xC0: num = 12;break;
_0x6F:
	CPI  R30,LOW(0xC0)
	BRNE _0x70
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP _0x91
; 0000 028B case 0xD0: num = 13;break;
_0x70:
	CPI  R30,LOW(0xD0)
	BRNE _0x71
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP _0x91
; 0000 028C case 0xE0: num = 14;break;
_0x71:
	CPI  R30,LOW(0xE0)
	BRNE _0x72
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RJMP _0x91
; 0000 028D case 0xF0: num = 15;break;
_0x72:
	CPI  R30,LOW(0xF0)
	BRNE _0x63
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
_0x91:
	MOVW R4,R30
; 0000 028E }
_0x63:
; 0000 028F if(mode == 8 && num >= 8) //8모드일때 난수값 설정
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x75
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 0290 num = num - 8;  //8모드 일때, 당첨숫자는 0번 ~ 7번이여서 8번 ~ 16번은 8을 빼서 0~7번으로 만든다
	MOVW R30,R4
	SBIW R30,8
	MOVW R4,R30
; 0000 0291 
; 0000 0292 DDRE = 0xff;
_0x74:
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 0293 
; 0000 0294 switch(num){ //난수값을 led로 표시
	MOVW R30,R4
; 0000 0295 case 0: PORTE = 0x00;   break;
	SBIW R30,0
	BRNE _0x7A
	LDI  R30,LOW(0)
	RJMP _0x92
; 0000 0296 case 1: PORTE = 0x10;   break;
_0x7A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7B
	LDI  R30,LOW(16)
	RJMP _0x92
; 0000 0297 case 2: PORTE = 0x20;   break;
_0x7B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7C
	LDI  R30,LOW(32)
	RJMP _0x92
; 0000 0298 case 3: PORTE = 0x30;   break;
_0x7C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7D
	LDI  R30,LOW(48)
	RJMP _0x92
; 0000 0299 case 4: PORTE = 0x40;   break;
_0x7D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x7E
	LDI  R30,LOW(64)
	RJMP _0x92
; 0000 029A case 5: PORTE = 0x50;   break;
_0x7E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7F
	LDI  R30,LOW(80)
	RJMP _0x92
; 0000 029B case 6: PORTE = 0x60;   break;
_0x7F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x80
	LDI  R30,LOW(96)
	RJMP _0x92
; 0000 029C case 7: PORTE = 0x70;   break;
_0x80:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x81
	LDI  R30,LOW(112)
	RJMP _0x92
; 0000 029D case 8: PORTE = 0x80;   break;
_0x81:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x82
	LDI  R30,LOW(128)
	RJMP _0x92
; 0000 029E case 9: PORTE = 0x90;   break;
_0x82:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x83
	LDI  R30,LOW(144)
	RJMP _0x92
; 0000 029F case 10: PORTE = 0xA0;  break;
_0x83:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x84
	LDI  R30,LOW(160)
	RJMP _0x92
; 0000 02A0 case 11: PORTE = 0xB0;  break;
_0x84:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x85
	LDI  R30,LOW(176)
	RJMP _0x92
; 0000 02A1 case 12: PORTE = 0xC0;  break;
_0x85:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x86
	LDI  R30,LOW(192)
	RJMP _0x92
; 0000 02A2 case 13: PORTE = 0xD0;  break;
_0x86:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x87
	LDI  R30,LOW(208)
	RJMP _0x92
; 0000 02A3 case 14: PORTE = 0xE0;  break;
_0x87:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x88
	LDI  R30,LOW(224)
	RJMP _0x92
; 0000 02A4 case 15: PORTE = 0xF0;  break;
_0x88:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x79
	LDI  R30,LOW(240)
_0x92:
	OUT  0x3,R30
; 0000 02A5 }
_0x79:
; 0000 02A6 
; 0000 02A7 
; 0000 02A8 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 02A9 
; 0000 02AA brk = 0; //초기값 갱신
	CLR  R10
	CLR  R11
; 0000 02AB 
; 0000 02AC while(brk == 0) {
_0x8A:
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x8C
; 0000 02AD buzzer_off(); // 게임 실행 후 buzzer off
	RCALL _buzzer_off
; 0000 02AE tri = 1; // 0->1로 갱신
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 02AF manager(); //시작부분으로 돌아감
	RCALL _manager
; 0000 02B0 }
	RJMP _0x8A
_0x8C:
; 0000 02B1 }
	RET
; .FEND

	.DSEG
_0x5A:
	.BYTE 0x23
;void main(void)
; 0000 02B4 {

	.CSEG
_main:
; .FSTART _main
; 0000 02B5 PORTA = 0xff; DDRA = 0xff; //LCD
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	OUT  0x1A,R30
; 0000 02B6 PORTB = 0x00; DDRB = 0xff; //LED 4개 가로 1이면 on
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 02B7 PORTC = 0xff; DDRC = 0xff; //LED 8개 세로 0이면 on
	OUT  0x15,R30
	OUT  0x14,R30
; 0000 02B8 PORTD = 0x00; DDRD = 0x0f; //키매트릭스
	LDI  R30,LOW(0)
	OUT  0x12,R30
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 02B9 PORTE = 0x00; DDRE = 0x00; //랜덤 입력(4~7)
	RCALL SUBOPT_0x13
; 0000 02BA PORTF = 0xff; DDRF = 0x00; //기타 입력(16(0), 8(1), ST(2), RST(3))
	LDI  R30,LOW(255)
	STS  98,R30
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 02BB PORTG = 0xff; DDRG = 0xff; //오디오
	RCALL SUBOPT_0x12
	STS  100,R30
; 0000 02BC 
; 0000 02BD while(1)  reset();
_0x8D:
	RCALL _reset
	RJMP _0x8D
; 0000 02BE }
_0x90:
	RJMP _0x90
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R12
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R12
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R13
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x200000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_vertical:
	.BYTE 0x4
_red_led:
	.BYTE 0x4
_green_led:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	MOVW R8,R30
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	RCALL _lcd_putsf
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:97 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x4:
	MOV  R26,R21
	RCALL _keyMatrix
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	OUT  0x18,R30
	LDS  R30,_green_led
	OUT  0x15,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL _lcd_puts
	__DELAY_USW 2000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	OUT  0x18,R30
	LDS  R30,_red_led
	OUT  0x15,R30
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:148 WORDS
SUBOPT_0x9:
	RCALL _lcd_puts
	RCALL _buzzer2
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _delay_ms
	RCALL _buzzer_off
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	OUT  0x18,R30
	__GETB1MN _green_led,1
	OUT  0x15,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0xB:
	__DELAY_USW 2000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	OUT  0x18,R30
	__GETB1MN _red_led,1
	OUT  0x15,R30
	RCALL _lcd_clear
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	OUT  0x18,R30
	__GETB1MN _green_led,2
	OUT  0x15,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE:
	OUT  0x18,R30
	__GETB1MN _red_led,2
	OUT  0x15,R30
	RCALL _lcd_clear
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xF:
	OUT  0x18,R30
	__GETB1MN _green_led,3
	OUT  0x15,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	OUT  0x18,R30
	__GETB1MN _red_led,3
	OUT  0x15,R30
	RCALL _lcd_clear
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(255)
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	OUT  0x3,R30
	OUT  0x2,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
