v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 60 -110 60 -90 {lab=#net1}
N -190 30 -190 50 {lab=0}
N -190 -50 -190 -30 {lab=VDD}
N 60 -180 60 -160 {lab=0}
N -115 30 -115 40 {lab=0}
N -115 -60 -115 -30 {lab=#net2}
N -115 -60 -45 -60 {lab=#net2}
N 70 40 70 60 {lab=0}
N 90 -110 90 -90 {lab=VDD}
N 90 -110 110 -110 {lab=VDD}
N 190 -30 220 -30 {lab=#net3}
N -52.5 -0 -0 0 {lab=#net4}
N -45 -60 -0 -60 {lab=#net2}
N -52.5 60 -52.5 70 {lab=0}
C {vsource.sym} -190 0 0 0 {name=V1 value=1.8 savecurrent=false}
C {vsource.sym} -115 0 0 0 {name=V2 value=0.90 savecurrent=false}
C {isource.sym} 60 -133.3274088887357 0 0 {name=I0 value=12u}
C {gnd.sym} -190 50 0 0 {name=l1 lab=0}
C {lab_pin.sym} -190 -50 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {gnd.sym} 60 -180 2 0 {name=l2 lab=0}
C {gnd.sym} -115 40 0 0 {name=l3 lab=0}
C {gnd.sym} 70 60 0 0 {name=l4 lab=0}
C {lab_pin.sym} 110 -110 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {noconn.sym} 220 -30 0 0 {name=l5}
C {sky130_fd_pr/corner.sym} -275 -225 0 0 {name=CORNER only_toplevel=true corner=tt}
C {code_shown.sym} -160 -235 0 0 {name=Spice directive only_toplevel=false value="
.control
op
save all
write OTA_tb.raw all
.endc
"}
C {devices/launcher.sym} 70 -235 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {ngspice_get_value.sym} 270 -140 0 0 {name=r1 node=@m.x1.xm3.msky130_fd_pr__nfet_01v8[gm]
descr="M3 gm="}
C {ngspice_get_value.sym} 270 -110 0 0 {name=r2 node=@m.x1.xm4.msky130_fd_pr__nfet_01v8[gm]
descr="M4 gm="}
C {ngspice_get_value.sym} 270 -80 0 0 {name=r3 node=@m.x1.xm5.msky130_fd_pr__pfet_01v8[gm]
descr="M5 gm="}
C {ngspice_get_value.sym} 270 -50 0 0 {name=r4 node=@m.x1.xm6.msky130_fd_pr__pfet_01v8[gm]
descr="M6 gm="}
C {code.sym} -395 -230 0 0 {name=Op save only_toplevel=false value=".save @m.x1.xm3.msky130_fd_pr__nfet_01v8[gm]
.save @m.x1.xm4.msky130_fd_pr__nfet_01v8[gm]
.save @m.x1.xm5.msky130_fd_pr__pfet_01v8[gm]
.save @m.x1.xm6.msky130_fd_pr__pfet_01v8[gm]
.save @m.x1.xm3.msky130_fd_pr__nfet_01v8[id]
.save @m.x1.xm4.msky130_fd_pr__nfet_01v8[id]
.save @m.x1.xm5.msky130_fd_pr__pfet_01v8[id]
.save @m.x1.xm6.msky130_fd_pr__pfet_01v8[id]
.save @m.x1.xm3.msky130_fd_pr__nfet_01v8[vgs]
.save @m.x1.xm4.msky130_fd_pr__nfet_01v8[vgs]
.save @m.x1.xm5.msky130_fd_pr__pfet_01v8[vgs]
.save @m.x1.xm6.msky130_fd_pr__pfet_01v8[vgs]
.save @m.x1.xm3.msky130_fd_pr__nfet_01v8[vds]
.save @m.x1.xm4.msky130_fd_pr__nfet_01v8[vds]
.save @m.x1.xm5.msky130_fd_pr__pfet_01v8[vds]
.save @m.x1.xm6.msky130_fd_pr__pfet_01v8[vds]
.save @m.x1.xm3.msky130_fd_pr__nfet_01v8[gds]
.save @m.x1.xm4.msky130_fd_pr__nfet_01v8[gds]
.save @m.x1.xm5.msky130_fd_pr__pfet_01v8[gds]
.save @m.x1.xm6.msky130_fd_pr__pfet_01v8[gds]
"}
C {ngspice_get_value.sym} 330 -145 0 0 {name=r5 node=@m.x1.xm3.msky130_fd_pr__nfet_01v8[gds]
descr="M3 gds="}
C {ngspice_get_value.sym} 330 -115 0 0 {name=r6 node=@m.x1.xm4.msky130_fd_pr__nfet_01v8[gds]
descr="M4 gds="}
C {ngspice_get_value.sym} 330 -85 0 0 {name=r7 node=@m.x1.xm5.msky130_fd_pr__pfet_01v8[gds]
descr="M5 gds="}
C {ngspice_get_value.sym} 330 -55 0 0 {name=r8 node=@m.x1.xm6.msky130_fd_pr__pfet_01v8[gds]
descr="M6 gds="}
C {ngspice_get_value.sym} 395 -145 0 0 {name=r9 node=i(@m.x1.xm3.msky130_fd_pr__nfet_01v8[id])
descr="M3 id="}
C {ngspice_get_value.sym} 395 -115 0 0 {name=r10 node=i(@m.x1.xm4.msky130_fd_pr__nfet_01v8[id])
descr="M4 id="}
C {ngspice_get_value.sym} 395 -85 0 0 {name=r11 node=i(@m.x1.xm5.msky130_fd_pr__pfet_01v8[id])
descr="M5 id="}
C {ngspice_get_value.sym} 395 -55 0 0 {name=r12 node=i(@m.x1.xm6.msky130_fd_pr__pfet_01v8[id])
descr="M6 id="}
C {ngspice_get_value.sym} 465 -150 0 0 {name=r13 node=v(@m.x1.xm3.msky130_fd_pr__nfet_01v8[vds])
descr="M3 vds="}
C {ngspice_get_value.sym} 465 -120 0 0 {name=r14 node=v(@m.x1.xm4.msky130_fd_pr__nfet_01v8[vds])
descr="M4 vds="}
C {ngspice_get_value.sym} 465 -90 0 0 {name=r15 node=v(@m.x1.xm5.msky130_fd_pr__pfet_01v8[vds])
descr="M5 vds="}
C {ngspice_get_value.sym} 465 -60 0 0 {name=r16 node=v(@m.x1.xm6.msky130_fd_pr__pfet_01v8[vds])
descr="M6 vds="}
C {ngspice_get_value.sym} 525 -145 0 0 {name=r17 node=v(@m.x1.xm3.msky130_fd_pr__nfet_01v8[vgs])
descr="M3 vgs="}
C {ngspice_get_value.sym} 525 -115 0 0 {name=r18 node=v(@m.x1.xm4.msky130_fd_pr__nfet_01v8[vgs])
descr="M4 vgs="}
C {ngspice_get_value.sym} 525 -85 0 0 {name=r19 node=v(@m.x1.xm5.msky130_fd_pr__pfet_01v8[vgs])
descr="M5 vgs="}
C {ngspice_get_value.sym} 525 -55 0 0 {name=r20 node=v(@m.x1.xm6.msky130_fd_pr__pfet_01v8[vgs])
descr="M6 vgs="}
C {vsource.sym} -52.5 30 0 0 {name=V3 value=0.90 savecurrent=false}
C {gnd.sym} -52.5 70 0 0 {name=l6 lab=0}
C {../../../common/analog/ota5t/OTA_5T.sym} 70 -30 0 0 {name=x1}
