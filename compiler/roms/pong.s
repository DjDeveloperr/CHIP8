fn_00d4:
  ld I, #754                  ; 0xa2f2 @ 0x02d4
  ld I, Ve.B                  ; 0xfe33 @ 0x02d6
  ld V2, I                    ; 0xf265 @ 0x02d8
  ld I, V1.F                  ; 0xf129 @ 0x02da
  ld V4, #20                  ; 0x6414 @ 0x02dc
  ld V5, #0                   ; 0x6500 @ 0x02de
  drw V4, V5                  ; 0xd455 @ 0x02e0
  add V4, #21                 ; 0x7415 @ 0x02e2
  ld I, V2.F                  ; 0xf229 @ 0x02e4
  drw V4, V5                  ; 0xd455 @ 0x02e6
  ret                         ; 0x00ee @ 0x02e8
main:
  ld Va, #2                   ; 0x6a02 @ 0x0200
  ld Vb, #12                  ; 0x6b0c @ 0x0202
  ld Vc, #63                  ; 0x6c3f @ 0x0204
  ld Vd, #12                  ; 0x6d0c @ 0x0206
  ld I, #746                  ; 0xa2ea @ 0x0208
  drw Va, Vb                  ; 0xdab6 @ 0x020a
  drw Vc, Vd                  ; 0xdcd6 @ 0x020c
  ld Ve, #0                   ; 0x6e00 @ 0x020e
  call fn_00d4                ; 0x22d4 @ 0x0210
  ld V6, #3                   ; 0x6603 @ 0x0212
  ld V8, #2                   ; 0x6802 @ 0x0214
  ld V0, #96                  ; 0x6060 @ 0x0216
  ld DT, V0                   ; 0xf015 @ 0x0218
  ld V0, DT                   ; 0xf007 @ 0x021a
  se V0, #0                   ; 0x3000 @ 0x021c
  jmp #0x021a                 ; 0x121a @ 0x021e
  rnd V7, #23                 ; 0xc717 @ 0x0220
  add V7, #8                  ; 0x7708 @ 0x0222
  ld V9, #255                 ; 0x69ff @ 0x0224
  ld I, #752                  ; 0xa2f0 @ 0x0226
  drw V6, V7                  ; 0xd671 @ 0x0228
  ld I, #746                  ; 0xa2ea @ 0x022a
  drw Va, Vb                  ; 0xdab6 @ 0x022c
  drw Vc, Vd                  ; 0xdcd6 @ 0x022e
  ld V0, #1                   ; 0x6001 @ 0x0230
  sknp V0                     ; 0xe0a1 @ 0x0232
  add Vb, #254                ; 0x7bfe @ 0x0234
  ld V0, #4                   ; 0x6004 @ 0x0236
  sknp V0                     ; 0xe0a1 @ 0x0238
  add Vb, #2                  ; 0x7b02 @ 0x023a
  ld V0, #31                  ; 0x601f @ 0x023c
  and Vb, V0                  ; 0x8b02 @ 0x023e
  drw Va, Vb                  ; 0xdab6 @ 0x0240
  ld V0, #12                  ; 0x600c @ 0x0242
  sknp V0                     ; 0xe0a1 @ 0x0244
  add Vd, #254                ; 0x7dfe @ 0x0246
  ld V0, #13                  ; 0x600d @ 0x0248
  sknp V0                     ; 0xe0a1 @ 0x024a
  add Vd, #2                  ; 0x7d02 @ 0x024c
  ld V0, #31                  ; 0x601f @ 0x024e
  and Vd, V0                  ; 0x8d02 @ 0x0250
  drw Vc, Vd                  ; 0xdcd6 @ 0x0252
  ld I, #752                  ; 0xa2f0 @ 0x0254
  drw V6, V7                  ; 0xd671 @ 0x0256
  add V6, V8                  ; 0x8684 @ 0x0258
  add V7, V9                  ; 0x8794 @ 0x025a
  ld V0, #63                  ; 0x603f @ 0x025c
  and V6, V0                  ; 0x8602 @ 0x025e
  ld V1, #31                  ; 0x611f @ 0x0260
  and V7, V1                  ; 0x8712 @ 0x0262
  sne V6, #2                  ; 0x4602 @ 0x0264
  jmp #0x0278                 ; 0x1278 @ 0x0266
  sne V6, #63                 ; 0x463f @ 0x0268
  jmp #0x0282                 ; 0x1282 @ 0x026a
  sne V7, #31                 ; 0x471f @ 0x026c
  ld V9, #255                 ; 0x69ff @ 0x026e
  sne V7, #0                  ; 0x4700 @ 0x0270
  ld V9, #1                   ; 0x6901 @ 0x0272
  drw V6, V7                  ; 0xd671 @ 0x0274
  jmp #0x022a                 ; 0x122a @ 0x0276
  ld V8, #2                   ; 0x6802 @ 0x0278
  ld V3, #1                   ; 0x6301 @ 0x027a
  ld V0, V7                   ; 0x8070 @ 0x027c
  sub V0, Vb                  ; 0x80b5 @ 0x027e
  jmp #0x028a                 ; 0x128a @ 0x0280
  ld V8, #254                 ; 0x68fe @ 0x0282
  ld V3, #10                  ; 0x630a @ 0x0284
  ld V0, V7                   ; 0x8070 @ 0x0286
  sub V0, Vd                  ; 0x80d5 @ 0x0288
  se Vf, #1                   ; 0x3f01 @ 0x028a
  jmp #0x02a2                 ; 0x12a2 @ 0x028c
  ld V1, #2                   ; 0x6102 @ 0x028e
  sub V0, V1                  ; 0x8015 @ 0x0290
  se Vf, #1                   ; 0x3f01 @ 0x0292
  jmp #0x02ba                 ; 0x12ba @ 0x0294
  sub V0, V1                  ; 0x8015 @ 0x0296
  se Vf, #1                   ; 0x3f01 @ 0x0298
  jmp #0x02c8                 ; 0x12c8 @ 0x029a
  sub V0, V1                  ; 0x8015 @ 0x029c
  se Vf, #1                   ; 0x3f01 @ 0x029e
  jmp #0x02c2                 ; 0x12c2 @ 0x02a0
  ld V0, #32                  ; 0x6020 @ 0x02a2
  ld ST, V0                   ; 0xf018 @ 0x02a4
  call fn_00d4                ; 0x22d4 @ 0x02a6
  add Ve, V3                  ; 0x8e34 @ 0x02a8
  call fn_00d4                ; 0x22d4 @ 0x02aa
  ld V6, #62                  ; 0x663e @ 0x02ac
  se V3, #1                   ; 0x3301 @ 0x02ae
  ld V6, #3                   ; 0x6603 @ 0x02b0
  ld V8, #254                 ; 0x68fe @ 0x02b2
  se V3, #1                   ; 0x3301 @ 0x02b4
  ld V8, #2                   ; 0x6802 @ 0x02b6
  jmp #0x0216                 ; 0x1216 @ 0x02b8
  add V9, #255                ; 0x79ff @ 0x02ba
  sne V9, #254                ; 0x49fe @ 0x02bc
  ld V9, #255                 ; 0x69ff @ 0x02be
  jmp #0x02c8                 ; 0x12c8 @ 0x02c0
  add V9, #1                  ; 0x7901 @ 0x02c2
  sne V9, #2                  ; 0x4902 @ 0x02c4
  ld V9, #1                   ; 0x6901 @ 0x02c6
  ld V0, #4                   ; 0x6004 @ 0x02c8
  ld ST, V0                   ; 0xf018 @ 0x02ca
  add V6, #1                  ; 0x7601 @ 0x02cc
  sne V6, #64                 ; 0x4640 @ 0x02ce
  add V6, #254                ; 0x76fe @ 0x02d0
  jmp #0x026c                 ; 0x126c @ 0x02d2
data:
  dat 0x8080                  ; 0x8080 @ 0x02ea
  dat 0x8080                  ; 0x8080 @ 0x02ec
  dat 0x8080                  ; 0x8080 @ 0x02ee
  dat 0x8000                  ; 0x8000 @ 0x02f0
  dat 0x0000                  ; 0x0000 @ 0x02f2
  dat 0x0000                  ; 0x0000 @ 0x02f4