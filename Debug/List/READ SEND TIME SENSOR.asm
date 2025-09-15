
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _mode_baudrate=R4
	.DEF _diaChiSlave=R3
	.DEF _length_rx=R6
	.DEF _function_code=R5
	.DEF _address_register1=R8
	.DEF _number_register1=R7
	.DEF _number_byte1=R10
	.DEF _number_status1=R9
	.DEF _CRC16=R11
	.DEF _CRC16_msb=R12
	.DEF _F_rx=R14
	.DEF _timeSetOn1=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

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
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x0,0x1C,0x1,0x2,0x15,0x5,0x19
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _set_time
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : READ SEND TIME SENSOR
;Version : V4.0. chinh  tiep tu v3.1, sua code "khi ket thúc chu trình thì sensor phai dc tác dong 2 lan moi ket thúc"
;Date    : 11-Sep-2025
;Author  : Nguyen Van Anh
;Company : VART
;Comments: PHAN CUNG V2.0. FIX CHAN PIN DE TRANH TRUONG HOP COPY
;update:
;    chinh 5s->2s, 1 INput cho senssor out  , IN2 1->0: lieu vao    IN2  0->1: lieu ra     (chinh o v3.1 roi)
;    time 2 may responte ko bi trung nhau
;    time out bi mat du lieu
;    1 pack data là thoi gian vào, thoi gian ra, thoi gian luu hóa (vào - ra), thoi gian thao tác (ra - vào lan truoc dó  ...
;    cho pack data này co dinh luôn cho den khi có out moi thì moi thay doi 1 lan 4 cái
;    update luu addr vao epprom
;
;file modbus config tren modbus poll: C:\Users\anhhu\Documents\modbus Poll
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;
;1. modbus RTU, baud mac dinh 9600.
;2. dia chi slave hoac ghi all: 0x?? hoac 0x00
;3. thanh ghi modbus bat dau ghi realtime va dia chi slave la thanh ghi so 10(0x0A):
;    vd: Tx:00 10 00 0A 00 0A 14 00 01 00 0F 00 1B 00 1E 00 19 00 05 00 19 00 00 00 00 00 00 66 2B
;
;    trong do:   0x00: addr de ghi all slave
;                0x10: funtion code 0x10 :16 write multiple register
;                0x00 (MSB) 0x0A(LSB): thanh ghi bat dau ghi      (thanh ghi so 10)
;                0x00 (MSB) 0x0A(LSB): so luong thanh ghi duoc dung (10 thanh ghi duoc dung)
;                0x14: so byte data (20 byte data do dung 10 thanh ghi 2byte - 1 word)
;                0x00 0x01: set addr cho slave là 0x01
;                00 0F: 15 gio
;                00 1B: 27 phut
;                00 1E: 30 giay
;                0x00 0x19: ngay 25
;                0x00 0x05: thang 5
;                0x00 0x19: nam 25
;                0x00 0x00: du phong
;                0x00 0x00: du phong
;                0x00 0x00: du phong
;                0x66 0x2B: CRC-16 modbus
;
;4. thanh ghi modbus bat dau doc du lieu may 1 la thanh ghi so 21(0x15):
;    vd: Tx:01 03 00 15 00 14 54 01         (may tinh gui xuong slave)
;    trong dó:   0x01: addr slave
;                0x03: function code read
;                0x00 (MSB) 0x15(LSB): thanh ghi bat dau doc là thanh ghi so 21
;                0x00 (MSB) 0x14(LSB): tong co 20 word data can doc (40 byte)
;                0x54 (MSB) 0x01(LSB): CRC-16 modbus
;        Rx:01 03 00 28 data... CRC          (salve phan hoi)
;
;
;5. thanh ghi modbus bat dau doc du lieu may 2 la thanh ghi so 41(0x29):
;    vd: Tx:01 03 00 29 00 14 94 0D
;    trong dó:   0x01: addr slave
;                0x03: function code read
;                0x00 (MSB) 0x29(LSB): thanh ghi bat dau doc là thanh ghi so 41
;                0x00 (MSB) 0x14(LSB): tong co 20 byte data can doc
;                0x94 (MSB) 0x0D(LSB): CRC-16 modbus
;       Rx:01 03 00 3d data... CRC          (salve phan hoi)
;
;
;
;
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <InitV20.h>

	.CSEG
_Init:
; .FSTART _Init
	LDI  R30,LOW(128)
	STS  97,R30
	LDI  R30,LOW(0)
	STS  97,R30
	LDI  R30,LOW(254)
	OUT  0x4,R30
	LDI  R30,LOW(255)
	OUT  0x5,R30
	LDI  R30,LOW(251)
	OUT  0x7,R30
	LDI  R30,LOW(255)
	OUT  0x8,R30
	LDI  R30,LOW(199)
	OUT  0xA,R30
	LDI  R30,LOW(255)
	OUT  0xB,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	LDI  R30,LOW(3)
	OUT  0x25,R30
	LDI  R30,LOW(83)
	OUT  0x26,R30
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x28,R30
	STS  128,R30
	LDI  R30,LOW(3)
	STS  129,R30
	CALL SUBOPT_0x0
	LDI  R30,LOW(0)
	STS  135,R30
	STS  134,R30
	STS  137,R30
	STS  136,R30
	STS  139,R30
	STS  138,R30
	STS  182,R30
	STS  176,R30
	LDI  R30,LOW(3)
	STS  177,R30
	LDI  R30,LOW(83)
	STS  178,R30
	LDI  R30,LOW(0)
	STS  179,R30
	STS  180,R30
	LDI  R30,LOW(1)
	STS  110,R30
	STS  111,R30
	STS  112,R30
	LDI  R30,LOW(0)
	STS  105,R30
	OUT  0x1D,R30
	STS  104,R30
	STS  192,R30
	LDI  R30,LOW(152)
	STS  193,R30
	LDI  R30,LOW(6)
	STS  194,R30
	LDI  R30,LOW(0)
	STS  197,R30
	LDI  R30,LOW(71)
	STS  196,R30
	LDI  R30,LOW(0)
	STS  188,R30
	sei
	RET
; .FEND
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <i2c.h>
;#include <stdio.h>
;
;#define IN1 PIND.3
;#define IN2 PIND.4
;#define IN3 PIND.5
;#define IN4 PINB.0
;#define SQW PINC.2
;
;#define DE PORTD.2    //EN RS485
;#define RST_RTC PORTC.3
;
;#define ON      1
;#define OFF     0
;
;#define MAY1    1
;#define MAY2    2
;
;#define addr_baudrate        0x011
;#define addr_diaChiSlave     0x012
;
;#define timeSet   20    //20x100ms  //sau timeSetOn ms thì tính là có tin hieu
;
;unsigned char mode_baudrate;
;unsigned char diaChiSlave;
;unsigned char buff_rx[50] = {0};
;unsigned char buff_tx[50] = {0};
;unsigned char length_rx = 0;
;unsigned char function_code = 0;
;unsigned char address_register1 = 0, number_register1 = 0, number_byte1 = 0, number_status1 = 0; //writre dung 0x10 :16  ...
;unsigned int CRC16 = 0;
;unsigned char F_rx = 0;
;unsigned char timeSetOn1 = 0;
;unsigned char timeSetOn2 = 0;
;
;unsigned char demIN2,demIN4;  //dem so lan kich sensor out
;
;bit chuTrinhMay1 = 0;   //kiem tra tinh xac thuc cua 1 chu trinh vao phai co ra, va muon ra phai co vao
;bit chuTrinhMay2 = 0;   //kiem tra tinh xac thuc cua 1 chu trinh vao phai co ra, va muon ra phai co vao
;
;typedef struct {
;    unsigned char second;
;    unsigned char minute;
;    unsigned char hour;
;    unsigned char day;     // 1-7 (DS3231 luu th? trong tu?n)
;    unsigned char date;    // Ngày (1-31)
;    unsigned char month;   // Tháng (1-12)
;    unsigned char year;    // Nam (00-99)
;} RTC_Time;
;
;RTC_Time current;
;RTC_Time realTimeIn1;       //thoi diem lieu vao khuon may 1
;RTC_Time realTimeOut1;      //thoi diem lieu ra khuon may 1
;RTC_Time realTimeOut1_QK;      //thoi diem lieu ra CHU TRINH TRUOC khuon may 1
;RTC_Time realTimeIn2;       //thoi diem lieu vao khuon may 2
;RTC_Time realTimeOut2;      //thoi diem lieu ra khuon may 2
;RTC_Time realTimeOut2_QK;      //thoi diem lieu ra CHU TRINH TRUOC khuon may 2
;RTC_Time timeLuuHoa1;       //thoi gian luu hoa (tu luc vao den luc ra) máy 1
;RTC_Time timeLuuHoa2;       //thoi gian luu hoa (tu luc vao den luc ra) máy 2
;RTC_Time timeThaoTac1;      //thoi gian thao tac (tu luc ra lan truoc den vao lan sau) máy 1
;RTC_Time timeThaoTac2;      //thoi gian thao tac (tu luc ra lan truoc den vao lan sau) máy 2
;
;RTC_Time realTimeInX1;
;RTC_Time realTimeOutX1;
;RTC_Time timeLuuHoaX1;
;RTC_Time timeThaoTacX1;
;
;RTC_Time realTimeInX2;
;RTC_Time realTimeOutX2;
;RTC_Time timeLuuHoaX2;
;RTC_Time timeThaoTacX2;
;
;// Ghi thoi gian mac dinh khi nap code:
;RTC_Time set_time = {0, 28, 01, 2, 21, 5, 25};  // giây, phút, gio, thu, ngày, tháng, nam

	.DSEG
;
;unsigned char bcd_to_dec(unsigned char val) {
; 0000 009E unsigned char bcd_to_dec(unsigned char val) {

	.CSEG
_bcd_to_dec:
; .FSTART _bcd_to_dec
; 0000 009F     return ((val >> 4) * 10 + (val & 0x0F));
	ST   -Y,R26
;	val -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	RJMP _0x20A0002
; 0000 00A0 }
; .FEND
;
;unsigned char dec_to_bcd(unsigned char val) {
; 0000 00A2 unsigned char dec_to_bcd(unsigned char val) {
_dec_to_bcd:
; .FSTART _dec_to_bcd
; 0000 00A3     return ((val / 10) << 4) | (val % 10);
	ST   -Y,R26
;	val -> Y+0
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SWAP R30
	ANDI R30,0xF0
	MOV  R22,R30
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	OR   R30,R22
	RJMP _0x20A0002
; 0000 00A4 }
; .FEND
;
;void set_ds3231_datetime(RTC_Time *t) {
; 0000 00A6 void set_ds3231_datetime(RTC_Time *t) {
_set_ds3231_datetime:
; .FSTART _set_ds3231_datetime
; 0000 00A7     i2c_start();
	CALL SUBOPT_0x1
;	*t -> Y+0
; 0000 00A8     i2c_write(0xD0);  // DS3231 I2C address + Write
; 0000 00A9     i2c_write(0x00);  // Start at register 0 (seconds)
; 0000 00AA 
; 0000 00AB     i2c_write(dec_to_bcd(t->second));
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	CALL SUBOPT_0x2
; 0000 00AC     i2c_write(dec_to_bcd(t->minute));
	LDD  R26,Z+1
	CALL SUBOPT_0x2
; 0000 00AD     i2c_write(dec_to_bcd(t->hour));
	LDD  R26,Z+2
	CALL SUBOPT_0x2
; 0000 00AE     i2c_write(dec_to_bcd(t->day));
	LDD  R26,Z+3
	CALL SUBOPT_0x2
; 0000 00AF     i2c_write(dec_to_bcd(t->date));
	LDD  R26,Z+4
	CALL SUBOPT_0x2
; 0000 00B0     i2c_write(dec_to_bcd(t->month));
	LDD  R26,Z+5
	CALL SUBOPT_0x2
; 0000 00B1     i2c_write(dec_to_bcd(t->year));
	LDD  R26,Z+6
	RCALL _dec_to_bcd
	MOV  R26,R30
	CALL _i2c_write
; 0000 00B2 
; 0000 00B3     i2c_stop();
	CALL _i2c_stop
; 0000 00B4 }
	RJMP _0x20A0001
; .FEND
;
;void read_ds3231_datetime(RTC_Time *t) {
; 0000 00B6 void read_ds3231_datetime(RTC_Time *t) {
_read_ds3231_datetime:
; .FSTART _read_ds3231_datetime
; 0000 00B7     i2c_start();
	CALL SUBOPT_0x1
;	*t -> Y+0
; 0000 00B8     i2c_write(0xD0);  // DS3231 I2C address + Write
; 0000 00B9     i2c_write(0x00);  // Start at register 0 (seconds)
; 0000 00BA     i2c_start();
	CALL _i2c_start
; 0000 00BB     i2c_write(0xD1);  // DS3231 I2C address + Read
	LDI  R26,LOW(209)
	CALL _i2c_write
; 0000 00BC 
; 0000 00BD     t->second = bcd_to_dec(i2c_read(1));
	CALL SUBOPT_0x3
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
; 0000 00BE     t->minute = bcd_to_dec(i2c_read(1));
	CALL SUBOPT_0x3
	__PUTB1SNS 0,1
; 0000 00BF     t->hour   = bcd_to_dec(i2c_read(1));
	CALL SUBOPT_0x3
	__PUTB1SNS 0,2
; 0000 00C0     t->day    = bcd_to_dec(i2c_read(1));
	CALL SUBOPT_0x3
	__PUTB1SNS 0,3
; 0000 00C1     t->date   = bcd_to_dec(i2c_read(1));
	CALL SUBOPT_0x3
	__PUTB1SNS 0,4
; 0000 00C2     t->month  = bcd_to_dec(i2c_read(1) & 0x1F);  // Mask century bit
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,LOW(0x1F)
	MOV  R26,R30
	RCALL _bcd_to_dec
	__PUTB1SNS 0,5
; 0000 00C3     t->year   = bcd_to_dec(i2c_read(0));
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R26,R30
	RCALL _bcd_to_dec
	__PUTB1SNS 0,6
; 0000 00C4 
; 0000 00C5     i2c_stop();
	CALL _i2c_stop
; 0000 00C6 }
	RJMP _0x20A0001
; .FEND
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)      //1ms
; 0000 00CB {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
; 0000 00CC // Reinitialize Timer 0 value
; 0000 00CD TCNT0=0x53;
	LDI  R30,LOW(83)
	OUT  0x26,R30
; 0000 00CE // Place your code here
; 0000 00CF 
; 0000 00D0 }
	RJMP _0xAD
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)      //100ms
; 0000 00D4 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D5 // Reinitialize Timer1 value
; 0000 00D6 TCNT1H=0xBC80 >> 8;
	CALL SUBOPT_0x0
; 0000 00D7 TCNT1L=0xBC80 & 0xff;
; 0000 00D8 // Place your code here
; 0000 00D9     length_rx = 0;
	CLR  R6
; 0000 00DA 
; 0000 00DB //    if (((IN1 == OFF && chuTrinhMay1 == OFF) || (IN2 == OFF && chuTrinhMay1 == ON)) && timeSetOn1 > 0)
; 0000 00DC //        timeSetOn1 --;
; 0000 00DD //
; 0000 00DE //    if (((IN3 == OFF && chuTrinhMay2 == OFF) || (IN4 == OFF && chuTrinhMay2 == ON)) && timeSetOn2 > 0)
; 0000 00DF //        timeSetOn2 --;
; 0000 00E0 
; 0000 00E1     if (((IN2 == ON && chuTrinhMay1 == OFF) || (IN2 == OFF && chuTrinhMay1 == ON)) && timeSetOn1 > 0)
	SBIS 0x9,4
	RJMP _0x5
	SBIS 0x1E,0
	RJMP _0x7
_0x5:
	SBIC 0x9,4
	RJMP _0x8
	SBIC 0x1E,0
	RJMP _0x7
_0x8:
	RJMP _0xB
_0x7:
	LDI  R30,LOW(0)
	CP   R30,R13
	BRLO _0xC
_0xB:
	RJMP _0x4
_0xC:
; 0000 00E2         timeSetOn1 --;
	DEC  R13
; 0000 00E3 
; 0000 00E4     if (((IN4 == ON && chuTrinhMay2 == OFF) || (IN4 == OFF && chuTrinhMay2 == ON)) && timeSetOn2 > 0)
_0x4:
	SBIS 0x3,0
	RJMP _0xE
	SBIS 0x1E,1
	RJMP _0x10
_0xE:
	SBIC 0x3,0
	RJMP _0x11
	SBIC 0x1E,1
	RJMP _0x10
_0x11:
	RJMP _0x14
_0x10:
	LDS  R26,_timeSetOn2
	CPI  R26,LOW(0x1)
	BRSH _0x15
_0x14:
	RJMP _0xD
_0x15:
; 0000 00E5         timeSetOn2 --;
	LDS  R30,_timeSetOn2
	SUBI R30,LOW(1)
	STS  _timeSetOn2,R30
; 0000 00E6 
; 0000 00E7 }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)      //0.5ms
; 0000 00EB {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
; 0000 00EC // Reinitialize Timer2 value
; 0000 00ED TCNT2=0x53;
	LDI  R30,LOW(83)
	STS  178,R30
; 0000 00EE // Place your code here
; 0000 00EF 
; 0000 00F0 }
_0xAD:
	LD   R30,Y+
	RETI
; .FEND
;//=================================================================================
;
;
;//TRUYEN DATA RA NGOAI ==================================================================================
;void send1(unsigned char udata){//Ham gui 1 ky tu ASCII
; 0000 00F5 void send1(unsigned char udata){
_send1:
; .FSTART _send1
; 0000 00F6     while(!(UCSR0A & (1<<UDRE0)));//Kiem tra co UDRE    //while(UCSRA.5 != 1);
	ST   -Y,R26
;	udata -> Y+0
_0x16:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x16
; 0000 00F7     UDR0=udata;//Send 1 byte
	LD   R30,Y
	STS  198,R30
; 0000 00F8 }
	RJMP _0x20A0002
; .FEND
;
;void send(unsigned char *s){//Ham gui chuoi ki tu qua UART  ============================================================ ...
; 0000 00FA void send(unsigned char *s){
; 0000 00FB      unsigned char n,i;
; 0000 00FC      DE = 1;
;	*s -> Y+2
;	n -> R17
;	i -> R16
; 0000 00FD      delay_ms(5);
; 0000 00FE      n=strlen(s); //Dem xem co bao nhieu ky tu
; 0000 00FF      for(i=0;i<n;i++)//Vong lap gui tung ky tu 1
; 0000 0100      {
; 0000 0101         send1(s[i]);
; 0000 0102      }
; 0000 0103      delay_ms(10);
; 0000 0104      DE = 0;
; 0000 0105 }
;
;unsigned int CRC_Check(unsigned char *Buf_Crc, unsigned char Length)
; 0000 0108 {
_CRC_Check:
; .FSTART _CRC_Check
; 0000 0109     unsigned int Crc_Temp = 0xFFFF;
; 0000 010A     unsigned char Crc0_Index, Crc1_Index;
; 0000 010B     for (Crc0_Index = 0; Crc0_Index < Length; Crc0_Index++)
	ST   -Y,R26
	CALL __SAVELOCR4
;	*Buf_Crc -> Y+5
;	Length -> Y+4
;	Crc_Temp -> R16,R17
;	Crc0_Index -> R19
;	Crc1_Index -> R18
	__GETWRN 16,17,-1
	LDI  R19,LOW(0)
_0x21:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x22
; 0000 010C     {
; 0000 010D         Crc_Temp = Crc_Temp ^ *Buf_Crc;          // XOR byte into least sig. byte of crc
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LD   R30,X
	LDI  R31,0
	__EORWRR 16,17,30,31
; 0000 010E         for (Crc1_Index = 8; Crc1_Index != 0; Crc1_Index--)
	LDI  R18,LOW(8)
_0x24:
	CPI  R18,0
	BREQ _0x25
; 0000 010F         {    // Loop over each bit
; 0000 0110             if ((Crc_Temp & 0x0001) != 0)
	SBRS R16,0
	RJMP _0x26
; 0000 0111             {      // If the LSB is set
; 0000 0112                 Crc_Temp >>= 1;                    // Shift right and XOR 0xA001
	LSR  R17
	ROR  R16
; 0000 0113                 Crc_Temp ^= 0xA001;
	LDI  R30,LOW(40961)
	LDI  R31,HIGH(40961)
	__EORWRR 16,17,30,31
; 0000 0114             }
; 0000 0115             else                            // Else LSB is not set
	RJMP _0x27
_0x26:
; 0000 0116                 Crc_Temp >>= 1;                    // Just shift right
	LSR  R17
	ROR  R16
; 0000 0117         }
_0x27:
	SUBI R18,1
	RJMP _0x24
_0x25:
; 0000 0118         Buf_Crc++;
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
; 0000 0119     }
	SUBI R19,-1
	RJMP _0x21
_0x22:
; 0000 011A     return Crc_Temp;
	MOVW R30,R16
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; 0000 011B }
; .FEND
;
;void dataTrans(unsigned char MAYx)  //can gui data may nao len may 1 hay may 2
; 0000 011E {
_dataTrans:
; .FSTART _dataTrans
; 0000 011F     if (MAYx == MAY1)
	ST   -Y,R26
;	MAYx -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x28
; 0000 0120     {
; 0000 0121         realTimeInX1.hour    =   realTimeIn1.hour;
	__GETB1MN _realTimeIn1,2
	__PUTB1MN _realTimeInX1,2
; 0000 0122         realTimeInX1.minute  =   realTimeIn1.minute;
	__GETB1MN _realTimeIn1,1
	__PUTB1MN _realTimeInX1,1
; 0000 0123         realTimeInX1.second  =   realTimeIn1.second;
	LDS  R30,_realTimeIn1
	STS  _realTimeInX1,R30
; 0000 0124         realTimeInX1.date    =   realTimeIn1.date;
	__GETB1MN _realTimeIn1,4
	__PUTB1MN _realTimeInX1,4
; 0000 0125         realTimeInX1.month   =   realTimeIn1.month;
	__GETB1MN _realTimeIn1,5
	__PUTB1MN _realTimeInX1,5
; 0000 0126         realTimeInX1.year    =   realTimeIn1.year;
	__GETB1MN _realTimeIn1,6
	__PUTB1MN _realTimeInX1,6
; 0000 0127 
; 0000 0128         realTimeOutX1.hour    =   realTimeOut1.hour;
	__GETB1MN _realTimeOut1,2
	__PUTB1MN _realTimeOutX1,2
; 0000 0129         realTimeOutX1.minute  =   realTimeOut1.minute;
	__GETB1MN _realTimeOut1,1
	__PUTB1MN _realTimeOutX1,1
; 0000 012A         realTimeOutX1.second  =   realTimeOut1.second;
	LDS  R30,_realTimeOut1
	STS  _realTimeOutX1,R30
; 0000 012B         realTimeOutX1.date    =   realTimeOut1.date;
	__GETB1MN _realTimeOut1,4
	__PUTB1MN _realTimeOutX1,4
; 0000 012C         realTimeOutX1.month   =   realTimeOut1.month;
	__GETB1MN _realTimeOut1,5
	__PUTB1MN _realTimeOutX1,5
; 0000 012D         realTimeOutX1.year    =   realTimeOut1.year;
	__GETB1MN _realTimeOut1,6
	__PUTB1MN _realTimeOutX1,6
; 0000 012E 
; 0000 012F         timeLuuHoaX1.hour    =   timeLuuHoa1.hour;
	__GETB1MN _timeLuuHoa1,2
	__PUTB1MN _timeLuuHoaX1,2
; 0000 0130         timeLuuHoaX1.minute  =   timeLuuHoa1.minute;
	__GETB1MN _timeLuuHoa1,1
	__PUTB1MN _timeLuuHoaX1,1
; 0000 0131         timeLuuHoaX1.second  =   timeLuuHoa1.second;
	LDS  R30,_timeLuuHoa1
	STS  _timeLuuHoaX1,R30
; 0000 0132 
; 0000 0133         timeThaoTacX1.hour   =   timeThaoTac1.hour;
	__GETB1MN _timeThaoTac1,2
	__PUTB1MN _timeThaoTacX1,2
; 0000 0134         timeThaoTacX1.minute =   timeThaoTac1.minute;
	__GETB1MN _timeThaoTac1,1
	__PUTB1MN _timeThaoTacX1,1
; 0000 0135         timeThaoTacX1.second =   timeThaoTac1.second;
	LDS  R30,_timeThaoTac1
	STS  _timeThaoTacX1,R30
; 0000 0136 
; 0000 0137     }
; 0000 0138     else if (MAYx == MAY2)
	RJMP _0x29
_0x28:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x2A
; 0000 0139     {
; 0000 013A         realTimeInX2.hour    =   realTimeIn2.hour;
	__GETB1MN _realTimeIn2,2
	__PUTB1MN _realTimeInX2,2
; 0000 013B         realTimeInX2.minute  =   realTimeIn2.minute;
	__GETB1MN _realTimeIn2,1
	__PUTB1MN _realTimeInX2,1
; 0000 013C         realTimeInX2.second  =   realTimeIn2.second;
	LDS  R30,_realTimeIn2
	STS  _realTimeInX2,R30
; 0000 013D         realTimeInX2.date    =   realTimeIn2.date;
	__GETB1MN _realTimeIn2,4
	__PUTB1MN _realTimeInX2,4
; 0000 013E         realTimeInX2.month   =   realTimeIn2.month;
	__GETB1MN _realTimeIn2,5
	__PUTB1MN _realTimeInX2,5
; 0000 013F         realTimeInX2.year    =   realTimeIn2.year;
	__GETB1MN _realTimeIn2,6
	__PUTB1MN _realTimeInX2,6
; 0000 0140 
; 0000 0141         realTimeOutX2.hour    =   realTimeOut2.hour;
	__GETB1MN _realTimeOut2,2
	__PUTB1MN _realTimeOutX2,2
; 0000 0142         realTimeOutX2.minute  =   realTimeOut2.minute;
	__GETB1MN _realTimeOut2,1
	__PUTB1MN _realTimeOutX2,1
; 0000 0143         realTimeOutX2.second  =   realTimeOut2.second;
	LDS  R30,_realTimeOut2
	STS  _realTimeOutX2,R30
; 0000 0144         realTimeOutX2.date    =   realTimeOut2.date;
	__GETB1MN _realTimeOut2,4
	__PUTB1MN _realTimeOutX2,4
; 0000 0145         realTimeOutX2.month   =   realTimeOut2.month;
	__GETB1MN _realTimeOut2,5
	__PUTB1MN _realTimeOutX2,5
; 0000 0146         realTimeOutX2.year    =   realTimeOut2.year;
	__GETB1MN _realTimeOut2,6
	__PUTB1MN _realTimeOutX2,6
; 0000 0147 
; 0000 0148         timeLuuHoaX2.hour    =   timeLuuHoa2.hour;
	__GETB1MN _timeLuuHoa2,2
	__PUTB1MN _timeLuuHoaX2,2
; 0000 0149         timeLuuHoaX2.minute  =   timeLuuHoa2.minute;
	__GETB1MN _timeLuuHoa2,1
	__PUTB1MN _timeLuuHoaX2,1
; 0000 014A         timeLuuHoaX2.second  =   timeLuuHoa2.second;
	LDS  R30,_timeLuuHoa2
	STS  _timeLuuHoaX2,R30
; 0000 014B 
; 0000 014C         timeThaoTacX2.hour   =   timeThaoTac2.hour;
	__GETB1MN _timeThaoTac2,2
	__PUTB1MN _timeThaoTacX2,2
; 0000 014D         timeThaoTacX2.minute =   timeThaoTac2.minute;
	__GETB1MN _timeThaoTac2,1
	__PUTB1MN _timeThaoTacX2,1
; 0000 014E         timeThaoTacX2.second =   timeThaoTac2.second;
	LDS  R30,_timeThaoTac2
	STS  _timeThaoTacX2,R30
; 0000 014F     }
; 0000 0150 }
_0x2A:
_0x29:
_0x20A0002:
	ADIW R28,1
	RET
; .FEND
;
;void transModbusRTU_dataMay_x(unsigned char MAYX)
; 0000 0153 {
_transModbusRTU_dataMay_x:
; .FSTART _transModbusRTU_dataMay_x
; 0000 0154     unsigned char i;
; 0000 0155 
; 0000 0156     if (MAYX == MAY1)
	ST   -Y,R26
	ST   -Y,R17
;	MAYX -> Y+1
;	i -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x2B
; 0000 0157     {
; 0000 0158         buff_tx[0] = diaChiSlave;
	CALL SUBOPT_0x4
; 0000 0159         buff_tx[1] = function_code;
; 0000 015A         buff_tx[2] = number_status1*2;      //so byte duoc gui len master
; 0000 015B 
; 0000 015C         buff_tx[3]  = 0x00;
; 0000 015D         buff_tx[4]  = realTimeInX1.hour;
	__GETB1MN _realTimeInX1,2
	__PUTB1MN _buff_tx,4
; 0000 015E         buff_tx[5]  = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,5
; 0000 015F         buff_tx[6]  = realTimeInX1.minute;
	__GETB1MN _realTimeInX1,1
	CALL SUBOPT_0x5
; 0000 0160         buff_tx[7]  = 0x00;
; 0000 0161         buff_tx[8]  = realTimeInX1.second;
	LDS  R30,_realTimeInX1
	CALL SUBOPT_0x6
; 0000 0162         buff_tx[9]  = 0x00;
; 0000 0163         buff_tx[10] = realTimeInX1.date;
	__GETB1MN _realTimeInX1,4
	CALL SUBOPT_0x7
; 0000 0164         buff_tx[11] = 0x00;
; 0000 0165         buff_tx[12] = realTimeInX1.month;
	__GETB1MN _realTimeInX1,5
	CALL SUBOPT_0x8
; 0000 0166         buff_tx[13] = 0x00;
; 0000 0167         buff_tx[14] = realTimeInX1.year;
	__GETB1MN _realTimeInX1,6
	CALL SUBOPT_0x9
; 0000 0168 
; 0000 0169         buff_tx[15] = 0x00;
; 0000 016A         buff_tx[16] = realTimeOutX1.hour;
	__GETB1MN _realTimeOutX1,2
	CALL SUBOPT_0xA
; 0000 016B         buff_tx[17] = 0x00;
; 0000 016C         buff_tx[18] = realTimeOutX1.minute;
	__GETB1MN _realTimeOutX1,1
	CALL SUBOPT_0xB
; 0000 016D         buff_tx[19] = 0x00;
; 0000 016E         buff_tx[20] = realTimeOutX1.second;
	LDS  R30,_realTimeOutX1
	CALL SUBOPT_0xC
; 0000 016F         buff_tx[21] = 0x00;
; 0000 0170         buff_tx[22] = realTimeOutX1.date;
	__GETB1MN _realTimeOutX1,4
	__PUTB1MN _buff_tx,22
; 0000 0171         buff_tx[23] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,23
; 0000 0172         buff_tx[24] = realTimeOutX1.month;
	__GETB1MN _realTimeOutX1,5
	__PUTB1MN _buff_tx,24
; 0000 0173         buff_tx[25] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,25
; 0000 0174         buff_tx[26] = realTimeOutX1.year;
	__GETB1MN _realTimeOutX1,6
	__PUTB1MN _buff_tx,26
; 0000 0175 
; 0000 0176         buff_tx[27] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,27
; 0000 0177         buff_tx[28] = timeLuuHoaX1.hour;
	__GETB1MN _timeLuuHoaX1,2
	__PUTB1MN _buff_tx,28
; 0000 0178         buff_tx[29] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,29
; 0000 0179         buff_tx[30] = timeLuuHoaX1.minute;
	__GETB1MN _timeLuuHoaX1,1
	__PUTB1MN _buff_tx,30
; 0000 017A         buff_tx[31] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,31
; 0000 017B         buff_tx[32] = timeLuuHoaX1.second;
	LDS  R30,_timeLuuHoaX1
	__PUTB1MN _buff_tx,32
; 0000 017C         buff_tx[33] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,33
; 0000 017D 
; 0000 017E         buff_tx[34] = timeThaoTacX1.hour;
	__GETB1MN _timeThaoTacX1,2
	__PUTB1MN _buff_tx,34
; 0000 017F         buff_tx[35] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,35
; 0000 0180         buff_tx[36] = timeThaoTacX1.hour;
	__GETB1MN _timeThaoTacX1,2
	__PUTB1MN _buff_tx,36
; 0000 0181         buff_tx[37] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,37
; 0000 0182         buff_tx[38] = timeThaoTacX1.second;
	LDS  R30,_timeThaoTacX1
	RJMP _0xAA
; 0000 0183 
; 0000 0184         buff_tx[39] = 0x00;
; 0000 0185         buff_tx[40] = 0x00; //du phong
; 0000 0186         buff_tx[41] = 0x00;
; 0000 0187         buff_tx[42] = 0x00; //du phong
; 0000 0188 
; 0000 0189         CRC16 = CRC_Check(&buff_tx[0],43);
; 0000 018A         buff_tx[43] = ((unsigned char *)&CRC16)[0];
; 0000 018B         buff_tx[44] = ((unsigned char *)&CRC16)[1];
; 0000 018C         buff_tx[45] = 0xFF;
; 0000 018D     }
; 0000 018E 
; 0000 018F     else if (MAYX == MAY2)
_0x2B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x2D
; 0000 0190     {
; 0000 0191         buff_tx[0] = diaChiSlave;
	CALL SUBOPT_0x4
; 0000 0192         buff_tx[1] = function_code;
; 0000 0193         buff_tx[2] = number_status1*2;      //so byte duoc gui len master
; 0000 0194 
; 0000 0195         buff_tx[3]  = 0x00;
; 0000 0196         buff_tx[4]  = realTimeInX2.hour;
	__GETB1MN _realTimeInX2,2
	__PUTB1MN _buff_tx,4
; 0000 0197         buff_tx[5]  = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,5
; 0000 0198         buff_tx[6]  = realTimeInX2.minute;
	__GETB1MN _realTimeInX2,1
	CALL SUBOPT_0x5
; 0000 0199         buff_tx[7]  = 0x00;
; 0000 019A         buff_tx[8]  = realTimeInX2.second;
	LDS  R30,_realTimeInX2
	CALL SUBOPT_0x6
; 0000 019B         buff_tx[9]  = 0x00;
; 0000 019C         buff_tx[10] = realTimeInX2.date;
	__GETB1MN _realTimeInX2,4
	CALL SUBOPT_0x7
; 0000 019D         buff_tx[11] = 0x00;
; 0000 019E         buff_tx[12] = realTimeInX2.month;
	__GETB1MN _realTimeInX2,5
	CALL SUBOPT_0x8
; 0000 019F         buff_tx[13] = 0x00;
; 0000 01A0         buff_tx[14] = realTimeInX2.year;
	__GETB1MN _realTimeInX2,6
	CALL SUBOPT_0x9
; 0000 01A1 
; 0000 01A2         buff_tx[15] = 0x00;
; 0000 01A3         buff_tx[16] = realTimeOutX2.hour;
	__GETB1MN _realTimeOutX2,2
	CALL SUBOPT_0xA
; 0000 01A4         buff_tx[17] = 0x00;
; 0000 01A5         buff_tx[18] = realTimeOutX2.minute;
	__GETB1MN _realTimeOutX2,1
	CALL SUBOPT_0xB
; 0000 01A6         buff_tx[19] = 0x00;
; 0000 01A7         buff_tx[20] = realTimeOutX2.second;
	LDS  R30,_realTimeOutX2
	CALL SUBOPT_0xC
; 0000 01A8         buff_tx[21] = 0x00;
; 0000 01A9         buff_tx[22] = realTimeOutX2.date;
	__GETB1MN _realTimeOutX2,4
	__PUTB1MN _buff_tx,22
; 0000 01AA         buff_tx[23] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,23
; 0000 01AB         buff_tx[24] = realTimeOutX2.month;
	__GETB1MN _realTimeOutX2,5
	__PUTB1MN _buff_tx,24
; 0000 01AC         buff_tx[25] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,25
; 0000 01AD         buff_tx[26] = realTimeOutX2.year;
	__GETB1MN _realTimeOutX2,6
	__PUTB1MN _buff_tx,26
; 0000 01AE 
; 0000 01AF         buff_tx[27] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,27
; 0000 01B0         buff_tx[28] = timeLuuHoaX2.hour;
	__GETB1MN _timeLuuHoaX2,2
	__PUTB1MN _buff_tx,28
; 0000 01B1         buff_tx[29] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,29
; 0000 01B2         buff_tx[30] = timeLuuHoaX2.minute;
	__GETB1MN _timeLuuHoaX2,1
	__PUTB1MN _buff_tx,30
; 0000 01B3         buff_tx[31] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,31
; 0000 01B4         buff_tx[32] = timeLuuHoaX2.second;
	LDS  R30,_timeLuuHoaX2
	__PUTB1MN _buff_tx,32
; 0000 01B5         buff_tx[33] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,33
; 0000 01B6 
; 0000 01B7         buff_tx[34] = timeThaoTacX2.hour;
	__GETB1MN _timeThaoTacX2,2
	__PUTB1MN _buff_tx,34
; 0000 01B8         buff_tx[35] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,35
; 0000 01B9         buff_tx[36] = timeThaoTacX2.hour;
	__GETB1MN _timeThaoTacX2,2
	__PUTB1MN _buff_tx,36
; 0000 01BA         buff_tx[37] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,37
; 0000 01BB         buff_tx[38] = timeThaoTacX2.second;
	LDS  R30,_timeThaoTacX2
_0xAA:
	__PUTB1MN _buff_tx,38
; 0000 01BC 
; 0000 01BD         buff_tx[39] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,39
; 0000 01BE         buff_tx[40] = 0x00; //du phong
	__PUTB1MN _buff_tx,40
; 0000 01BF         buff_tx[41] = 0x00;
	__PUTB1MN _buff_tx,41
; 0000 01C0         buff_tx[42] = 0x00; //du phong
	__PUTB1MN _buff_tx,42
; 0000 01C1 
; 0000 01C2         CRC16 = CRC_Check(&buff_tx[0],43);
	LDI  R30,LOW(_buff_tx)
	LDI  R31,HIGH(_buff_tx)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(43)
	CALL SUBOPT_0xD
; 0000 01C3         buff_tx[43] = ((unsigned char *)&CRC16)[0];
	__PUTBMRN _buff_tx,43,11
; 0000 01C4         buff_tx[44] = ((unsigned char *)&CRC16)[1];
	__PUTBMRN _buff_tx,44,12
; 0000 01C5         buff_tx[45] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _buff_tx,45
; 0000 01C6     }
; 0000 01C7 
; 0000 01C8     DE = 1;
_0x2D:
	CALL SUBOPT_0xE
; 0000 01C9     delay_ms(10);
; 0000 01CA     for(i=0;i<=45;i++)
_0x31:
	CPI  R17,46
	BRSH _0x32
; 0000 01CB     {
; 0000 01CC         send1(buff_tx[i]);
	CALL SUBOPT_0xF
; 0000 01CD     }
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 01CE     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 01CF     DE = 0;
	CBI  0xB,2
; 0000 01D0 }
	LDD  R17,Y+0
	RJMP _0x20A0001
; .FEND
;
;void transModbusRTU_setup() //gui du lieu tra lai xac nhan thoi gian realtime va addr dduojc thiet lap
; 0000 01D3 {
_transModbusRTU_setup:
; .FSTART _transModbusRTU_setup
; 0000 01D4     unsigned char i;
; 0000 01D5     buff_tx[0] = diaChiSlave;
	ST   -Y,R17
;	i -> R17
	STS  _buff_tx,R3
; 0000 01D6     buff_tx[1] = 0x03;
	LDI  R30,LOW(3)
	__PUTB1MN _buff_tx,1
; 0000 01D7     buff_tx[2] = number_status1*2;      //so byte duoc gui len master
	MOV  R30,R9
	LSL  R30
	__PUTB1MN _buff_tx,2
; 0000 01D8 
; 0000 01D9     read_ds3231_datetime(&current);
	LDI  R26,LOW(_current)
	LDI  R27,HIGH(_current)
	RCALL _read_ds3231_datetime
; 0000 01DA     buff_tx[3]  = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,3
; 0000 01DB     buff_tx[4]  = diaChiSlave;
	__PUTBMRN _buff_tx,4,3
; 0000 01DC     buff_tx[5]  = 0x00;
	__PUTB1MN _buff_tx,5
; 0000 01DD     buff_tx[6]  = current.hour;
	__GETB1MN _current,2
	CALL SUBOPT_0x5
; 0000 01DE     buff_tx[7]  = 0x00;
; 0000 01DF     buff_tx[8]  = current.minute;
	__GETB1MN _current,1
	CALL SUBOPT_0x6
; 0000 01E0     buff_tx[9]  = 0x00;
; 0000 01E1     buff_tx[10] = current.second;
	LDS  R30,_current
	CALL SUBOPT_0x7
; 0000 01E2     buff_tx[11] = 0x00;
; 0000 01E3     buff_tx[12] = current.date;
	__GETB1MN _current,4
	CALL SUBOPT_0x8
; 0000 01E4     buff_tx[13] = 0x00;
; 0000 01E5     buff_tx[14] = current.month;
	__GETB1MN _current,5
	CALL SUBOPT_0x9
; 0000 01E6     buff_tx[15] = 0x00;
; 0000 01E7     buff_tx[16] = current.year;
	__GETB1MN _current,6
	CALL SUBOPT_0xA
; 0000 01E8     buff_tx[17] = 0x00;
; 0000 01E9     buff_tx[18] = 0x00;    //du phong
	LDI  R30,LOW(0)
	CALL SUBOPT_0xB
; 0000 01EA     buff_tx[19] = 0x00;
; 0000 01EB     buff_tx[20] = 0x00;    //du phong
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
; 0000 01EC     buff_tx[21] = 0x00;
; 0000 01ED     buff_tx[22] = 0x00;    //du phong
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,22
; 0000 01EE 
; 0000 01EF     CRC16 = CRC_Check(&buff_tx[0],23);
	LDI  R30,LOW(_buff_tx)
	LDI  R31,HIGH(_buff_tx)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(23)
	CALL SUBOPT_0xD
; 0000 01F0     buff_tx[23] = ((unsigned char *)&CRC16)[0];
	__PUTBMRN _buff_tx,23,11
; 0000 01F1     buff_tx[24] = ((unsigned char *)&CRC16)[1];
	__PUTBMRN _buff_tx,24,12
; 0000 01F2     buff_tx[25] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _buff_tx,25
; 0000 01F3 
; 0000 01F4     DE = 1;
	CALL SUBOPT_0xE
; 0000 01F5     delay_ms(10);
; 0000 01F6     for(i=0;i<=25;i++)
_0x38:
	CPI  R17,26
	BRSH _0x39
; 0000 01F7     {
; 0000 01F8         send1(buff_tx[i]);
	CALL SUBOPT_0xF
; 0000 01F9     }
	SUBI R17,-1
	RJMP _0x38
_0x39:
; 0000 01FA     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 01FB     DE = 0;
	CBI  0xB,2
; 0000 01FC }
	LD   R17,Y+
	RET
; .FEND
;
;//interrupt [USART_RXC] void rx_isr()
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0200 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0201 //    if (RXCIE0 && RXC0)
; 0000 0202     {
; 0000 0203         buff_rx[length_rx] = UDR0;
	CALL SUBOPT_0x10
	LDS  R30,198
	ST   X,R30
; 0000 0204         if((UCSR0A & (1<<RXC0))==0)    //(UCSRA.7==0)
	LDS  R30,192
	ANDI R30,LOW(0x80)
	BREQ PC+2
	RJMP _0x3C
; 0000 0205         {
; 0000 0206             if ((buff_rx[0] == diaChiSlave) || (buff_rx[0] == 0x00))
	LDS  R26,_buff_rx
	CP   R3,R26
	BREQ _0x3E
	CPI  R26,LOW(0x0)
	BREQ _0x3E
	RJMP _0x3D
_0x3E:
; 0000 0207             {
; 0000 0208 //                send("vao modbus ok!\r\n");
; 0000 0209                 if (length_rx == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x40
; 0000 020A                     function_code = buff_rx[1];
	__GETBRMN 5,_buff_rx,1
; 0000 020B 
; 0000 020C                 if (length_rx == 6 && function_code == 0x10)
_0x40:
	LDI  R30,LOW(6)
	CP   R30,R6
	BRNE _0x42
	LDI  R30,LOW(16)
	CP   R30,R5
	BREQ _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 020D                 {
; 0000 020E //                    send("length=6?\r\n");
; 0000 020F                     address_register1 = buff_rx[3];    //dia chi thanh ghi dau tien
	__GETBRMN 8,_buff_rx,3
; 0000 0210                     number_status1 = buff_rx[5];   //so word
	__GETBRMN 9,_buff_rx,5
; 0000 0211                     number_byte1 = buff_rx[6];   //so byte ghi vao vung nho
	__GETBRMN 10,_buff_rx,6
; 0000 0212                 }
; 0000 0213                 else if (length_rx == 5 && function_code == 0x03)
	RJMP _0x44
_0x41:
	LDI  R30,LOW(5)
	CP   R30,R6
	BRNE _0x46
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 0214                 {
; 0000 0215                     address_register1 = buff_rx[3];    //dia chi thanh ghi dau tien
	__GETBRMN 8,_buff_rx,3
; 0000 0216                     number_status1 = buff_rx[5];   //so word
	__GETBRMN 9,_buff_rx,5
; 0000 0217                 }
; 0000 0218 
; 0000 0219                 if (length_rx == 8 + number_byte1 && function_code == 0x10 && address_register1 == 0x0A )   //phan hoi g ...
_0x45:
_0x44:
	MOV  R30,R10
	LDI  R31,0
	ADIW R30,8
	MOV  R26,R6
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x49
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x49
	LDI  R30,LOW(10)
	CP   R30,R8
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 021A                 {
; 0000 021B //                    send("Fx=10?");
; 0000 021C                     CRC16 = CRC_Check(&buff_rx[0],length_rx-1);
	CALL SUBOPT_0x11
; 0000 021D                     if (( buff_rx[length_rx-1] == ((unsigned char *)&CRC16)[0] ) && (buff_rx[length_rx] = ((unsigned cha ...
	CALL SUBOPT_0x12
	BRNE _0x4C
	CALL SUBOPT_0x10
	MOV  R30,R12
	ST   X,R30
	CPI  R30,0
	BRNE _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 021E                         F_rx = 10;
	LDI  R30,LOW(10)
	MOV  R14,R30
; 0000 021F                 }
_0x4B:
; 0000 0220                 else if (length_rx == 7 && function_code == 0x03 && (address_register1 == 0x15 || address_register1 == 0 ...
	RJMP _0x4E
_0x48:
	LDI  R30,LOW(7)
	CP   R30,R6
	BRNE _0x50
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x50
	LDI  R30,LOW(21)
	CP   R30,R8
	BREQ _0x51
	LDI  R30,LOW(41)
	CP   R30,R8
	BRNE _0x50
_0x51:
	RJMP _0x53
_0x50:
	RJMP _0x4F
_0x53:
; 0000 0221                 {
; 0000 0222                     CRC16 = CRC_Check(&buff_rx[0],length_rx-1);
	CALL SUBOPT_0x11
; 0000 0223                     if (( buff_rx[length_rx-1] == ((unsigned char *)&CRC16)[0] ) && (buff_rx[length_rx] = ((unsigned cha ...
	CALL SUBOPT_0x12
	BRNE _0x55
	CALL SUBOPT_0x10
	MOV  R30,R12
	ST   X,R30
	CPI  R30,0
	BRNE _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 0224                         F_rx = 3;
	LDI  R30,LOW(3)
	MOV  R14,R30
; 0000 0225                 }
_0x54:
; 0000 0226                 else
	RJMP _0x57
_0x4F:
; 0000 0227                     F_rx = 0;
	CLR  R14
; 0000 0228             }
_0x57:
_0x4E:
; 0000 0229             length_rx ++;
_0x3D:
	INC  R6
; 0000 022A         }
; 0000 022B         UCSR0A=(0<<RXC0);    //Xoa co nhan   //UCSRA.7=0;
_0x3C:
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 022C     }
; 0000 022D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;//==========================BEGIN DOC GHI VAO EPPROM ==========================
;void epprom_write(unsigned int add, unsigned char data)
; 0000 0231 {
_epprom_write:
; .FSTART _epprom_write
; 0000 0232     while(EECR & (1<<EEPE));
	ST   -Y,R26
;	add -> Y+1
;	data -> Y+0
_0x58:
	SBIC 0x1F,1
	RJMP _0x58
; 0000 0233     EEAR=add;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x21+1,R31
	OUT  0x21,R30
; 0000 0234     EEDR=data;
	LD   R30,Y
	OUT  0x20,R30
; 0000 0235     EECR=(1<<EEMPE);
	LDI  R30,LOW(4)
	OUT  0x1F,R30
; 0000 0236     EECR|=(1<<EEPE);
	SBI  0x1F,1
; 0000 0237 }
	ADIW R28,3
	RET
; .FEND
;
;unsigned char epprom_read(unsigned int add)
; 0000 023A {
_epprom_read:
; .FSTART _epprom_read
; 0000 023B     while(EECR & (1<<EEPE));
	ST   -Y,R27
	ST   -Y,R26
;	add -> Y+0
_0x5B:
	SBIC 0x1F,1
	RJMP _0x5B
; 0000 023C     EEAR=add;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x21+1,R31
	OUT  0x21,R30
; 0000 023D     EECR|=(1<<EERE);
	SBI  0x1F,0
; 0000 023E     return EEDR;
	IN   R30,0x20
_0x20A0001:
	ADIW R28,2
	RET
; 0000 023F }
; .FEND
;
;void setting()
; 0000 0242 {
_setting:
; .FSTART _setting
; 0000 0243     if (epprom_read(0x010) != 1)
	LDI  R26,LOW(16)
	LDI  R27,0
	RCALL _epprom_read
	CPI  R30,LOW(0x1)
	BREQ _0x5E
; 0000 0244     {
; 0000 0245         epprom_write(addr_baudrate,0x01); //1            //khoi tao khi nap code co baudrate 9600
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x13
; 0000 0246         epprom_write(addr_diaChiSlave,0x01);          //khoi tao khi nap code chon dia chi slave la 01
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x13
; 0000 0247         epprom_write(0x010,1); //sau khi luu gia tri default cho cac thong so thi set len 1 de sau ko ghi nua
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x13
; 0000 0248         set_ds3231_datetime(&set_time);     //set realtime 1 lan khi nap code
	LDI  R26,LOW(_set_time)
	LDI  R27,HIGH(_set_time)
	RCALL _set_ds3231_datetime
; 0000 0249     }
; 0000 024A 
; 0000 024B     mode_baudrate        = epprom_read(addr_baudrate);
_0x5E:
	LDI  R26,LOW(17)
	LDI  R27,0
	RCALL _epprom_read
	MOV  R4,R30
; 0000 024C     diaChiSlave     = epprom_read(addr_diaChiSlave);
	LDI  R26,LOW(18)
	LDI  R27,0
	RCALL _epprom_read
	MOV  R3,R30
; 0000 024D 
; 0000 024E     if      (mode_baudrate == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x5F
; 0000 024F         UBRR0L = 71;     // THACH ANH 11.0592Mhz  71  9600  baud
	LDI  R30,LOW(71)
	RJMP _0xAB
; 0000 0250     else if (mode_baudrate == 2)
_0x5F:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x61
; 0000 0251         UBRR0L = 47;     // THACH ANH 11.0592Mhz  47  14400 baud
	LDI  R30,LOW(47)
	RJMP _0xAB
; 0000 0252     else if (mode_baudrate == 3)
_0x61:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x63
; 0000 0253         UBRR0L = 35;     // THACH ANH 11.0592Mhz  35  19200 baud
	LDI  R30,LOW(35)
	RJMP _0xAB
; 0000 0254     else if (mode_baudrate == 4)
_0x63:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x65
; 0000 0255         UBRR0L = 17;     // THACH ANH 11.0592Mhz  17  38400 baud
	LDI  R30,LOW(17)
_0xAB:
	STS  196,R30
; 0000 0256 
; 0000 0257     DE = 0;
_0x65:
	CBI  0xB,2
; 0000 0258     timeSetOn1 = timeSet;
	LDI  R30,LOW(20)
	MOV  R13,R30
; 0000 0259     timeSetOn2 = timeSet;
	STS  _timeSetOn2,R30
; 0000 025A }
	RET
; .FEND
;
;//==========================END DOC GHI VAO EPPROM ==========================
;
;void main(void)
; 0000 025F {
_main:
; .FSTART _main
; 0000 0260     Init();
	RCALL _Init
; 0000 0261     i2c_init();
	CALL _i2c_init
; 0000 0262     delay_ms(100);
	CALL SUBOPT_0x14
; 0000 0263     setting();
	RCALL _setting
; 0000 0264     realTimeOut1.hour = realTimeOut1.minute = realTimeOut1.second = 0;
	LDI  R30,LOW(0)
	STS  _realTimeOut1,R30
	__PUTB1MN _realTimeOut1,1
	__PUTB1MN _realTimeOut1,2
; 0000 0265 
; 0000 0266 //    send("start!");
; 0000 0267 
; 0000 0268     while (1)
_0x68:
; 0000 0269     {
; 0000 026A         /*
; 0000 026B         //========================================================
; 0000 026C            read_ds3231_datetime(&current);
; 0000 026D 
; 0000 026E //             In ra UART neu can
; 0000 026F              printf("Time: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
; 0000 0270                     current.hour, current.minute, current.second,
; 0000 0271                     current.date, current.month, current.year);
; 0000 0272 
; 0000 0273             delay_ms(1000);
; 0000 0274         //========================================================
; 0000 0275         */
; 0000 0276 
; 0000 0277         if (F_rx == 10)
	LDI  R30,LOW(10)
	CP   R30,R14
	BRNE _0x6B
; 0000 0278         {
; 0000 0279             diaChiSlave     =   buff_rx[8];
	__GETBRMN 3,_buff_rx,8
; 0000 027A             set_time.hour   =   buff_rx[10];
	__GETB1MN _buff_rx,10
	__PUTB1MN _set_time,2
; 0000 027B             set_time.minute =   buff_rx[12];
	__GETB1MN _buff_rx,12
	__PUTB1MN _set_time,1
; 0000 027C             set_time.second =   buff_rx[14];
	__GETB1MN _buff_rx,14
	STS  _set_time,R30
; 0000 027D             set_time.date   =   buff_rx[16];
	__GETB1MN _buff_rx,16
	__PUTB1MN _set_time,4
; 0000 027E             set_time.month  =   buff_rx[18];
	__GETB1MN _buff_rx,18
	__PUTB1MN _set_time,5
; 0000 027F             set_time.year   =   buff_rx[20];
	__GETB1MN _buff_rx,20
	__PUTB1MN _set_time,6
; 0000 0280             set_ds3231_datetime(&set_time);
	LDI  R26,LOW(_set_time)
	LDI  R27,HIGH(_set_time)
	RCALL _set_ds3231_datetime
; 0000 0281             delay_ms(100);
	CALL SUBOPT_0x14
; 0000 0282             transModbusRTU_setup();
	RCALL _transModbusRTU_setup
; 0000 0283             F_rx = 0;
	CLR  R14
; 0000 0284 //            send("ghi suscess");
; 0000 0285             epprom_write(addr_diaChiSlave,diaChiSlave);
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R3
	RCALL _epprom_write
; 0000 0286         }
; 0000 0287 
; 0000 0288         else if (F_rx == 3)
	RJMP _0x6C
_0x6B:
	LDI  R30,LOW(3)
	CP   R30,R14
	BRNE _0x6D
; 0000 0289         {
; 0000 028A             delay_ms(100);  //tach chuoi hoi ra
	CALL SUBOPT_0x14
; 0000 028B             if (address_register1 == 0x15)
	LDI  R30,LOW(21)
	CP   R30,R8
	BRNE _0x6E
; 0000 028C             {
; 0000 028D                 transModbusRTU_dataMay_x(MAY1);
	LDI  R26,LOW(1)
	RJMP _0xAC
; 0000 028E             }
; 0000 028F             else if (address_register1 == 0x29)
_0x6E:
	LDI  R30,LOW(41)
	CP   R30,R8
	BRNE _0x70
; 0000 0290             {
; 0000 0291                 transModbusRTU_dataMay_x(MAY2);
	LDI  R26,LOW(2)
_0xAC:
	RCALL _transModbusRTU_dataMay_x
; 0000 0292             }
; 0000 0293 
; 0000 0294             F_rx = 0;
_0x70:
	CLR  R14
; 0000 0295         }
; 0000 0296 
; 0000 0297 
; 0000 0298         //========================================================
; 0000 0299         //GHI THOI GIAN IN OUT SENSSOR 1
; 0000 029A //        if(IN1 == OFF && chuTrinhMay1 == OFF && timeSetOn1 == 0)
; 0000 029B         if(IN2 == ON && chuTrinhMay1 == OFF && timeSetOn1 == 0)          //IN2 1->0: lieu vao
_0x6D:
_0x6C:
	SBIS 0x9,4
	RJMP _0x72
	SBIC 0x1E,0
	RJMP _0x72
	TST  R13
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 029C         {
; 0000 029D             chuTrinhMay1 = ON;
	SBI  0x1E,0
; 0000 029E             demIN2 = 0;      //khoi tao dem so lan kich sensor out
	LDI  R30,LOW(0)
	STS  _demIN2,R30
; 0000 029F             read_ds3231_datetime(&realTimeIn1);     //may 1      //doc lan 1 de tinh time thao tac
	LDI  R26,LOW(_realTimeIn1)
	LDI  R27,HIGH(_realTimeIn1)
	RCALL _read_ds3231_datetime
; 0000 02A0 
; 0000 02A1             //tinh time thao tac tu lan ra truoc toi lan vao tiep theo
; 0000 02A2             if ((realTimeOut1_QK.hour || realTimeOut1_QK.minute || realTimeOut1_QK.second) != 0)
	__GETB1MN _realTimeOut1_QK,2
	CPI  R30,0
	BRNE _0x77
	__GETB1MN _realTimeOut1_QK,1
	CPI  R30,0
	BRNE _0x77
	LDS  R30,_realTimeOut1_QK
	CPI  R30,0
	BRNE _0x77
	RJMP _0x76
_0x77:
; 0000 02A3             {
; 0000 02A4                 if (realTimeIn1.second >= realTimeOut1_QK.second)
	LDS  R30,_realTimeOut1_QK
	LDS  R26,_realTimeIn1
	CP   R26,R30
	BRLO _0x79
; 0000 02A5                     timeThaoTac1.second = realTimeIn1.second - realTimeOut1_QK.second;
	LDS  R26,_realTimeOut1_QK
	LDS  R30,_realTimeIn1
	SUB  R30,R26
	STS  _timeThaoTac1,R30
; 0000 02A6                 else
	RJMP _0x7A
_0x79:
; 0000 02A7                 {
; 0000 02A8                     timeThaoTac1.second = realTimeIn1.second + 60 - realTimeOut1_QK.second;
	LDS  R30,_realTimeIn1
	SUBI R30,-LOW(60)
	LDS  R26,_realTimeOut1_QK
	SUB  R30,R26
	STS  _timeThaoTac1,R30
; 0000 02A9                     realTimeIn1.minute = realTimeIn1.minute - 1;
	__GETB1MN _realTimeIn1,1
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn1,1
; 0000 02AA                 }
_0x7A:
; 0000 02AB                 if (realTimeIn1.minute >= realTimeOut1_QK.minute)
	__GETB2MN _realTimeIn1,1
	__GETB1MN _realTimeOut1_QK,1
	CP   R26,R30
	BRLO _0x7B
; 0000 02AC                     timeThaoTac1.minute = realTimeIn1.minute - realTimeOut1_QK.minute;
	__GETB1MN _realTimeIn1,1
	__GETB2MN _realTimeOut1_QK,1
	SUB  R30,R26
	__PUTB1MN _timeThaoTac1,1
; 0000 02AD                 else
	RJMP _0x7C
_0x7B:
; 0000 02AE                 {
; 0000 02AF                     timeThaoTac1.minute = realTimeIn1.minute + 60 - realTimeOut1_QK.minute;
	__GETB1MN _realTimeIn1,1
	SUBI R30,-LOW(60)
	__GETB2MN _realTimeOut1_QK,1
	SUB  R30,R26
	__PUTB1MN _timeThaoTac1,1
; 0000 02B0                     realTimeIn1.hour = realTimeIn1.hour - 1;
	__GETB1MN _realTimeIn1,2
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn1,2
; 0000 02B1                 }
_0x7C:
; 0000 02B2                 if (realTimeIn1.hour >= realTimeOut1_QK.hour)
	__GETB2MN _realTimeIn1,2
	__GETB1MN _realTimeOut1_QK,2
	CP   R26,R30
	BRLO _0x7D
; 0000 02B3                     timeThaoTac1.hour = realTimeIn1.hour - realTimeOut1_QK.hour;
	__GETB1MN _realTimeIn1,2
	__GETB2MN _realTimeOut1_QK,2
	SUB  R30,R26
	__PUTB1MN _timeThaoTac1,2
; 0000 02B4                 else
	RJMP _0x7E
_0x7D:
; 0000 02B5                 {
; 0000 02B6                     timeThaoTac1.hour = realTimeIn1.hour + 24 - realTimeOut1_QK.hour;
	__GETB1MN _realTimeIn1,2
	SUBI R30,-LOW(24)
	__GETB2MN _realTimeOut1_QK,2
	SUB  R30,R26
	__PUTB1MN _timeThaoTac1,2
; 0000 02B7                     realTimeIn1.day = realTimeIn1.day - 1;
	__GETB1MN _realTimeIn1,3
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn1,3
; 0000 02B8                 }
_0x7E:
; 0000 02B9 
; 0000 02BA //                DE = 1;
; 0000 02BB //                printf("Time thao tac may 1: %02u:%02u:%02u\r\n",
; 0000 02BC //                    timeThaoTac1.hour, timeThaoTac1.minute, timeThaoTac1.second);
; 0000 02BD //                DE = 0;
; 0000 02BE             }
; 0000 02BF 
; 0000 02C0             read_ds3231_datetime(&realTimeIn1);     //may 1   //doc lan 2 de luu lai gia tri vao
_0x76:
	LDI  R26,LOW(_realTimeIn1)
	LDI  R27,HIGH(_realTimeIn1)
	RCALL _read_ds3231_datetime
; 0000 02C1 //            DE = 1;
; 0000 02C2 //            printf("Time lieu vao may 1: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
; 0000 02C3 //                realTimeIn1.hour, realTimeIn1.minute, realTimeIn1.second,
; 0000 02C4 //                realTimeIn1.date, realTimeIn1.month, realTimeIn1.year);
; 0000 02C5 //            DE = 0;
; 0000 02C6 
; 0000 02C7 //            chuTrinhMay1 = ON;
; 0000 02C8             timeSetOn1 = timeSet;
	LDI  R30,LOW(20)
	MOV  R13,R30
; 0000 02C9 //            delay_ms(200);
; 0000 02CA         }
; 0000 02CB 
; 0000 02CC //        if(IN2 == OFF && chuTrinhMay1 == ON && timeSetOn1 == 0)
; 0000 02CD         if(IN2 == OFF && chuTrinhMay1 == ON && timeSetOn1 == 0 && demIN2 == 0)      //IN2  0->1: lieu ra        //demIN2 ...
_0x71:
	SBIC 0x9,4
	RJMP _0x80
	SBIS 0x1E,0
	RJMP _0x80
	TST  R13
	BRNE _0x80
	LDS  R26,_demIN2
	CPI  R26,LOW(0x0)
	BREQ _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 02CE         {
; 0000 02CF             demIN2 = 1;
	LDI  R30,LOW(1)
	STS  _demIN2,R30
; 0000 02D0         }
; 0000 02D1 
; 0000 02D2         if(IN2 == OFF && chuTrinhMay1 == ON && timeSetOn1 == 0 && demIN2 == 1)      //IN2  0->1: lieu ra       //demIN2  ...
_0x7F:
	SBIC 0x9,4
	RJMP _0x83
	SBIS 0x1E,0
	RJMP _0x83
	TST  R13
	BRNE _0x83
	LDS  R26,_demIN2
	CPI  R26,LOW(0x1)
	BREQ _0x84
_0x83:
	RJMP _0x82
_0x84:
; 0000 02D3         {
; 0000 02D4             demIN2 = 2;
	LDI  R30,LOW(2)
	STS  _demIN2,R30
; 0000 02D5             realTimeOut1_QK.hour = realTimeOut1.hour;
	__GETB1MN _realTimeOut1,2
	__PUTB1MN _realTimeOut1_QK,2
; 0000 02D6             realTimeOut1_QK.minute = realTimeOut1.minute;
	__GETB1MN _realTimeOut1,1
	__PUTB1MN _realTimeOut1_QK,1
; 0000 02D7             realTimeOut1_QK.second = realTimeOut1.second;
	LDS  R30,_realTimeOut1
	STS  _realTimeOut1_QK,R30
; 0000 02D8 
; 0000 02D9             read_ds3231_datetime(&realTimeOut1);    //may 1  //tinh time thao tac
	LDI  R26,LOW(_realTimeOut1)
	LDI  R27,HIGH(_realTimeOut1)
	RCALL _read_ds3231_datetime
; 0000 02DA //            DE = 1;
; 0000 02DB //            printf("Time lieu ra may 1: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
; 0000 02DC //                realTimeOut1.hour, realTimeOut1.minute, realTimeOut1.second,
; 0000 02DD //                realTimeOut1.date, realTimeOut1.month, realTimeOut1.year);
; 0000 02DE //            DE = 0;
; 0000 02DF 
; 0000 02E0 
; 0000 02E1             //tinh time luu hoa may 1
; 0000 02E2             timeLuuHoa1.hour = realTimeOut1.hour - realTimeIn1.hour;
	CALL SUBOPT_0x15
; 0000 02E3             timeLuuHoa1.minute = realTimeOut1.minute - realTimeIn1.minute;
	CALL SUBOPT_0x16
; 0000 02E4             timeLuuHoa1.second = realTimeOut1.second - realTimeIn1.second;
	CALL SUBOPT_0x17
; 0000 02E5 
; 0000 02E6             if (realTimeOut1.second >= realTimeIn1.second)
	LDS  R30,_realTimeIn1
	LDS  R26,_realTimeOut1
	CP   R26,R30
	BRLO _0x85
; 0000 02E7                 timeLuuHoa1.second = realTimeOut1.second - realTimeIn1.second;
	CALL SUBOPT_0x17
; 0000 02E8             else
	RJMP _0x86
_0x85:
; 0000 02E9             {
; 0000 02EA                 timeLuuHoa1.second = realTimeOut1.second + 60 - realTimeIn1.second;
	LDS  R30,_realTimeOut1
	SUBI R30,-LOW(60)
	LDS  R26,_realTimeIn1
	SUB  R30,R26
	STS  _timeLuuHoa1,R30
; 0000 02EB                 realTimeOut1.minute = realTimeOut1.minute - 1;
	__GETB1MN _realTimeOut1,1
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut1,1
; 0000 02EC             }
_0x86:
; 0000 02ED             if (realTimeOut1.minute >= realTimeIn1.minute)
	__GETB2MN _realTimeOut1,1
	__GETB1MN _realTimeIn1,1
	CP   R26,R30
	BRLO _0x87
; 0000 02EE                 timeLuuHoa1.minute = realTimeOut1.minute - realTimeIn1.minute;
	CALL SUBOPT_0x16
; 0000 02EF             else
	RJMP _0x88
_0x87:
; 0000 02F0             {
; 0000 02F1                 timeLuuHoa1.minute = realTimeOut1.minute + 60 - realTimeIn1.minute;
	__GETB1MN _realTimeOut1,1
	SUBI R30,-LOW(60)
	__GETB2MN _realTimeIn1,1
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa1,1
; 0000 02F2                 realTimeOut1.hour = realTimeOut1.hour - 1;
	__GETB1MN _realTimeOut1,2
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut1,2
; 0000 02F3             }
_0x88:
; 0000 02F4             if (realTimeOut1.hour >= realTimeIn1.hour)
	__GETB2MN _realTimeOut1,2
	__GETB1MN _realTimeIn1,2
	CP   R26,R30
	BRLO _0x89
; 0000 02F5                 timeLuuHoa1.hour = realTimeOut1.hour - realTimeIn1.hour;
	CALL SUBOPT_0x15
; 0000 02F6             else
	RJMP _0x8A
_0x89:
; 0000 02F7             {
; 0000 02F8                 timeLuuHoa1.hour = realTimeOut1.hour + 24 - realTimeIn1.hour;
	__GETB1MN _realTimeOut1,2
	SUBI R30,-LOW(24)
	__GETB2MN _realTimeIn1,2
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa1,2
; 0000 02F9                 realTimeOut1.day = realTimeOut1.day - 1;
	__GETB1MN _realTimeOut1,3
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut1,3
; 0000 02FA             }
_0x8A:
; 0000 02FB 
; 0000 02FC //            DE = 1;
; 0000 02FD //            printf("Time Luu Hoa may 1: %02u:%02u:%02u\r\n",
; 0000 02FE //                timeLuuHoa1.hour, timeLuuHoa1.minute, timeLuuHoa1.second);
; 0000 02FF //            DE = 0;
; 0000 0300 
; 0000 0301             read_ds3231_datetime(&realTimeOut1);    //may 1  //doc lan 2 luu lai gia tri time out
	LDI  R26,LOW(_realTimeOut1)
	LDI  R27,HIGH(_realTimeOut1)
	RCALL _read_ds3231_datetime
; 0000 0302 
; 0000 0303 
; 0000 0304 //            dataTrans(MAY1);
; 0000 0305             chuTrinhMay1 = OFF;
	CBI  0x1E,0
; 0000 0306             timeSetOn1 = timeSet;
	LDI  R30,LOW(20)
	MOV  R13,R30
; 0000 0307             delay_ms(100);
	CALL SUBOPT_0x14
; 0000 0308             dataTrans(MAY1);
	LDI  R26,LOW(1)
	RCALL _dataTrans
; 0000 0309         }
; 0000 030A         //========================================================
; 0000 030B 
; 0000 030C         //========================================================
; 0000 030D         //GHI THOI GIAN IN OUT SENSSOR 2
; 0000 030E //        if(IN3 == OFF && chuTrinhMay2 == OFF && timeSetOn2 == 0)
; 0000 030F         if(IN4 == ON && chuTrinhMay2 == OFF && timeSetOn2 == 0)
_0x82:
	SBIS 0x3,0
	RJMP _0x8E
	SBIC 0x1E,1
	RJMP _0x8E
	LDS  R26,_timeSetOn2
	CPI  R26,LOW(0x0)
	BREQ _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 0310         {
; 0000 0311             chuTrinhMay2 = ON;
	SBI  0x1E,1
; 0000 0312             demIN4 = 0;      //khoi tao dem so lan kich sensor out
	LDI  R30,LOW(0)
	STS  _demIN4,R30
; 0000 0313             read_ds3231_datetime(&realTimeIn2);     //may 2  // doc lan 1 tinh time thao tac
	LDI  R26,LOW(_realTimeIn2)
	LDI  R27,HIGH(_realTimeIn2)
	RCALL _read_ds3231_datetime
; 0000 0314 
; 0000 0315             //tinh time thao tac tu lan ra truoc toi lan vao tiep theo
; 0000 0316             if ((realTimeOut2.hour || realTimeOut2.minute || realTimeOut2.second) != 0)
	__GETB1MN _realTimeOut2,2
	CPI  R30,0
	BRNE _0x93
	__GETB1MN _realTimeOut2,1
	CPI  R30,0
	BRNE _0x93
	LDS  R30,_realTimeOut2
	CPI  R30,0
	BRNE _0x93
	RJMP _0x92
_0x93:
; 0000 0317             {
; 0000 0318                 if (realTimeIn2.second >= realTimeOut2.second)
	LDS  R30,_realTimeOut2
	LDS  R26,_realTimeIn2
	CP   R26,R30
	BRLO _0x95
; 0000 0319                     timeThaoTac2.second = realTimeIn2.second - realTimeOut2.second;
	LDS  R26,_realTimeOut2
	LDS  R30,_realTimeIn2
	SUB  R30,R26
	STS  _timeThaoTac2,R30
; 0000 031A                 else
	RJMP _0x96
_0x95:
; 0000 031B                 {
; 0000 031C                     timeThaoTac2.second = realTimeIn2.second + 60 - realTimeOut2.second;
	LDS  R30,_realTimeIn2
	SUBI R30,-LOW(60)
	LDS  R26,_realTimeOut2
	SUB  R30,R26
	STS  _timeThaoTac2,R30
; 0000 031D                     realTimeIn2.minute = realTimeIn2.minute - 1;
	__GETB1MN _realTimeIn2,1
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn2,1
; 0000 031E                 }
_0x96:
; 0000 031F                 if (realTimeIn2.minute >= realTimeOut2.minute)
	__GETB2MN _realTimeIn2,1
	__GETB1MN _realTimeOut2,1
	CP   R26,R30
	BRLO _0x97
; 0000 0320                     timeThaoTac2.minute = realTimeIn2.minute - realTimeOut2.minute;
	__GETB1MN _realTimeIn2,1
	__GETB2MN _realTimeOut2,1
	SUB  R30,R26
	__PUTB1MN _timeThaoTac2,1
; 0000 0321                 else
	RJMP _0x98
_0x97:
; 0000 0322                 {
; 0000 0323                     timeThaoTac2.minute = realTimeIn2.minute + 60 - realTimeOut2.minute;
	__GETB1MN _realTimeIn2,1
	SUBI R30,-LOW(60)
	__GETB2MN _realTimeOut2,1
	SUB  R30,R26
	__PUTB1MN _timeThaoTac2,1
; 0000 0324                     realTimeIn2.hour = realTimeIn2.hour - 1;
	__GETB1MN _realTimeIn2,2
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn2,2
; 0000 0325                 }
_0x98:
; 0000 0326                 if (realTimeIn2.hour >= realTimeOut2.hour)
	__GETB2MN _realTimeIn2,2
	__GETB1MN _realTimeOut2,2
	CP   R26,R30
	BRLO _0x99
; 0000 0327                     timeThaoTac2.hour = realTimeIn2.hour - realTimeOut2.hour;
	__GETB1MN _realTimeIn2,2
	__GETB2MN _realTimeOut2,2
	SUB  R30,R26
	__PUTB1MN _timeThaoTac2,2
; 0000 0328                 else
	RJMP _0x9A
_0x99:
; 0000 0329                 {
; 0000 032A                     timeThaoTac2.hour = realTimeIn2.hour + 24 - realTimeOut2.hour;
	__GETB1MN _realTimeIn2,2
	SUBI R30,-LOW(24)
	__GETB2MN _realTimeOut2,2
	SUB  R30,R26
	__PUTB1MN _timeThaoTac2,2
; 0000 032B                     realTimeIn2.day = realTimeIn2.day - 1;
	__GETB1MN _realTimeIn2,3
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeIn2,3
; 0000 032C                 }
_0x9A:
; 0000 032D 
; 0000 032E //                DE = 1;
; 0000 032F //                printf("Time thao tac may 2: %02u:%02u:%02u\r\n",
; 0000 0330 //                    timeThaoTac2.hour, timeThaoTac2.minute, timeThaoTac2.second);
; 0000 0331 //                DE = 0;
; 0000 0332             }
; 0000 0333             read_ds3231_datetime(&realTimeIn2);     //may 2   //doc lan 2 de luu lai gia tri vao
_0x92:
	LDI  R26,LOW(_realTimeIn2)
	LDI  R27,HIGH(_realTimeIn2)
	RCALL _read_ds3231_datetime
; 0000 0334 //            DE = 1;
; 0000 0335 //            printf("Time lieu vao may 2: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
; 0000 0336 //                realTimeIn2.hour, realTimeIn2.minute, realTimeIn2.second,
; 0000 0337 //                realTimeIn2.date, realTimeIn2.month, realTimeIn2.year);
; 0000 0338 //            DE = 0;
; 0000 0339 
; 0000 033A //            chuTrinhMay2 = ON;
; 0000 033B             timeSetOn2 = timeSet;
	LDI  R30,LOW(20)
	STS  _timeSetOn2,R30
; 0000 033C //            delay_ms(200);
; 0000 033D         }
; 0000 033E 
; 0000 033F //        if(IN4 == OFF && chuTrinhMay2 == ON && timeSetOn2 == 0)
; 0000 0340         if(IN4 == OFF && chuTrinhMay2 == ON && timeSetOn2 == 0 && demIN4 == 0)      //IN4  0->1: lieu ra        //demIN2 ...
_0x8D:
	SBIC 0x3,0
	RJMP _0x9C
	SBIS 0x1E,1
	RJMP _0x9C
	LDS  R26,_timeSetOn2
	CPI  R26,LOW(0x0)
	BRNE _0x9C
	LDS  R26,_demIN4
	CPI  R26,LOW(0x0)
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 0341         {
; 0000 0342             demIN4 = 1;
	LDI  R30,LOW(1)
	STS  _demIN4,R30
; 0000 0343         }
; 0000 0344 
; 0000 0345         if(IN4 == OFF && chuTrinhMay2 == ON && timeSetOn2 == 0 && demIN4 == 1)     //IN4  0->1: lieu ra        //demIN2  ...
_0x9B:
	SBIC 0x3,0
	RJMP _0x9F
	SBIS 0x1E,1
	RJMP _0x9F
	LDS  R26,_timeSetOn2
	CPI  R26,LOW(0x0)
	BRNE _0x9F
	LDS  R26,_demIN4
	CPI  R26,LOW(0x1)
	BREQ _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 0346         {
; 0000 0347             demIN4 = 2;
	LDI  R30,LOW(2)
	STS  _demIN4,R30
; 0000 0348             timeThaoTac2.hour   = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _timeThaoTac2,2
; 0000 0349             timeThaoTac2.minute = 0;
	__PUTB1MN _timeThaoTac2,1
; 0000 034A             timeThaoTac2.second = 0;
	STS  _timeThaoTac2,R30
; 0000 034B 
; 0000 034C             read_ds3231_datetime(&realTimeOut2);    //may 2     // doc lan 1 tinh time thao tac
	LDI  R26,LOW(_realTimeOut2)
	LDI  R27,HIGH(_realTimeOut2)
	RCALL _read_ds3231_datetime
; 0000 034D //            DE = 1;
; 0000 034E //            printf("Time lieu ra may 2: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
; 0000 034F //                realTimeOut2.hour, realTimeOut2.minute, realTimeOut2.second,
; 0000 0350 //                realTimeOut2.date, realTimeOut2.month, realTimeOut2.year);
; 0000 0351 //            DE = 0;
; 0000 0352 
; 0000 0353 
; 0000 0354             //tinh time luu hoa may 2
; 0000 0355             timeLuuHoa2.hour = realTimeOut2.hour - realTimeIn2.hour;
	CALL SUBOPT_0x18
; 0000 0356             timeLuuHoa2.minute = realTimeOut2.minute - realTimeIn2.minute;
	CALL SUBOPT_0x19
; 0000 0357             timeLuuHoa2.second = realTimeOut2.second - realTimeIn2.second;
	CALL SUBOPT_0x1A
; 0000 0358 
; 0000 0359             if (realTimeOut2.second >= realTimeIn2.second)
	LDS  R30,_realTimeIn2
	LDS  R26,_realTimeOut2
	CP   R26,R30
	BRLO _0xA1
; 0000 035A                 timeLuuHoa2.second = realTimeOut2.second - realTimeIn2.second;
	CALL SUBOPT_0x1A
; 0000 035B             else
	RJMP _0xA2
_0xA1:
; 0000 035C             {
; 0000 035D                 timeLuuHoa2.second = realTimeOut2.second + 60 - realTimeIn2.second;
	LDS  R30,_realTimeOut2
	SUBI R30,-LOW(60)
	LDS  R26,_realTimeIn2
	SUB  R30,R26
	STS  _timeLuuHoa2,R30
; 0000 035E                 realTimeOut2.minute = realTimeOut2.minute - 1;
	__GETB1MN _realTimeOut2,1
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut2,1
; 0000 035F             }
_0xA2:
; 0000 0360             if (realTimeOut2.minute >= realTimeIn2.minute)
	__GETB2MN _realTimeOut2,1
	__GETB1MN _realTimeIn2,1
	CP   R26,R30
	BRLO _0xA3
; 0000 0361                 timeLuuHoa2.minute = realTimeOut2.minute - realTimeIn2.minute;
	CALL SUBOPT_0x19
; 0000 0362             else
	RJMP _0xA4
_0xA3:
; 0000 0363             {
; 0000 0364                 timeLuuHoa2.minute = realTimeOut2.minute + 60 - realTimeIn2.minute;
	__GETB1MN _realTimeOut2,1
	SUBI R30,-LOW(60)
	__GETB2MN _realTimeIn2,1
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa2,1
; 0000 0365                 realTimeOut2.hour = realTimeOut2.hour - 1;
	__GETB1MN _realTimeOut2,2
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut2,2
; 0000 0366             }
_0xA4:
; 0000 0367             if (realTimeOut2.hour >= realTimeIn2.hour)
	__GETB2MN _realTimeOut2,2
	__GETB1MN _realTimeIn2,2
	CP   R26,R30
	BRLO _0xA5
; 0000 0368                 timeLuuHoa2.hour = realTimeOut2.hour - realTimeIn2.hour;
	CALL SUBOPT_0x18
; 0000 0369             else
	RJMP _0xA6
_0xA5:
; 0000 036A             {
; 0000 036B                 timeLuuHoa2.hour = realTimeOut2.hour + 24 - realTimeIn2.hour;
	__GETB1MN _realTimeOut2,2
	SUBI R30,-LOW(24)
	__GETB2MN _realTimeIn2,2
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa2,2
; 0000 036C                 realTimeOut2.day = realTimeOut2.day - 1;
	__GETB1MN _realTimeOut2,3
	SUBI R30,LOW(1)
	__PUTB1MN _realTimeOut2,3
; 0000 036D             }
_0xA6:
; 0000 036E 
; 0000 036F //            DE = 1;
; 0000 0370 //            printf("Time Luu Hoa may 2: %02u:%02u:%02u\r\n",
; 0000 0371 //                timeLuuHoa2.hour, timeLuuHoa2.minute, timeLuuHoa2.second);
; 0000 0372 //            DE = 0;
; 0000 0373 
; 0000 0374             read_ds3231_datetime(&realTimeOut2);    //may 2  //doc lan 2 luu lai gia tri time out
	LDI  R26,LOW(_realTimeOut2)
	LDI  R27,HIGH(_realTimeOut2)
	RCALL _read_ds3231_datetime
; 0000 0375 
; 0000 0376 //            dataTrans(MAY2);
; 0000 0377             chuTrinhMay2 = OFF;
	CBI  0x1E,1
; 0000 0378             timeSetOn2 = timeSet;
	LDI  R30,LOW(20)
	STS  _timeSetOn2,R30
; 0000 0379             delay_ms(100);
	CALL SUBOPT_0x14
; 0000 037A             dataTrans(MAY2);
	LDI  R26,LOW(2)
	RCALL _dataTrans
; 0000 037B         }
; 0000 037C         //========================================================
; 0000 037D     }
_0x9E:
	RJMP _0x68
; 0000 037E }
_0xA9:
	RJMP _0xA9
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_buff_rx:
	.BYTE 0x32
_buff_tx:
	.BYTE 0x32
_timeSetOn2:
	.BYTE 0x1
_demIN2:
	.BYTE 0x1
_demIN4:
	.BYTE 0x1
_current:
	.BYTE 0x7
_realTimeIn1:
	.BYTE 0x7
_realTimeOut1:
	.BYTE 0x7
_realTimeOut1_QK:
	.BYTE 0x7
_realTimeIn2:
	.BYTE 0x7
_realTimeOut2:
	.BYTE 0x7
_timeLuuHoa1:
	.BYTE 0x7
_timeLuuHoa2:
	.BYTE 0x7
_timeThaoTac1:
	.BYTE 0x7
_timeThaoTac2:
	.BYTE 0x7
_realTimeInX1:
	.BYTE 0x7
_realTimeOutX1:
	.BYTE 0x7
_timeLuuHoaX1:
	.BYTE 0x7
_timeThaoTacX1:
	.BYTE 0x7
_realTimeInX2:
	.BYTE 0x7
_realTimeOutX2:
	.BYTE 0x7
_timeLuuHoaX2:
	.BYTE 0x7
_timeThaoTacX2:
	.BYTE 0x7
_set_time:
	.BYTE 0x7
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(188)
	STS  133,R30
	LDI  R30,LOW(128)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(0)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2:
	CALL _dec_to_bcd
	MOV  R26,R30
	CALL _i2c_write
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd_to_dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	STS  _buff_tx,R3
	__PUTBMRN _buff_tx,1,5
	MOV  R30,R9
	LSL  R30
	__PUTB1MN _buff_tx,2
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__PUTB1MN _buff_tx,6
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	__PUTB1MN _buff_tx,8
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__PUTB1MN _buff_tx,10
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__PUTB1MN _buff_tx,12
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__PUTB1MN _buff_tx,14
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__PUTB1MN _buff_tx,16
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__PUTB1MN _buff_tx,18
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	__PUTB1MN _buff_tx,20
	LDI  R30,LOW(0)
	__PUTB1MN _buff_tx,21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CALL _CRC_Check
	__PUTW1R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	SBI  0xB,2
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_buff_tx)
	SBCI R31,HIGH(-_buff_tx)
	LD   R26,Z
	JMP  _send1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOV  R26,R6
	LDI  R27,0
	SUBI R26,LOW(-_buff_rx)
	SBCI R27,HIGH(-_buff_rx)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_buff_rx)
	LDI  R31,HIGH(_buff_rx)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R6
	SUBI R26,LOW(1)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOV  R30,R6
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_buff_rx)
	SBCI R31,HIGH(-_buff_rx)
	LD   R26,Z
	CP   R11,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _epprom_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__GETB1MN _realTimeOut1,2
	__GETB2MN _realTimeIn1,2
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa1,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__GETB1MN _realTimeOut1,1
	__GETB2MN _realTimeIn1,1
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa1,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDS  R26,_realTimeIn1
	LDS  R30,_realTimeOut1
	SUB  R30,R26
	STS  _timeLuuHoa1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	__GETB1MN _realTimeOut2,2
	__GETB2MN _realTimeIn2,2
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa2,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__GETB1MN _realTimeOut2,1
	__GETB2MN _realTimeIn2,1
	SUB  R30,R26
	__PUTB1MN _timeLuuHoa2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDS  R26,_realTimeIn2
	LDS  R30,_realTimeOut2
	SUB  R30,R26
	STS  _timeLuuHoa2,R30
	RET


	.CSEG
	.equ __sda_bit=4
	.equ __scl_bit=5
	.equ __i2c_port=0x08 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
