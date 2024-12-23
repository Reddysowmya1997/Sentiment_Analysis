* HSPICE Deck for a 2 to 4 decoder

.include '45nm_bsim4.txt'

.tran 50p 20ns
.options post
.temp 100 

vSupply Vdd 0 1.1V
vGround Vss 0 0V

.global Vdd
.global Vss

vcc Vcc 0 1.5V
vee Vee 0 -1.5V	

.param length=45n
.param wnmos=90n
.param wpmos=225n

************Sub-Circuit for a NAND Gate*******************
.subckt NAND in1 in2 op
*Trnstr Drain Gate Source Substrate Type Width   Length
 M1     op    in1  Vdd    Vcc       PMOS W=wpmos L=length
 M2     op    in2  Vdd    Vcc       PMOS W=wpmos L=length
 M4     op    in1  N1     Vee       NMOS W=wnmos L=length
 M5     N1    in1  N2     Vee       NMOS W=wnmos L=length     
.ends

************Sub-Circuit for an Inverter*******************
.subckt INVERTER in out
*Trnstr Drain Gate Source Substrate Type Width      Length
 M7    out    in   Vdd    Vcc       PMOS W=300n    L=length
 M8    out    in   Vss    Vee       NMOS W=wnmos    L=length
.ends

xinv1 A A0 INVERTER
xinv2 B B0 INVERTER

xnand1 A0 B0  Y0 NAND 
xnand2 A  B0  Y1 NAND 
xnand3 A0 B   Y2 NAND
xnand4 A  B   Y3 NAND 

xinv4 Y0 Q0 INVERTER
xinv5 Y1 Q1 INVERTER
xinv6 Y2 Q2 INVERTER
xinv7 Y3 Q3 INVERTER

VA A Vss pulse (0 0 1.99ns 0.01ns 0.01ns 1.99ns 4ns)
VB B Vss pulse (0 0 0.99ns 0.01ns 0.01ns 0.99ns 2ns) 
.measure tran leakage0 rms I(vSupply) FROM=0n TO=20n
.print leakage0 

.alter
.tran 50p 20ns
VA A Vss pulse (0 0 1.99ns 0.01ns 0.01ns 1.99ns 4ns)
VB B Vss pulse (0 1.1 0.99ns 0.01ns 0.01ns 0.99ns 2ns) 
.measure tran leakage1 rms I(vSupply) FROM=0n TO=20n
.print leakage1 

.alter
.tran 50p 20ns
VA A Vss pulse (0 1.1 1.99ns 0.01ns 0.01ns 1.99ns 4ns)
VB B Vss pulse (0 0 0.99ns 0.01ns 0.01ns 0.99ns 2ns) 
.measure tran leakage2 rms I(vSupply) FROM=0n TO=20n
.print leakage2

.alter
.tran 50p 20ns
VA A Vss pulse (0 1.1 1.99ns 0.01ns 0.01ns 1.99ns 4ns)
VB B Vss pulse (0 1.1 0.99ns 0.01ns 0.01ns 0.99ns 2ns) 
.measure tran leakage3 rms I(vSupply) FROM=0n TO=20n
.print leakage3

.end