v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 325 -105 1125 295 {flags=graph
y1=-150
y2=-0.00037
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=9
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
node=ph(vout)
color=4
dataset=-1
unitx=1
logx=1
logy=0
hcursor1_y=-49.813242
hilight_wave=0}
B 2 325 -505 1125 -105 {flags=graph
y1=-40
y2=41
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=9
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
color=4
node="\\"GainDB; v(vout) log10() 20 *\\""
hcursor1_y=37
hilight_wave=0}
N -120 -60 0 -60 {lab=#net1}
N -30 -0 -0 -0 {lab=#net2}
N -120 0 -120 80 {lab=0}
N -120 80 -80 80 {lab=0}
N -80 80 -30 80 {lab=0}
N -30 60 -30 80 {lab=0}
N 70 40 70 80 {lab=0}
N -30 80 70 80 {lab=0}
N -280 10 -280 40 {lab=0}
N -280 -100 -280 -50 {lab=VDD}
N 90 -130 90 -90 {lab=VDD}
N 60 -150 60 -90 {lab=#net3}
N 60 -240 60 -210 {lab=0}
N 190 -30 260 -30 {lab=Vout}
N 260 30 260 50 {lab=0}
C {vsource.sym} -120 -30 0 0 {name=V1 value="DC 0.9 AC -0.5" savecurrent=false}
C {vsource.sym} -30 30 0 0 {name=V2 value="DC 0.9 AC 0.5" savecurrent=false}
C {gnd.sym} -80 80 0 0 {name=l1 lab=0}
C {vsource.sym} -280 -20 0 0 {name=V3 value=1.8 savecurrent=false}
C {gnd.sym} -280 40 0 0 {name=l2 lab=0}
C {lab_pin.sym} -280 -100 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 90 -130 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {isource.sym} 60 -180 0 0 {name=I0 value=12.56u}
C {gnd.sym} 60 -240 2 0 {name=l3 lab=0}
C {lab_pin.sym} 260 -30 0 0 {name=p3 sig_type=std_logic lab=Vout}
C {capa-2.sym} 260 0 0 0 {name=CLoad
m=1
value=1p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 260 50 0 0 {name=l4 lab=0}
C {sky130_fd_pr/corner.sym} -300 -270 0 0 {name=CORNER only_toplevel=true corner=tt}
C {code_shown.sym} -310 -480 0 0 {name=Spice directive only_toplevel=false value="
.control
ac dec 1000 1 1G
let gain_db=20*log10(mag(v(vout)))
let phase= ph(v(vout))
save all
write OTA_5T_ac_tb.raw all
.endc
"}
C {../../../common/analog/ota5t/OTA_5T.sym} 70 -30 0 0 {name=x1}
