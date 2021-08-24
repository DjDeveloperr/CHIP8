main:
  jmp #0x0218                 ; 0x1218 @ 0x0200
  se V4, V4                   ; 0x5449 @ 0x0202
  sne V3, #84                 ; 0x4354 @ 0x0204
  sne V1, #67                 ; 0x4143 @ 0x0206
  call #0x0062                ; 0x2062 @ 0x0208
  add V9, #32                 ; 0x7920 @ 0x020a
  sne V4, #97                 ; 0x4461 @ 0x020c
  add V6, #105                ; 0x7669 @ 0x020e
  ld V4, #32                  ; 0x6420 @ 0x0210
  se V7, V4                   ; 0x5749 @ 0x0212
  sne Ve, #84                 ; 0x4e54 @ 0x0214
  sne V5, #82                 ; 0x4552 @ 0x0216
  ld Vb, #0                   ; 0x6b00 @ 0x0218
  ld Vc, #0                   ; 0x6c00 @ 0x021a
  ld V0, Vb                   ; 0x80b0 @ 0x021c
  ld V1, Vc                   ; 0x81c0 @ 0x021e
  ld I, #998                  ; 0xa3e6 @ 0x0220
  ld I, V1                    ; 0xf155 @ 0x0222
  ld I, #964                  ; 0xa3c4 @ 0x0224
  ld Vf, I                    ; 0xff65 @ 0x0226
  ld I, #948                  ; 0xa3b4 @ 0x0228
  ld I, Vf                    ; 0xff55 @ 0x022a
  ld I, #998                  ; 0xa3e6 @ 0x022c
  ld V1, I                    ; 0xf165 @ 0x022e
  ld Vb, V0                   ; 0x8b00 @ 0x0230
  ld Vc, V1                   ; 0x8c10 @ 0x0232
  cls                         ; 0x00e0 @ 0x0234
  ld Ve, #1                   ; 0x6e01 @ 0x0236
  ld V0, #19                  ; 0x6013 @ 0x0238
  ld V1, #3                   ; 0x6103 @ 0x023a
  ld I, #922                  ; 0xa39a @ 0x023c
  drw V0, V1                  ; 0xd011 @ 0x023e
  add V0, #8                  ; 0x7008 @ 0x0240
  se V0, #43                  ; 0x302b @ 0x0242
  jmp #0x023e                 ; 0x123e @ 0x0244
  ld V0, #19                  ; 0x6013 @ 0x0246
  add V1, #8                  ; 0x7108 @ 0x0248
  se V1, #35                  ; 0x3123 @ 0x024a
  jmp #0x023e                 ; 0x123e @ 0x024c
  ld V0, #19                  ; 0x6013 @ 0x024e
  ld V1, #3                   ; 0x6103 @ 0x0250
  ld I, #923                  ; 0xa39b @ 0x0252
  drw V0, V1                  ; 0xd01f @ 0x0254
  add V0, #8                  ; 0x7008 @ 0x0256
  se V0, #51                  ; 0x3033 @ 0x0258
  jmp #0x0254                 ; 0x1254 @ 0x025a
  ld V0, #19                  ; 0x6013 @ 0x025c
  add V1, #15                 ; 0x710f @ 0x025e
  drw V0, V1                  ; 0xd01a @ 0x0260
  add V0, #8                  ; 0x7008 @ 0x0262
  se V0, #51                  ; 0x3033 @ 0x0264
  jmp #0x0260                 ; 0x1260 @ 0x0266
  call #0x0366                ; 0x2366 @ 0x0268
  ld V0, K                    ; 0xf00a @ 0x026a
  ld V1, V0                   ; 0x8100 @ 0x026c
  ld I, #948                  ; 0xa3b4 @ 0x026e
  add I, V0                   ; 0xf01e @ 0x0270
  ld V0, I                    ; 0xf065 @ 0x0272
  sne V0, #0                  ; 0x4000 @ 0x0274
  jmp #0x028a                 ; 0x128a @ 0x0276
  call #0x027c                ; 0x227c @ 0x0278
  jmp #0x026a                 ; 0x126a @ 0x027a
  ld V0, #16                  ; 0x6010 @ 0x027c
  ld ST, V0                   ; 0xf018 @ 0x027e
  ld DT, V0                   ; 0xf015 @ 0x0280
  ld V0, DT                   ; 0xf007 @ 0x0282
  se V0, #0                   ; 0x3000 @ 0x0284
  jmp #0x0282                 ; 0x1282 @ 0x0286
  ret                         ; 0x00ee @ 0x0288
  ld V0, #2                   ; 0x6002 @ 0x028a
  xor Ve, V0                  ; 0x8e03 @ 0x028c
  ld V0, Ve                   ; 0x80e0 @ 0x028e
  ld I, V0                    ; 0xf055 @ 0x0290
  ld I, #980                  ; 0xa3d4 @ 0x0292
  ld V0, V1                   ; 0x8010 @ 0x0294
  add V0, #255                ; 0x70ff @ 0x0296
  add V0, V0                  ; 0x8004 @ 0x0298
  add I, V0                   ; 0xf01e @ 0x029a
  ld V1, I                    ; 0xf165 @ 0x029c
  ld I, #938                  ; 0xa3aa @ 0x029e
  se Ve, #3                   ; 0x3e03 @ 0x02a0
  ld I, #943                  ; 0xa3af @ 0x02a2
  drw V0, V1                  ; 0xd015 @ 0x02a4
  call #0x02c8                ; 0x22c8 @ 0x02a6
  se Va, #0                   ; 0x3a00 @ 0x02a8
  jmp #0x021c                 ; 0x121c @ 0x02aa
  ld I, #948                  ; 0xa3b4 @ 0x02ac
  ld V1, #0                   ; 0x6100 @ 0x02ae
  ld V2, #0                   ; 0x6200 @ 0x02b0
  ld V3, #1                   ; 0x6301 @ 0x02b2
  ld V0, I                    ; 0xf065 @ 0x02b4
  se V0, #0                   ; 0x3000 @ 0x02b6
  add V1, #1                  ; 0x7101 @ 0x02b8
  add I, V3                   ; 0xf31e @ 0x02ba
  add V2, #1                  ; 0x7201 @ 0x02bc
  se V2, #16                  ; 0x3210 @ 0x02be
  jmp #0x02b4                 ; 0x12b4 @ 0x02c0
  se V1, #16                  ; 0x3110 @ 0x02c2
  jmp #0x026a                 ; 0x126a @ 0x02c4
  jmp #0x021c                 ; 0x121c @ 0x02c6
  ld Va, #0                   ; 0x6a00 @ 0x02c8
  ld I, #948                  ; 0xa3b4 @ 0x02ca
  ld V0, #1                   ; 0x6001 @ 0x02cc
  add I, V0                   ; 0xf01e @ 0x02ce
  ld V8, I                    ; 0xf865 @ 0x02d0
  ld V9, #0                   ; 0x6900 @ 0x02d2
  add V9, V0                  ; 0x8904 @ 0x02d4
  call #0x0344                ; 0x2344 @ 0x02d6
  add V9, V1                  ; 0x8914 @ 0x02d8
  call #0x0344                ; 0x2344 @ 0x02da
  add V9, V2                  ; 0x8924 @ 0x02dc
  call #0x034a                ; 0x234a @ 0x02de
  ld V9, #0                   ; 0x6900 @ 0x02e0
  add V9, V3                  ; 0x8934 @ 0x02e2
  call #0x0344                ; 0x2344 @ 0x02e4
  add V9, V4                  ; 0x8944 @ 0x02e6
  call #0x0344                ; 0x2344 @ 0x02e8
  add V9, V5                  ; 0x8954 @ 0x02ea
  call #0x034a                ; 0x234a @ 0x02ec
  ld V9, #0                   ; 0x6900 @ 0x02ee
  add V9, V6                  ; 0x8964 @ 0x02f0
  call #0x0344                ; 0x2344 @ 0x02f2
  add V9, V7                  ; 0x8974 @ 0x02f4
  call #0x0344                ; 0x2344 @ 0x02f6
  add V9, V8                  ; 0x8984 @ 0x02f8
  call #0x034a                ; 0x234a @ 0x02fa
  ld V9, #0                   ; 0x6900 @ 0x02fc
  add V9, V6                  ; 0x8964 @ 0x02fe
  call #0x0344                ; 0x2344 @ 0x0300
  add V9, V3                  ; 0x8934 @ 0x0302
  call #0x0344                ; 0x2344 @ 0x0304
  add V9, V0                  ; 0x8904 @ 0x0306
  call #0x034a                ; 0x234a @ 0x0308
  ld V9, #0                   ; 0x6900 @ 0x030a
  add V9, V7                  ; 0x8974 @ 0x030c
  call #0x0344                ; 0x2344 @ 0x030e
  add V9, V4                  ; 0x8944 @ 0x0310
  call #0x0344                ; 0x2344 @ 0x0312
  add V9, V1                  ; 0x8914 @ 0x0314
  call #0x034a                ; 0x234a @ 0x0316
  ld V9, #0                   ; 0x6900 @ 0x0318
  add V9, V8                  ; 0x8984 @ 0x031a
  call #0x0344                ; 0x2344 @ 0x031c
  add V9, V5                  ; 0x8954 @ 0x031e
  call #0x0344                ; 0x2344 @ 0x0320
  add V9, V2                  ; 0x8924 @ 0x0322
  call #0x034a                ; 0x234a @ 0x0324
  ld V9, #0                   ; 0x6900 @ 0x0326
  add V9, V8                  ; 0x8984 @ 0x0328
  call #0x0344                ; 0x2344 @ 0x032a
  add V9, V4                  ; 0x8944 @ 0x032c
  call #0x0344                ; 0x2344 @ 0x032e
  add V9, V0                  ; 0x8904 @ 0x0330
  call #0x034a                ; 0x234a @ 0x0332
  ld V9, #0                   ; 0x6900 @ 0x0334
  add V9, V6                  ; 0x8964 @ 0x0336
  call #0x0344                ; 0x2344 @ 0x0338
  add V9, V4                  ; 0x8944 @ 0x033a
  call #0x0344                ; 0x2344 @ 0x033c
  add V9, V2                  ; 0x8924 @ 0x033e
  call #0x034a                ; 0x234a @ 0x0340
  ret                         ; 0x00ee @ 0x0342
  shl V9, V0                  ; 0x890e @ 0x0344
  shl V9, V0                  ; 0x890e @ 0x0346
  ret                         ; 0x00ee @ 0x0348
  sne V9, #21                 ; 0x4915 @ 0x034a
  jmp #0x0354                 ; 0x1354 @ 0x034c
  sne V9, #63                 ; 0x493f @ 0x034e
  jmp #0x035a                 ; 0x135a @ 0x0350
  ret                         ; 0x00ee @ 0x0352
  call #0x0366                ; 0x2366 @ 0x0354
  add Vb, #1                  ; 0x7b01 @ 0x0356
  jmp #0x035e                 ; 0x135e @ 0x0358
  call #0x0366                ; 0x2366 @ 0x035a
  add Vc, #1                  ; 0x7c01 @ 0x035c
  call #0x0366                ; 0x2366 @ 0x035e
  ld Va, #1                   ; 0x6a01 @ 0x0360
  ld V0, K                    ; 0xf00a @ 0x0362
  ret                         ; 0x00ee @ 0x0364
  ld V3, #5                   ; 0x6305 @ 0x0366
  ld V4, #10                  ; 0x640a @ 0x0368
  ld I, #943                  ; 0xa3af @ 0x036a
  drw V3, V4                  ; 0xd345 @ 0x036c
  ld V3, #2                   ; 0x6302 @ 0x036e
  add V4, #6                  ; 0x7406 @ 0x0370
  ld I, #998                  ; 0xa3e6 @ 0x0372
  ld I, Vb.B                  ; 0xfb33 @ 0x0374
  call #0x0388                ; 0x2388 @ 0x0376
  ld V3, #50                  ; 0x6332 @ 0x0378
  ld V4, #10                  ; 0x640a @ 0x037a
  ld I, #938                  ; 0xa3aa @ 0x037c
  drw V3, V4                  ; 0xd345 @ 0x037e
  ld V3, #47                  ; 0x632f @ 0x0380
  add V4, #6                  ; 0x7406 @ 0x0382
  ld I, #998                  ; 0xa3e6 @ 0x0384
  ld I, Vc.B                  ; 0xfc33 @ 0x0386
  ld V2, I                    ; 0xf265 @ 0x0388
  ld I, V0.F                  ; 0xf029 @ 0x038a
  call #0x0394                ; 0x2394 @ 0x038c
  ld I, V1.F                  ; 0xf129 @ 0x038e
  call #0x0394                ; 0x2394 @ 0x0390
  ld I, V2.F                  ; 0xf229 @ 0x0392
  drw V3, V4                  ; 0xd345 @ 0x0394
  add V3, #5                  ; 0x7305 @ 0x0396
  ret                         ; 0x00ee @ 0x0398
  add Vf, #128                ; 0x7f80 @ 0x039a
  ld V0, V8                   ; 0x8080 @ 0x039c
  ld V0, V8                   ; 0x8080 @ 0x039e
  ld V0, V8                   ; 0x8080 @ 0x03a0
  ld V0, V8                   ; 0x8080 @ 0x03a2
  ld V0, V8                   ; 0x8080 @ 0x03a4
  ld V0, V8                   ; 0x8080 @ 0x03a6
  ld V0, V8                   ; 0x8080 @ 0x03a8
  jmp #0x0c22                 ; 0x1c22 @ 0x03aa
  call #0x0222                ; 0x2222 @ 0x03ac
  jmp #0x0c22                 ; 0x1c22 @ 0x03ae
  jmp #0x0408                 ; 0x1408 @ 0x03b0
  jmp #0x0422                 ; 0x1422 @ 0x03b2
  sys #0x0100                 ; 0x0100 @ 0x03b4
  sys #0x0000                 ; 0x0000 @ 0x03b6
  sys #0x0000                 ; 0x0000 @ 0x03b8
  sys #0x0000                 ; 0x0000 @ 0x03ba
  sys #0x0000                 ; 0x0000 @ 0x03bc
  sys #0x0101                 ; 0x0101 @ 0x03be
  sys #0x0101                 ; 0x0101 @ 0x03c0
  sys #0x0101                 ; 0x0101 @ 0x03c2
  sys #0x0100                 ; 0x0100 @ 0x03c4
  sys #0x0000                 ; 0x0000 @ 0x03c6
  sys #0x0000                 ; 0x0000 @ 0x03c8
  sys #0x0000                 ; 0x0000 @ 0x03ca
  sys #0x0000                 ; 0x0000 @ 0x03cc
  sys #0x0101                 ; 0x0101 @ 0x03ce
  sys #0x0101                 ; 0x0101 @ 0x03d0
  sys #0x0101                 ; 0x0101 @ 0x03d2
  jmp #0x0305                 ; 0x1305 @ 0x03d4
  jmp #0x0b05                 ; 0x1b05 @ 0x03d6
  call #0x0305                ; 0x2305 @ 0x03d8
  jmp #0x030d                 ; 0x130d @ 0x03da
  jmp #0x0b0d                 ; 0x1b0d @ 0x03dc
  call #0x030d                ; 0x230d @ 0x03de
  jmp #0x0315                 ; 0x1315 @ 0x03e0
  jmp #0x0b15                 ; 0x1b15 @ 0x03e2
  call #0x0315                ; 0x2315 @ 0x03e4