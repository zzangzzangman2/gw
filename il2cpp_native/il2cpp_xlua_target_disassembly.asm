; XXTEAUtil.DecryptByteArray
; RVA 0x1c79b00 file_offset 0x1c79b00
; public static string DecryptByteArray(byte[] source) { }
01c79b00: str      x23, [sp, #-0x40]!
01c79b04: stp      x22, x21, [sp, #0x10]
01c79b08: stp      x20, x19, [sp, #0x20]
01c79b0c: stp      x29, x30, [sp, #0x30]
01c79b10: add      x29, sp, #0x30
01c79b14: adrp     x20, #0x3200000
01c79b18: ldrb     w8, [x20, #0x97d]
01c79b1c: mov      x19, x0
01c79b20: tbnz     w8, #0, #0x1c79b68
01c79b24: adrp     x0, #0x2fdf000
01c79b28: ldr      x0, [x0, #0xb78]
01c79b2c: bl       #0xa5ffc0
01c79b30: adrp     x0, #0x3006000
01c79b34: ldr      x0, [x0, #0xf20]
01c79b38: bl       #0xa5ffc0
01c79b3c: adrp     x0, #0x2ff6000
01c79b40: ldr      x0, [x0, #0x58]
01c79b44: bl       #0xa5ffc0
01c79b48: adrp     x0, #0x300c000
01c79b4c: ldr      x0, [x0, #0xdd8]
01c79b50: bl       #0xa5ffc0
01c79b54: adrp     x0, #0x2ffa000
01c79b58: ldr      x0, [x0, #0xee8]
01c79b5c: bl       #0xa5ffc0
01c79b60: mov      w8, #1
01c79b64: strb     w8, [x20, #0x97d]
01c79b68: mov      w0, #0x1fd
01c79b6c: mov      x1, xzr
01c79b70: bl       #0xedcd74
01c79b74: tbz      w0, #0, #0x1c79ba4
01c79b78: mov      w0, #0x1fd
01c79b7c: mov      x1, xzr
01c79b80: bl       #0xedce44
01c79b84: cbz      x0, #0x1c79d58
01c79b88: mov      x1, x19
01c79b8c: ldp      x29, x30, [sp, #0x30]
01c79b90: ldp      x20, x19, [sp, #0x20]
01c79b94: ldp      x22, x21, [sp, #0x10]
01c79b98: mov      x2, xzr
01c79b9c: ldr      x23, [sp], #0x40
01c79ba0: b        #0xac260c
01c79ba4: cbz      x19, #0x1c79d58
01c79ba8: ldr      x8, [x19, #0x18]
01c79bac: cbz      x8, #0x1c79d38
01c79bb0: cbz      w8, #0x1c79d5c
01c79bb4: ldrb     w9, [x19, #0x20]
01c79bb8: cmp      w9, #0xc
01c79bbc: b.ne     #0x1c79d08
01c79bc0: cmp      w8, #1
01c79bc4: b.ls     #0x1c79d5c
01c79bc8: ldrb     w9, [x19, #0x21]
01c79bcc: cmp      w9, #7
01c79bd0: b.ne     #0x1c79d08
01c79bd4: cmp      w8, #2
01c79bd8: b.ls     #0x1c79d5c
01c79bdc: ldrb     w9, [x19, #0x22]
01c79be0: cmp      w9, #8
01c79be4: b.ne     #0x1c79d08
01c79be8: cmp      w8, #3
01c79bec: b.ls     #0x1c79d5c
01c79bf0: ldrb     w9, [x19, #0x23]
01c79bf4: cmp      w9, #0xd
01c79bf8: b.ne     #0x1c79d08
01c79bfc: cmp      w8, #4
01c79c00: b.ls     #0x1c79d5c
01c79c04: ldrb     w9, [x19, #0x24]
01c79c08: cmp      w9, #0xb
01c79c0c: b.ne     #0x1c79d08
01c79c10: cmp      w8, #5
01c79c14: b.ls     #0x1c79d5c
01c79c18: ldrb     w8, [x19, #0x25]
01c79c1c: cmp      w8, #9
01c79c20: b.ne     #0x1c79d08
01c79c24: adrp     x22, #0x2fdf000
01c79c28: ldr      x22, [x22, #0xb78]
01c79c2c: mov      w1, #6
01c79c30: mov      x0, x19
01c79c34: ldr      x2, [x22]
01c79c38: bl       #0xcce940
01c79c3c: adrp     x21, #0x2ff6000
01c79c40: ldr      x21, [x21, #0x58]
01c79c44: ldr      x1, [x21]
01c79c48: bl       #0xccee44
01c79c4c: adrp     x23, #0x300c000
01c79c50: ldr      x23, [x23, #0xdd8]
01c79c54: mov      x20, x0
01c79c58: ldr      x8, [x23]
01c79c5c: ldrb     w9, [x8, #0x133]
01c79c60: tbz      w9, #1, #0x1c79c74
01c79c64: ldr      w9, [x8, #0xe0]
01c79c68: cbnz     w9, #0x1c79c74
01c79c6c: mov      x0, x8
01c79c70: bl       #0xa60070
01c79c74: mov      x0, x20
01c79c78: mov      w1, wzr
01c79c7c: bl       #0x1c78e80
01c79c80: ldr      x8, [x23]
01c79c84: mov      x20, x0
01c79c88: mov      w1, wzr
01c79c8c: ldr      x8, [x8, #0xb8]
01c79c90: ldr      x8, [x8, #8]
01c79c94: mov      x0, x8
01c79c98: bl       #0x1c78e80
01c79c9c: mov      x1, x0
01c79ca0: mov      x0, x20
01c79ca4: bl       #0x1c79628
01c79ca8: mov      w1, #1
01c79cac: bl       #0x1c793b0
01c79cb0: ldr      x2, [x22]
01c79cb4: mov      w1, #1
01c79cb8: mov      x20, x0
01c79cbc: bl       #0xcce940
01c79cc0: cbz      x20, #0x1c79d58
01c79cc4: adrp     x8, #0x3006000
01c79cc8: ldr      w1, [x20, #0x18]
01c79ccc: ldr      x8, [x8, #0xf20]
01c79cd0: ldr      x2, [x8]
01c79cd4: bl       #0xcceaf4
01c79cd8: ldr      x1, [x21]
01c79cdc: bl       #0xccee44
01c79ce0: mov      x1, xzr
01c79ce4: bl       #0xb39294
01c79ce8: cbz      x0, #0x1c79d0c
01c79cec: mov      x20, x0
01c79cf0: mov      x0, xzr
01c79cf4: bl       #0x1984094
01c79cf8: cbz      x0, #0x1c79d58
01c79cfc: ldr      x8, [x0]
01c79d00: mov      x1, x20
01c79d04: b        #0x1c79d1c
01c79d08: mov      x0, xzr
01c79d0c: bl       #0x1983d5c
01c79d10: cbz      x0, #0x1c79d58
01c79d14: ldr      x8, [x0]
01c79d18: mov      x1, x19
01c79d1c: ldr      x3, [x8, #0x3d8]
01c79d20: ldr      x2, [x8, #0x3e0]
01c79d24: ldp      x29, x30, [sp, #0x30]
01c79d28: ldp      x20, x19, [sp, #0x20]
01c79d2c: ldp      x22, x21, [sp, #0x10]
01c79d30: ldr      x23, [sp], #0x40
01c79d34: br       x3
01c79d38: adrp     x8, #0x2ffa000
01c79d3c: ldr      x8, [x8, #0xee8]
01c79d40: ldp      x29, x30, [sp, #0x30]
01c79d44: ldp      x20, x19, [sp, #0x20]
01c79d48: ldp      x22, x21, [sp, #0x10]
01c79d4c: ldr      x0, [x8]
01c79d50: ldr      x23, [sp], #0x40
01c79d54: ret
01c79d58: bl       #0xa60094
01c79d5c: bl       #0xa600c0
01c79d60: mov      x1, xzr
01c79d64: bl       #0xa60060
01c79d68: str      x21, [sp, #-0x30]!
01c79d6c: stp      x20, x19, [sp, #0x10]
01c79d70: stp      x29, x30, [sp, #0x20]
01c79d74: add      x29, sp, #0x20
01c79d78: adrp     x20, #0x3200000
01c79d7c: ldrb     w8, [x20, #0x97e]
01c79d80: mov      x19, x1
01c79d84: mov      x21, x0
01c79d88: tbnz     w8, #0, #0x1c79db8
01c79d8c: adrp     x0, #0x302c000
01c79d90: ldr      x0, [x0, #0xc18]
01c79d94: bl       #0xa5ffc0
01c79d98: adrp     x0, #0x300c000
01c79d9c: ldr      x0, [x0, #0xdd8]
01c79da0: bl       #0xa5ffc0
01c79da4: adrp     x0, #0x2ffa000
01c79da8: ldr      x0, [x0, #0xee8]
01c79dac: bl       #0xa5ffc0
01c79db0: mov      w8, #1
01c79db4: strb     w8, [x20, #0x97e]
01c79db8: mov      w0, #0x200
01c79dbc: mov      x1, xzr
01c79dc0: bl       #0xedcd74
01c79dc4: tbz      w0, #0, #0x1c79df4
01c79dc8: mov      w0, #0x200
01c79dcc: mov      x1, xzr
01c79dd0: bl       #0xedce44
01c79dd4: cbz      x0, #0x1c79ef4
01c79dd8: mov      x2, x19
01c79ddc: ldp      x29, x30, [sp, #0x20]
01c79de0: ldp      x20, x19, [sp, #0x10]
01c79de4: mov      x1, x21
01c79de8: mov      x3, xzr
01c79dec: ldr      x21, [sp], #0x30
01c79df0: b        #0xac292c
01c79df4: cbz      x21, #0x1c79ef4
01c79df8: ldr      w8, [x21, #0x10]
01c79dfc: cbz      w8, #0x1c79ed8
01c79e00: mov      x0, xzr
01c79e04: bl       #0x1984094
01c79e08: adrp     x8, #0x302c000
01c79e0c: ldr      x8, [x8, #0xc18]
01c79e10: mov      x20, x0
01c79e14: ldr      x8, [x8]
01c79e18: ldrb     w9, [x8, #0x133]
01c79e1c: tbz      w9, #1, #0x1c79e30
01c79e20: ldr      w9, [x8, #0xe0]
01c79e24: cbnz     w9, #0x1c79e30
01c79e28: mov      x0, x8
01c79e2c: bl       #0xa60070
01c79e30: mov      x0, x21
01c79e34: mov      x1, xzr
01c79e38: bl       #0x1450ab8
01c79e3c: cbz      x20, #0x1c79ef4
01c79e40: ldr      x8, [x20]
01c79e44: mov      x21, x0
01c79e48: mov      x0, x20
01c79e4c: mov      x1, x19
01c79e50: ldr      x9, [x8, #0x2c8]
01c79e54: ldr      x2, [x8, #0x2d0]
01c79e58: blr      x9
01c79e5c: adrp     x8, #0x300c000
01c79e60: ldr      x8, [x8, #0xdd8]
01c79e64: mov      x19, x0
01c79e68: ldr      x8, [x8]
01c79e6c: ldrb     w9, [x8, #0x133]
01c79e70: tbz      w9, #1, #0x1c79e84
01c79e74: ldr      w9, [x8, #0xe0]
01c79e78: cbnz     w9, #0x1c79e84
01c79e7c: mov      x0, x8
01c79e80: bl       #0xa60070
01c79e84: mov      x0, x21
01c79e88: mov      w1, wzr
01c79e8c: bl       #0x1c78e80
01c79e90: mov      x21, x0
01c79e94: mov      x0, x19
01c79e98: mov      w1, wzr
01c79e9c: bl       #0x1c78e80
01c79ea0: mov      x1, x0
01c79ea4: mov      x0, x21
01c79ea8: bl       #0x1c79628
01c79eac: mov      w1, #1
01c79eb0: bl       #0x1c793b0
01c79eb4: ldr      x8, [x20]
01c79eb8: mov      x1, x0
01c79ebc: mov      x0, x20
01c79ec0: ldp      x29, x30, [sp, #0x20]
01c79ec4: ldr      x3, [x8, #0x3d8]
01c79ec8: ldr      x2, [x8, #0x3e0]
01c79ecc: ldp      x20, x19, [sp, #0x10]
01c79ed0: ldr      x21, [sp], #0x30
01c79ed4: br       x3
01c79ed8: adrp     x8, #0x2ffa000
01c79edc: ldr      x8, [x8, #0xee8]
01c79ee0: ldp      x29, x30, [sp, #0x20]
01c79ee4: ldp      x20, x19, [sp, #0x10]
01c79ee8: ldr      x0, [x8]
01c79eec: ldr      x21, [sp], #0x30
01c79ef0: ret
01c79ef4: bl       #0xa60094
01c79ef8: str      x21, [sp, #-0x30]!
01c79efc: stp      x20, x19, [sp, #0x10]
01c79f00: stp      x29, x30, [sp, #0x20]
01c79f04: add      x29, sp, #0x20
01c79f08: adrp     x21, #0x3200000
01c79f0c: ldrb     w8, [x21, #0x97f]
01c79f10: mov      x20, x1
01c79f14: mov      x19, x0
01c79f18: tbnz     w8, #0, #0x1c79f3c
01c79f1c: adrp     x0, #0x2fec000
01c79f20: ldr      x0, [x0, #0x3a0]
01c79f24: bl       #0xa5ffc0
01c79f28: adrp     x0, #0x300c000
01c79f2c: ldr      x0, [x0, #0xdd8]
01c79f30: bl       #0xa5ffc0
01c79f34: mov      w8, #1
01c79f38: strb     w8, [x21, #0x97f]
01c79f3c: mov      w0, #0x201
01c79f40: mov      x1, xzr
01c79f44: bl       #0xedcd74
01c79f48: tbz      w0, #0, #0x1c79f78
01c79f4c: mov      w0, #0x201
01c79f50: mov      x1, xzr
01c79f54: bl       #0xedce44
01c79f58: cbz      x0, #0x1c7a048
01c79f5c: mov      x1, x19
01c79f60: mov      x2, x20
01c79f64: ldp      x29, x30, [sp, #0x20]
01c79f68: ldp      x20, x19, [sp, #0x10]
01c79f6c: mov      x3, xzr
01c79f70: ldr      x21, [sp], #0x30
01c79f74: b        #0xac292c
01c79f78: cbz      x19, #0x1c7a048
01c79f7c: ldr      x8, [x19, #0x18]

; XXTEAUtil.DecryptGetString
; RVA 0x1c79ef8 file_offset 0x1c79ef8
; public static string DecryptGetString(byte[] bytes, string key) { }
01c79ef8: str      x21, [sp, #-0x30]!
01c79efc: stp      x20, x19, [sp, #0x10]
01c79f00: stp      x29, x30, [sp, #0x20]
01c79f04: add      x29, sp, #0x20
01c79f08: adrp     x21, #0x3200000
01c79f0c: ldrb     w8, [x21, #0x97f]
01c79f10: mov      x20, x1
01c79f14: mov      x19, x0
01c79f18: tbnz     w8, #0, #0x1c79f3c
01c79f1c: adrp     x0, #0x2fec000
01c79f20: ldr      x0, [x0, #0x3a0]
01c79f24: bl       #0xa5ffc0
01c79f28: adrp     x0, #0x300c000
01c79f2c: ldr      x0, [x0, #0xdd8]
01c79f30: bl       #0xa5ffc0
01c79f34: mov      w8, #1
01c79f38: strb     w8, [x21, #0x97f]
01c79f3c: mov      w0, #0x201
01c79f40: mov      x1, xzr
01c79f44: bl       #0xedcd74
01c79f48: tbz      w0, #0, #0x1c79f78
01c79f4c: mov      w0, #0x201
01c79f50: mov      x1, xzr
01c79f54: bl       #0xedce44
01c79f58: cbz      x0, #0x1c7a048
01c79f5c: mov      x1, x19
01c79f60: mov      x2, x20
01c79f64: ldp      x29, x30, [sp, #0x20]
01c79f68: ldp      x20, x19, [sp, #0x10]
01c79f6c: mov      x3, xzr
01c79f70: ldr      x21, [sp], #0x30
01c79f74: b        #0xac292c
01c79f78: cbz      x19, #0x1c7a048
01c79f7c: ldr      x8, [x19, #0x18]
01c79f80: cbz      x8, #0x1c7a024
01c79f84: mov      x0, xzr
01c79f88: bl       #0x1984094
01c79f8c: cbz      x0, #0x1c7a048
01c79f90: ldr      x8, [x0]
01c79f94: mov      x1, x20
01c79f98: mov      x21, x0
01c79f9c: ldr      x9, [x8, #0x2c8]
01c79fa0: ldr      x2, [x8, #0x2d0]
01c79fa4: blr      x9
01c79fa8: adrp     x8, #0x300c000
01c79fac: ldr      x8, [x8, #0xdd8]
01c79fb0: mov      x20, x0
01c79fb4: ldr      x8, [x8]
01c79fb8: ldrb     w9, [x8, #0x133]
01c79fbc: tbz      w9, #1, #0x1c79fd0
01c79fc0: ldr      w9, [x8, #0xe0]
01c79fc4: cbnz     w9, #0x1c79fd0
01c79fc8: mov      x0, x8
01c79fcc: bl       #0xa60070
01c79fd0: mov      x0, x19
01c79fd4: mov      w1, wzr
01c79fd8: bl       #0x1c78e80
01c79fdc: mov      x19, x0
01c79fe0: mov      x0, x20
01c79fe4: mov      w1, wzr
01c79fe8: bl       #0x1c78e80
01c79fec: mov      x1, x0
01c79ff0: mov      x0, x19
01c79ff4: bl       #0x1c79628
01c79ff8: mov      w1, #1
01c79ffc: bl       #0x1c793b0
01c7a000: ldr      x8, [x21]
01c7a004: ldp      x29, x30, [sp, #0x20]
01c7a008: ldp      x20, x19, [sp, #0x10]
01c7a00c: mov      x1, x0
01c7a010: ldr      x3, [x8, #0x3d8]
01c7a014: ldr      x2, [x8, #0x3e0]
01c7a018: mov      x0, x21
01c7a01c: ldr      x21, [sp], #0x30
01c7a020: br       x3
01c7a024: adrp     x8, #0x2fec000
01c7a028: ldr      x8, [x8, #0x3a0]
01c7a02c: ldp      x29, x30, [sp, #0x20]
01c7a030: ldp      x20, x19, [sp, #0x10]
01c7a034: ldr      x8, [x8]
01c7a038: ldr      x8, [x8, #0xb8]
01c7a03c: ldr      x0, [x8]
01c7a040: ldr      x21, [sp], #0x30
01c7a044: ret
01c7a048: bl       #0xa60094
01c7a04c: stp      x26, x25, [sp, #-0x50]!
01c7a050: stp      x24, x23, [sp, #0x10]
01c7a054: stp      x22, x21, [sp, #0x20]
01c7a058: stp      x20, x19, [sp, #0x30]
01c7a05c: stp      x29, x30, [sp, #0x40]
01c7a060: add      x29, sp, #0x40
01c7a064: adrp     x21, #0x3200000
01c7a068: ldrb     w8, [x21, #0x980]
01c7a06c: mov      x19, x1
01c7a070: mov      x20, x0
01c7a074: tbnz     w8, #0, #0x1c7a098
01c7a078: adrp     x0, #0x3013000
01c7a07c: ldr      x0, [x0, #0x468]
01c7a080: bl       #0xa5ffc0
01c7a084: adrp     x0, #0x300c000
01c7a088: ldr      x0, [x0, #0xdd8]
01c7a08c: bl       #0xa5ffc0
01c7a090: mov      w8, #1
01c7a094: strb     w8, [x21, #0x980]
01c7a098: mov      w0, #0x202
01c7a09c: mov      x1, xzr
01c7a0a0: bl       #0xedcd74
01c7a0a4: tbz      w0, #0, #0x1c7a0dc
01c7a0a8: mov      w0, #0x202
01c7a0ac: mov      x1, xzr
01c7a0b0: bl       #0xedce44
01c7a0b4: cbz      x0, #0x1c7a1b4
01c7a0b8: mov      x1, x20
01c7a0bc: mov      x2, x19
01c7a0c0: ldp      x29, x30, [sp, #0x40]
01c7a0c4: ldp      x20, x19, [sp, #0x30]
01c7a0c8: ldp      x22, x21, [sp, #0x20]
01c7a0cc: ldp      x24, x23, [sp, #0x10]
01c7a0d0: mov      x3, xzr
01c7a0d4: ldp      x26, x25, [sp], #0x50
01c7a0d8: b        #0xad0558
01c7a0dc: cbz      x20, #0x1c7a1b4
01c7a0e0: adrp     x8, #0x3013000
01c7a0e4: ldr      x8, [x8, #0x468]
01c7a0e8: ldr      w1, [x20, #0x18]
01c7a0ec: ldr      x0, [x8]
01c7a0f0: bl       #0xa5ffd4
01c7a0f4: ldr      x8, [x20, #0x18]
01c7a0f8: mov      x21, x0
01c7a0fc: cmp      w8, #1
01c7a100: b.lt     #0x1c7a18c
01c7a104: adrp     x26, #0x300c000
01c7a108: ldr      x26, [x26, #0xdd8]
01c7a10c: mov      x23, xzr
01c7a110: and      x8, x8, #0xffffffff
01c7a114: add      x24, x20, #0x20
01c7a118: add      x25, x21, #0x20
01c7a11c: cmp      x23, w8, uxtw
01c7a120: b.hs     #0x1c7a1a8
01c7a124: ldr      x0, [x26]
01c7a128: ldr      x22, [x24, x23, lsl #3]
01c7a12c: ldrb     w8, [x0, #0x133]
01c7a130: tbz      w8, #1, #0x1c7a140
01c7a134: ldr      w8, [x0, #0xe0]
01c7a138: cbnz     w8, #0x1c7a140
01c7a13c: bl       #0xa60070
01c7a140: mov      x0, x22
01c7a144: mov      x1, x19
01c7a148: bl       #0x1c79ef8
01c7a14c: cbz      x21, #0x1c7a1b4
01c7a150: mov      x22, x0
01c7a154: cbz      x0, #0x1c7a16c
01c7a158: ldr      x8, [x21]
01c7a15c: mov      x0, x22
01c7a160: ldr      x1, [x8, #0x40]
01c7a164: bl       #0xa6007c
01c7a168: cbz      x0, #0x1c7a1b8
01c7a16c: ldr      w8, [x21, #0x18]
01c7a170: cmp      x23, x8
01c7a174: b.hs     #0x1c7a1a8
01c7a178: str      x22, [x25, x23, lsl #3]
01c7a17c: ldr      w8, [x20, #0x18]
01c7a180: add      x23, x23, #1
01c7a184: cmp      x23, w8, sxtw
01c7a188: b.lt     #0x1c7a11c
01c7a18c: mov      x0, x21
01c7a190: ldp      x29, x30, [sp, #0x40]
01c7a194: ldp      x20, x19, [sp, #0x30]
01c7a198: ldp      x22, x21, [sp, #0x20]
01c7a19c: ldp      x24, x23, [sp, #0x10]
01c7a1a0: ldp      x26, x25, [sp], #0x50
01c7a1a4: ret
01c7a1a8: bl       #0xa600c0
01c7a1ac: mov      x1, xzr
01c7a1b0: bl       #0xa60060
01c7a1b4: bl       #0xa60094
01c7a1b8: bl       #0xa600b4
01c7a1bc: mov      x1, xzr
01c7a1c0: bl       #0xa60060
01c7a1c4: stp      x20, x19, [sp, #-0x20]!
01c7a1c8: stp      x29, x30, [sp, #0x10]
01c7a1cc: add      x29, sp, #0x10
01c7a1d0: mov      w20, w1
01c7a1d4: mov      w19, w0
01c7a1d8: mov      w0, #0x154
01c7a1dc: mov      x1, xzr
01c7a1e0: bl       #0xedcd74
01c7a1e4: tbz      w0, #0, #0x1c7a210
01c7a1e8: mov      w0, #0x154
01c7a1ec: mov      x1, xzr
01c7a1f0: bl       #0xedce44
01c7a1f4: cbz      x0, #0x1c7a230
01c7a1f8: ldp      x29, x30, [sp, #0x10]
01c7a1fc: mov      w1, w19
01c7a200: mov      w2, w20
01c7a204: mov      x3, xzr
01c7a208: ldp      x20, x19, [sp], #0x20
01c7a20c: b        #0xac8100
01c7a210: cbz      w20, #0x1c7a220
01c7a214: lsr      w8, w19, #1
01c7a218: sub      w9, w20, #1
01c7a21c: lsr      w19, w8, w9
01c7a220: ldp      x29, x30, [sp, #0x10]
01c7a224: mov      w0, w19
01c7a228: ldp      x20, x19, [sp], #0x20
01c7a22c: ret
01c7a230: bl       #0xa60094
01c7a234: stp      x20, x19, [sp, #-0x20]!
01c7a238: stp      x29, x30, [sp, #0x10]
01c7a23c: add      x29, sp, #0x10
01c7a240: adrp     x20, #0x3200000
01c7a244: ldrb     w8, [x20, #0x985]
01c7a248: mov      x19, x0
01c7a24c: tbnz     w8, #0, #0x1c7a264
01c7a250: adrp     x0, #0x302c000
01c7a254: ldr      x0, [x0, #0xc18]
01c7a258: bl       #0xa5ffc0
01c7a25c: mov      w8, #1
01c7a260: strb     w8, [x20, #0x985]
01c7a264: mov      w0, #0x203
01c7a268: mov      x1, xzr
01c7a26c: bl       #0xedcd74
01c7a270: tbz      w0, #0, #0x1c7a298
01c7a274: mov      w0, #0x203
01c7a278: mov      x1, xzr
01c7a27c: bl       #0xedce44
01c7a280: cbz      x0, #0x1c7a2f8
01c7a284: ldp      x29, x30, [sp, #0x10]
01c7a288: mov      x1, x19
01c7a28c: mov      x2, xzr
01c7a290: ldp      x20, x19, [sp], #0x20
01c7a294: b        #0xac260c
01c7a298: mov      x0, xzr
01c7a29c: bl       #0x1984094
01c7a2a0: adrp     x8, #0x302c000
01c7a2a4: ldr      x8, [x8, #0xc18]
01c7a2a8: mov      x20, x0
01c7a2ac: ldr      x0, [x8]
01c7a2b0: ldrb     w8, [x0, #0x133]
01c7a2b4: tbz      w8, #1, #0x1c7a2c4
01c7a2b8: ldr      w8, [x0, #0xe0]
01c7a2bc: cbnz     w8, #0x1c7a2c4
01c7a2c0: bl       #0xa60070
01c7a2c4: mov      x0, x19
01c7a2c8: mov      x1, xzr
01c7a2cc: bl       #0x1450ab8
01c7a2d0: mov      x1, x0
01c7a2d4: cbz      x20, #0x1c7a2fc
01c7a2d8: ldr      x8, [x20]
01c7a2dc: ldr      x9, [x8, #0x3d8]
01c7a2e0: ldr      x2, [x8, #0x3e0]
01c7a2e4: mov      x0, x20
01c7a2e8: blr      x9
01c7a2ec: ldp      x29, x30, [sp, #0x10]
01c7a2f0: ldp      x20, x19, [sp], #0x20
01c7a2f4: ret
01c7a2f8: bl       #0xa60094
01c7a2fc: bl       #0xa60094
01c7a300: b        #0x1c7a310
01c7a304: b        #0x1c7a310
01c7a308: b        #0x1c7a310
01c7a30c: b        #0x1c7a310
01c7a310: mov      x19, x0
01c7a314: cmp      w1, #1
01c7a318: b.ne     #0x1c7a3e4
01c7a31c: mov      x0, x19
01c7a320: bl       #0x71de70
01c7a324: ldr      x19, [x0]
01c7a328: mov      x20, x0
01c7a32c: adrp     x0, #0x3015000
01c7a330: ldr      x0, [x0, #0x800]
01c7a334: bl       #0xa5ffc4
01c7a338: ldr      x8, [x20]
01c7a33c: ldr      x1, [x8]
01c7a340: bl       #0xa603fc
01c7a344: tbz      w0, #0, #0x1c7a3bc
01c7a348: bl       #0x71d350
01c7a34c: mov      x0, x19
01c7a350: bl       #0x88d168
01c7a354: ldr      x8, [x19]
01c7a358: mov      x0, x19
01c7a35c: ldp      x9, x1, [x8, #0x188]
01c7a360: blr      x9
01c7a364: mov      x19, x0
01c7a368: adrp     x0, #0x3048000
01c7a36c: ldr      x0, [x0, #0x148]
01c7a370: bl       #0xa5ffc4
01c7a374: mov      x1, x19

; XXTEAUtil.DecryptGetArray
; RVA 0x1c7a04c file_offset 0x1c7a04c
; public static string[] DecryptGetArray(byte[][] arr, string key) { }
01c7a04c: stp      x26, x25, [sp, #-0x50]!
01c7a050: stp      x24, x23, [sp, #0x10]
01c7a054: stp      x22, x21, [sp, #0x20]
01c7a058: stp      x20, x19, [sp, #0x30]
01c7a05c: stp      x29, x30, [sp, #0x40]
01c7a060: add      x29, sp, #0x40
01c7a064: adrp     x21, #0x3200000
01c7a068: ldrb     w8, [x21, #0x980]
01c7a06c: mov      x19, x1
01c7a070: mov      x20, x0
01c7a074: tbnz     w8, #0, #0x1c7a098
01c7a078: adrp     x0, #0x3013000
01c7a07c: ldr      x0, [x0, #0x468]
01c7a080: bl       #0xa5ffc0
01c7a084: adrp     x0, #0x300c000
01c7a088: ldr      x0, [x0, #0xdd8]
01c7a08c: bl       #0xa5ffc0
01c7a090: mov      w8, #1
01c7a094: strb     w8, [x21, #0x980]
01c7a098: mov      w0, #0x202
01c7a09c: mov      x1, xzr
01c7a0a0: bl       #0xedcd74
01c7a0a4: tbz      w0, #0, #0x1c7a0dc
01c7a0a8: mov      w0, #0x202
01c7a0ac: mov      x1, xzr
01c7a0b0: bl       #0xedce44
01c7a0b4: cbz      x0, #0x1c7a1b4
01c7a0b8: mov      x1, x20
01c7a0bc: mov      x2, x19
01c7a0c0: ldp      x29, x30, [sp, #0x40]
01c7a0c4: ldp      x20, x19, [sp, #0x30]
01c7a0c8: ldp      x22, x21, [sp, #0x20]
01c7a0cc: ldp      x24, x23, [sp, #0x10]
01c7a0d0: mov      x3, xzr
01c7a0d4: ldp      x26, x25, [sp], #0x50
01c7a0d8: b        #0xad0558
01c7a0dc: cbz      x20, #0x1c7a1b4
01c7a0e0: adrp     x8, #0x3013000
01c7a0e4: ldr      x8, [x8, #0x468]
01c7a0e8: ldr      w1, [x20, #0x18]
01c7a0ec: ldr      x0, [x8]
01c7a0f0: bl       #0xa5ffd4
01c7a0f4: ldr      x8, [x20, #0x18]
01c7a0f8: mov      x21, x0
01c7a0fc: cmp      w8, #1
01c7a100: b.lt     #0x1c7a18c
01c7a104: adrp     x26, #0x300c000
01c7a108: ldr      x26, [x26, #0xdd8]
01c7a10c: mov      x23, xzr
01c7a110: and      x8, x8, #0xffffffff
01c7a114: add      x24, x20, #0x20
01c7a118: add      x25, x21, #0x20
01c7a11c: cmp      x23, w8, uxtw
01c7a120: b.hs     #0x1c7a1a8
01c7a124: ldr      x0, [x26]
01c7a128: ldr      x22, [x24, x23, lsl #3]
01c7a12c: ldrb     w8, [x0, #0x133]
01c7a130: tbz      w8, #1, #0x1c7a140
01c7a134: ldr      w8, [x0, #0xe0]
01c7a138: cbnz     w8, #0x1c7a140
01c7a13c: bl       #0xa60070
01c7a140: mov      x0, x22
01c7a144: mov      x1, x19
01c7a148: bl       #0x1c79ef8
01c7a14c: cbz      x21, #0x1c7a1b4
01c7a150: mov      x22, x0
01c7a154: cbz      x0, #0x1c7a16c
01c7a158: ldr      x8, [x21]
01c7a15c: mov      x0, x22
01c7a160: ldr      x1, [x8, #0x40]
01c7a164: bl       #0xa6007c
01c7a168: cbz      x0, #0x1c7a1b8
01c7a16c: ldr      w8, [x21, #0x18]
01c7a170: cmp      x23, x8
01c7a174: b.hs     #0x1c7a1a8
01c7a178: str      x22, [x25, x23, lsl #3]
01c7a17c: ldr      w8, [x20, #0x18]
01c7a180: add      x23, x23, #1
01c7a184: cmp      x23, w8, sxtw
01c7a188: b.lt     #0x1c7a11c
01c7a18c: mov      x0, x21
01c7a190: ldp      x29, x30, [sp, #0x40]
01c7a194: ldp      x20, x19, [sp, #0x30]
01c7a198: ldp      x22, x21, [sp, #0x20]
01c7a19c: ldp      x24, x23, [sp, #0x10]
01c7a1a0: ldp      x26, x25, [sp], #0x50
01c7a1a4: ret
01c7a1a8: bl       #0xa600c0
01c7a1ac: mov      x1, xzr
01c7a1b0: bl       #0xa60060
01c7a1b4: bl       #0xa60094
01c7a1b8: bl       #0xa600b4
01c7a1bc: mov      x1, xzr
01c7a1c0: bl       #0xa60060
01c7a1c4: stp      x20, x19, [sp, #-0x20]!
01c7a1c8: stp      x29, x30, [sp, #0x10]
01c7a1cc: add      x29, sp, #0x10
01c7a1d0: mov      w20, w1
01c7a1d4: mov      w19, w0
01c7a1d8: mov      w0, #0x154
01c7a1dc: mov      x1, xzr
01c7a1e0: bl       #0xedcd74
01c7a1e4: tbz      w0, #0, #0x1c7a210
01c7a1e8: mov      w0, #0x154
01c7a1ec: mov      x1, xzr
01c7a1f0: bl       #0xedce44
01c7a1f4: cbz      x0, #0x1c7a230
01c7a1f8: ldp      x29, x30, [sp, #0x10]
01c7a1fc: mov      w1, w19
01c7a200: mov      w2, w20
01c7a204: mov      x3, xzr
01c7a208: ldp      x20, x19, [sp], #0x20
01c7a20c: b        #0xac8100
01c7a210: cbz      w20, #0x1c7a220
01c7a214: lsr      w8, w19, #1
01c7a218: sub      w9, w20, #1
01c7a21c: lsr      w19, w8, w9
01c7a220: ldp      x29, x30, [sp, #0x10]
01c7a224: mov      w0, w19
01c7a228: ldp      x20, x19, [sp], #0x20
01c7a22c: ret
01c7a230: bl       #0xa60094
01c7a234: stp      x20, x19, [sp, #-0x20]!
01c7a238: stp      x29, x30, [sp, #0x10]
01c7a23c: add      x29, sp, #0x10
01c7a240: adrp     x20, #0x3200000
01c7a244: ldrb     w8, [x20, #0x985]
01c7a248: mov      x19, x0
01c7a24c: tbnz     w8, #0, #0x1c7a264
01c7a250: adrp     x0, #0x302c000
01c7a254: ldr      x0, [x0, #0xc18]
01c7a258: bl       #0xa5ffc0
01c7a25c: mov      w8, #1
01c7a260: strb     w8, [x20, #0x985]
01c7a264: mov      w0, #0x203
01c7a268: mov      x1, xzr
01c7a26c: bl       #0xedcd74
01c7a270: tbz      w0, #0, #0x1c7a298
01c7a274: mov      w0, #0x203
01c7a278: mov      x1, xzr
01c7a27c: bl       #0xedce44
01c7a280: cbz      x0, #0x1c7a2f8
01c7a284: ldp      x29, x30, [sp, #0x10]
01c7a288: mov      x1, x19
01c7a28c: mov      x2, xzr
01c7a290: ldp      x20, x19, [sp], #0x20
01c7a294: b        #0xac260c
01c7a298: mov      x0, xzr
01c7a29c: bl       #0x1984094
01c7a2a0: adrp     x8, #0x302c000
01c7a2a4: ldr      x8, [x8, #0xc18]
01c7a2a8: mov      x20, x0
01c7a2ac: ldr      x0, [x8]
01c7a2b0: ldrb     w8, [x0, #0x133]
01c7a2b4: tbz      w8, #1, #0x1c7a2c4
01c7a2b8: ldr      w8, [x0, #0xe0]
01c7a2bc: cbnz     w8, #0x1c7a2c4
01c7a2c0: bl       #0xa60070
01c7a2c4: mov      x0, x19
01c7a2c8: mov      x1, xzr
01c7a2cc: bl       #0x1450ab8
01c7a2d0: mov      x1, x0
01c7a2d4: cbz      x20, #0x1c7a2fc
01c7a2d8: ldr      x8, [x20]
01c7a2dc: ldr      x9, [x8, #0x3d8]
01c7a2e0: ldr      x2, [x8, #0x3e0]
01c7a2e4: mov      x0, x20
01c7a2e8: blr      x9
01c7a2ec: ldp      x29, x30, [sp, #0x10]
01c7a2f0: ldp      x20, x19, [sp], #0x20
01c7a2f4: ret
01c7a2f8: bl       #0xa60094
01c7a2fc: bl       #0xa60094
01c7a300: b        #0x1c7a310
01c7a304: b        #0x1c7a310
01c7a308: b        #0x1c7a310
01c7a30c: b        #0x1c7a310
01c7a310: mov      x19, x0
01c7a314: cmp      w1, #1
01c7a318: b.ne     #0x1c7a3e4
01c7a31c: mov      x0, x19
01c7a320: bl       #0x71de70
01c7a324: ldr      x19, [x0]
01c7a328: mov      x20, x0
01c7a32c: adrp     x0, #0x3015000
01c7a330: ldr      x0, [x0, #0x800]
01c7a334: bl       #0xa5ffc4
01c7a338: ldr      x8, [x20]
01c7a33c: ldr      x1, [x8]
01c7a340: bl       #0xa603fc
01c7a344: tbz      w0, #0, #0x1c7a3bc
01c7a348: bl       #0x71d350
01c7a34c: mov      x0, x19
01c7a350: bl       #0x88d168
01c7a354: ldr      x8, [x19]
01c7a358: mov      x0, x19
01c7a35c: ldp      x9, x1, [x8, #0x188]
01c7a360: blr      x9
01c7a364: mov      x19, x0
01c7a368: adrp     x0, #0x3048000
01c7a36c: ldr      x0, [x0, #0x148]
01c7a370: bl       #0xa5ffc4
01c7a374: mov      x1, x19
01c7a378: mov      x2, xzr
01c7a37c: bl       #0x1e52e14
01c7a380: mov      x19, x0
01c7a384: adrp     x0, #0x3015000
01c7a388: ldr      x0, [x0, #0x800]
01c7a38c: bl       #0xa5ffc4
01c7a390: bl       #0xa6008c
01c7a394: mov      x1, x19
01c7a398: mov      x2, xzr
01c7a39c: mov      x20, x0
01c7a3a0: bl       #0x1e0d6e4
01c7a3a4: adrp     x0, #0x2ff2000
01c7a3a8: ldr      x0, [x0, #0x590]
01c7a3ac: bl       #0xa5ffc4
01c7a3b0: mov      x1, x0
01c7a3b4: mov      x0, x20
01c7a3b8: bl       #0xa60060
01c7a3bc: mov      w0, #8
01c7a3c0: bl       #0x71cab0
01c7a3c4: ldr      x8, [x20]
01c7a3c8: str      x8, [x0]
01c7a3cc: adrp     x1, #0x2f81000
01c7a3d0: add      x1, x1, #0x458
01c7a3d4: mov      x2, xzr
01c7a3d8: bl       #0x71dbf0
01c7a3dc: mov      x19, x0
01c7a3e0: bl       #0x71d350
01c7a3e4: mov      x0, x19
01c7a3e8: bl       #0x71d1f0
01c7a3ec: bl       #0x88d17c
01c7a3f0: stp      x20, x19, [sp, #-0x20]!
01c7a3f4: stp      x29, x30, [sp, #0x10]
01c7a3f8: add      x29, sp, #0x10
01c7a3fc: adrp     x20, #0x3200000
01c7a400: ldrb     w8, [x20, #0x986]
01c7a404: mov      x19, x0
01c7a408: tbnz     w8, #0, #0x1c7a420
01c7a40c: adrp     x0, #0x302c000
01c7a410: ldr      x0, [x0, #0xc18]
01c7a414: bl       #0xa5ffc0
01c7a418: mov      w8, #1
01c7a41c: strb     w8, [x20, #0x986]
01c7a420: mov      w0, #0x204
01c7a424: mov      x1, xzr
01c7a428: bl       #0xedcd74
01c7a42c: tbz      w0, #0, #0x1c7a454
01c7a430: mov      w0, #0x204
01c7a434: mov      x1, xzr
01c7a438: bl       #0xedce44
01c7a43c: cbz      x0, #0x1c7a4b0
01c7a440: ldp      x29, x30, [sp, #0x10]
01c7a444: mov      x1, x19
01c7a448: mov      x2, xzr
01c7a44c: ldp      x20, x19, [sp], #0x20
01c7a450: b        #0xac260c
01c7a454: mov      x0, xzr
01c7a458: bl       #0x1984094
01c7a45c: cbz      x0, #0x1c7a4b4
01c7a460: ldr      x8, [x0]
01c7a464: ldr      x9, [x8, #0x2c8]
01c7a468: ldr      x2, [x8, #0x2d0]
01c7a46c: mov      x1, x19
01c7a470: blr      x9
01c7a474: adrp     x8, #0x302c000
01c7a478: ldr      x8, [x8, #0xc18]
01c7a47c: mov      x19, x0
01c7a480: ldr      x0, [x8]
01c7a484: ldrb     w8, [x0, #0x133]
01c7a488: tbz      w8, #1, #0x1c7a498
01c7a48c: ldr      w8, [x0, #0xe0]
01c7a490: cbnz     w8, #0x1c7a498
01c7a494: bl       #0xa60070
01c7a498: mov      x0, x19
01c7a49c: mov      x1, xzr
01c7a4a0: bl       #0x1464a60
01c7a4a4: ldp      x29, x30, [sp, #0x10]
01c7a4a8: ldp      x20, x19, [sp], #0x20
01c7a4ac: ret
01c7a4b0: bl       #0xa60094
01c7a4b4: bl       #0xa60094
01c7a4b8: b        #0x1c7a4c4
01c7a4bc: b        #0x1c7a4c4
01c7a4c0: b        #0x1c7a4c4
01c7a4c4: mov      x19, x0
01c7a4c8: cmp      w1, #1

; LuaManager.MyLoader
; RVA 0xd2a5a0 file_offset 0xd2a5a0
; private byte[] MyLoader(ref string filePath) { }
00d2a5a0: str      x21, [sp, #-0x30]!
00d2a5a4: stp      x20, x19, [sp, #0x10]
00d2a5a8: stp      x29, x30, [sp, #0x20]
00d2a5ac: add      x29, sp, #0x20
00d2a5b0: adrp     x21, #0x31f7000
00d2a5b4: ldrb     w8, [x21, #0xe02]
00d2a5b8: mov      x19, x1
00d2a5bc: mov      x20, x0
00d2a5c0: tbnz     w8, #0, #0xd2a5d8
00d2a5c4: adrp     x0, #0x2ffb000
00d2a5c8: ldr      x0, [x0, #0x2e0]
00d2a5cc: bl       #0xa5ffc0
00d2a5d0: mov      w8, #1
00d2a5d4: strb     w8, [x21, #0xe02]
00d2a5d8: mov      w0, #0x2268
00d2a5dc: mov      x1, xzr
00d2a5e0: bl       #0xedcd74
00d2a5e4: tbz      w0, #0, #0xd2a614
00d2a5e8: mov      w0, #0x2268
00d2a5ec: mov      x1, xzr
00d2a5f0: bl       #0xedce44
00d2a5f4: cbz      x0, #0xd2a660
00d2a5f8: mov      x1, x20
00d2a5fc: mov      x2, x19
00d2a600: ldp      x29, x30, [sp, #0x20]
00d2a604: ldp      x20, x19, [sp, #0x10]
00d2a608: mov      x3, xzr
00d2a60c: ldr      x21, [sp], #0x30
00d2a610: b        #0xaf1b98
00d2a614: adrp     x8, #0x2ffb000
00d2a618: ldr      x0, [x19]
00d2a61c: ldr      x8, [x8, #0x2e0]
00d2a620: mov      x2, xzr
00d2a624: ldr      x1, [x8]
00d2a628: bl       #0x1e58ecc
00d2a62c: tbz      w0, #0, #0xd2a644
00d2a630: ldp      x29, x30, [sp, #0x20]
00d2a634: ldp      x20, x19, [sp, #0x10]
00d2a638: mov      x0, xzr
00d2a63c: ldr      x21, [sp], #0x30
00d2a640: ret
00d2a644: ldr      x1, [x19]
00d2a648: mov      x0, x20
00d2a64c: ldp      x29, x30, [sp, #0x20]
00d2a650: ldp      x20, x19, [sp, #0x10]
00d2a654: mov      w2, wzr
00d2a658: ldr      x21, [sp], #0x30
00d2a65c: b        #0xd2a664
00d2a660: bl       #0xa60094
00d2a664: sub      sp, sp, #0x50
00d2a668: stp      x24, x23, [sp, #0x10]
00d2a66c: stp      x22, x21, [sp, #0x20]
00d2a670: stp      x20, x19, [sp, #0x30]
00d2a674: stp      x29, x30, [sp, #0x40]
00d2a678: add      x29, sp, #0x40
00d2a67c: adrp     x22, #0x31f7000
00d2a680: ldrb     w8, [x22, #0xe03]
00d2a684: mov      w21, w2
00d2a688: mov      x19, x1
00d2a68c: mov      x20, x0
00d2a690: tbnz     w8, #0, #0xd2a720
00d2a694: adrp     x0, #0x301a000
00d2a698: ldr      x0, [x0, #0x7e0]
00d2a69c: bl       #0xa5ffc0
00d2a6a0: adrp     x0, #0x2ff2000
00d2a6a4: ldr      x0, [x0, #0x58]
00d2a6a8: bl       #0xa5ffc0
00d2a6ac: adrp     x0, #0x2ffd000
00d2a6b0: ldr      x0, [x0, #0xef0]
00d2a6b4: bl       #0xa5ffc0
00d2a6b8: adrp     x0, #0x3013000
00d2a6bc: ldr      x0, [x0, #0xf58]
00d2a6c0: bl       #0xa5ffc0
00d2a6c4: adrp     x0, #0x3018000
00d2a6c8: ldr      x0, [x0, #0x2a0]
00d2a6cc: bl       #0xa5ffc0
00d2a6d0: adrp     x0, #0x3015000
00d2a6d4: ldr      x0, [x0, #0x388]
00d2a6d8: bl       #0xa5ffc0
00d2a6dc: adrp     x0, #0x2fed000
00d2a6e0: ldr      x0, [x0, #0x168]
00d2a6e4: bl       #0xa5ffc0
00d2a6e8: adrp     x0, #0x2ff2000
00d2a6ec: ldr      x0, [x0, #0xd18]
00d2a6f0: bl       #0xa5ffc0
00d2a6f4: adrp     x0, #0x300f000
00d2a6f8: ldr      x0, [x0, #0x9c8]
00d2a6fc: bl       #0xa5ffc0
00d2a700: adrp     x0, #0x2fef000
00d2a704: ldr      x0, [x0, #0xa40]
00d2a708: bl       #0xa5ffc0
00d2a70c: adrp     x0, #0x2fe3000
00d2a710: ldr      x0, [x0, #0x570]
00d2a714: bl       #0xa5ffc0
00d2a718: mov      w8, #1
00d2a71c: strb     w8, [x22, #0xe03]
00d2a720: mov      w0, #0x1324
00d2a724: mov      x1, xzr
00d2a728: str      xzr, [sp, #8]
00d2a72c: bl       #0xedcd74
00d2a730: tbz      w0, #0, #0xd2a760
00d2a734: mov      w0, #0x1324
00d2a738: mov      x1, xzr
00d2a73c: bl       #0xedce44
00d2a740: cbz      x0, #0xd2aab8
00d2a744: and      w3, w21, #1
00d2a748: mov      x1, x20
00d2a74c: mov      x2, x19
00d2a750: mov      x4, xzr
00d2a754: bl       #0xafb7fc
00d2a758: mov      x20, x0
00d2a75c: b        #0xd2aa9c
00d2a760: adrp     x23, #0x3013000
00d2a764: ldr      x23, [x23, #0xf58]
00d2a768: ldr      x0, [x23]
00d2a76c: ldrb     w8, [x0, #0x133]
00d2a770: tbz      w8, #1, #0xd2a780
00d2a774: ldr      w8, [x0, #0xe0]
00d2a778: cbnz     w8, #0xd2a780
00d2a77c: bl       #0xa60070
00d2a780: adrp     x24, #0x31f6000
00d2a784: ldrb     w8, [x24, #0xafe]
00d2a788: cbnz     w8, #0xd2a7a0
00d2a78c: adrp     x0, #0x3013000
00d2a790: ldr      x0, [x0, #0xf58]
00d2a794: bl       #0xa5ffc0
00d2a798: mov      w8, #1
00d2a79c: strb     w8, [x24, #0xafe]
00d2a7a0: ldr      x0, [x23]
00d2a7a4: ldrb     w8, [x0, #0x133]
00d2a7a8: tbz      w8, #1, #0xd2a7bc
00d2a7ac: ldr      w8, [x0, #0xe0]
00d2a7b0: cbnz     w8, #0xd2a7bc
00d2a7b4: bl       #0xa60070
00d2a7b8: ldr      x0, [x23]
00d2a7bc: ldr      x8, [x0, #0xb8]
00d2a7c0: ldr      x8, [x8, #0x60]
00d2a7c4: cbz      x8, #0xd2aab8
00d2a7c8: ldr      x22, [x8, #0x20]
00d2a7cc: tbz      w21, #0, #0xd2a7ec
00d2a7d0: adrp     x8, #0x2fed000
00d2a7d4: ldr      x8, [x8, #0x168]
00d2a7d8: mov      x1, x19
00d2a7dc: mov      x2, xzr
00d2a7e0: ldr      x0, [x8]
00d2a7e4: bl       #0x1e52e14
00d2a7e8: b        #0xd2a810
00d2a7ec: adrp     x8, #0x3015000
00d2a7f0: adrp     x9, #0x2fe3000
00d2a7f4: ldr      x8, [x8, #0x388]
00d2a7f8: ldr      x9, [x9, #0x570]
00d2a7fc: mov      x1, x19
00d2a800: mov      x3, xzr
00d2a804: ldr      x0, [x8]
00d2a808: ldr      x2, [x9]
00d2a80c: bl       #0x1e5e730
00d2a810: mov      x2, x0
00d2a814: cbz      x22, #0xd2aab8
00d2a818: mov      x0, x22
00d2a81c: mov      w1, wzr
00d2a820: mov      x3, xzr
00d2a824: bl       #0x171a268
00d2a828: cbz      x0, #0xd2aa98
00d2a82c: ldr      x20, [x20, #0xf8]
00d2a830: mov      x1, xzr
00d2a834: bl       #0x1445034
00d2a838: cbz      x20, #0xd2aab8
00d2a83c: adrp     x8, #0x2ffd000
00d2a840: ldr      x8, [x8, #0xef0]
00d2a844: mov      x1, x0
00d2a848: add      x2, sp, #8
00d2a84c: mov      x0, x20
00d2a850: ldr      x3, [x8]
00d2a854: bl       #0x2013cc0
00d2a858: tbz      w0, #0, #0xd2aa98
00d2a85c: ldr      x0, [x23]
00d2a860: ldrb     w8, [x0, #0x133]
00d2a864: tbz      w8, #1, #0xd2a874
00d2a868: ldr      w8, [x0, #0xe0]
00d2a86c: cbnz     w8, #0xd2a874
00d2a870: bl       #0xa60070
00d2a874: ldrb     w8, [x24, #0xafe]
00d2a878: cbnz     w8, #0xd2a890
00d2a87c: adrp     x0, #0x3013000
00d2a880: ldr      x0, [x0, #0xf58]
00d2a884: bl       #0xa5ffc0
00d2a888: mov      w8, #1
00d2a88c: strb     w8, [x24, #0xafe]
00d2a890: ldr      x0, [x23]
00d2a894: ldrb     w8, [x0, #0x133]
00d2a898: tbz      w8, #1, #0xd2a8ac
00d2a89c: ldr      w8, [x0, #0xe0]
00d2a8a0: cbnz     w8, #0xd2a8ac
00d2a8a4: bl       #0xa60070
00d2a8a8: ldr      x0, [x23]
00d2a8ac: ldr      x8, [x0, #0xb8]
00d2a8b0: ldr      x0, [x8, #0x60]
00d2a8b4: cbz      x0, #0xd2aab8
00d2a8b8: mov      x1, x19
00d2a8bc: mov      x2, xzr
00d2a8c0: bl       #0x1432d5c
00d2a8c4: ldr      x8, [sp, #8]
00d2a8c8: cbz      x8, #0xd2aab8
00d2a8cc: adrp     x9, #0x2ff2000
00d2a8d0: ldr      x9, [x9, #0x58]
00d2a8d4: mov      x1, x0
00d2a8d8: mov      x0, x8
00d2a8dc: ldr      x2, [x9]
00d2a8e0: bl       #0x11b2304
00d2a8e4: cbz      x0, #0xd2aab8
00d2a8e8: mov      x1, xzr
00d2a8ec: bl       #0x12c1c70
00d2a8f0: cbz      x19, #0xd2aab8
00d2a8f4: adrp     x8, #0x2fef000
00d2a8f8: ldr      x8, [x8, #0xa40]
00d2a8fc: mov      x20, x0
00d2a900: mov      w2, #1
00d2a904: mov      x0, x19
00d2a908: ldr      x1, [x8]
00d2a90c: mov      x3, xzr
00d2a910: bl       #0x1e5ba74
00d2a914: cmn      w0, #1
00d2a918: b.ne     #0xd2aa44
00d2a91c: adrp     x8, #0x2ff2000
00d2a920: ldr      x8, [x8, #0xd18]
00d2a924: mov      w2, #1
00d2a928: mov      x0, x19
00d2a92c: mov      x3, xzr
00d2a930: ldr      x1, [x8]
00d2a934: bl       #0x1e5ba74
00d2a938: cmn      w0, #1
00d2a93c: b.ne     #0xd2aa44
00d2a940: cbnz     x20, #0xd2aa14
00d2a944: adrp     x8, #0x300f000
00d2a948: ldr      x8, [x8, #0x9c8]
00d2a94c: mov      x1, x19
00d2a950: mov      x2, xzr
00d2a954: ldr      x0, [x8]
00d2a958: bl       #0x1e52e14
00d2a95c: adrp     x8, #0x301a000
00d2a960: ldr      x8, [x8, #0x7e0]
00d2a964: mov      x19, x0
00d2a968: ldr      x22, [x8]
00d2a96c: ldr      x8, [x22, #0x30]
00d2a970: ldr      x21, [x8]
00d2a974: ldrh     w8, [x21, #0x132]
00d2a978: tbnz     w8, #0, #0xd2a988
00d2a97c: mov      x0, x21
00d2a980: bl       #0xa0d618
00d2a984: ldrh     w8, [x21, #0x132]
00d2a988: tbz      w8, #9, #0xd2a9cc
00d2a98c: ldr      x8, [x22, #0x30]
00d2a990: ldr      x21, [x8]
00d2a994: ldrb     w8, [x21, #0x132]
00d2a998: tbnz     w8, #0, #0xd2a9a4
00d2a99c: mov      x0, x21
00d2a9a0: bl       #0xa0d618
00d2a9a4: ldr      w8, [x21, #0xe0]
00d2a9a8: cbnz     w8, #0xd2a9cc
00d2a9ac: ldr      x8, [x22, #0x30]
00d2a9b0: ldr      x21, [x8]
00d2a9b4: ldrb     w8, [x21, #0x132]
00d2a9b8: tbnz     w8, #0, #0xd2a9c4
00d2a9bc: mov      x0, x21
00d2a9c0: bl       #0xa0d618
00d2a9c4: mov      x0, x21
00d2a9c8: bl       #0xa60070
00d2a9cc: ldr      x8, [x22, #0x30]
00d2a9d0: ldr      x21, [x8]
00d2a9d4: ldrb     w8, [x21, #0x132]
00d2a9d8: tbnz     w8, #0, #0xd2a9e4
00d2a9dc: mov      x0, x21
00d2a9e0: bl       #0xa0d618
00d2a9e4: ldr      x0, [x23]
00d2a9e8: ldr      x8, [x21, #0xb8]
00d2a9ec: ldrb     w9, [x0, #0x133]
00d2a9f0: ldr      x21, [x8]
00d2a9f4: tbz      w9, #1, #0xd2aa04
00d2a9f8: ldr      w8, [x0, #0xe0]
00d2a9fc: cbnz     w8, #0xd2aa04
00d2aa00: bl       #0xa60070
00d2aa04: mov      x0, x19
00d2aa08: mov      x1, x21
00d2aa0c: mov      x2, xzr
00d2aa10: bl       #0xe7e8e4
00d2aa14: adrp     x8, #0x3018000
00d2aa18: ldr      x8, [x8, #0x2a0]
00d2aa1c: ldr      x0, [x8]

; LuaManager.GetLuaBuff
; RVA 0xd2a664 file_offset 0xd2a664
; private byte[] GetLuaBuff(string filePath, bool isLuaUIFile) { }
00d2a664: sub      sp, sp, #0x50
00d2a668: stp      x24, x23, [sp, #0x10]
00d2a66c: stp      x22, x21, [sp, #0x20]
00d2a670: stp      x20, x19, [sp, #0x30]
00d2a674: stp      x29, x30, [sp, #0x40]
00d2a678: add      x29, sp, #0x40
00d2a67c: adrp     x22, #0x31f7000
00d2a680: ldrb     w8, [x22, #0xe03]
00d2a684: mov      w21, w2
00d2a688: mov      x19, x1
00d2a68c: mov      x20, x0
00d2a690: tbnz     w8, #0, #0xd2a720
00d2a694: adrp     x0, #0x301a000
00d2a698: ldr      x0, [x0, #0x7e0]
00d2a69c: bl       #0xa5ffc0
00d2a6a0: adrp     x0, #0x2ff2000
00d2a6a4: ldr      x0, [x0, #0x58]
00d2a6a8: bl       #0xa5ffc0
00d2a6ac: adrp     x0, #0x2ffd000
00d2a6b0: ldr      x0, [x0, #0xef0]
00d2a6b4: bl       #0xa5ffc0
00d2a6b8: adrp     x0, #0x3013000
00d2a6bc: ldr      x0, [x0, #0xf58]
00d2a6c0: bl       #0xa5ffc0
00d2a6c4: adrp     x0, #0x3018000
00d2a6c8: ldr      x0, [x0, #0x2a0]
00d2a6cc: bl       #0xa5ffc0
00d2a6d0: adrp     x0, #0x3015000
00d2a6d4: ldr      x0, [x0, #0x388]
00d2a6d8: bl       #0xa5ffc0
00d2a6dc: adrp     x0, #0x2fed000
00d2a6e0: ldr      x0, [x0, #0x168]
00d2a6e4: bl       #0xa5ffc0
00d2a6e8: adrp     x0, #0x2ff2000
00d2a6ec: ldr      x0, [x0, #0xd18]
00d2a6f0: bl       #0xa5ffc0
00d2a6f4: adrp     x0, #0x300f000
00d2a6f8: ldr      x0, [x0, #0x9c8]
00d2a6fc: bl       #0xa5ffc0
00d2a700: adrp     x0, #0x2fef000
00d2a704: ldr      x0, [x0, #0xa40]
00d2a708: bl       #0xa5ffc0
00d2a70c: adrp     x0, #0x2fe3000
00d2a710: ldr      x0, [x0, #0x570]
00d2a714: bl       #0xa5ffc0
00d2a718: mov      w8, #1
00d2a71c: strb     w8, [x22, #0xe03]
00d2a720: mov      w0, #0x1324
00d2a724: mov      x1, xzr
00d2a728: str      xzr, [sp, #8]
00d2a72c: bl       #0xedcd74
00d2a730: tbz      w0, #0, #0xd2a760
00d2a734: mov      w0, #0x1324
00d2a738: mov      x1, xzr
00d2a73c: bl       #0xedce44
00d2a740: cbz      x0, #0xd2aab8
00d2a744: and      w3, w21, #1
00d2a748: mov      x1, x20
00d2a74c: mov      x2, x19
00d2a750: mov      x4, xzr
00d2a754: bl       #0xafb7fc
00d2a758: mov      x20, x0
00d2a75c: b        #0xd2aa9c
00d2a760: adrp     x23, #0x3013000
00d2a764: ldr      x23, [x23, #0xf58]
00d2a768: ldr      x0, [x23]
00d2a76c: ldrb     w8, [x0, #0x133]
00d2a770: tbz      w8, #1, #0xd2a780
00d2a774: ldr      w8, [x0, #0xe0]
00d2a778: cbnz     w8, #0xd2a780
00d2a77c: bl       #0xa60070
00d2a780: adrp     x24, #0x31f6000
00d2a784: ldrb     w8, [x24, #0xafe]
00d2a788: cbnz     w8, #0xd2a7a0
00d2a78c: adrp     x0, #0x3013000
00d2a790: ldr      x0, [x0, #0xf58]
00d2a794: bl       #0xa5ffc0
00d2a798: mov      w8, #1
00d2a79c: strb     w8, [x24, #0xafe]
00d2a7a0: ldr      x0, [x23]
00d2a7a4: ldrb     w8, [x0, #0x133]
00d2a7a8: tbz      w8, #1, #0xd2a7bc
00d2a7ac: ldr      w8, [x0, #0xe0]
00d2a7b0: cbnz     w8, #0xd2a7bc
00d2a7b4: bl       #0xa60070
00d2a7b8: ldr      x0, [x23]
00d2a7bc: ldr      x8, [x0, #0xb8]
00d2a7c0: ldr      x8, [x8, #0x60]
00d2a7c4: cbz      x8, #0xd2aab8
00d2a7c8: ldr      x22, [x8, #0x20]
00d2a7cc: tbz      w21, #0, #0xd2a7ec
00d2a7d0: adrp     x8, #0x2fed000
00d2a7d4: ldr      x8, [x8, #0x168]
00d2a7d8: mov      x1, x19
00d2a7dc: mov      x2, xzr
00d2a7e0: ldr      x0, [x8]
00d2a7e4: bl       #0x1e52e14
00d2a7e8: b        #0xd2a810
00d2a7ec: adrp     x8, #0x3015000
00d2a7f0: adrp     x9, #0x2fe3000
00d2a7f4: ldr      x8, [x8, #0x388]
00d2a7f8: ldr      x9, [x9, #0x570]
00d2a7fc: mov      x1, x19
00d2a800: mov      x3, xzr
00d2a804: ldr      x0, [x8]
00d2a808: ldr      x2, [x9]
00d2a80c: bl       #0x1e5e730
00d2a810: mov      x2, x0
00d2a814: cbz      x22, #0xd2aab8
00d2a818: mov      x0, x22
00d2a81c: mov      w1, wzr
00d2a820: mov      x3, xzr
00d2a824: bl       #0x171a268
00d2a828: cbz      x0, #0xd2aa98
00d2a82c: ldr      x20, [x20, #0xf8]
00d2a830: mov      x1, xzr
00d2a834: bl       #0x1445034
00d2a838: cbz      x20, #0xd2aab8
00d2a83c: adrp     x8, #0x2ffd000
00d2a840: ldr      x8, [x8, #0xef0]
00d2a844: mov      x1, x0
00d2a848: add      x2, sp, #8
00d2a84c: mov      x0, x20
00d2a850: ldr      x3, [x8]
00d2a854: bl       #0x2013cc0
00d2a858: tbz      w0, #0, #0xd2aa98
00d2a85c: ldr      x0, [x23]
00d2a860: ldrb     w8, [x0, #0x133]
00d2a864: tbz      w8, #1, #0xd2a874
00d2a868: ldr      w8, [x0, #0xe0]
00d2a86c: cbnz     w8, #0xd2a874
00d2a870: bl       #0xa60070
00d2a874: ldrb     w8, [x24, #0xafe]
00d2a878: cbnz     w8, #0xd2a890
00d2a87c: adrp     x0, #0x3013000
00d2a880: ldr      x0, [x0, #0xf58]
00d2a884: bl       #0xa5ffc0
00d2a888: mov      w8, #1
00d2a88c: strb     w8, [x24, #0xafe]
00d2a890: ldr      x0, [x23]
00d2a894: ldrb     w8, [x0, #0x133]
00d2a898: tbz      w8, #1, #0xd2a8ac
00d2a89c: ldr      w8, [x0, #0xe0]
00d2a8a0: cbnz     w8, #0xd2a8ac
00d2a8a4: bl       #0xa60070
00d2a8a8: ldr      x0, [x23]
00d2a8ac: ldr      x8, [x0, #0xb8]
00d2a8b0: ldr      x0, [x8, #0x60]
00d2a8b4: cbz      x0, #0xd2aab8
00d2a8b8: mov      x1, x19
00d2a8bc: mov      x2, xzr
00d2a8c0: bl       #0x1432d5c
00d2a8c4: ldr      x8, [sp, #8]
00d2a8c8: cbz      x8, #0xd2aab8
00d2a8cc: adrp     x9, #0x2ff2000
00d2a8d0: ldr      x9, [x9, #0x58]
00d2a8d4: mov      x1, x0
00d2a8d8: mov      x0, x8
00d2a8dc: ldr      x2, [x9]
00d2a8e0: bl       #0x11b2304
00d2a8e4: cbz      x0, #0xd2aab8
00d2a8e8: mov      x1, xzr
00d2a8ec: bl       #0x12c1c70
00d2a8f0: cbz      x19, #0xd2aab8
00d2a8f4: adrp     x8, #0x2fef000
00d2a8f8: ldr      x8, [x8, #0xa40]
00d2a8fc: mov      x20, x0
00d2a900: mov      w2, #1
00d2a904: mov      x0, x19
00d2a908: ldr      x1, [x8]
00d2a90c: mov      x3, xzr
00d2a910: bl       #0x1e5ba74
00d2a914: cmn      w0, #1
00d2a918: b.ne     #0xd2aa44
00d2a91c: adrp     x8, #0x2ff2000
00d2a920: ldr      x8, [x8, #0xd18]
00d2a924: mov      w2, #1
00d2a928: mov      x0, x19
00d2a92c: mov      x3, xzr
00d2a930: ldr      x1, [x8]
00d2a934: bl       #0x1e5ba74
00d2a938: cmn      w0, #1
00d2a93c: b.ne     #0xd2aa44
00d2a940: cbnz     x20, #0xd2aa14
00d2a944: adrp     x8, #0x300f000
00d2a948: ldr      x8, [x8, #0x9c8]
00d2a94c: mov      x1, x19
00d2a950: mov      x2, xzr
00d2a954: ldr      x0, [x8]
00d2a958: bl       #0x1e52e14
00d2a95c: adrp     x8, #0x301a000
00d2a960: ldr      x8, [x8, #0x7e0]
00d2a964: mov      x19, x0
00d2a968: ldr      x22, [x8]
00d2a96c: ldr      x8, [x22, #0x30]
00d2a970: ldr      x21, [x8]
00d2a974: ldrh     w8, [x21, #0x132]
00d2a978: tbnz     w8, #0, #0xd2a988
00d2a97c: mov      x0, x21
00d2a980: bl       #0xa0d618
00d2a984: ldrh     w8, [x21, #0x132]
00d2a988: tbz      w8, #9, #0xd2a9cc
00d2a98c: ldr      x8, [x22, #0x30]
00d2a990: ldr      x21, [x8]
00d2a994: ldrb     w8, [x21, #0x132]
00d2a998: tbnz     w8, #0, #0xd2a9a4
00d2a99c: mov      x0, x21
00d2a9a0: bl       #0xa0d618
00d2a9a4: ldr      w8, [x21, #0xe0]
00d2a9a8: cbnz     w8, #0xd2a9cc
00d2a9ac: ldr      x8, [x22, #0x30]
00d2a9b0: ldr      x21, [x8]
00d2a9b4: ldrb     w8, [x21, #0x132]
00d2a9b8: tbnz     w8, #0, #0xd2a9c4
00d2a9bc: mov      x0, x21
00d2a9c0: bl       #0xa0d618
00d2a9c4: mov      x0, x21
00d2a9c8: bl       #0xa60070
00d2a9cc: ldr      x8, [x22, #0x30]
00d2a9d0: ldr      x21, [x8]
00d2a9d4: ldrb     w8, [x21, #0x132]
00d2a9d8: tbnz     w8, #0, #0xd2a9e4
00d2a9dc: mov      x0, x21
00d2a9e0: bl       #0xa0d618
00d2a9e4: ldr      x0, [x23]
00d2a9e8: ldr      x8, [x21, #0xb8]
00d2a9ec: ldrb     w9, [x0, #0x133]
00d2a9f0: ldr      x21, [x8]
00d2a9f4: tbz      w9, #1, #0xd2aa04
00d2a9f8: ldr      w8, [x0, #0xe0]
00d2a9fc: cbnz     w8, #0xd2aa04
00d2aa00: bl       #0xa60070
00d2aa04: mov      x0, x19
00d2aa08: mov      x1, x21
00d2aa0c: mov      x2, xzr
00d2aa10: bl       #0xe7e8e4
00d2aa14: adrp     x8, #0x3018000
00d2aa18: ldr      x8, [x8, #0x2a0]
00d2aa1c: ldr      x0, [x8]
00d2aa20: ldrb     w8, [x0, #0x133]
00d2aa24: tbz      w8, #1, #0xd2aa34
00d2aa28: ldr      w8, [x0, #0xe0]
00d2aa2c: cbnz     w8, #0xd2aa34
00d2aa30: bl       #0xa60070
00d2aa34: mov      x0, x20
00d2aa38: mov      x1, xzr
00d2aa3c: bl       #0xf84ed4
00d2aa40: mov      x20, x0
00d2aa44: cbz      x20, #0xd2aab8
00d2aa48: ldr      w8, [x20, #0x18]
00d2aa4c: cbz      w8, #0xd2aabc
00d2aa50: ldrb     w9, [x20, #0x20]
00d2aa54: cmp      w9, #0xef
00d2aa58: b.ne     #0xd2aa9c
00d2aa5c: cmp      w8, #1
00d2aa60: b.ls     #0xd2aabc
00d2aa64: ldrb     w9, [x20, #0x21]
00d2aa68: cmp      w9, #0xbb
00d2aa6c: b.ne     #0xd2aa9c
00d2aa70: cmp      w8, #2
00d2aa74: b.ls     #0xd2aabc
00d2aa78: ldrb     w8, [x20, #0x22]
00d2aa7c: cmp      w8, #0xbf
00d2aa80: b.ne     #0xd2aa9c
00d2aa84: mov      w8, #0x20
00d2aa88: mov      w9, #0x2020
00d2aa8c: strb     w8, [x20, #0x22]
00d2aa90: strh     w9, [x20, #0x20]
00d2aa94: b        #0xd2aa9c
00d2aa98: mov      x20, xzr
00d2aa9c: mov      x0, x20
00d2aaa0: ldp      x29, x30, [sp, #0x40]
00d2aaa4: ldp      x20, x19, [sp, #0x30]
00d2aaa8: ldp      x22, x21, [sp, #0x20]
00d2aaac: ldp      x24, x23, [sp, #0x10]
00d2aab0: add      sp, sp, #0x50
00d2aab4: ret
00d2aab8: bl       #0xa60094
00d2aabc: bl       #0xa600c0
00d2aac0: mov      x1, xzr
00d2aac4: bl       #0xa60060
00d2aac8: stp      x22, x21, [sp, #-0x30]!
00d2aacc: stp      x20, x19, [sp, #0x10]
00d2aad0: stp      x29, x30, [sp, #0x20]
00d2aad4: add      x29, sp, #0x20
00d2aad8: adrp     x21, #0x31f7000
00d2aadc: ldrb     w8, [x21, #0xe04]
00d2aae0: mov      x20, x1

; LuaManager.LoadUIScript
; RVA 0xd2adcc file_offset 0xd2adcc
; public object[] LoadUIScript(string fileName, string chunkName = "chunk", LuaTable env) { }
00d2adcc: str      x23, [sp, #-0x40]!
00d2add0: stp      x22, x21, [sp, #0x10]
00d2add4: stp      x20, x19, [sp, #0x20]
00d2add8: stp      x29, x30, [sp, #0x30]
00d2addc: add      x29, sp, #0x30
00d2ade0: adrp     x23, #0x31f7000
00d2ade4: ldrb     w8, [x23, #0xe05]
00d2ade8: mov      x19, x3
00d2adec: mov      x20, x2
00d2adf0: mov      x21, x1
00d2adf4: mov      x22, x0
00d2adf8: tbnz     w8, #0, #0xd2ae4c
00d2adfc: adrp     x0, #0x3037000
00d2ae00: ldr      x0, [x0, #0x760]
00d2ae04: bl       #0xa5ffc0
00d2ae08: adrp     x0, #0x2ffc000
00d2ae0c: ldr      x0, [x0, #0xca8]
00d2ae10: bl       #0xa5ffc0
00d2ae14: adrp     x0, #0x2ff8000
00d2ae18: ldr      x0, [x0, #0x50]
00d2ae1c: bl       #0xa5ffc0
00d2ae20: adrp     x0, #0x3018000
00d2ae24: ldr      x0, [x0, #0x2a0]
00d2ae28: bl       #0xa5ffc0
00d2ae2c: adrp     x0, #0x3018000
00d2ae30: ldr      x0, [x0, #0x958]
00d2ae34: bl       #0xa5ffc0
00d2ae38: adrp     x0, #0x3006000
00d2ae3c: ldr      x0, [x0, #0x388]
00d2ae40: bl       #0xa5ffc0
00d2ae44: mov      w8, #1
00d2ae48: strb     w8, [x23, #0xe05]
00d2ae4c: mov      w0, #0x1323
00d2ae50: mov      x1, xzr
00d2ae54: bl       #0xedcd74
00d2ae58: tbz      w0, #0, #0xd2ae94
00d2ae5c: mov      w0, #0x1323
00d2ae60: mov      x1, xzr
00d2ae64: bl       #0xedce44
00d2ae68: cbz      x0, #0xd2b010
00d2ae6c: mov      x1, x22
00d2ae70: mov      x2, x21
00d2ae74: mov      x3, x20
00d2ae78: mov      x4, x19
00d2ae7c: ldp      x29, x30, [sp, #0x30]
00d2ae80: ldp      x20, x19, [sp, #0x20]
00d2ae84: ldp      x22, x21, [sp, #0x10]
00d2ae88: mov      x5, xzr
00d2ae8c: ldr      x23, [sp], #0x40
00d2ae90: b        #0xac6e88
00d2ae94: adrp     x23, #0x2ffc000
00d2ae98: ldr      x23, [x23, #0xca8]
00d2ae9c: ldr      x0, [x23]
00d2aea0: ldrb     w8, [x0, #0x133]
00d2aea4: tbz      w8, #1, #0xd2aeb8
00d2aea8: ldr      w8, [x0, #0xe0]
00d2aeac: cbnz     w8, #0xd2aeb8
00d2aeb0: bl       #0xa60070
00d2aeb4: ldr      x0, [x23]
00d2aeb8: ldr      x8, [x0, #0xb8]
00d2aebc: ldrb     w8, [x8, #9]
00d2aec0: cbz      w8, #0xd2af6c
00d2aec4: mov      x0, xzr
00d2aec8: bl       #0x13157f0
00d2aecc: adrp     x8, #0x3006000
00d2aed0: ldr      x8, [x8, #0x388]
00d2aed4: mov      x2, xzr
00d2aed8: ldr      x1, [x8]
00d2aedc: bl       #0x1e52e14
00d2aee0: mov      x1, xzr
00d2aee4: bl       #0x197bc00
00d2aee8: tbz      w0, #0, #0xd2af80
00d2aeec: adrp     x8, #0x2ff8000
00d2aef0: ldr      x8, [x8, #0x50]
00d2aef4: ldr      x0, [x8]
00d2aef8: ldrb     w8, [x0, #0x133]
00d2aefc: tbz      w8, #1, #0xd2af0c
00d2af00: ldr      w8, [x0, #0xe0]
00d2af04: cbnz     w8, #0xd2af0c
00d2af08: bl       #0xa60070
00d2af0c: mov      x0, x21
00d2af10: mov      x1, xzr
00d2af14: bl       #0x1f72824
00d2af18: mov      x20, x0
00d2af1c: mov      x0, xzr
00d2af20: bl       #0x13157f0
00d2af24: adrp     x8, #0x3018000
00d2af28: ldr      x8, [x8, #0x958]
00d2af2c: mov      x2, x21
00d2af30: mov      x3, xzr
00d2af34: ldr      x1, [x8]
00d2af38: bl       #0x1e5e730
00d2af3c: mov      x1, xzr
00d2af40: bl       #0x127d95c
00d2af44: mov      x21, x0
00d2af48: mov      x0, xzr
00d2af4c: bl       #0x1984094
00d2af50: cbz      x0, #0xd2b010
00d2af54: ldr      x8, [x0]
00d2af58: mov      x1, x21
00d2af5c: ldr      x9, [x8, #0x2c8]
00d2af60: ldr      x2, [x8, #0x2d0]
00d2af64: blr      x9
00d2af68: b        #0xd2afd0
00d2af6c: mov      w2, #1
00d2af70: mov      x0, x22
00d2af74: mov      x1, x21
00d2af78: bl       #0xd2a664
00d2af7c: b        #0xd2afd0
00d2af80: mov      x0, xzr
00d2af84: bl       #0x13157f0
00d2af88: mov      x1, x21
00d2af8c: mov      x2, xzr
00d2af90: bl       #0x1e52e14
00d2af94: mov      x1, xzr
00d2af98: bl       #0x127e65c
00d2af9c: adrp     x8, #0x3018000
00d2afa0: ldr      x8, [x8, #0x2a0]
00d2afa4: mov      x21, x0
00d2afa8: ldr      x8, [x8]
00d2afac: ldrb     w9, [x8, #0x133]
00d2afb0: tbz      w9, #1, #0xd2afc4
00d2afb4: ldr      w9, [x8, #0xe0]
00d2afb8: cbnz     w9, #0xd2afc4
00d2afbc: mov      x0, x8
00d2afc0: bl       #0xa60070
00d2afc4: mov      x0, x21
00d2afc8: mov      x1, xzr
00d2afcc: bl       #0xf84ed4
00d2afd0: adrp     x8, #0x3037000
00d2afd4: ldr      x8, [x8, #0x760]
00d2afd8: ldr      x8, [x8]
00d2afdc: ldr      x8, [x8, #0xb8]
00d2afe0: ldr      x8, [x8]
00d2afe4: cbz      x8, #0xd2b010
00d2afe8: mov      x2, x20
00d2afec: mov      x3, x19
00d2aff0: ldp      x29, x30, [sp, #0x30]
00d2aff4: ldp      x20, x19, [sp, #0x20]
00d2aff8: ldp      x22, x21, [sp, #0x10]
00d2affc: mov      x1, x0
00d2b000: mov      x0, x8
00d2b004: mov      x4, xzr
00d2b008: ldr      x23, [sp], #0x40
00d2b00c: b        #0x16cb838
00d2b010: bl       #0xa60094
00d2b014: str      x19, [sp, #-0x20]!
00d2b018: stp      x29, x30, [sp, #0x10]
00d2b01c: add      x29, sp, #0x10
00d2b020: mov      x19, x0
00d2b024: mov      w0, #0x1328
00d2b028: mov      x1, xzr
00d2b02c: bl       #0xedcd74
00d2b030: tbz      w0, #0, #0xd2b058
00d2b034: mov      w0, #0x1328
00d2b038: mov      x1, xzr
00d2b03c: bl       #0xedce44
00d2b040: cbz      x0, #0xd2b06c
00d2b044: ldp      x29, x30, [sp, #0x10]
00d2b048: mov      x1, x19
00d2b04c: mov      x2, xzr
00d2b050: ldr      x19, [sp], #0x20
00d2b054: b        #0xac2a78
00d2b058: mov      w8, #1
00d2b05c: strb     w8, [x19, #0x48]
00d2b060: ldp      x29, x30, [sp, #0x10]
00d2b064: ldr      x19, [sp], #0x20
00d2b068: ret
00d2b06c: bl       #0xa60094
00d2b070: stp      x20, x19, [sp, #-0x20]!
00d2b074: stp      x29, x30, [sp, #0x10]
00d2b078: add      x29, sp, #0x10
00d2b07c: adrp     x20, #0x31f7000
00d2b080: ldrb     w8, [x20, #0xe07]
00d2b084: mov      x19, x0
00d2b088: tbnz     w8, #0, #0xd2b0a0
00d2b08c: adrp     x0, #0x3037000
00d2b090: ldr      x0, [x0, #0x760]
00d2b094: bl       #0xa5ffc0
00d2b098: mov      w8, #1
00d2b09c: strb     w8, [x20, #0xe07]
00d2b0a0: mov      w0, #0x21be
00d2b0a4: mov      x1, xzr
00d2b0a8: bl       #0xedcd74
00d2b0ac: tbz      w0, #0, #0xd2b0d4
00d2b0b0: mov      w0, #0x21be
00d2b0b4: mov      x1, xzr
00d2b0b8: bl       #0xedce44
00d2b0bc: cbz      x0, #0xd2b14c
00d2b0c0: ldp      x29, x30, [sp, #0x10]
00d2b0c4: mov      x1, x19
00d2b0c8: mov      x2, xzr
00d2b0cc: ldp      x20, x19, [sp], #0x20
00d2b0d0: b        #0xac2a78
00d2b0d4: ldrb     w8, [x19, #0x48]
00d2b0d8: cbz      w8, #0xd2b0ec
00d2b0dc: ldr      x0, [x19, #0x30]
00d2b0e0: cbz      x0, #0xd2b0ec
00d2b0e4: mov      x1, xzr
00d2b0e8: bl       #0x165fe8c
00d2b0ec: adrp     x20, #0x3037000
00d2b0f0: ldr      x20, [x20, #0x760]
00d2b0f4: ldr      x8, [x20]
00d2b0f8: ldr      x8, [x8, #0xb8]
00d2b0fc: ldr      x8, [x8]
00d2b100: cbz      x8, #0xd2b140
00d2b104: mov      x0, xzr
00d2b108: bl       #0x12c4d5c
00d2b10c: ldp      s1, s2, [x19, #0xe8]
00d2b110: fsub     s0, s0, s1
00d2b114: fcmp     s0, s2
00d2b118: b.le     #0xd2b140
00d2b11c: ldr      x8, [x20]
00d2b120: ldr      x8, [x8, #0xb8]
00d2b124: ldr      x0, [x8]
00d2b128: cbz      x0, #0xd2b14c
00d2b12c: mov      x1, xzr
00d2b130: bl       #0x16c8280
00d2b134: mov      x0, xzr
00d2b138: bl       #0x12c4d5c
00d2b13c: str      s0, [x19, #0xe8]
00d2b140: ldp      x29, x30, [sp, #0x10]
00d2b144: ldp      x20, x19, [sp], #0x20
00d2b148: ret
00d2b14c: bl       #0xa60094
00d2b150: str      x19, [sp, #-0x20]!
00d2b154: stp      x29, x30, [sp, #0x10]
00d2b158: add      x29, sp, #0x10
00d2b15c: mov      x19, x0
00d2b160: mov      w0, #0xf67
00d2b164: mov      x1, xzr
00d2b168: bl       #0xedcd74
00d2b16c: tbz      w0, #0, #0xd2b194
00d2b170: mov      w0, #0xf67
00d2b174: mov      x1, xzr
00d2b178: bl       #0xedce44
00d2b17c: cbz      x0, #0xd2b1c0
00d2b180: ldp      x29, x30, [sp, #0x10]
00d2b184: mov      x1, x19
00d2b188: mov      x2, xzr
00d2b18c: ldr      x19, [sp], #0x20
00d2b190: b        #0xac2a78
00d2b194: ldrb     w8, [x19, #0x48]
00d2b198: cbz      w8, #0xd2b1b4
00d2b19c: ldr      x0, [x19, #0x38]
00d2b1a0: cbz      x0, #0xd2b1b4
00d2b1a4: ldp      x29, x30, [sp, #0x10]
00d2b1a8: mov      x1, xzr
00d2b1ac: ldr      x19, [sp], #0x20
00d2b1b0: b        #0x165fe8c
00d2b1b4: ldp      x29, x30, [sp, #0x10]
00d2b1b8: ldr      x19, [sp], #0x20
00d2b1bc: ret
00d2b1c0: bl       #0xa60094
00d2b1c4: str      x19, [sp, #-0x20]!
00d2b1c8: stp      x29, x30, [sp, #0x10]
00d2b1cc: add      x29, sp, #0x10
00d2b1d0: mov      x19, x0
00d2b1d4: mov      w0, #0x21c4
00d2b1d8: mov      x1, xzr
00d2b1dc: bl       #0xedcd74
00d2b1e0: tbz      w0, #0, #0xd2b208
00d2b1e4: mov      w0, #0x21c4
00d2b1e8: mov      x1, xzr
00d2b1ec: bl       #0xedce44
00d2b1f0: cbz      x0, #0xd2b234
00d2b1f4: ldp      x29, x30, [sp, #0x10]
00d2b1f8: mov      x1, x19
00d2b1fc: mov      x2, xzr
00d2b200: ldr      x19, [sp], #0x20
00d2b204: b        #0xac2a78
00d2b208: ldrb     w8, [x19, #0x48]
00d2b20c: cbz      w8, #0xd2b228
00d2b210: ldr      x0, [x19, #0x28]
00d2b214: cbz      x0, #0xd2b228
00d2b218: ldp      x29, x30, [sp, #0x10]
00d2b21c: mov      x1, xzr
00d2b220: ldr      x19, [sp], #0x20
00d2b224: b        #0x165fe8c
00d2b228: ldp      x29, x30, [sp, #0x10]
00d2b22c: ldr      x19, [sp], #0x20
00d2b230: ret
00d2b234: bl       #0xa60094
00d2b238: str      x21, [sp, #-0x30]!
00d2b23c: stp      x20, x19, [sp, #0x10]
00d2b240: stp      x29, x30, [sp, #0x20]
00d2b244: add      x29, sp, #0x20
00d2b248: adrp     x21, #0x31f7000

; SecurityUtil.Xor
; RVA 0xf84ed4 file_offset 0xf84ed4
; public static byte[] Xor(byte[] buffer) { }
00f84ed4: stp      x24, x23, [sp, #-0x40]!
00f84ed8: stp      x22, x21, [sp, #0x10]
00f84edc: stp      x20, x19, [sp, #0x20]
00f84ee0: stp      x29, x30, [sp, #0x30]
00f84ee4: add      x29, sp, #0x30
00f84ee8: adrp     x20, #0x31f8000
00f84eec: ldrb     w8, [x20, #0xb00]
00f84ef0: mov      x19, x0
00f84ef4: tbnz     w8, #0, #0xf84f0c
00f84ef8: adrp     x0, #0x3018000
00f84efc: ldr      x0, [x0, #0x2a0]
00f84f00: bl       #0xa5ffc0
00f84f04: mov      w8, #1
00f84f08: strb     w8, [x20, #0xb00]
00f84f0c: mov      w0, #0x37a
00f84f10: mov      x1, xzr
00f84f14: bl       #0xedcd74
00f84f18: tbz      w0, #0, #0xf84f48
00f84f1c: mov      w0, #0x37a
00f84f20: mov      x1, xzr
00f84f24: bl       #0xedce44
00f84f28: cbz      x0, #0xf8502c
00f84f2c: mov      x1, x19
00f84f30: ldp      x29, x30, [sp, #0x30]
00f84f34: ldp      x20, x19, [sp, #0x20]
00f84f38: ldp      x22, x21, [sp, #0x10]
00f84f3c: mov      x2, xzr
00f84f40: ldp      x24, x23, [sp], #0x40
00f84f44: b        #0xaca664
00f84f48: adrp     x20, #0x3018000
00f84f4c: ldr      x20, [x20, #0x2a0]
00f84f50: ldr      x0, [x20]
00f84f54: ldrb     w8, [x0, #0x133]
00f84f58: tbz      w8, #1, #0xf84f6c
00f84f5c: ldr      w8, [x0, #0xe0]
00f84f60: cbnz     w8, #0xf84f6c
00f84f64: bl       #0xa60070
00f84f68: ldr      x0, [x20]
00f84f6c: ldr      x8, [x0, #0xb8]
00f84f70: ldr      x8, [x8]
00f84f74: cbz      x8, #0xf8502c
00f84f78: cbz      x19, #0xf8502c
00f84f7c: ldr      x9, [x19, #0x18]
00f84f80: cmp      w9, #1
00f84f84: b.lt     #0xf85008
00f84f88: ldr      w22, [x8, #0x18]
00f84f8c: mov      x21, xzr
00f84f90: and      x8, x9, #0xffffffff
00f84f94: cmp      x21, w8, uxtw
00f84f98: b.hs     #0xf85020
00f84f9c: ldr      x0, [x20]
00f84fa0: add      x23, x19, x21
00f84fa4: ldrb     w24, [x23, #0x20]
00f84fa8: ldrb     w8, [x0, #0x133]
00f84fac: tbz      w8, #1, #0xf84fc0
00f84fb0: ldr      w8, [x0, #0xe0]
00f84fb4: cbnz     w8, #0xf84fc0
00f84fb8: bl       #0xa60070
00f84fbc: ldr      x0, [x20]
00f84fc0: ldr      x8, [x0, #0xb8]
00f84fc4: ldr      x9, [x8]
00f84fc8: cbz      x9, #0xf8502c
00f84fcc: ldr      w8, [x9, #0x18]
00f84fd0: sdiv     w10, w21, w22
00f84fd4: msub     w10, w10, w22, w21
00f84fd8: cmp      w10, w8
00f84fdc: b.hs     #0xf85020
00f84fe0: ldr      w8, [x19, #0x18]
00f84fe4: cmp      x21, x8
00f84fe8: b.hs     #0xf85020
00f84fec: add      x9, x9, w10, sxtw
00f84ff0: ldrb     w9, [x9, #0x20]
00f84ff4: add      x21, x21, #1
00f84ff8: cmp      x21, w8, sxtw
00f84ffc: eor      w9, w9, w24
00f85000: strb     w9, [x23, #0x20]
00f85004: b.lt     #0xf84f94
00f85008: mov      x0, x19
00f8500c: ldp      x29, x30, [sp, #0x30]
00f85010: ldp      x20, x19, [sp, #0x20]
00f85014: ldp      x22, x21, [sp, #0x10]
00f85018: ldp      x24, x23, [sp], #0x40
00f8501c: ret
00f85020: bl       #0xa600c0
00f85024: mov      x1, xzr
00f85028: bl       #0xa60060
00f8502c: bl       #0xa60094
00f85030: str      x19, [sp, #-0x20]!
00f85034: stp      x29, x30, [sp, #0x10]
00f85038: add      x29, sp, #0x10
00f8503c: adrp     x19, #0x31f8000
00f85040: ldrb     w8, [x19, #0xb01]
00f85044: tbnz     w8, #0, #0xf85074
00f85048: adrp     x0, #0x3008000
00f8504c: ldr      x0, [x0, #0x160]
00f85050: bl       #0xa5ffc0
00f85054: adrp     x0, #0x3018000
00f85058: ldr      x0, [x0, #0x2a0]
00f8505c: bl       #0xa5ffc0
00f85060: adrp     x0, #0x3016000
00f85064: ldr      x0, [x0, #0x8d8]
00f85068: bl       #0xa5ffc0
00f8506c: mov      w8, #1
00f85070: strb     w8, [x19, #0xb01]
00f85074: adrp     x8, #0x3008000
00f85078: ldr      x8, [x8, #0x160]
00f8507c: mov      w1, #0x16
00f85080: ldr      x0, [x8]
00f85084: bl       #0xa5ffd4
00f85088: adrp     x8, #0x3016000
00f8508c: ldr      x8, [x8, #0x8d8]
00f85090: mov      x2, xzr
00f85094: mov      x19, x0
00f85098: ldr      x1, [x8]
00f8509c: bl       #0x1b443ac
00f850a0: adrp     x8, #0x3018000
00f850a4: ldr      x8, [x8, #0x2a0]
00f850a8: ldr      x8, [x8]
00f850ac: ldr      x8, [x8, #0xb8]
00f850b0: str      x19, [x8]
00f850b4: ldp      x29, x30, [sp, #0x10]
00f850b8: ldr      x19, [sp], #0x20
00f850bc: ret
00f850c0: str      x19, [sp, #-0x20]!
00f850c4: stp      x29, x30, [sp, #0x10]
00f850c8: add      x29, sp, #0x10
00f850cc: mov      x19, x0
00f850d0: mov      w0, #0x25e7
00f850d4: mov      x1, xzr
00f850d8: bl       #0xedcd74
00f850dc: tbz      w0, #0, #0xf85104
00f850e0: mov      w0, #0x25e7
00f850e4: mov      x1, xzr
00f850e8: bl       #0xedce44
00f850ec: cbz      x0, #0xf85118
00f850f0: ldp      x29, x30, [sp, #0x10]
00f850f4: mov      x1, x19
00f850f8: mov      x2, xzr
00f850fc: ldr      x19, [sp], #0x20
00f85100: b        #0xac2a78
00f85104: mov      w8, #0x3f800000
00f85108: str      w8, [x19, #0x10]
00f8510c: ldp      x29, x30, [sp, #0x10]
00f85110: ldr      x19, [sp], #0x20
00f85114: ret
00f85118: bl       #0xa60094
00f8511c: mov      x1, xzr
00f85120: b        #0x1dcd4c8
00f85124: stp      x22, x21, [sp, #-0x30]!
00f85128: stp      x20, x19, [sp, #0x10]
00f8512c: stp      x29, x30, [sp, #0x20]
00f85130: add      x29, sp, #0x20
00f85134: adrp     x22, #0x31f8000
00f85138: ldrb     w8, [x22, #0xb02]
00f8513c: mov      x20, x2
00f85140: mov      x21, x1
00f85144: mov      x19, x0
00f85148: tbnz     w8, #0, #0xf85160
00f8514c: adrp     x0, #0x3043000
00f85150: ldr      x0, [x0, #0xf80]
00f85154: bl       #0xa5ffc0
00f85158: mov      w8, #1
00f8515c: strb     w8, [x22, #0xb02]
00f85160: mov      w0, #0x25e8
00f85164: mov      x1, xzr
00f85168: bl       #0xedcd74
00f8516c: tbz      w0, #0, #0xf851a0
00f85170: mov      w0, #0x25e8
00f85174: mov      x1, xzr
00f85178: bl       #0xedce44
00f8517c: cbz      x0, #0xf851e4
00f85180: mov      x1, x19
00f85184: mov      x3, x20
00f85188: ldp      x29, x30, [sp, #0x20]
00f8518c: ldp      x20, x19, [sp, #0x10]
00f85190: mov      x2, x21
00f85194: mov      x4, xzr
00f85198: ldp      x22, x21, [sp], #0x30
00f8519c: b        #0xb260fc
00f851a0: adrp     x8, #0x3043000
00f851a4: ldr      x8, [x8, #0xf80]
00f851a8: mov      x0, x19
00f851ac: mov      x1, x21
00f851b0: mov      x2, x20
00f851b4: ldr      x3, [x8]
00f851b8: bl       #0x1260020
00f851bc: ldr      x8, [x19, #0x18]
00f851c0: cbz      x8, #0xf851e4
00f851c4: ldr      x8, [x8, #0x10]
00f851c8: cbz      x8, #0xf851e4
00f851cc: ldr      w9, [x19, #0x20]
00f851d0: str      w9, [x8, #0x10]
00f851d4: ldp      x29, x30, [sp, #0x20]
00f851d8: ldp      x20, x19, [sp, #0x10]
00f851dc: ldp      x22, x21, [sp], #0x30
00f851e0: ret
00f851e4: bl       #0xa60094
00f851e8: stp      x20, x19, [sp, #-0x20]!
00f851ec: stp      x29, x30, [sp, #0x10]
00f851f0: add      x29, sp, #0x10
00f851f4: adrp     x20, #0x31f8000
00f851f8: ldrb     w8, [x20, #0xb03]
00f851fc: mov      x19, x0
00f85200: tbnz     w8, #0, #0xf85218
00f85204: adrp     x0, #0x303d000
00f85208: ldr      x0, [x0, #0xd18]
00f8520c: bl       #0xa5ffc0
00f85210: mov      w8, #1
00f85214: strb     w8, [x20, #0xb03]
00f85218: adrp     x8, #0x303d000
00f8521c: ldr      x8, [x8, #0xd18]
00f85220: ldp      x29, x30, [sp, #0x10]
00f85224: mov      x0, x19
00f85228: ldr      x1, [x8]
00f8522c: ldp      x20, x19, [sp], #0x20
00f85230: b        #0x1260024
00f85234: sub      sp, sp, #0xb0
00f85238: stp      x22, x21, [sp, #0x80]
00f8523c: stp      x20, x19, [sp, #0x90]
00f85240: stp      x29, x30, [sp, #0xa0]
00f85244: add      x29, sp, #0xa0
00f85248: mov      x20, x1
00f8524c: mov      x21, x0
00f85250: mov      w0, #0x25e9
00f85254: mov      x1, xzr
00f85258: mov      x22, x3
00f8525c: mov      x19, x2
00f85260: bl       #0xedcd74
00f85264: tbz      w0, #0, #0xf852c4
00f85268: mov      w0, #0x25e9
00f8526c: mov      x1, xzr
00f85270: bl       #0xedce44
00f85274: ldp      q1, q0, [x22, #0x20]
00f85278: ldp      q3, q2, [x22]
00f8527c: stp      q1, q0, [sp, #0x60]
00f85280: stp      q3, q2, [sp, #0x40]
00f85284: cbz      x0, #0xf852e4
00f85288: ldp      q1, q0, [sp, #0x60]
00f8528c: ldp      q3, q2, [sp, #0x40]
00f85290: mov      x4, sp
00f85294: mov      x1, x21
00f85298: mov      x2, x20
00f8529c: mov      x3, x19
00f852a0: mov      x5, xzr
00f852a4: stp      q1, q0, [sp, #0x20]
00f852a8: stp      q3, q2, [sp]
00f852ac: bl       #0xac22bc
00f852b0: ldp      x29, x30, [sp, #0xa0]
00f852b4: ldp      x20, x19, [sp, #0x90]
00f852b8: ldp      x22, x21, [sp, #0x80]
00f852bc: add      sp, sp, #0xb0
00f852c0: ret
00f852c4: ldr      x1, [x21, #0x10]
00f852c8: ldp      x29, x30, [sp, #0xa0]
00f852cc: ldp      x20, x19, [sp, #0x90]
00f852d0: ldp      x22, x21, [sp, #0x80]
00f852d4: mov      w0, #0x2714
00f852d8: mov      x2, xzr
00f852dc: add      sp, sp, #0xb0
00f852e0: b        #0x16c93d4
00f852e4: bl       #0xa60094
00f852e8: sub      sp, sp, #0xb0
00f852ec: stp      x22, x21, [sp, #0x80]
00f852f0: stp      x20, x19, [sp, #0x90]
00f852f4: stp      x29, x30, [sp, #0xa0]
00f852f8: add      x29, sp, #0xa0
00f852fc: mov      x20, x1
00f85300: mov      x21, x0
00f85304: mov      w0, #0x25ea
00f85308: mov      x1, xzr
00f8530c: mov      x22, x3
00f85310: mov      x19, x2
00f85314: bl       #0xedcd74
00f85318: tbz      w0, #0, #0xf85378
00f8531c: mov      w0, #0x25ea
00f85320: mov      x1, xzr
00f85324: bl       #0xedce44
00f85328: ldp      q1, q0, [x22, #0x20]
00f8532c: ldp      q3, q2, [x22]
00f85330: stp      q1, q0, [sp, #0x60]
00f85334: stp      q3, q2, [sp, #0x40]
00f85338: cbz      x0, #0xf85398
00f8533c: ldp      q1, q0, [sp, #0x60]
00f85340: ldp      q3, q2, [sp, #0x40]
00f85344: mov      x4, sp
00f85348: mov      x1, x21
00f8534c: mov      x2, x20
00f85350: mov      x3, x19

; SecurityUtil..cctor
; RVA 0xf85030 file_offset 0xf85030
; private static void .cctor()
00f85030: str      x19, [sp, #-0x20]!
00f85034: stp      x29, x30, [sp, #0x10]
00f85038: add      x29, sp, #0x10
00f8503c: adrp     x19, #0x31f8000
00f85040: ldrb     w8, [x19, #0xb01]
00f85044: tbnz     w8, #0, #0xf85074
00f85048: adrp     x0, #0x3008000
00f8504c: ldr      x0, [x0, #0x160]
00f85050: bl       #0xa5ffc0
00f85054: adrp     x0, #0x3018000
00f85058: ldr      x0, [x0, #0x2a0]
00f8505c: bl       #0xa5ffc0
00f85060: adrp     x0, #0x3016000
00f85064: ldr      x0, [x0, #0x8d8]
00f85068: bl       #0xa5ffc0
00f8506c: mov      w8, #1
00f85070: strb     w8, [x19, #0xb01]
00f85074: adrp     x8, #0x3008000
00f85078: ldr      x8, [x8, #0x160]
00f8507c: mov      w1, #0x16
00f85080: ldr      x0, [x8]
00f85084: bl       #0xa5ffd4
00f85088: adrp     x8, #0x3016000
00f8508c: ldr      x8, [x8, #0x8d8]
00f85090: mov      x2, xzr
00f85094: mov      x19, x0
00f85098: ldr      x1, [x8]
00f8509c: bl       #0x1b443ac
00f850a0: adrp     x8, #0x3018000
00f850a4: ldr      x8, [x8, #0x2a0]
00f850a8: ldr      x8, [x8]
00f850ac: ldr      x8, [x8, #0xb8]
00f850b0: str      x19, [x8]
00f850b4: ldp      x29, x30, [sp, #0x10]
00f850b8: ldr      x19, [sp], #0x20
00f850bc: ret
00f850c0: str      x19, [sp, #-0x20]!
00f850c4: stp      x29, x30, [sp, #0x10]
00f850c8: add      x29, sp, #0x10
00f850cc: mov      x19, x0
00f850d0: mov      w0, #0x25e7
00f850d4: mov      x1, xzr
00f850d8: bl       #0xedcd74
00f850dc: tbz      w0, #0, #0xf85104
00f850e0: mov      w0, #0x25e7
00f850e4: mov      x1, xzr
00f850e8: bl       #0xedce44
00f850ec: cbz      x0, #0xf85118
00f850f0: ldp      x29, x30, [sp, #0x10]
00f850f4: mov      x1, x19
00f850f8: mov      x2, xzr
00f850fc: ldr      x19, [sp], #0x20
00f85100: b        #0xac2a78
00f85104: mov      w8, #0x3f800000
00f85108: str      w8, [x19, #0x10]
00f8510c: ldp      x29, x30, [sp, #0x10]
00f85110: ldr      x19, [sp], #0x20
00f85114: ret
00f85118: bl       #0xa60094
00f8511c: mov      x1, xzr
00f85120: b        #0x1dcd4c8
00f85124: stp      x22, x21, [sp, #-0x30]!
00f85128: stp      x20, x19, [sp, #0x10]
00f8512c: stp      x29, x30, [sp, #0x20]
00f85130: add      x29, sp, #0x20
00f85134: adrp     x22, #0x31f8000
00f85138: ldrb     w8, [x22, #0xb02]
00f8513c: mov      x20, x2
00f85140: mov      x21, x1
00f85144: mov      x19, x0
00f85148: tbnz     w8, #0, #0xf85160
00f8514c: adrp     x0, #0x3043000
00f85150: ldr      x0, [x0, #0xf80]
00f85154: bl       #0xa5ffc0
00f85158: mov      w8, #1
00f8515c: strb     w8, [x22, #0xb02]
00f85160: mov      w0, #0x25e8
00f85164: mov      x1, xzr
00f85168: bl       #0xedcd74
00f8516c: tbz      w0, #0, #0xf851a0
00f85170: mov      w0, #0x25e8
00f85174: mov      x1, xzr
00f85178: bl       #0xedce44
00f8517c: cbz      x0, #0xf851e4
00f85180: mov      x1, x19
00f85184: mov      x3, x20
00f85188: ldp      x29, x30, [sp, #0x20]
00f8518c: ldp      x20, x19, [sp, #0x10]
00f85190: mov      x2, x21
00f85194: mov      x4, xzr
00f85198: ldp      x22, x21, [sp], #0x30
00f8519c: b        #0xb260fc
00f851a0: adrp     x8, #0x3043000
00f851a4: ldr      x8, [x8, #0xf80]
00f851a8: mov      x0, x19
00f851ac: mov      x1, x21
00f851b0: mov      x2, x20
00f851b4: ldr      x3, [x8]
00f851b8: bl       #0x1260020
00f851bc: ldr      x8, [x19, #0x18]
00f851c0: cbz      x8, #0xf851e4
00f851c4: ldr      x8, [x8, #0x10]
00f851c8: cbz      x8, #0xf851e4
00f851cc: ldr      w9, [x19, #0x20]
00f851d0: str      w9, [x8, #0x10]
00f851d4: ldp      x29, x30, [sp, #0x20]
00f851d8: ldp      x20, x19, [sp, #0x10]
00f851dc: ldp      x22, x21, [sp], #0x30
00f851e0: ret
00f851e4: bl       #0xa60094
00f851e8: stp      x20, x19, [sp, #-0x20]!
00f851ec: stp      x29, x30, [sp, #0x10]
00f851f0: add      x29, sp, #0x10
00f851f4: adrp     x20, #0x31f8000
00f851f8: ldrb     w8, [x20, #0xb03]
00f851fc: mov      x19, x0
00f85200: tbnz     w8, #0, #0xf85218
00f85204: adrp     x0, #0x303d000
00f85208: ldr      x0, [x0, #0xd18]
00f8520c: bl       #0xa5ffc0
00f85210: mov      w8, #1
00f85214: strb     w8, [x20, #0xb03]
00f85218: adrp     x8, #0x303d000
00f8521c: ldr      x8, [x8, #0xd18]
00f85220: ldp      x29, x30, [sp, #0x10]
00f85224: mov      x0, x19
00f85228: ldr      x1, [x8]
00f8522c: ldp      x20, x19, [sp], #0x20
00f85230: b        #0x1260024
00f85234: sub      sp, sp, #0xb0
00f85238: stp      x22, x21, [sp, #0x80]
00f8523c: stp      x20, x19, [sp, #0x90]
00f85240: stp      x29, x30, [sp, #0xa0]
00f85244: add      x29, sp, #0xa0
00f85248: mov      x20, x1
00f8524c: mov      x21, x0
00f85250: mov      w0, #0x25e9
00f85254: mov      x1, xzr
00f85258: mov      x22, x3
00f8525c: mov      x19, x2
00f85260: bl       #0xedcd74
00f85264: tbz      w0, #0, #0xf852c4
00f85268: mov      w0, #0x25e9
00f8526c: mov      x1, xzr
00f85270: bl       #0xedce44
00f85274: ldp      q1, q0, [x22, #0x20]
00f85278: ldp      q3, q2, [x22]
00f8527c: stp      q1, q0, [sp, #0x60]
00f85280: stp      q3, q2, [sp, #0x40]
00f85284: cbz      x0, #0xf852e4
00f85288: ldp      q1, q0, [sp, #0x60]
00f8528c: ldp      q3, q2, [sp, #0x40]
00f85290: mov      x4, sp
00f85294: mov      x1, x21
00f85298: mov      x2, x20
00f8529c: mov      x3, x19
00f852a0: mov      x5, xzr
00f852a4: stp      q1, q0, [sp, #0x20]
00f852a8: stp      q3, q2, [sp]
00f852ac: bl       #0xac22bc
00f852b0: ldp      x29, x30, [sp, #0xa0]
00f852b4: ldp      x20, x19, [sp, #0x90]
00f852b8: ldp      x22, x21, [sp, #0x80]
00f852bc: add      sp, sp, #0xb0
00f852c0: ret
00f852c4: ldr      x1, [x21, #0x10]
00f852c8: ldp      x29, x30, [sp, #0xa0]
00f852cc: ldp      x20, x19, [sp, #0x90]
00f852d0: ldp      x22, x21, [sp, #0x80]
00f852d4: mov      w0, #0x2714
00f852d8: mov      x2, xzr
00f852dc: add      sp, sp, #0xb0
00f852e0: b        #0x16c93d4
00f852e4: bl       #0xa60094
00f852e8: sub      sp, sp, #0xb0
00f852ec: stp      x22, x21, [sp, #0x80]
00f852f0: stp      x20, x19, [sp, #0x90]
00f852f4: stp      x29, x30, [sp, #0xa0]
00f852f8: add      x29, sp, #0xa0
00f852fc: mov      x20, x1
00f85300: mov      x21, x0
00f85304: mov      w0, #0x25ea
00f85308: mov      x1, xzr
00f8530c: mov      x22, x3
00f85310: mov      x19, x2
00f85314: bl       #0xedcd74
00f85318: tbz      w0, #0, #0xf85378
00f8531c: mov      w0, #0x25ea
00f85320: mov      x1, xzr
00f85324: bl       #0xedce44
00f85328: ldp      q1, q0, [x22, #0x20]
00f8532c: ldp      q3, q2, [x22]
00f85330: stp      q1, q0, [sp, #0x60]
00f85334: stp      q3, q2, [sp, #0x40]
00f85338: cbz      x0, #0xf85398
00f8533c: ldp      q1, q0, [sp, #0x60]
00f85340: ldp      q3, q2, [sp, #0x40]
00f85344: mov      x4, sp
00f85348: mov      x1, x21
00f8534c: mov      x2, x20
00f85350: mov      x3, x19
00f85354: mov      x5, xzr
00f85358: stp      q1, q0, [sp, #0x20]
00f8535c: stp      q3, q2, [sp]
00f85360: bl       #0xac22bc
00f85364: ldp      x29, x30, [sp, #0xa0]
00f85368: ldp      x20, x19, [sp, #0x90]
00f8536c: ldp      x22, x21, [sp, #0x80]
00f85370: add      sp, sp, #0xb0
00f85374: ret
00f85378: ldp      x29, x30, [sp, #0xa0]
00f8537c: ldp      x20, x19, [sp, #0x90]
00f85380: ldp      x22, x21, [sp, #0x80]
00f85384: mov      w0, #0x2715
00f85388: mov      x1, xzr
00f8538c: mov      x2, xzr
00f85390: add      sp, sp, #0xb0
00f85394: b        #0x16c93d4
00f85398: bl       #0xa60094
00f8539c: stp      x20, x19, [sp, #-0x20]!
00f853a0: stp      x29, x30, [sp, #0x10]
00f853a4: add      x29, sp, #0x10
00f853a8: adrp     x20, #0x31f8000
00f853ac: ldrb     w8, [x20, #0xb04]
00f853b0: mov      x19, x0
00f853b4: tbnz     w8, #0, #0xf853cc
00f853b8: adrp     x0, #0x302d000
00f853bc: ldr      x0, [x0, #0x108]
00f853c0: bl       #0xa5ffc0
00f853c4: mov      w8, #1
00f853c8: strb     w8, [x20, #0xb04]
00f853cc: adrp     x8, #0x302d000
00f853d0: ldr      x8, [x8, #0x108]
00f853d4: ldp      x29, x30, [sp, #0x10]
00f853d8: mov      x0, x19
00f853dc: ldr      x1, [x8]
00f853e0: ldp      x20, x19, [sp], #0x20
00f853e4: b        #0x12605cc
00f853e8: stp      x20, x19, [sp, #-0x20]!
00f853ec: stp      x29, x30, [sp, #0x10]
00f853f0: add      x29, sp, #0x10
00f853f4: adrp     x20, #0x31f8000
00f853f8: ldrb     w8, [x20, #0xb05]
00f853fc: mov      x19, x0
00f85400: tbnz     w8, #0, #0xf85418
00f85404: adrp     x0, #0x3040000
00f85408: ldr      x0, [x0, #0x7e0]
00f8540c: bl       #0xa5ffc0
00f85410: mov      w8, #1
00f85414: strb     w8, [x20, #0xb05]
00f85418: adrp     x8, #0x3040000
00f8541c: ldr      x8, [x8, #0x7e0]
00f85420: ldr      x0, [x8]
00f85424: ldrb     w8, [x0, #0x133]
00f85428: tbz      w8, #1, #0xf85438
00f8542c: ldr      w8, [x0, #0xe0]
00f85430: cbnz     w8, #0xf85438
00f85434: bl       #0xa60070
00f85438: ldp      x29, x30, [sp, #0x10]
00f8543c: mov      x0, x19
00f85440: mov      x1, xzr
00f85444: ldp      x20, x19, [sp], #0x20
00f85448: b        #0x1bc64b0
00f8544c: stp      x20, x19, [sp, #-0x20]!
00f85450: stp      x29, x30, [sp, #0x10]
00f85454: add      x29, sp, #0x10
00f85458: adrp     x20, #0x31f8000
00f8545c: ldrb     w8, [x20, #0xb06]
00f85460: mov      x19, x0
00f85464: tbnz     w8, #0, #0xf8547c
00f85468: adrp     x0, #0x2ffc000
00f8546c: ldr      x0, [x0, #0x4a8]
00f85470: bl       #0xa5ffc0
00f85474: mov      w8, #1
00f85478: strb     w8, [x20, #0xb06]
00f8547c: mov      w0, #0x2017
00f85480: mov      x1, xzr
00f85484: bl       #0xedcd74
00f85488: tbz      w0, #0, #0xf854b0
00f8548c: mov      w0, #0x2017
00f85490: mov      x1, xzr
00f85494: bl       #0xedce44
00f85498: cbz      x0, #0xf854e4
00f8549c: ldp      x29, x30, [sp, #0x10]
00f854a0: mov      x1, x19
00f854a4: mov      x2, xzr
00f854a8: ldp      x20, x19, [sp], #0x20
00f854ac: b        #0xac2a78

; XXTEAUtil.Encrypt(byte[])
; RVA 0x1c78d98 file_offset 0x1c78d98
; public static byte[] Encrypt(byte[] data) { }
01c78d98: stp      x20, x19, [sp, #-0x20]!
01c78d9c: stp      x29, x30, [sp, #0x10]
01c78da0: add      x29, sp, #0x10
01c78da4: adrp     x20, #0x3200000
01c78da8: ldrb     w8, [x20, #0x97a]
01c78dac: mov      x19, x0
01c78db0: tbnz     w8, #0, #0x1c78dc8
01c78db4: adrp     x0, #0x300c000
01c78db8: ldr      x0, [x0, #0xdd8]
01c78dbc: bl       #0xa5ffc0
01c78dc0: mov      w8, #1
01c78dc4: strb     w8, [x20, #0x97a]
01c78dc8: mov      w0, #0x1fa
01c78dcc: mov      x1, xzr
01c78dd0: bl       #0xedcd74
01c78dd4: tbz      w0, #0, #0x1c78dfc
01c78dd8: mov      w0, #0x1fa
01c78ddc: mov      x1, xzr
01c78de0: bl       #0xedce44
01c78de4: cbz      x0, #0x1c78e7c
01c78de8: ldp      x29, x30, [sp, #0x10]
01c78dec: mov      x1, x19
01c78df0: mov      x2, xzr
01c78df4: ldp      x20, x19, [sp], #0x20
01c78df8: b        #0xaca664
01c78dfc: cbz      x19, #0x1c78e7c
01c78e00: ldr      x8, [x19, #0x18]
01c78e04: cbz      x8, #0x1c78e6c
01c78e08: adrp     x20, #0x300c000
01c78e0c: ldr      x20, [x20, #0xdd8]
01c78e10: ldr      x0, [x20]
01c78e14: ldrb     w8, [x0, #0x133]
01c78e18: tbz      w8, #1, #0x1c78e28
01c78e1c: ldr      w8, [x0, #0xe0]
01c78e20: cbnz     w8, #0x1c78e28
01c78e24: bl       #0xa60070
01c78e28: mov      w1, #1
01c78e2c: mov      x0, x19
01c78e30: bl       #0x1c78e80
01c78e34: ldr      x8, [x20]
01c78e38: mov      x19, x0
01c78e3c: mov      w1, wzr
01c78e40: ldr      x8, [x8, #0xb8]
01c78e44: ldr      x8, [x8]
01c78e48: mov      x0, x8
01c78e4c: bl       #0x1c78e80
01c78e50: mov      x1, x0
01c78e54: mov      x0, x19
01c78e58: bl       #0x1c7907c
01c78e5c: ldp      x29, x30, [sp, #0x10]
01c78e60: mov      w1, wzr
01c78e64: ldp      x20, x19, [sp], #0x20
01c78e68: b        #0x1c793b0
01c78e6c: ldp      x29, x30, [sp, #0x10]
01c78e70: mov      x0, x19
01c78e74: ldp      x20, x19, [sp], #0x20
01c78e78: ret
01c78e7c: bl       #0xa60094
01c78e80: str      x25, [sp, #-0x50]!
01c78e84: stp      x24, x23, [sp, #0x10]
01c78e88: stp      x22, x21, [sp, #0x20]
01c78e8c: stp      x20, x19, [sp, #0x30]
01c78e90: stp      x29, x30, [sp, #0x40]
01c78e94: add      x29, sp, #0x40
01c78e98: adrp     x21, #0x3200000
01c78e9c: ldrb     w8, [x21, #0x983]
01c78ea0: mov      w20, w1
01c78ea4: mov      x19, x0
01c78ea8: tbnz     w8, #0, #0x1c78ecc
01c78eac: adrp     x0, #0x2ffc000
01c78eb0: ldr      x0, [x0, #0x620]
01c78eb4: bl       #0xa5ffc0
01c78eb8: adrp     x0, #0x300c000
01c78ebc: ldr      x0, [x0, #0xdd8]
01c78ec0: bl       #0xa5ffc0
01c78ec4: mov      w8, #1
01c78ec8: strb     w8, [x21, #0x983]
01c78ecc: mov      w0, #0x153
01c78ed0: mov      x1, xzr
01c78ed4: bl       #0xedcd74
01c78ed8: tbz      w0, #0, #0x1c78f10
01c78edc: mov      w0, #0x153
01c78ee0: mov      x1, xzr
01c78ee4: bl       #0xedce44
01c78ee8: cbz      x0, #0x1c79078
01c78eec: and      w2, w20, #1
01c78ef0: mov      x1, x19
01c78ef4: ldp      x29, x30, [sp, #0x40]
01c78ef8: ldp      x20, x19, [sp, #0x30]
01c78efc: ldp      x22, x21, [sp, #0x20]
01c78f00: ldp      x24, x23, [sp, #0x10]
01c78f04: mov      x3, xzr
01c78f08: ldr      x25, [sp], #0x50
01c78f0c: b        #0xacad4c
01c78f10: cbz      x19, #0x1c79078
01c78f14: adrp     x22, #0x300c000
01c78f18: ldr      x22, [x22, #0xdd8]
01c78f1c: ldr      x0, [x19, #0x18]
01c78f20: ldr      x8, [x22]
01c78f24: tst      x0, #3
01c78f28: ldrh     w9, [x8, #0x132]
01c78f2c: b.eq     #0x1c78f58
01c78f30: tbz      w9, #9, #0x1c78f48
01c78f34: ldr      w9, [x8, #0xe0]
01c78f38: cbnz     w9, #0x1c78f48
01c78f3c: mov      x0, x8
01c78f40: bl       #0xa60070
01c78f44: ldr      x0, [x19, #0x18]
01c78f48: mov      w1, #2
01c78f4c: bl       #0x1c7a1c4
01c78f50: add      w21, w0, #1
01c78f54: b        #0x1c78f7c
01c78f58: tbz      w9, #9, #0x1c78f70
01c78f5c: ldr      w9, [x8, #0xe0]
01c78f60: cbnz     w9, #0x1c78f70
01c78f64: mov      x0, x8
01c78f68: bl       #0xa60070
01c78f6c: ldr      x0, [x19, #0x18]
01c78f70: mov      w1, #2
01c78f74: bl       #0x1c7a1c4
01c78f78: mov      w21, w0
01c78f7c: adrp     x8, #0x2ffc000
01c78f80: ldr      x8, [x8, #0x620]
01c78f84: ldr      x0, [x8]
01c78f88: tbz      w20, #0, #0x1c78fb8
01c78f8c: add      w1, w21, #1
01c78f90: bl       #0xa5ffd4
01c78f94: cbz      x0, #0x1c79078
01c78f98: ldr      w8, [x0, #0x18]
01c78f9c: mov      x20, x0
01c78fa0: cmp      w21, w8
01c78fa4: b.hs     #0x1c7906c
01c78fa8: ldr      x8, [x19, #0x18]
01c78fac: add      x9, x20, w21, sxtw #2
01c78fb0: str      w8, [x9, #0x20]
01c78fb4: b        #0x1c78fc4
01c78fb8: mov      w1, w21
01c78fbc: bl       #0xa5ffd4
01c78fc0: mov      x20, x0
01c78fc4: ldr      x8, [x19, #0x18]
01c78fc8: cmp      w8, #1
01c78fcc: b.lt     #0x1c79050
01c78fd0: mov      w23, wzr
01c78fd4: mov      x21, xzr
01c78fd8: sxtw     x24, w8
01c78fdc: add      x25, x19, #0x20
01c78fe0: ldr      x0, [x22]
01c78fe4: ldrb     w8, [x0, #0x133]
01c78fe8: tbz      w8, #1, #0x1c78ff8
01c78fec: ldr      w8, [x0, #0xe0]
01c78ff0: cbnz     w8, #0x1c78ff8
01c78ff4: bl       #0xa60070
01c78ff8: mov      w1, #2
01c78ffc: mov      w0, w21
01c79000: bl       #0x1c7a1c4
01c79004: cbz      x20, #0x1c79078
01c79008: ldr      w8, [x20, #0x18]
01c7900c: cmp      w0, w8
01c79010: b.hs     #0x1c7906c
01c79014: ldr      w8, [x19, #0x18]
01c79018: cmp      x21, x8
01c7901c: b.hs     #0x1c7906c
01c79020: add      x8, x20, w0, sxtw #2
01c79024: ldrb     w9, [x25, x21]
01c79028: add      x8, x8, #0x20
01c7902c: ldr      w11, [x8]
01c79030: and      w10, w23, #0x18
01c79034: add      x21, x21, #1
01c79038: lsl      w9, w9, w10
01c7903c: cmp      x21, x24
01c79040: orr      w9, w9, w11
01c79044: add      w23, w23, #8
01c79048: str      w9, [x8]
01c7904c: b.lt     #0x1c78fe0
01c79050: mov      x0, x20
01c79054: ldp      x29, x30, [sp, #0x40]
01c79058: ldp      x20, x19, [sp, #0x30]
01c7905c: ldp      x22, x21, [sp, #0x20]
01c79060: ldp      x24, x23, [sp, #0x10]
01c79064: ldr      x25, [sp], #0x50
01c79068: ret
01c7906c: bl       #0xa600c0
01c79070: mov      x1, xzr
01c79074: bl       #0xa60060
01c79078: bl       #0xa60094
01c7907c: sub      sp, sp, #0x90
01c79080: stp      x28, x27, [sp, #0x30]
01c79084: stp      x26, x25, [sp, #0x40]
01c79088: stp      x24, x23, [sp, #0x50]
01c7908c: stp      x22, x21, [sp, #0x60]
01c79090: stp      x20, x19, [sp, #0x70]
01c79094: stp      x29, x30, [sp, #0x80]
01c79098: add      x29, sp, #0x80
01c7909c: adrp     x21, #0x3200000
01c790a0: ldrb     w8, [x21, #0x981]
01c790a4: mov      x20, x1
01c790a8: str      x0, [sp, #0x28]
01c790ac: tbnz     w8, #0, #0x1c790d0
01c790b0: adrp     x0, #0x2ffc000
01c790b4: ldr      x0, [x0, #0x620]
01c790b8: bl       #0xa5ffc0
01c790bc: adrp     x0, #0x300c000
01c790c0: ldr      x0, [x0, #0xdd8]
01c790c4: bl       #0xa5ffc0
01c790c8: mov      w8, #1
01c790cc: strb     w8, [x21, #0x981]
01c790d0: mov      w0, #0x155
01c790d4: mov      x1, xzr
01c790d8: bl       #0xedcd74
01c790dc: tbz      w0, #0, #0x1c7911c
01c790e0: mov      w0, #0x155
01c790e4: mov      x1, xzr
01c790e8: bl       #0xedce44
01c790ec: ldr      x1, [sp, #0x28]
01c790f0: cbz      x0, #0x1c793ac
01c790f4: mov      x2, x20
01c790f8: ldp      x29, x30, [sp, #0x80]
01c790fc: ldp      x20, x19, [sp, #0x70]
01c79100: ldp      x22, x21, [sp, #0x60]
01c79104: ldp      x24, x23, [sp, #0x50]
01c79108: ldp      x26, x25, [sp, #0x40]
01c7910c: ldp      x28, x27, [sp, #0x30]
01c79110: mov      x3, xzr
01c79114: add      sp, sp, #0x90
01c79118: b        #0xacae48
01c7911c: ldr      x21, [sp, #0x28]
01c79120: cbz      x21, #0x1c793ac
01c79124: ldr      x22, [x21, #0x18]
01c79128: sub      w8, w22, #1
01c7912c: cmp      w8, #1
01c79130: str      x8, [sp, #0x10]
01c79134: b.lt     #0x1c7937c
01c79138: cbz      x20, #0x1c793ac
01c7913c: ldr      w8, [x20, #0x18]
01c79140: cmp      w8, #3
01c79144: b.le     #0x1c79150
01c79148: mov      x8, x22
01c7914c: b        #0x1c79190
01c79150: adrp     x8, #0x2ffc000
01c79154: ldr      x8, [x8, #0x620]
01c79158: mov      w1, #4
01c7915c: ldr      x0, [x8]
01c79160: bl       #0xa5ffd4
01c79164: ldr      w4, [x20, #0x18]
01c79168: mov      x19, x21
01c7916c: mov      x21, x0
01c79170: mov      x0, x20
01c79174: mov      w1, wzr
01c79178: mov      x2, x21
01c7917c: mov      w3, wzr
01c79180: mov      x5, xzr
01c79184: bl       #0x16675c0
01c79188: ldr      x8, [x19, #0x18]
01c7918c: mov      x20, x21
01c79190: ldr      x9, [sp, #0x10]
01c79194: cmp      w9, w8
01c79198: b.hs     #0x1c793a0
01c7919c: mov      w8, #0x34
01c791a0: ldr      x21, [sp, #0x28]
01c791a4: sdiv     w8, w8, w22
01c791a8: add      w9, w8, #6
01c791ac: cmp      w9, #1
01c791b0: b.lt     #0x1c7937c
01c791b4: ldr      x9, [sp, #0x10]
01c791b8: mov      w24, wzr
01c791bc: add      w8, w8, #5
01c791c0: sxtw     x10, w9
01c791c4: add      x9, x21, w9, sxtw #2
01c791c8: add      x28, x9, #0x20
01c791cc: ldr      w22, [x28]
01c791d0: str      x10, [sp, #0x20]
01c791d4: str      x28, [sp, #8]
01c791d8: str      w8, [sp, #0x1c]
01c791dc: adrp     x8, #0x300c000
01c791e0: ldr      x8, [x8, #0xdd8]
01c791e4: mov      w9, #0x79b9
01c791e8: movk     w9, #0x9e37, lsl #16
01c791ec: add      w24, w24, w9
01c791f0: ldr      x0, [x8]
01c791f4: ldrb     w8, [x0, #0x133]
01c791f8: tbz      w8, #1, #0x1c79208
01c791fc: ldr      w8, [x0, #0xe0]
01c79200: cbnz     w8, #0x1c79208
01c79204: bl       #0xa60070
01c79208: mov      w1, #2
01c7920c: mov      w0, w24
01c79210: bl       #0x1c7a1c4
01c79214: mov      x28, xzr

; XXTEAUtil.Decrypt(byte[])
; RVA 0x1c79540 file_offset 0x1c79540
; public static byte[] Decrypt(byte[] data) { }
01c79540: stp      x20, x19, [sp, #-0x20]!
01c79544: stp      x29, x30, [sp, #0x10]
01c79548: add      x29, sp, #0x10
01c7954c: adrp     x20, #0x3200000
01c79550: ldrb     w8, [x20, #0x97b]
01c79554: mov      x19, x0
01c79558: tbnz     w8, #0, #0x1c79570
01c7955c: adrp     x0, #0x300c000
01c79560: ldr      x0, [x0, #0xdd8]
01c79564: bl       #0xa5ffc0
01c79568: mov      w8, #1
01c7956c: strb     w8, [x20, #0x97b]
01c79570: mov      w0, #0x1fb
01c79574: mov      x1, xzr
01c79578: bl       #0xedcd74
01c7957c: tbz      w0, #0, #0x1c795a4
01c79580: mov      w0, #0x1fb
01c79584: mov      x1, xzr
01c79588: bl       #0xedce44
01c7958c: cbz      x0, #0x1c79624
01c79590: ldp      x29, x30, [sp, #0x10]
01c79594: mov      x1, x19
01c79598: mov      x2, xzr
01c7959c: ldp      x20, x19, [sp], #0x20
01c795a0: b        #0xaca664
01c795a4: cbz      x19, #0x1c79624
01c795a8: ldr      x8, [x19, #0x18]
01c795ac: cbz      x8, #0x1c79614
01c795b0: adrp     x20, #0x300c000
01c795b4: ldr      x20, [x20, #0xdd8]
01c795b8: ldr      x0, [x20]
01c795bc: ldrb     w8, [x0, #0x133]
01c795c0: tbz      w8, #1, #0x1c795d0
01c795c4: ldr      w8, [x0, #0xe0]
01c795c8: cbnz     w8, #0x1c795d0
01c795cc: bl       #0xa60070
01c795d0: mov      x0, x19
01c795d4: mov      w1, wzr
01c795d8: bl       #0x1c78e80
01c795dc: ldr      x8, [x20]
01c795e0: mov      x19, x0
01c795e4: mov      w1, wzr
01c795e8: ldr      x8, [x8, #0xb8]
01c795ec: ldr      x8, [x8]
01c795f0: mov      x0, x8
01c795f4: bl       #0x1c78e80
01c795f8: mov      x1, x0
01c795fc: mov      x0, x19
01c79600: bl       #0x1c79628
01c79604: ldp      x29, x30, [sp, #0x10]
01c79608: mov      w1, #1
01c7960c: ldp      x20, x19, [sp], #0x20
01c79610: b        #0x1c793b0
01c79614: ldp      x29, x30, [sp, #0x10]
01c79618: mov      x0, x19
01c7961c: ldp      x20, x19, [sp], #0x20
01c79620: ret
01c79624: bl       #0xa60094
01c79628: sub      sp, sp, #0x90
01c7962c: stp      x28, x27, [sp, #0x30]
01c79630: stp      x26, x25, [sp, #0x40]
01c79634: stp      x24, x23, [sp, #0x50]
01c79638: stp      x22, x21, [sp, #0x60]
01c7963c: stp      x20, x19, [sp, #0x70]
01c79640: stp      x29, x30, [sp, #0x80]
01c79644: add      x29, sp, #0x80
01c79648: adrp     x21, #0x3200000
01c7964c: ldrb     w8, [x21, #0x982]
01c79650: mov      x20, x1
01c79654: mov      x19, x0
01c79658: tbnz     w8, #0, #0x1c7967c
01c7965c: adrp     x0, #0x2ffc000
01c79660: ldr      x0, [x0, #0x620]
01c79664: bl       #0xa5ffc0
01c79668: adrp     x0, #0x300c000
01c7966c: ldr      x0, [x0, #0xdd8]
01c79670: bl       #0xa5ffc0
01c79674: mov      w8, #1
01c79678: strb     w8, [x21, #0x982]
01c7967c: mov      w0, #0x1fc
01c79680: mov      x1, xzr
01c79684: bl       #0xedcd74
01c79688: tbz      w0, #0, #0x1c796c8
01c7968c: mov      w0, #0x1fc
01c79690: mov      x1, xzr
01c79694: bl       #0xedce44
01c79698: cbz      x0, #0x1c79970
01c7969c: mov      x1, x19
01c796a0: mov      x2, x20
01c796a4: ldp      x29, x30, [sp, #0x80]
01c796a8: ldp      x20, x19, [sp, #0x70]
01c796ac: ldp      x22, x21, [sp, #0x60]
01c796b0: ldp      x24, x23, [sp, #0x50]
01c796b4: ldp      x26, x25, [sp, #0x40]
01c796b8: ldp      x28, x27, [sp, #0x30]
01c796bc: mov      x3, xzr
01c796c0: add      sp, sp, #0x90
01c796c4: b        #0xacae48
01c796c8: cbz      x19, #0x1c79970
01c796cc: ldr      x23, [x19, #0x18]
01c796d0: sub      w27, w23, #1
01c796d4: cmp      w27, #1
01c796d8: b.lt     #0x1c79940
01c796dc: cbz      x20, #0x1c79970
01c796e0: ldr      w8, [x20, #0x18]
01c796e4: cmp      w8, #3
01c796e8: b.le     #0x1c796f4
01c796ec: mov      x8, x23
01c796f0: b        #0x1c79730
01c796f4: adrp     x8, #0x2ffc000
01c796f8: ldr      x8, [x8, #0x620]
01c796fc: mov      w1, #4
01c79700: ldr      x0, [x8]
01c79704: bl       #0xa5ffd4
01c79708: ldr      w4, [x20, #0x18]
01c7970c: mov      x21, x0
01c79710: mov      x0, x20
01c79714: mov      w1, wzr
01c79718: mov      x2, x21
01c7971c: mov      w3, wzr
01c79720: mov      x5, xzr
01c79724: bl       #0x16675c0
01c79728: ldr      x8, [x19, #0x18]
01c7972c: mov      x20, x21
01c79730: cmp      w27, w8
01c79734: b.hs     #0x1c79964
01c79738: mov      w8, #0x34
01c7973c: mov      w9, #0x79b9
01c79740: mov      w10, #0xda56
01c79744: movk     w9, #0x9e37, lsl #16
01c79748: sdiv     w8, w8, w23
01c7974c: movk     w10, #0xb54c, lsl #16
01c79750: madd     w8, w8, w9, w10
01c79754: str      w8, [sp, #0x2c]
01c79758: cbz      w8, #0x1c79940
01c7975c: sxtw     x8, w27
01c79760: add      x9, x19, w27, sxtw #2
01c79764: ldr      w22, [x19, #0x20]
01c79768: sub      w10, w23, #2
01c7976c: add      x9, x9, #0x20
01c79770: add      x8, x8, #8
01c79774: stp      x8, x9, [sp, #0x10]
01c79778: sbfiz    x8, x10, #2, #0x20
01c7977c: add      x8, x8, #0x20
01c79780: str      x8, [sp, #8]
01c79784: str      x27, [sp, #0x20]
01c79788: adrp     x8, #0x300c000
01c7978c: ldr      x8, [x8, #0xdd8]
01c79790: ldr      x0, [x8]
01c79794: ldrb     w8, [x0, #0x133]
01c79798: tbz      w8, #1, #0x1c797a8
01c7979c: ldr      w8, [x0, #0xe0]
01c797a0: cbnz     w8, #0x1c797a8
01c797a4: bl       #0xa60070
01c797a8: ldr      w0, [sp, #0x2c]
01c797ac: mov      w1, #2
01c797b0: bl       #0x1c7a1c4
01c797b4: ldp      x25, x26, [sp, #8]
01c797b8: and      w8, w0, #3
01c797bc: mov      w28, w27
01c797c0: str      w8, [sp, #0x28]
01c797c4: ldr      x8, [x19, #0x18]
01c797c8: sub      w21, w28, #1
01c797cc: cmp      w21, w8
01c797d0: b.hs     #0x1c79964
01c797d4: sub      x9, x26, #8
01c797d8: and      x8, x8, #0xffffffff
01c797dc: cmp      x9, x8
01c797e0: b.hs     #0x1c79964
01c797e4: adrp     x8, #0x300c000
01c797e8: ldr      x8, [x8, #0xdd8]
01c797ec: ldr      w23, [x19, x25]
01c797f0: ldr      w27, [x19, x26, lsl #2]
01c797f4: ldr      x0, [x8]
01c797f8: ldrb     w8, [x0, #0x133]
01c797fc: tbz      w8, #1, #0x1c7980c
01c79800: ldr      w8, [x0, #0xe0]
01c79804: cbnz     w8, #0x1c7980c
01c79808: bl       #0xa60070
01c7980c: mov      w1, #5
01c79810: mov      w0, w23
01c79814: bl       #0x1c7a1c4
01c79818: mov      w24, w0
01c7981c: mov      w1, #3
01c79820: mov      w0, w22
01c79824: bl       #0x1c7a1c4
01c79828: cbz      x20, #0x1c79970
01c7982c: ldr      w10, [sp, #0x28]
01c79830: ldr      w9, [x20, #0x18]
01c79834: and      w8, w28, #3
01c79838: eor      w8, w8, w10
01c7983c: cmp      w8, w9
01c79840: b.hs     #0x1c79964
01c79844: add      x8, x20, w8, uxtw #2
01c79848: ldr      w8, [x8, #0x20]
01c7984c: ldr      w11, [sp, #0x2c]
01c79850: eor      w9, w24, w22, lsl #2
01c79854: eor      w10, w0, w23, lsl #4
01c79858: eor      w8, w8, w23
01c7985c: eor      w11, w22, w11
01c79860: add      w9, w10, w9
01c79864: add      w8, w8, w11
01c79868: eor      w8, w8, w9
01c7986c: sub      w22, w27, w8
01c79870: cmp      w21, #0
01c79874: str      w22, [x19, x26, lsl #2]
01c79878: sub      x26, x26, #1
01c7987c: sub      x25, x25, #4
01c79880: mov      w28, w21
01c79884: b.gt     #0x1c797c4
01c79888: ldr      w8, [x19, #0x18]
01c7988c: ldr      x27, [sp, #0x20]
01c79890: cmp      w27, w8
01c79894: b.hs     #0x1c79964
01c79898: adrp     x8, #0x300c000
01c7989c: ldr      x8, [x8, #0xdd8]
01c798a0: ldr      w25, [x19, #0x20]
01c798a4: ldr      x0, [x8]
01c798a8: ldr      x8, [sp, #0x18]
01c798ac: ldr      w23, [x8]
01c798b0: ldrb     w8, [x0, #0x133]
01c798b4: tbz      w8, #1, #0x1c798c4
01c798b8: ldr      w8, [x0, #0xe0]
01c798bc: cbnz     w8, #0x1c798c4
01c798c0: bl       #0xa60070
01c798c4: mov      w1, #5
01c798c8: mov      w0, w23
01c798cc: bl       #0x1c7a1c4
01c798d0: mov      w24, w0
01c798d4: mov      w1, #3
01c798d8: mov      w0, w22
01c798dc: bl       #0x1c7a1c4
01c798e0: cbz      x20, #0x1c79970
01c798e4: ldr      w10, [sp, #0x28]
01c798e8: ldr      w9, [x20, #0x18]
01c798ec: and      w8, w21, #3
01c798f0: eor      w8, w8, w10
01c798f4: cmp      w8, w9
01c798f8: b.hs     #0x1c79964
01c798fc: add      x8, x20, w8, uxtw #2
01c79900: ldr      w8, [x8, #0x20]
01c79904: ldr      w12, [sp, #0x2c]
01c79908: eor      w9, w24, w22, lsl #2
01c7990c: eor      w10, w0, w23, lsl #4
01c79910: eor      w8, w8, w23
01c79914: eor      w11, w22, w12
01c79918: add      w9, w10, w9
01c7991c: add      w8, w8, w11
01c79920: eor      w8, w8, w9
01c79924: sub      w22, w25, w8
01c79928: mov      w8, #0x8647
01c7992c: movk     w8, #0x61c8, lsl #16
01c79930: adds     w12, w12, w8
01c79934: str      w12, [sp, #0x2c]
01c79938: str      w22, [x19, #0x20]
01c7993c: b.ne     #0x1c79788
01c79940: mov      x0, x19
01c79944: ldp      x29, x30, [sp, #0x80]
01c79948: ldp      x20, x19, [sp, #0x70]
01c7994c: ldp      x22, x21, [sp, #0x60]
01c79950: ldp      x24, x23, [sp, #0x50]
01c79954: ldp      x26, x25, [sp, #0x40]
01c79958: ldp      x28, x27, [sp, #0x30]
01c7995c: add      sp, sp, #0x90
01c79960: ret
01c79964: bl       #0xa600c0
01c79968: mov      x1, xzr
01c7996c: bl       #0xa60060
01c79970: bl       #0xa60094
01c79974: str      x21, [sp, #-0x30]!
01c79978: stp      x20, x19, [sp, #0x10]
01c7997c: stp      x29, x30, [sp, #0x20]
01c79980: add      x29, sp, #0x20
01c79984: adrp     x21, #0x3200000
01c79988: ldrb     w8, [x21, #0x97c]
01c7998c: mov      x19, x1
01c79990: mov      x20, x0
01c79994: tbnz     w8, #0, #0x1c799c4
01c79998: adrp     x0, #0x302c000
01c7999c: ldr      x0, [x0, #0xc18]
01c799a0: bl       #0xa5ffc0
01c799a4: adrp     x0, #0x300c000
01c799a8: ldr      x0, [x0, #0xdd8]
01c799ac: bl       #0xa5ffc0
01c799b0: adrp     x0, #0x2ffa000
01c799b4: ldr      x0, [x0, #0xee8]
01c799b8: bl       #0xa5ffc0
01c799bc: mov      w8, #1

; XXTEAUtil.Encrypt(string,key)
; RVA 0x1c79974 file_offset 0x1c79974
; public static string Encrypt(string source, string key) { }
01c79974: str      x21, [sp, #-0x30]!
01c79978: stp      x20, x19, [sp, #0x10]
01c7997c: stp      x29, x30, [sp, #0x20]
01c79980: add      x29, sp, #0x20
01c79984: adrp     x21, #0x3200000
01c79988: ldrb     w8, [x21, #0x97c]
01c7998c: mov      x19, x1
01c79990: mov      x20, x0
01c79994: tbnz     w8, #0, #0x1c799c4
01c79998: adrp     x0, #0x302c000
01c7999c: ldr      x0, [x0, #0xc18]
01c799a0: bl       #0xa5ffc0
01c799a4: adrp     x0, #0x300c000
01c799a8: ldr      x0, [x0, #0xdd8]
01c799ac: bl       #0xa5ffc0
01c799b0: adrp     x0, #0x2ffa000
01c799b4: ldr      x0, [x0, #0xee8]
01c799b8: bl       #0xa5ffc0
01c799bc: mov      w8, #1
01c799c0: strb     w8, [x21, #0x97c]
01c799c4: mov      w0, #0x152
01c799c8: mov      x1, xzr
01c799cc: bl       #0xedcd74
01c799d0: tbz      w0, #0, #0x1c79a00
01c799d4: mov      w0, #0x152
01c799d8: mov      x1, xzr
01c799dc: bl       #0xedce44
01c799e0: cbz      x0, #0x1c79afc
01c799e4: mov      x1, x20
01c799e8: mov      x2, x19
01c799ec: ldp      x29, x30, [sp, #0x20]
01c799f0: ldp      x20, x19, [sp, #0x10]
01c799f4: mov      x3, xzr
01c799f8: ldr      x21, [sp], #0x30
01c799fc: b        #0xac292c
01c79a00: mov      x0, xzr
01c79a04: bl       #0x1984094
01c79a08: cbz      x0, #0x1c79afc
01c79a0c: ldr      x8, [x0]
01c79a10: mov      x1, x20
01c79a14: mov      x21, x0
01c79a18: ldr      x9, [x8, #0x2c8]
01c79a1c: ldr      x2, [x8, #0x2d0]
01c79a20: blr      x9
01c79a24: ldr      x8, [x21]
01c79a28: mov      x20, x0
01c79a2c: mov      x0, x21
01c79a30: mov      x1, x19
01c79a34: ldr      x9, [x8, #0x2c8]
01c79a38: ldr      x2, [x8, #0x2d0]
01c79a3c: blr      x9
01c79a40: cbz      x20, #0x1c79afc
01c79a44: ldr      x8, [x20, #0x18]
01c79a48: cbz      x8, #0x1c79ae0
01c79a4c: adrp     x8, #0x300c000
01c79a50: ldr      x8, [x8, #0xdd8]
01c79a54: mov      x19, x0
01c79a58: ldr      x0, [x8]
01c79a5c: ldrb     w8, [x0, #0x133]
01c79a60: tbz      w8, #1, #0x1c79a70
01c79a64: ldr      w8, [x0, #0xe0]
01c79a68: cbnz     w8, #0x1c79a70
01c79a6c: bl       #0xa60070
01c79a70: mov      w1, #1
01c79a74: mov      x0, x20
01c79a78: bl       #0x1c78e80
01c79a7c: mov      x20, x0
01c79a80: mov      x0, x19
01c79a84: mov      w1, wzr
01c79a88: bl       #0x1c78e80
01c79a8c: mov      x1, x0
01c79a90: mov      x0, x20
01c79a94: bl       #0x1c7907c
01c79a98: mov      w1, wzr
01c79a9c: bl       #0x1c793b0
01c79aa0: adrp     x8, #0x302c000
01c79aa4: ldr      x8, [x8, #0xc18]
01c79aa8: mov      x19, x0
01c79aac: ldr      x8, [x8]
01c79ab0: ldrb     w9, [x8, #0x133]
01c79ab4: tbz      w9, #1, #0x1c79ac8
01c79ab8: ldr      w9, [x8, #0xe0]
01c79abc: cbnz     w9, #0x1c79ac8
01c79ac0: mov      x0, x8
01c79ac4: bl       #0xa60070
01c79ac8: mov      x0, x19
01c79acc: ldp      x29, x30, [sp, #0x20]
01c79ad0: ldp      x20, x19, [sp, #0x10]
01c79ad4: mov      x1, xzr
01c79ad8: ldr      x21, [sp], #0x30
01c79adc: b        #0x1464a60
01c79ae0: adrp     x8, #0x2ffa000
01c79ae4: ldr      x8, [x8, #0xee8]
01c79ae8: ldp      x29, x30, [sp, #0x20]
01c79aec: ldp      x20, x19, [sp, #0x10]
01c79af0: ldr      x0, [x8]
01c79af4: ldr      x21, [sp], #0x30
01c79af8: ret
01c79afc: bl       #0xa60094
01c79b00: str      x23, [sp, #-0x40]!
01c79b04: stp      x22, x21, [sp, #0x10]
01c79b08: stp      x20, x19, [sp, #0x20]
01c79b0c: stp      x29, x30, [sp, #0x30]
01c79b10: add      x29, sp, #0x30
01c79b14: adrp     x20, #0x3200000
01c79b18: ldrb     w8, [x20, #0x97d]
01c79b1c: mov      x19, x0
01c79b20: tbnz     w8, #0, #0x1c79b68
01c79b24: adrp     x0, #0x2fdf000
01c79b28: ldr      x0, [x0, #0xb78]
01c79b2c: bl       #0xa5ffc0
01c79b30: adrp     x0, #0x3006000
01c79b34: ldr      x0, [x0, #0xf20]
01c79b38: bl       #0xa5ffc0
01c79b3c: adrp     x0, #0x2ff6000
01c79b40: ldr      x0, [x0, #0x58]
01c79b44: bl       #0xa5ffc0
01c79b48: adrp     x0, #0x300c000
01c79b4c: ldr      x0, [x0, #0xdd8]
01c79b50: bl       #0xa5ffc0
01c79b54: adrp     x0, #0x2ffa000
01c79b58: ldr      x0, [x0, #0xee8]
01c79b5c: bl       #0xa5ffc0
01c79b60: mov      w8, #1
01c79b64: strb     w8, [x20, #0x97d]
01c79b68: mov      w0, #0x1fd
01c79b6c: mov      x1, xzr
01c79b70: bl       #0xedcd74
01c79b74: tbz      w0, #0, #0x1c79ba4
01c79b78: mov      w0, #0x1fd
01c79b7c: mov      x1, xzr
01c79b80: bl       #0xedce44
01c79b84: cbz      x0, #0x1c79d58
01c79b88: mov      x1, x19
01c79b8c: ldp      x29, x30, [sp, #0x30]
01c79b90: ldp      x20, x19, [sp, #0x20]
01c79b94: ldp      x22, x21, [sp, #0x10]
01c79b98: mov      x2, xzr
01c79b9c: ldr      x23, [sp], #0x40
01c79ba0: b        #0xac260c
01c79ba4: cbz      x19, #0x1c79d58
01c79ba8: ldr      x8, [x19, #0x18]
01c79bac: cbz      x8, #0x1c79d38
01c79bb0: cbz      w8, #0x1c79d5c
01c79bb4: ldrb     w9, [x19, #0x20]
01c79bb8: cmp      w9, #0xc
01c79bbc: b.ne     #0x1c79d08
01c79bc0: cmp      w8, #1
01c79bc4: b.ls     #0x1c79d5c
01c79bc8: ldrb     w9, [x19, #0x21]
01c79bcc: cmp      w9, #7
01c79bd0: b.ne     #0x1c79d08
01c79bd4: cmp      w8, #2
01c79bd8: b.ls     #0x1c79d5c
01c79bdc: ldrb     w9, [x19, #0x22]
01c79be0: cmp      w9, #8
01c79be4: b.ne     #0x1c79d08
01c79be8: cmp      w8, #3
01c79bec: b.ls     #0x1c79d5c
01c79bf0: ldrb     w9, [x19, #0x23]
01c79bf4: cmp      w9, #0xd
01c79bf8: b.ne     #0x1c79d08
01c79bfc: cmp      w8, #4
01c79c00: b.ls     #0x1c79d5c
01c79c04: ldrb     w9, [x19, #0x24]
01c79c08: cmp      w9, #0xb
01c79c0c: b.ne     #0x1c79d08
01c79c10: cmp      w8, #5
01c79c14: b.ls     #0x1c79d5c
01c79c18: ldrb     w8, [x19, #0x25]
01c79c1c: cmp      w8, #9
01c79c20: b.ne     #0x1c79d08
01c79c24: adrp     x22, #0x2fdf000
01c79c28: ldr      x22, [x22, #0xb78]
01c79c2c: mov      w1, #6
01c79c30: mov      x0, x19
01c79c34: ldr      x2, [x22]
01c79c38: bl       #0xcce940
01c79c3c: adrp     x21, #0x2ff6000
01c79c40: ldr      x21, [x21, #0x58]
01c79c44: ldr      x1, [x21]
01c79c48: bl       #0xccee44
01c79c4c: adrp     x23, #0x300c000
01c79c50: ldr      x23, [x23, #0xdd8]
01c79c54: mov      x20, x0
01c79c58: ldr      x8, [x23]
01c79c5c: ldrb     w9, [x8, #0x133]
01c79c60: tbz      w9, #1, #0x1c79c74
01c79c64: ldr      w9, [x8, #0xe0]
01c79c68: cbnz     w9, #0x1c79c74
01c79c6c: mov      x0, x8
01c79c70: bl       #0xa60070
01c79c74: mov      x0, x20
01c79c78: mov      w1, wzr
01c79c7c: bl       #0x1c78e80
01c79c80: ldr      x8, [x23]
01c79c84: mov      x20, x0
01c79c88: mov      w1, wzr
01c79c8c: ldr      x8, [x8, #0xb8]
01c79c90: ldr      x8, [x8, #8]
01c79c94: mov      x0, x8
01c79c98: bl       #0x1c78e80
01c79c9c: mov      x1, x0
01c79ca0: mov      x0, x20
01c79ca4: bl       #0x1c79628
01c79ca8: mov      w1, #1
01c79cac: bl       #0x1c793b0
01c79cb0: ldr      x2, [x22]
01c79cb4: mov      w1, #1
01c79cb8: mov      x20, x0
01c79cbc: bl       #0xcce940
01c79cc0: cbz      x20, #0x1c79d58
01c79cc4: adrp     x8, #0x3006000
01c79cc8: ldr      w1, [x20, #0x18]
01c79ccc: ldr      x8, [x8, #0xf20]
01c79cd0: ldr      x2, [x8]
01c79cd4: bl       #0xcceaf4
01c79cd8: ldr      x1, [x21]
01c79cdc: bl       #0xccee44
01c79ce0: mov      x1, xzr
01c79ce4: bl       #0xb39294
01c79ce8: cbz      x0, #0x1c79d0c
01c79cec: mov      x20, x0
01c79cf0: mov      x0, xzr
01c79cf4: bl       #0x1984094
01c79cf8: cbz      x0, #0x1c79d58
01c79cfc: ldr      x8, [x0]
01c79d00: mov      x1, x20
01c79d04: b        #0x1c79d1c
01c79d08: mov      x0, xzr
01c79d0c: bl       #0x1983d5c
01c79d10: cbz      x0, #0x1c79d58
01c79d14: ldr      x8, [x0]
01c79d18: mov      x1, x19
01c79d1c: ldr      x3, [x8, #0x3d8]
01c79d20: ldr      x2, [x8, #0x3e0]
01c79d24: ldp      x29, x30, [sp, #0x30]
01c79d28: ldp      x20, x19, [sp, #0x20]
01c79d2c: ldp      x22, x21, [sp, #0x10]
01c79d30: ldr      x23, [sp], #0x40
01c79d34: br       x3
01c79d38: adrp     x8, #0x2ffa000
01c79d3c: ldr      x8, [x8, #0xee8]
01c79d40: ldp      x29, x30, [sp, #0x30]
01c79d44: ldp      x20, x19, [sp, #0x20]
01c79d48: ldp      x22, x21, [sp, #0x10]
01c79d4c: ldr      x0, [x8]
01c79d50: ldr      x23, [sp], #0x40
01c79d54: ret
01c79d58: bl       #0xa60094
01c79d5c: bl       #0xa600c0
01c79d60: mov      x1, xzr
01c79d64: bl       #0xa60060
01c79d68: str      x21, [sp, #-0x30]!
01c79d6c: stp      x20, x19, [sp, #0x10]
01c79d70: stp      x29, x30, [sp, #0x20]
01c79d74: add      x29, sp, #0x20
01c79d78: adrp     x20, #0x3200000
01c79d7c: ldrb     w8, [x20, #0x97e]
01c79d80: mov      x19, x1
01c79d84: mov      x21, x0
01c79d88: tbnz     w8, #0, #0x1c79db8
01c79d8c: adrp     x0, #0x302c000
01c79d90: ldr      x0, [x0, #0xc18]
01c79d94: bl       #0xa5ffc0
01c79d98: adrp     x0, #0x300c000
01c79d9c: ldr      x0, [x0, #0xdd8]
01c79da0: bl       #0xa5ffc0
01c79da4: adrp     x0, #0x2ffa000
01c79da8: ldr      x0, [x0, #0xee8]
01c79dac: bl       #0xa5ffc0
01c79db0: mov      w8, #1
01c79db4: strb     w8, [x20, #0x97e]
01c79db8: mov      w0, #0x200
01c79dbc: mov      x1, xzr
01c79dc0: bl       #0xedcd74
01c79dc4: tbz      w0, #0, #0x1c79df4
01c79dc8: mov      w0, #0x200
01c79dcc: mov      x1, xzr
01c79dd0: bl       #0xedce44
01c79dd4: cbz      x0, #0x1c79ef4
01c79dd8: mov      x2, x19
01c79ddc: ldp      x29, x30, [sp, #0x20]
01c79de0: ldp      x20, x19, [sp, #0x10]
01c79de4: mov      x1, x21
01c79de8: mov      x3, xzr
01c79dec: ldr      x21, [sp], #0x30
01c79df0: b        #0xac292c

; XXTEAUtil.Decrypt(string,key)
; RVA 0x1c79d68 file_offset 0x1c79d68
; public static string Decrypt(string source, string key) { }
01c79d68: str      x21, [sp, #-0x30]!
01c79d6c: stp      x20, x19, [sp, #0x10]
01c79d70: stp      x29, x30, [sp, #0x20]
01c79d74: add      x29, sp, #0x20
01c79d78: adrp     x20, #0x3200000
01c79d7c: ldrb     w8, [x20, #0x97e]
01c79d80: mov      x19, x1
01c79d84: mov      x21, x0
01c79d88: tbnz     w8, #0, #0x1c79db8
01c79d8c: adrp     x0, #0x302c000
01c79d90: ldr      x0, [x0, #0xc18]
01c79d94: bl       #0xa5ffc0
01c79d98: adrp     x0, #0x300c000
01c79d9c: ldr      x0, [x0, #0xdd8]
01c79da0: bl       #0xa5ffc0
01c79da4: adrp     x0, #0x2ffa000
01c79da8: ldr      x0, [x0, #0xee8]
01c79dac: bl       #0xa5ffc0
01c79db0: mov      w8, #1
01c79db4: strb     w8, [x20, #0x97e]
01c79db8: mov      w0, #0x200
01c79dbc: mov      x1, xzr
01c79dc0: bl       #0xedcd74
01c79dc4: tbz      w0, #0, #0x1c79df4
01c79dc8: mov      w0, #0x200
01c79dcc: mov      x1, xzr
01c79dd0: bl       #0xedce44
01c79dd4: cbz      x0, #0x1c79ef4
01c79dd8: mov      x2, x19
01c79ddc: ldp      x29, x30, [sp, #0x20]
01c79de0: ldp      x20, x19, [sp, #0x10]
01c79de4: mov      x1, x21
01c79de8: mov      x3, xzr
01c79dec: ldr      x21, [sp], #0x30
01c79df0: b        #0xac292c
01c79df4: cbz      x21, #0x1c79ef4
01c79df8: ldr      w8, [x21, #0x10]
01c79dfc: cbz      w8, #0x1c79ed8
01c79e00: mov      x0, xzr
01c79e04: bl       #0x1984094
01c79e08: adrp     x8, #0x302c000
01c79e0c: ldr      x8, [x8, #0xc18]
01c79e10: mov      x20, x0
01c79e14: ldr      x8, [x8]
01c79e18: ldrb     w9, [x8, #0x133]
01c79e1c: tbz      w9, #1, #0x1c79e30
01c79e20: ldr      w9, [x8, #0xe0]
01c79e24: cbnz     w9, #0x1c79e30
01c79e28: mov      x0, x8
01c79e2c: bl       #0xa60070
01c79e30: mov      x0, x21
01c79e34: mov      x1, xzr
01c79e38: bl       #0x1450ab8
01c79e3c: cbz      x20, #0x1c79ef4
01c79e40: ldr      x8, [x20]
01c79e44: mov      x21, x0
01c79e48: mov      x0, x20
01c79e4c: mov      x1, x19
01c79e50: ldr      x9, [x8, #0x2c8]
01c79e54: ldr      x2, [x8, #0x2d0]
01c79e58: blr      x9
01c79e5c: adrp     x8, #0x300c000
01c79e60: ldr      x8, [x8, #0xdd8]
01c79e64: mov      x19, x0
01c79e68: ldr      x8, [x8]
01c79e6c: ldrb     w9, [x8, #0x133]
01c79e70: tbz      w9, #1, #0x1c79e84
01c79e74: ldr      w9, [x8, #0xe0]
01c79e78: cbnz     w9, #0x1c79e84
01c79e7c: mov      x0, x8
01c79e80: bl       #0xa60070
01c79e84: mov      x0, x21
01c79e88: mov      w1, wzr
01c79e8c: bl       #0x1c78e80
01c79e90: mov      x21, x0
01c79e94: mov      x0, x19
01c79e98: mov      w1, wzr
01c79e9c: bl       #0x1c78e80
01c79ea0: mov      x1, x0
01c79ea4: mov      x0, x21
01c79ea8: bl       #0x1c79628
01c79eac: mov      w1, #1
01c79eb0: bl       #0x1c793b0
01c79eb4: ldr      x8, [x20]
01c79eb8: mov      x1, x0
01c79ebc: mov      x0, x20
01c79ec0: ldp      x29, x30, [sp, #0x20]
01c79ec4: ldr      x3, [x8, #0x3d8]
01c79ec8: ldr      x2, [x8, #0x3e0]
01c79ecc: ldp      x20, x19, [sp, #0x10]
01c79ed0: ldr      x21, [sp], #0x30
01c79ed4: br       x3
01c79ed8: adrp     x8, #0x2ffa000
01c79edc: ldr      x8, [x8, #0xee8]
01c79ee0: ldp      x29, x30, [sp, #0x20]
01c79ee4: ldp      x20, x19, [sp, #0x10]
01c79ee8: ldr      x0, [x8]
01c79eec: ldr      x21, [sp], #0x30
01c79ef0: ret
01c79ef4: bl       #0xa60094
01c79ef8: str      x21, [sp, #-0x30]!
01c79efc: stp      x20, x19, [sp, #0x10]
01c79f00: stp      x29, x30, [sp, #0x20]
01c79f04: add      x29, sp, #0x20
01c79f08: adrp     x21, #0x3200000
01c79f0c: ldrb     w8, [x21, #0x97f]
01c79f10: mov      x20, x1
01c79f14: mov      x19, x0
01c79f18: tbnz     w8, #0, #0x1c79f3c
01c79f1c: adrp     x0, #0x2fec000
01c79f20: ldr      x0, [x0, #0x3a0]
01c79f24: bl       #0xa5ffc0
01c79f28: adrp     x0, #0x300c000
01c79f2c: ldr      x0, [x0, #0xdd8]
01c79f30: bl       #0xa5ffc0
01c79f34: mov      w8, #1
01c79f38: strb     w8, [x21, #0x97f]
01c79f3c: mov      w0, #0x201
01c79f40: mov      x1, xzr
01c79f44: bl       #0xedcd74
01c79f48: tbz      w0, #0, #0x1c79f78
01c79f4c: mov      w0, #0x201
01c79f50: mov      x1, xzr
01c79f54: bl       #0xedce44
01c79f58: cbz      x0, #0x1c7a048
01c79f5c: mov      x1, x19
01c79f60: mov      x2, x20
01c79f64: ldp      x29, x30, [sp, #0x20]
01c79f68: ldp      x20, x19, [sp, #0x10]
01c79f6c: mov      x3, xzr
01c79f70: ldr      x21, [sp], #0x30
01c79f74: b        #0xac292c
01c79f78: cbz      x19, #0x1c7a048
01c79f7c: ldr      x8, [x19, #0x18]
01c79f80: cbz      x8, #0x1c7a024
01c79f84: mov      x0, xzr
01c79f88: bl       #0x1984094
01c79f8c: cbz      x0, #0x1c7a048
01c79f90: ldr      x8, [x0]
01c79f94: mov      x1, x20
01c79f98: mov      x21, x0
01c79f9c: ldr      x9, [x8, #0x2c8]
01c79fa0: ldr      x2, [x8, #0x2d0]
01c79fa4: blr      x9
01c79fa8: adrp     x8, #0x300c000
01c79fac: ldr      x8, [x8, #0xdd8]
01c79fb0: mov      x20, x0
01c79fb4: ldr      x8, [x8]
01c79fb8: ldrb     w9, [x8, #0x133]
01c79fbc: tbz      w9, #1, #0x1c79fd0
01c79fc0: ldr      w9, [x8, #0xe0]
01c79fc4: cbnz     w9, #0x1c79fd0
01c79fc8: mov      x0, x8
01c79fcc: bl       #0xa60070
01c79fd0: mov      x0, x19
01c79fd4: mov      w1, wzr
01c79fd8: bl       #0x1c78e80
01c79fdc: mov      x19, x0
01c79fe0: mov      x0, x20
01c79fe4: mov      w1, wzr
01c79fe8: bl       #0x1c78e80
01c79fec: mov      x1, x0
01c79ff0: mov      x0, x19
01c79ff4: bl       #0x1c79628
01c79ff8: mov      w1, #1
01c79ffc: bl       #0x1c793b0
01c7a000: ldr      x8, [x21]
01c7a004: ldp      x29, x30, [sp, #0x20]
01c7a008: ldp      x20, x19, [sp, #0x10]
01c7a00c: mov      x1, x0
01c7a010: ldr      x3, [x8, #0x3d8]
01c7a014: ldr      x2, [x8, #0x3e0]
01c7a018: mov      x0, x21
01c7a01c: ldr      x21, [sp], #0x30
01c7a020: br       x3
01c7a024: adrp     x8, #0x2fec000
01c7a028: ldr      x8, [x8, #0x3a0]
01c7a02c: ldp      x29, x30, [sp, #0x20]
01c7a030: ldp      x20, x19, [sp, #0x10]
01c7a034: ldr      x8, [x8]
01c7a038: ldr      x8, [x8, #0xb8]
01c7a03c: ldr      x0, [x8]
01c7a040: ldr      x21, [sp], #0x30
01c7a044: ret
01c7a048: bl       #0xa60094
01c7a04c: stp      x26, x25, [sp, #-0x50]!
01c7a050: stp      x24, x23, [sp, #0x10]
01c7a054: stp      x22, x21, [sp, #0x20]
01c7a058: stp      x20, x19, [sp, #0x30]
01c7a05c: stp      x29, x30, [sp, #0x40]
01c7a060: add      x29, sp, #0x40
01c7a064: adrp     x21, #0x3200000
01c7a068: ldrb     w8, [x21, #0x980]
01c7a06c: mov      x19, x1
01c7a070: mov      x20, x0
01c7a074: tbnz     w8, #0, #0x1c7a098
01c7a078: adrp     x0, #0x3013000
01c7a07c: ldr      x0, [x0, #0x468]
01c7a080: bl       #0xa5ffc0
01c7a084: adrp     x0, #0x300c000
01c7a088: ldr      x0, [x0, #0xdd8]
01c7a08c: bl       #0xa5ffc0
01c7a090: mov      w8, #1
01c7a094: strb     w8, [x21, #0x980]
01c7a098: mov      w0, #0x202
01c7a09c: mov      x1, xzr
01c7a0a0: bl       #0xedcd74
01c7a0a4: tbz      w0, #0, #0x1c7a0dc
01c7a0a8: mov      w0, #0x202
01c7a0ac: mov      x1, xzr
01c7a0b0: bl       #0xedce44
01c7a0b4: cbz      x0, #0x1c7a1b4
01c7a0b8: mov      x1, x20
01c7a0bc: mov      x2, x19
01c7a0c0: ldp      x29, x30, [sp, #0x40]
01c7a0c4: ldp      x20, x19, [sp, #0x30]
01c7a0c8: ldp      x22, x21, [sp, #0x20]
01c7a0cc: ldp      x24, x23, [sp, #0x10]
01c7a0d0: mov      x3, xzr
01c7a0d4: ldp      x26, x25, [sp], #0x50
01c7a0d8: b        #0xad0558
01c7a0dc: cbz      x20, #0x1c7a1b4
01c7a0e0: adrp     x8, #0x3013000
01c7a0e4: ldr      x8, [x8, #0x468]
01c7a0e8: ldr      w1, [x20, #0x18]
01c7a0ec: ldr      x0, [x8]
01c7a0f0: bl       #0xa5ffd4
01c7a0f4: ldr      x8, [x20, #0x18]
01c7a0f8: mov      x21, x0
01c7a0fc: cmp      w8, #1
01c7a100: b.lt     #0x1c7a18c
01c7a104: adrp     x26, #0x300c000
01c7a108: ldr      x26, [x26, #0xdd8]
01c7a10c: mov      x23, xzr
01c7a110: and      x8, x8, #0xffffffff
01c7a114: add      x24, x20, #0x20
01c7a118: add      x25, x21, #0x20
01c7a11c: cmp      x23, w8, uxtw
01c7a120: b.hs     #0x1c7a1a8
01c7a124: ldr      x0, [x26]
01c7a128: ldr      x22, [x24, x23, lsl #3]
01c7a12c: ldrb     w8, [x0, #0x133]
01c7a130: tbz      w8, #1, #0x1c7a140
01c7a134: ldr      w8, [x0, #0xe0]
01c7a138: cbnz     w8, #0x1c7a140
01c7a13c: bl       #0xa60070
01c7a140: mov      x0, x22
01c7a144: mov      x1, x19
01c7a148: bl       #0x1c79ef8
01c7a14c: cbz      x21, #0x1c7a1b4
01c7a150: mov      x22, x0
01c7a154: cbz      x0, #0x1c7a16c
01c7a158: ldr      x8, [x21]
01c7a15c: mov      x0, x22
01c7a160: ldr      x1, [x8, #0x40]
01c7a164: bl       #0xa6007c
01c7a168: cbz      x0, #0x1c7a1b8
01c7a16c: ldr      w8, [x21, #0x18]
01c7a170: cmp      x23, x8
01c7a174: b.hs     #0x1c7a1a8
01c7a178: str      x22, [x25, x23, lsl #3]
01c7a17c: ldr      w8, [x20, #0x18]
01c7a180: add      x23, x23, #1
01c7a184: cmp      x23, w8, sxtw
01c7a188: b.lt     #0x1c7a11c
01c7a18c: mov      x0, x21
01c7a190: ldp      x29, x30, [sp, #0x40]
01c7a194: ldp      x20, x19, [sp, #0x30]
01c7a198: ldp      x22, x21, [sp, #0x20]
01c7a19c: ldp      x24, x23, [sp, #0x10]
01c7a1a0: ldp      x26, x25, [sp], #0x50
01c7a1a4: ret
01c7a1a8: bl       #0xa600c0
01c7a1ac: mov      x1, xzr
01c7a1b0: bl       #0xa60060
01c7a1b4: bl       #0xa60094
01c7a1b8: bl       #0xa600b4
01c7a1bc: mov      x1, xzr
01c7a1c0: bl       #0xa60060
01c7a1c4: stp      x20, x19, [sp, #-0x20]!
01c7a1c8: stp      x29, x30, [sp, #0x10]
01c7a1cc: add      x29, sp, #0x10
01c7a1d0: mov      w20, w1
01c7a1d4: mov      w19, w0
01c7a1d8: mov      w0, #0x154
01c7a1dc: mov      x1, xzr
01c7a1e0: bl       #0xedcd74
01c7a1e4: tbz      w0, #0, #0x1c7a210

; XXTEAUtil.ToIntArray
; RVA 0x1c78e80 file_offset 0x1c78e80
; public static int[] ToIntArray(byte[] data, bool includeLength) { }
01c78e80: str      x25, [sp, #-0x50]!
01c78e84: stp      x24, x23, [sp, #0x10]
01c78e88: stp      x22, x21, [sp, #0x20]
01c78e8c: stp      x20, x19, [sp, #0x30]
01c78e90: stp      x29, x30, [sp, #0x40]
01c78e94: add      x29, sp, #0x40
01c78e98: adrp     x21, #0x3200000
01c78e9c: ldrb     w8, [x21, #0x983]
01c78ea0: mov      w20, w1
01c78ea4: mov      x19, x0
01c78ea8: tbnz     w8, #0, #0x1c78ecc
01c78eac: adrp     x0, #0x2ffc000
01c78eb0: ldr      x0, [x0, #0x620]
01c78eb4: bl       #0xa5ffc0
01c78eb8: adrp     x0, #0x300c000
01c78ebc: ldr      x0, [x0, #0xdd8]
01c78ec0: bl       #0xa5ffc0
01c78ec4: mov      w8, #1
01c78ec8: strb     w8, [x21, #0x983]
01c78ecc: mov      w0, #0x153
01c78ed0: mov      x1, xzr
01c78ed4: bl       #0xedcd74
01c78ed8: tbz      w0, #0, #0x1c78f10
01c78edc: mov      w0, #0x153
01c78ee0: mov      x1, xzr
01c78ee4: bl       #0xedce44
01c78ee8: cbz      x0, #0x1c79078
01c78eec: and      w2, w20, #1
01c78ef0: mov      x1, x19
01c78ef4: ldp      x29, x30, [sp, #0x40]
01c78ef8: ldp      x20, x19, [sp, #0x30]
01c78efc: ldp      x22, x21, [sp, #0x20]
01c78f00: ldp      x24, x23, [sp, #0x10]
01c78f04: mov      x3, xzr
01c78f08: ldr      x25, [sp], #0x50
01c78f0c: b        #0xacad4c
01c78f10: cbz      x19, #0x1c79078
01c78f14: adrp     x22, #0x300c000
01c78f18: ldr      x22, [x22, #0xdd8]
01c78f1c: ldr      x0, [x19, #0x18]
01c78f20: ldr      x8, [x22]
01c78f24: tst      x0, #3
01c78f28: ldrh     w9, [x8, #0x132]
01c78f2c: b.eq     #0x1c78f58
01c78f30: tbz      w9, #9, #0x1c78f48
01c78f34: ldr      w9, [x8, #0xe0]
01c78f38: cbnz     w9, #0x1c78f48
01c78f3c: mov      x0, x8
01c78f40: bl       #0xa60070
01c78f44: ldr      x0, [x19, #0x18]
01c78f48: mov      w1, #2
01c78f4c: bl       #0x1c7a1c4
01c78f50: add      w21, w0, #1
01c78f54: b        #0x1c78f7c
01c78f58: tbz      w9, #9, #0x1c78f70
01c78f5c: ldr      w9, [x8, #0xe0]
01c78f60: cbnz     w9, #0x1c78f70
01c78f64: mov      x0, x8
01c78f68: bl       #0xa60070
01c78f6c: ldr      x0, [x19, #0x18]
01c78f70: mov      w1, #2
01c78f74: bl       #0x1c7a1c4
01c78f78: mov      w21, w0
01c78f7c: adrp     x8, #0x2ffc000
01c78f80: ldr      x8, [x8, #0x620]
01c78f84: ldr      x0, [x8]
01c78f88: tbz      w20, #0, #0x1c78fb8
01c78f8c: add      w1, w21, #1
01c78f90: bl       #0xa5ffd4
01c78f94: cbz      x0, #0x1c79078
01c78f98: ldr      w8, [x0, #0x18]
01c78f9c: mov      x20, x0
01c78fa0: cmp      w21, w8
01c78fa4: b.hs     #0x1c7906c
01c78fa8: ldr      x8, [x19, #0x18]
01c78fac: add      x9, x20, w21, sxtw #2
01c78fb0: str      w8, [x9, #0x20]
01c78fb4: b        #0x1c78fc4
01c78fb8: mov      w1, w21
01c78fbc: bl       #0xa5ffd4
01c78fc0: mov      x20, x0
01c78fc4: ldr      x8, [x19, #0x18]
01c78fc8: cmp      w8, #1
01c78fcc: b.lt     #0x1c79050
01c78fd0: mov      w23, wzr
01c78fd4: mov      x21, xzr
01c78fd8: sxtw     x24, w8
01c78fdc: add      x25, x19, #0x20
01c78fe0: ldr      x0, [x22]
01c78fe4: ldrb     w8, [x0, #0x133]
01c78fe8: tbz      w8, #1, #0x1c78ff8
01c78fec: ldr      w8, [x0, #0xe0]
01c78ff0: cbnz     w8, #0x1c78ff8
01c78ff4: bl       #0xa60070
01c78ff8: mov      w1, #2
01c78ffc: mov      w0, w21
01c79000: bl       #0x1c7a1c4
01c79004: cbz      x20, #0x1c79078
01c79008: ldr      w8, [x20, #0x18]
01c7900c: cmp      w0, w8
01c79010: b.hs     #0x1c7906c
01c79014: ldr      w8, [x19, #0x18]
01c79018: cmp      x21, x8
01c7901c: b.hs     #0x1c7906c
01c79020: add      x8, x20, w0, sxtw #2
01c79024: ldrb     w9, [x25, x21]
01c79028: add      x8, x8, #0x20
01c7902c: ldr      w11, [x8]
01c79030: and      w10, w23, #0x18
01c79034: add      x21, x21, #1
01c79038: lsl      w9, w9, w10
01c7903c: cmp      x21, x24
01c79040: orr      w9, w9, w11
01c79044: add      w23, w23, #8
01c79048: str      w9, [x8]
01c7904c: b.lt     #0x1c78fe0
01c79050: mov      x0, x20
01c79054: ldp      x29, x30, [sp, #0x40]
01c79058: ldp      x20, x19, [sp, #0x30]
01c7905c: ldp      x22, x21, [sp, #0x20]
01c79060: ldp      x24, x23, [sp, #0x10]
01c79064: ldr      x25, [sp], #0x50
01c79068: ret
01c7906c: bl       #0xa600c0
01c79070: mov      x1, xzr
01c79074: bl       #0xa60060
01c79078: bl       #0xa60094
01c7907c: sub      sp, sp, #0x90
01c79080: stp      x28, x27, [sp, #0x30]
01c79084: stp      x26, x25, [sp, #0x40]
01c79088: stp      x24, x23, [sp, #0x50]
01c7908c: stp      x22, x21, [sp, #0x60]
01c79090: stp      x20, x19, [sp, #0x70]
01c79094: stp      x29, x30, [sp, #0x80]
01c79098: add      x29, sp, #0x80
01c7909c: adrp     x21, #0x3200000
01c790a0: ldrb     w8, [x21, #0x981]
01c790a4: mov      x20, x1
01c790a8: str      x0, [sp, #0x28]
01c790ac: tbnz     w8, #0, #0x1c790d0
01c790b0: adrp     x0, #0x2ffc000
01c790b4: ldr      x0, [x0, #0x620]
01c790b8: bl       #0xa5ffc0
01c790bc: adrp     x0, #0x300c000
01c790c0: ldr      x0, [x0, #0xdd8]
01c790c4: bl       #0xa5ffc0
01c790c8: mov      w8, #1
01c790cc: strb     w8, [x21, #0x981]
01c790d0: mov      w0, #0x155
01c790d4: mov      x1, xzr
01c790d8: bl       #0xedcd74
01c790dc: tbz      w0, #0, #0x1c7911c
01c790e0: mov      w0, #0x155
01c790e4: mov      x1, xzr
01c790e8: bl       #0xedce44
01c790ec: ldr      x1, [sp, #0x28]
01c790f0: cbz      x0, #0x1c793ac
01c790f4: mov      x2, x20
01c790f8: ldp      x29, x30, [sp, #0x80]
01c790fc: ldp      x20, x19, [sp, #0x70]
01c79100: ldp      x22, x21, [sp, #0x60]
01c79104: ldp      x24, x23, [sp, #0x50]
01c79108: ldp      x26, x25, [sp, #0x40]
01c7910c: ldp      x28, x27, [sp, #0x30]
01c79110: mov      x3, xzr
01c79114: add      sp, sp, #0x90
01c79118: b        #0xacae48
01c7911c: ldr      x21, [sp, #0x28]
01c79120: cbz      x21, #0x1c793ac
01c79124: ldr      x22, [x21, #0x18]
01c79128: sub      w8, w22, #1
01c7912c: cmp      w8, #1
01c79130: str      x8, [sp, #0x10]
01c79134: b.lt     #0x1c7937c
01c79138: cbz      x20, #0x1c793ac
01c7913c: ldr      w8, [x20, #0x18]
01c79140: cmp      w8, #3
01c79144: b.le     #0x1c79150
01c79148: mov      x8, x22
01c7914c: b        #0x1c79190
01c79150: adrp     x8, #0x2ffc000
01c79154: ldr      x8, [x8, #0x620]
01c79158: mov      w1, #4
01c7915c: ldr      x0, [x8]
01c79160: bl       #0xa5ffd4
01c79164: ldr      w4, [x20, #0x18]
01c79168: mov      x19, x21
01c7916c: mov      x21, x0
01c79170: mov      x0, x20
01c79174: mov      w1, wzr
01c79178: mov      x2, x21
01c7917c: mov      w3, wzr
01c79180: mov      x5, xzr
01c79184: bl       #0x16675c0
01c79188: ldr      x8, [x19, #0x18]
01c7918c: mov      x20, x21
01c79190: ldr      x9, [sp, #0x10]
01c79194: cmp      w9, w8
01c79198: b.hs     #0x1c793a0
01c7919c: mov      w8, #0x34
01c791a0: ldr      x21, [sp, #0x28]
01c791a4: sdiv     w8, w8, w22
01c791a8: add      w9, w8, #6
01c791ac: cmp      w9, #1
01c791b0: b.lt     #0x1c7937c
01c791b4: ldr      x9, [sp, #0x10]
01c791b8: mov      w24, wzr
01c791bc: add      w8, w8, #5
01c791c0: sxtw     x10, w9
01c791c4: add      x9, x21, w9, sxtw #2
01c791c8: add      x28, x9, #0x20
01c791cc: ldr      w22, [x28]
01c791d0: str      x10, [sp, #0x20]
01c791d4: str      x28, [sp, #8]
01c791d8: str      w8, [sp, #0x1c]
01c791dc: adrp     x8, #0x300c000
01c791e0: ldr      x8, [x8, #0xdd8]
01c791e4: mov      w9, #0x79b9
01c791e8: movk     w9, #0x9e37, lsl #16
01c791ec: add      w24, w24, w9
01c791f0: ldr      x0, [x8]
01c791f4: ldrb     w8, [x0, #0x133]
01c791f8: tbz      w8, #1, #0x1c79208
01c791fc: ldr      w8, [x0, #0xe0]
01c79200: cbnz     w8, #0x1c79208
01c79204: bl       #0xa60070
01c79208: mov      w1, #2
01c7920c: mov      w0, w24
01c79210: bl       #0x1c7a1c4
01c79214: mov      x28, xzr
01c79218: and      w27, w0, #3
01c7921c: ldr      w8, [x21, #0x18]
01c79220: add      x25, x28, #1
01c79224: cmp      x25, x8
01c79228: b.hs     #0x1c793a0
01c7922c: adrp     x8, #0x300c000
01c79230: ldr      x8, [x8, #0xdd8]
01c79234: add      x26, x21, x28, lsl #2
01c79238: ldp      w21, w23, [x26, #0x20]
01c7923c: mov      w19, w24
01c79240: ldr      x0, [x8]
01c79244: ldrb     w8, [x0, #0x133]
01c79248: tbz      w8, #1, #0x1c79258
01c7924c: ldr      w8, [x0, #0xe0]
01c79250: cbnz     w8, #0x1c79258
01c79254: bl       #0xa60070
01c79258: mov      w1, #5
01c7925c: mov      w0, w22
01c79260: bl       #0x1c7a1c4
01c79264: mov      w24, w0
01c79268: mov      w1, #3
01c7926c: mov      w0, w23
01c79270: bl       #0x1c7a1c4
01c79274: cbz      x20, #0x1c793ac
01c79278: ldr      w9, [x20, #0x18]
01c7927c: and      w8, w28, #3
01c79280: eor      w8, w8, w27
01c79284: cmp      w8, w9
01c79288: b.hs     #0x1c793a0
01c7928c: add      x8, x20, w8, uxtw #2
01c79290: ldr      w8, [x8, #0x20]
01c79294: eor      w9, w24, w23, lsl #2
01c79298: eor      w10, w0, w22, lsl #4
01c7929c: eor      w11, w23, w19
01c792a0: eor      w8, w8, w22
01c792a4: add      w9, w10, w9
01c792a8: add      w8, w8, w11
01c792ac: eor      w8, w8, w9
01c792b0: add      w22, w8, w21
01c792b4: ldp      x8, x21, [sp, #0x20]
01c792b8: mov      w24, w19
01c792bc: mov      x28, x25
01c792c0: str      w22, [x26, #0x20]
01c792c4: cmp      x25, x8
01c792c8: b.lt     #0x1c7921c
01c792cc: ldr      w8, [x21, #0x18]
01c792d0: ldr      x28, [sp, #8]
01c792d4: cbz      w8, #0x1c793a0
01c792d8: ldr      x9, [sp, #0x10]
01c792dc: cmp      w9, w8
01c792e0: b.hs     #0x1c793a0
01c792e4: adrp     x8, #0x300c000
01c792e8: ldr      x8, [x8, #0xdd8]
01c792ec: ldr      w23, [x21, #0x20]
01c792f0: ldr      w26, [x28]
01c792f4: ldr      x0, [x8]
01c792f8: ldrb     w8, [x0, #0x133]
01c792fc: tbz      w8, #1, #0x1c7930c

; XXTEAUtil.ToByteArray
; RVA 0x1c793b0 file_offset 0x1c793b0
; public static byte[] ToByteArray(int[] data, bool includeLength) { }
01c793b0: str      x25, [sp, #-0x50]!
01c793b4: stp      x24, x23, [sp, #0x10]
01c793b8: stp      x22, x21, [sp, #0x20]
01c793bc: stp      x20, x19, [sp, #0x30]
01c793c0: stp      x29, x30, [sp, #0x40]
01c793c4: add      x29, sp, #0x40
01c793c8: adrp     x21, #0x3200000
01c793cc: ldrb     w8, [x21, #0x984]
01c793d0: mov      w20, w1
01c793d4: mov      x19, x0
01c793d8: tbnz     w8, #0, #0x1c793fc
01c793dc: adrp     x0, #0x3008000
01c793e0: ldr      x0, [x0, #0x160]
01c793e4: bl       #0xa5ffc0
01c793e8: adrp     x0, #0x300c000
01c793ec: ldr      x0, [x0, #0xdd8]
01c793f0: bl       #0xa5ffc0
01c793f4: mov      w8, #1
01c793f8: strb     w8, [x21, #0x984]
01c793fc: mov      w0, #0x156
01c79400: mov      x1, xzr
01c79404: bl       #0xedcd74
01c79408: tbz      w0, #0, #0x1c79440
01c7940c: mov      w0, #0x156
01c79410: mov      x1, xzr
01c79414: bl       #0xedce44
01c79418: cbz      x0, #0x1c7953c
01c7941c: and      w2, w20, #1
01c79420: mov      x1, x19
01c79424: ldp      x29, x30, [sp, #0x40]
01c79428: ldp      x20, x19, [sp, #0x30]
01c7942c: ldp      x22, x21, [sp, #0x20]
01c79430: ldp      x24, x23, [sp, #0x10]
01c79434: mov      x3, xzr
01c79438: ldr      x25, [sp], #0x50
01c7943c: b        #0xacaf44
01c79440: cbz      x19, #0x1c7953c
01c79444: ldr      x8, [x19, #0x18]
01c79448: lsl      w22, w8, #2
01c7944c: tbz      w20, #0, #0x1c79478
01c79450: cbz      w8, #0x1c79530
01c79454: mov      x9, #-0x100000000
01c79458: add      x8, x9, x8, lsl #32
01c7945c: add      x8, x19, x8, asr #30
01c79460: ldr      w8, [x8, #0x20]
01c79464: cmp      w8, w22
01c79468: mov      w22, w8
01c7946c: b.le     #0x1c79478
01c79470: mov      x20, xzr
01c79474: b        #0x1c79514
01c79478: adrp     x8, #0x3008000
01c7947c: ldr      x8, [x8, #0x160]
01c79480: mov      w1, w22
01c79484: ldr      x0, [x8]
01c79488: bl       #0xa5ffd4
01c7948c: cmp      w22, #1
01c79490: mov      x20, x0
01c79494: b.lt     #0x1c79514
01c79498: adrp     x25, #0x300c000
01c7949c: ldr      x25, [x25, #0xdd8]
01c794a0: mov      w23, wzr
01c794a4: mov      x21, xzr
01c794a8: sxtw     x22, w22
01c794ac: add      x24, x20, #0x20
01c794b0: ldr      x0, [x25]
01c794b4: ldrb     w8, [x0, #0x133]
01c794b8: tbz      w8, #1, #0x1c794c8
01c794bc: ldr      w8, [x0, #0xe0]
01c794c0: cbnz     w8, #0x1c794c8
01c794c4: bl       #0xa60070
01c794c8: mov      w1, #2
01c794cc: mov      w0, w21
01c794d0: bl       #0x1c7a1c4
01c794d4: ldr      w8, [x19, #0x18]
01c794d8: cmp      w0, w8
01c794dc: b.hs     #0x1c79530
01c794e0: add      x8, x19, w0, sxtw #2
01c794e4: ldr      w0, [x8, #0x20]
01c794e8: and      w1, w23, #0x18
01c794ec: bl       #0x1c7a1c4
01c794f0: cbz      x20, #0x1c7953c
01c794f4: ldr      w8, [x20, #0x18]
01c794f8: cmp      x21, x8
01c794fc: b.hs     #0x1c79530
01c79500: strb     w0, [x24, x21]
01c79504: add      x21, x21, #1
01c79508: cmp      x21, x22
01c7950c: add      w23, w23, #8
01c79510: b.lt     #0x1c794b0
01c79514: mov      x0, x20
01c79518: ldp      x29, x30, [sp, #0x40]
01c7951c: ldp      x20, x19, [sp, #0x30]
01c79520: ldp      x22, x21, [sp, #0x20]
01c79524: ldp      x24, x23, [sp, #0x10]
01c79528: ldr      x25, [sp], #0x50
01c7952c: ret
01c79530: bl       #0xa600c0
01c79534: mov      x1, xzr
01c79538: bl       #0xa60060
01c7953c: bl       #0xa60094
01c79540: stp      x20, x19, [sp, #-0x20]!
01c79544: stp      x29, x30, [sp, #0x10]
01c79548: add      x29, sp, #0x10
01c7954c: adrp     x20, #0x3200000
01c79550: ldrb     w8, [x20, #0x97b]
01c79554: mov      x19, x0
01c79558: tbnz     w8, #0, #0x1c79570
01c7955c: adrp     x0, #0x300c000
01c79560: ldr      x0, [x0, #0xdd8]
01c79564: bl       #0xa5ffc0
01c79568: mov      w8, #1
01c7956c: strb     w8, [x20, #0x97b]
01c79570: mov      w0, #0x1fb
01c79574: mov      x1, xzr
01c79578: bl       #0xedcd74
01c7957c: tbz      w0, #0, #0x1c795a4
01c79580: mov      w0, #0x1fb
01c79584: mov      x1, xzr
01c79588: bl       #0xedce44
01c7958c: cbz      x0, #0x1c79624
01c79590: ldp      x29, x30, [sp, #0x10]
01c79594: mov      x1, x19
01c79598: mov      x2, xzr
01c7959c: ldp      x20, x19, [sp], #0x20
01c795a0: b        #0xaca664
01c795a4: cbz      x19, #0x1c79624
01c795a8: ldr      x8, [x19, #0x18]
01c795ac: cbz      x8, #0x1c79614
01c795b0: adrp     x20, #0x300c000
01c795b4: ldr      x20, [x20, #0xdd8]
01c795b8: ldr      x0, [x20]
01c795bc: ldrb     w8, [x0, #0x133]
01c795c0: tbz      w8, #1, #0x1c795d0
01c795c4: ldr      w8, [x0, #0xe0]
01c795c8: cbnz     w8, #0x1c795d0
01c795cc: bl       #0xa60070
01c795d0: mov      x0, x19
01c795d4: mov      w1, wzr
01c795d8: bl       #0x1c78e80
01c795dc: ldr      x8, [x20]
01c795e0: mov      x19, x0
01c795e4: mov      w1, wzr
01c795e8: ldr      x8, [x8, #0xb8]
01c795ec: ldr      x8, [x8]
01c795f0: mov      x0, x8
01c795f4: bl       #0x1c78e80
01c795f8: mov      x1, x0
01c795fc: mov      x0, x19
01c79600: bl       #0x1c79628
01c79604: ldp      x29, x30, [sp, #0x10]
01c79608: mov      w1, #1
01c7960c: ldp      x20, x19, [sp], #0x20
01c79610: b        #0x1c793b0
01c79614: ldp      x29, x30, [sp, #0x10]
01c79618: mov      x0, x19
01c7961c: ldp      x20, x19, [sp], #0x20
01c79620: ret
01c79624: bl       #0xa60094
01c79628: sub      sp, sp, #0x90
01c7962c: stp      x28, x27, [sp, #0x30]
01c79630: stp      x26, x25, [sp, #0x40]
01c79634: stp      x24, x23, [sp, #0x50]
01c79638: stp      x22, x21, [sp, #0x60]
01c7963c: stp      x20, x19, [sp, #0x70]
01c79640: stp      x29, x30, [sp, #0x80]
01c79644: add      x29, sp, #0x80
01c79648: adrp     x21, #0x3200000
01c7964c: ldrb     w8, [x21, #0x982]
01c79650: mov      x20, x1
01c79654: mov      x19, x0
01c79658: tbnz     w8, #0, #0x1c7967c
01c7965c: adrp     x0, #0x2ffc000
01c79660: ldr      x0, [x0, #0x620]
01c79664: bl       #0xa5ffc0
01c79668: adrp     x0, #0x300c000
01c7966c: ldr      x0, [x0, #0xdd8]
01c79670: bl       #0xa5ffc0
01c79674: mov      w8, #1
01c79678: strb     w8, [x21, #0x982]
01c7967c: mov      w0, #0x1fc
01c79680: mov      x1, xzr
01c79684: bl       #0xedcd74
01c79688: tbz      w0, #0, #0x1c796c8
01c7968c: mov      w0, #0x1fc
01c79690: mov      x1, xzr
01c79694: bl       #0xedce44
01c79698: cbz      x0, #0x1c79970
01c7969c: mov      x1, x19
01c796a0: mov      x2, x20
01c796a4: ldp      x29, x30, [sp, #0x80]
01c796a8: ldp      x20, x19, [sp, #0x70]
01c796ac: ldp      x22, x21, [sp, #0x60]
01c796b0: ldp      x24, x23, [sp, #0x50]
01c796b4: ldp      x26, x25, [sp, #0x40]
01c796b8: ldp      x28, x27, [sp, #0x30]
01c796bc: mov      x3, xzr
01c796c0: add      sp, sp, #0x90
01c796c4: b        #0xacae48
01c796c8: cbz      x19, #0x1c79970
01c796cc: ldr      x23, [x19, #0x18]
01c796d0: sub      w27, w23, #1
01c796d4: cmp      w27, #1
01c796d8: b.lt     #0x1c79940
01c796dc: cbz      x20, #0x1c79970
01c796e0: ldr      w8, [x20, #0x18]
01c796e4: cmp      w8, #3
01c796e8: b.le     #0x1c796f4
01c796ec: mov      x8, x23
01c796f0: b        #0x1c79730
01c796f4: adrp     x8, #0x2ffc000
01c796f8: ldr      x8, [x8, #0x620]
01c796fc: mov      w1, #4
01c79700: ldr      x0, [x8]
01c79704: bl       #0xa5ffd4
01c79708: ldr      w4, [x20, #0x18]
01c7970c: mov      x21, x0
01c79710: mov      x0, x20
01c79714: mov      w1, wzr
01c79718: mov      x2, x21
01c7971c: mov      w3, wzr
01c79720: mov      x5, xzr
01c79724: bl       #0x16675c0
01c79728: ldr      x8, [x19, #0x18]
01c7972c: mov      x20, x21
01c79730: cmp      w27, w8
01c79734: b.hs     #0x1c79964
01c79738: mov      w8, #0x34
01c7973c: mov      w9, #0x79b9
01c79740: mov      w10, #0xda56
01c79744: movk     w9, #0x9e37, lsl #16
01c79748: sdiv     w8, w8, w23
01c7974c: movk     w10, #0xb54c, lsl #16
01c79750: madd     w8, w8, w9, w10
01c79754: str      w8, [sp, #0x2c]
01c79758: cbz      w8, #0x1c79940
01c7975c: sxtw     x8, w27
01c79760: add      x9, x19, w27, sxtw #2
01c79764: ldr      w22, [x19, #0x20]
01c79768: sub      w10, w23, #2
01c7976c: add      x9, x9, #0x20
01c79770: add      x8, x8, #8
01c79774: stp      x8, x9, [sp, #0x10]
01c79778: sbfiz    x8, x10, #2, #0x20
01c7977c: add      x8, x8, #0x20
01c79780: str      x8, [sp, #8]
01c79784: str      x27, [sp, #0x20]
01c79788: adrp     x8, #0x300c000
01c7978c: ldr      x8, [x8, #0xdd8]
01c79790: ldr      x0, [x8]
01c79794: ldrb     w8, [x0, #0x133]
01c79798: tbz      w8, #1, #0x1c797a8
01c7979c: ldr      w8, [x0, #0xe0]
01c797a0: cbnz     w8, #0x1c797a8
01c797a4: bl       #0xa60070
01c797a8: ldr      w0, [sp, #0x2c]
01c797ac: mov      w1, #2
01c797b0: bl       #0x1c7a1c4
01c797b4: ldp      x25, x26, [sp, #8]
01c797b8: and      w8, w0, #3
01c797bc: mov      w28, w27
01c797c0: str      w8, [sp, #0x28]
01c797c4: ldr      x8, [x19, #0x18]
01c797c8: sub      w21, w28, #1
01c797cc: cmp      w21, w8
01c797d0: b.hs     #0x1c79964
01c797d4: sub      x9, x26, #8
01c797d8: and      x8, x8, #0xffffffff
01c797dc: cmp      x9, x8
01c797e0: b.hs     #0x1c79964
01c797e4: adrp     x8, #0x300c000
01c797e8: ldr      x8, [x8, #0xdd8]
01c797ec: ldr      w23, [x19, x25]
01c797f0: ldr      w27, [x19, x26, lsl #2]
01c797f4: ldr      x0, [x8]
01c797f8: ldrb     w8, [x0, #0x133]
01c797fc: tbz      w8, #1, #0x1c7980c
01c79800: ldr      w8, [x0, #0xe0]
01c79804: cbnz     w8, #0x1c7980c
01c79808: bl       #0xa60070
01c7980c: mov      w1, #5
01c79810: mov      w0, w23
01c79814: bl       #0x1c7a1c4
01c79818: mov      w24, w0
01c7981c: mov      w1, #3
01c79820: mov      w0, w22
01c79824: bl       #0x1c7a1c4
01c79828: cbz      x20, #0x1c79970
01c7982c: ldr      w10, [sp, #0x28]

; XXTEAUtil.Base64Decode
; RVA 0x1c7a234 file_offset 0x1c7a234
; public static string Base64Decode(string data) { }
01c7a234: stp      x20, x19, [sp, #-0x20]!
01c7a238: stp      x29, x30, [sp, #0x10]
01c7a23c: add      x29, sp, #0x10
01c7a240: adrp     x20, #0x3200000
01c7a244: ldrb     w8, [x20, #0x985]
01c7a248: mov      x19, x0
01c7a24c: tbnz     w8, #0, #0x1c7a264
01c7a250: adrp     x0, #0x302c000
01c7a254: ldr      x0, [x0, #0xc18]
01c7a258: bl       #0xa5ffc0
01c7a25c: mov      w8, #1
01c7a260: strb     w8, [x20, #0x985]
01c7a264: mov      w0, #0x203
01c7a268: mov      x1, xzr
01c7a26c: bl       #0xedcd74
01c7a270: tbz      w0, #0, #0x1c7a298
01c7a274: mov      w0, #0x203
01c7a278: mov      x1, xzr
01c7a27c: bl       #0xedce44
01c7a280: cbz      x0, #0x1c7a2f8
01c7a284: ldp      x29, x30, [sp, #0x10]
01c7a288: mov      x1, x19
01c7a28c: mov      x2, xzr
01c7a290: ldp      x20, x19, [sp], #0x20
01c7a294: b        #0xac260c
01c7a298: mov      x0, xzr
01c7a29c: bl       #0x1984094
01c7a2a0: adrp     x8, #0x302c000
01c7a2a4: ldr      x8, [x8, #0xc18]
01c7a2a8: mov      x20, x0
01c7a2ac: ldr      x0, [x8]
01c7a2b0: ldrb     w8, [x0, #0x133]
01c7a2b4: tbz      w8, #1, #0x1c7a2c4
01c7a2b8: ldr      w8, [x0, #0xe0]
01c7a2bc: cbnz     w8, #0x1c7a2c4
01c7a2c0: bl       #0xa60070
01c7a2c4: mov      x0, x19
01c7a2c8: mov      x1, xzr
01c7a2cc: bl       #0x1450ab8
01c7a2d0: mov      x1, x0
01c7a2d4: cbz      x20, #0x1c7a2fc
01c7a2d8: ldr      x8, [x20]
01c7a2dc: ldr      x9, [x8, #0x3d8]
01c7a2e0: ldr      x2, [x8, #0x3e0]
01c7a2e4: mov      x0, x20
01c7a2e8: blr      x9
01c7a2ec: ldp      x29, x30, [sp, #0x10]
01c7a2f0: ldp      x20, x19, [sp], #0x20
01c7a2f4: ret
01c7a2f8: bl       #0xa60094
01c7a2fc: bl       #0xa60094
01c7a300: b        #0x1c7a310
01c7a304: b        #0x1c7a310
01c7a308: b        #0x1c7a310
01c7a30c: b        #0x1c7a310
01c7a310: mov      x19, x0
01c7a314: cmp      w1, #1
01c7a318: b.ne     #0x1c7a3e4
01c7a31c: mov      x0, x19
01c7a320: bl       #0x71de70
01c7a324: ldr      x19, [x0]
01c7a328: mov      x20, x0
01c7a32c: adrp     x0, #0x3015000
01c7a330: ldr      x0, [x0, #0x800]
01c7a334: bl       #0xa5ffc4
01c7a338: ldr      x8, [x20]
01c7a33c: ldr      x1, [x8]
01c7a340: bl       #0xa603fc
01c7a344: tbz      w0, #0, #0x1c7a3bc
01c7a348: bl       #0x71d350
01c7a34c: mov      x0, x19
01c7a350: bl       #0x88d168
01c7a354: ldr      x8, [x19]
01c7a358: mov      x0, x19
01c7a35c: ldp      x9, x1, [x8, #0x188]
01c7a360: blr      x9
01c7a364: mov      x19, x0
01c7a368: adrp     x0, #0x3048000
01c7a36c: ldr      x0, [x0, #0x148]
01c7a370: bl       #0xa5ffc4
01c7a374: mov      x1, x19
01c7a378: mov      x2, xzr
01c7a37c: bl       #0x1e52e14
01c7a380: mov      x19, x0
01c7a384: adrp     x0, #0x3015000
01c7a388: ldr      x0, [x0, #0x800]
01c7a38c: bl       #0xa5ffc4
01c7a390: bl       #0xa6008c
01c7a394: mov      x1, x19
01c7a398: mov      x2, xzr
01c7a39c: mov      x20, x0
01c7a3a0: bl       #0x1e0d6e4
01c7a3a4: adrp     x0, #0x2ff2000
01c7a3a8: ldr      x0, [x0, #0x590]
01c7a3ac: bl       #0xa5ffc4
01c7a3b0: mov      x1, x0
01c7a3b4: mov      x0, x20
01c7a3b8: bl       #0xa60060
01c7a3bc: mov      w0, #8
01c7a3c0: bl       #0x71cab0
01c7a3c4: ldr      x8, [x20]
01c7a3c8: str      x8, [x0]
01c7a3cc: adrp     x1, #0x2f81000
01c7a3d0: add      x1, x1, #0x458
01c7a3d4: mov      x2, xzr
01c7a3d8: bl       #0x71dbf0
01c7a3dc: mov      x19, x0
01c7a3e0: bl       #0x71d350
01c7a3e4: mov      x0, x19
01c7a3e8: bl       #0x71d1f0
01c7a3ec: bl       #0x88d17c
01c7a3f0: stp      x20, x19, [sp, #-0x20]!
01c7a3f4: stp      x29, x30, [sp, #0x10]
01c7a3f8: add      x29, sp, #0x10
01c7a3fc: adrp     x20, #0x3200000
01c7a400: ldrb     w8, [x20, #0x986]
01c7a404: mov      x19, x0
01c7a408: tbnz     w8, #0, #0x1c7a420
01c7a40c: adrp     x0, #0x302c000
01c7a410: ldr      x0, [x0, #0xc18]
01c7a414: bl       #0xa5ffc0
01c7a418: mov      w8, #1
01c7a41c: strb     w8, [x20, #0x986]
01c7a420: mov      w0, #0x204
01c7a424: mov      x1, xzr
01c7a428: bl       #0xedcd74
01c7a42c: tbz      w0, #0, #0x1c7a454
01c7a430: mov      w0, #0x204
01c7a434: mov      x1, xzr
01c7a438: bl       #0xedce44
01c7a43c: cbz      x0, #0x1c7a4b0
01c7a440: ldp      x29, x30, [sp, #0x10]
01c7a444: mov      x1, x19
01c7a448: mov      x2, xzr
01c7a44c: ldp      x20, x19, [sp], #0x20
01c7a450: b        #0xac260c
01c7a454: mov      x0, xzr
01c7a458: bl       #0x1984094
01c7a45c: cbz      x0, #0x1c7a4b4
01c7a460: ldr      x8, [x0]
01c7a464: ldr      x9, [x8, #0x2c8]
01c7a468: ldr      x2, [x8, #0x2d0]
01c7a46c: mov      x1, x19
01c7a470: blr      x9
01c7a474: adrp     x8, #0x302c000
01c7a478: ldr      x8, [x8, #0xc18]
01c7a47c: mov      x19, x0
01c7a480: ldr      x0, [x8]
01c7a484: ldrb     w8, [x0, #0x133]
01c7a488: tbz      w8, #1, #0x1c7a498
01c7a48c: ldr      w8, [x0, #0xe0]
01c7a490: cbnz     w8, #0x1c7a498
01c7a494: bl       #0xa60070
01c7a498: mov      x0, x19
01c7a49c: mov      x1, xzr
01c7a4a0: bl       #0x1464a60
01c7a4a4: ldp      x29, x30, [sp, #0x10]
01c7a4a8: ldp      x20, x19, [sp], #0x20
01c7a4ac: ret
01c7a4b0: bl       #0xa60094
01c7a4b4: bl       #0xa60094
01c7a4b8: b        #0x1c7a4c4
01c7a4bc: b        #0x1c7a4c4
01c7a4c0: b        #0x1c7a4c4
01c7a4c4: mov      x19, x0
01c7a4c8: cmp      w1, #1
01c7a4cc: b.ne     #0x1c7a598
01c7a4d0: mov      x0, x19
01c7a4d4: bl       #0x71de70
01c7a4d8: ldr      x19, [x0]
01c7a4dc: mov      x20, x0
01c7a4e0: adrp     x0, #0x3015000
01c7a4e4: ldr      x0, [x0, #0x800]
01c7a4e8: bl       #0xa5ffc4
01c7a4ec: ldr      x8, [x20]
01c7a4f0: ldr      x1, [x8]
01c7a4f4: bl       #0xa603fc
01c7a4f8: tbz      w0, #0, #0x1c7a570
01c7a4fc: bl       #0x71d350
01c7a500: mov      x0, x19
01c7a504: bl       #0x88d168
01c7a508: ldr      x8, [x19]
01c7a50c: mov      x0, x19
01c7a510: ldp      x9, x1, [x8, #0x188]
01c7a514: blr      x9
01c7a518: mov      x19, x0
01c7a51c: adrp     x0, #0x2ffb000
01c7a520: ldr      x0, [x0, #0x7e0]
01c7a524: bl       #0xa5ffc4
01c7a528: mov      x1, x19
01c7a52c: mov      x2, xzr
01c7a530: bl       #0x1e52e14
01c7a534: mov      x19, x0
01c7a538: adrp     x0, #0x3015000
01c7a53c: ldr      x0, [x0, #0x800]
01c7a540: bl       #0xa5ffc4
01c7a544: bl       #0xa6008c
01c7a548: mov      x1, x19
01c7a54c: mov      x2, xzr
01c7a550: mov      x20, x0
01c7a554: bl       #0x1e0d6e4
01c7a558: adrp     x0, #0x2fe5000
01c7a55c: ldr      x0, [x0, #0xd30]
01c7a560: bl       #0xa5ffc4
01c7a564: mov      x1, x0
01c7a568: mov      x0, x20
01c7a56c: bl       #0xa60060
01c7a570: mov      w0, #8
01c7a574: bl       #0x71cab0
01c7a578: ldr      x8, [x20]
01c7a57c: str      x8, [x0]
01c7a580: adrp     x1, #0x2f81000
01c7a584: add      x1, x1, #0x458
01c7a588: mov      x2, xzr
01c7a58c: bl       #0x71dbf0
01c7a590: mov      x19, x0
01c7a594: bl       #0x71d350
01c7a598: mov      x0, x19
01c7a59c: bl       #0x71d1f0
01c7a5a0: bl       #0x88d17c
01c7a5a4: str      x21, [sp, #-0x30]!
01c7a5a8: stp      x20, x19, [sp, #0x10]
01c7a5ac: stp      x29, x30, [sp, #0x20]
01c7a5b0: add      x29, sp, #0x20
01c7a5b4: adrp     x19, #0x3200000
01c7a5b8: ldrb     w8, [x19, #0x987]
01c7a5bc: tbnz     w8, #0, #0x1c7a5f8
01c7a5c0: adrp     x0, #0x3008000
01c7a5c4: ldr      x0, [x0, #0x160]
01c7a5c8: bl       #0xa5ffc0
01c7a5cc: adrp     x0, #0x303a000
01c7a5d0: ldr      x0, [x0, #0x278]
01c7a5d4: bl       #0xa5ffc0
01c7a5d8: adrp     x0, #0x2fe9000
01c7a5dc: ldr      x0, [x0, #0xcb0]
01c7a5e0: bl       #0xa5ffc0
01c7a5e4: adrp     x0, #0x300c000
01c7a5e8: ldr      x0, [x0, #0xdd8]
01c7a5ec: bl       #0xa5ffc0
01c7a5f0: mov      w8, #1
01c7a5f4: strb     w8, [x19, #0x987]
01c7a5f8: adrp     x20, #0x3008000
01c7a5fc: ldr      x20, [x20, #0x160]
01c7a600: mov      w1, #8
01c7a604: ldr      x0, [x20]
01c7a608: bl       #0xa5ffd4
01c7a60c: adrp     x8, #0x303a000
01c7a610: ldr      x8, [x8, #0x278]
01c7a614: mov      x2, xzr
01c7a618: mov      x19, x0
01c7a61c: ldr      x1, [x8]
01c7a620: bl       #0x1b443ac
01c7a624: adrp     x21, #0x300c000
01c7a628: ldr      x21, [x21, #0xdd8]
01c7a62c: mov      w1, #0x40
01c7a630: ldr      x8, [x21]
01c7a634: ldr      x8, [x8, #0xb8]
01c7a638: str      x19, [x8]
01c7a63c: ldr      x0, [x20]
01c7a640: bl       #0xa5ffd4
01c7a644: adrp     x8, #0x2fe9000
01c7a648: ldr      x8, [x8, #0xcb0]
01c7a64c: mov      x2, xzr
01c7a650: mov      x19, x0
01c7a654: ldr      x1, [x8]
01c7a658: bl       #0x1b443ac
01c7a65c: ldr      x8, [x21]
01c7a660: ldr      x8, [x8, #0xb8]
01c7a664: str      x19, [x8, #8]
01c7a668: ldp      x29, x30, [sp, #0x20]
01c7a66c: ldp      x20, x19, [sp, #0x10]
01c7a670: ldr      x21, [sp], #0x30
01c7a674: ret
01c7a678: stp      x20, x19, [sp, #-0x20]!
01c7a67c: stp      x29, x30, [sp, #0x10]
01c7a680: add      x29, sp, #0x10
01c7a684: adrp     x20, #0x3200000
01c7a688: ldrb     w8, [x20, #0x989]
01c7a68c: mov      x19, x0
01c7a690: tbnz     w8, #0, #0x1c7a6a8
01c7a694: adrp     x0, #0x303c000
01c7a698: ldr      x0, [x0, #0x728]
01c7a69c: bl       #0xa5ffc0
01c7a6a0: mov      w8, #1
01c7a6a4: strb     w8, [x20, #0x989]
01c7a6a8: mov      w0, #0x156c
01c7a6ac: mov      x1, xzr
01c7a6b0: bl       #0xedcd74

; XXTEAUtil.Base64Encode
; RVA 0x1c7a3f0 file_offset 0x1c7a3f0
; public static string Base64Encode(string data) { }
01c7a3f0: stp      x20, x19, [sp, #-0x20]!
01c7a3f4: stp      x29, x30, [sp, #0x10]
01c7a3f8: add      x29, sp, #0x10
01c7a3fc: adrp     x20, #0x3200000
01c7a400: ldrb     w8, [x20, #0x986]
01c7a404: mov      x19, x0
01c7a408: tbnz     w8, #0, #0x1c7a420
01c7a40c: adrp     x0, #0x302c000
01c7a410: ldr      x0, [x0, #0xc18]
01c7a414: bl       #0xa5ffc0
01c7a418: mov      w8, #1
01c7a41c: strb     w8, [x20, #0x986]
01c7a420: mov      w0, #0x204
01c7a424: mov      x1, xzr
01c7a428: bl       #0xedcd74
01c7a42c: tbz      w0, #0, #0x1c7a454
01c7a430: mov      w0, #0x204
01c7a434: mov      x1, xzr
01c7a438: bl       #0xedce44
01c7a43c: cbz      x0, #0x1c7a4b0
01c7a440: ldp      x29, x30, [sp, #0x10]
01c7a444: mov      x1, x19
01c7a448: mov      x2, xzr
01c7a44c: ldp      x20, x19, [sp], #0x20
01c7a450: b        #0xac260c
01c7a454: mov      x0, xzr
01c7a458: bl       #0x1984094
01c7a45c: cbz      x0, #0x1c7a4b4
01c7a460: ldr      x8, [x0]
01c7a464: ldr      x9, [x8, #0x2c8]
01c7a468: ldr      x2, [x8, #0x2d0]
01c7a46c: mov      x1, x19
01c7a470: blr      x9
01c7a474: adrp     x8, #0x302c000
01c7a478: ldr      x8, [x8, #0xc18]
01c7a47c: mov      x19, x0
01c7a480: ldr      x0, [x8]
01c7a484: ldrb     w8, [x0, #0x133]
01c7a488: tbz      w8, #1, #0x1c7a498
01c7a48c: ldr      w8, [x0, #0xe0]
01c7a490: cbnz     w8, #0x1c7a498
01c7a494: bl       #0xa60070
01c7a498: mov      x0, x19
01c7a49c: mov      x1, xzr
01c7a4a0: bl       #0x1464a60
01c7a4a4: ldp      x29, x30, [sp, #0x10]
01c7a4a8: ldp      x20, x19, [sp], #0x20
01c7a4ac: ret
01c7a4b0: bl       #0xa60094
01c7a4b4: bl       #0xa60094
01c7a4b8: b        #0x1c7a4c4
01c7a4bc: b        #0x1c7a4c4
01c7a4c0: b        #0x1c7a4c4
01c7a4c4: mov      x19, x0
01c7a4c8: cmp      w1, #1
01c7a4cc: b.ne     #0x1c7a598
01c7a4d0: mov      x0, x19
01c7a4d4: bl       #0x71de70
01c7a4d8: ldr      x19, [x0]
01c7a4dc: mov      x20, x0
01c7a4e0: adrp     x0, #0x3015000
01c7a4e4: ldr      x0, [x0, #0x800]
01c7a4e8: bl       #0xa5ffc4
01c7a4ec: ldr      x8, [x20]
01c7a4f0: ldr      x1, [x8]
01c7a4f4: bl       #0xa603fc
01c7a4f8: tbz      w0, #0, #0x1c7a570
01c7a4fc: bl       #0x71d350
01c7a500: mov      x0, x19
01c7a504: bl       #0x88d168
01c7a508: ldr      x8, [x19]
01c7a50c: mov      x0, x19
01c7a510: ldp      x9, x1, [x8, #0x188]
01c7a514: blr      x9
01c7a518: mov      x19, x0
01c7a51c: adrp     x0, #0x2ffb000
01c7a520: ldr      x0, [x0, #0x7e0]
01c7a524: bl       #0xa5ffc4
01c7a528: mov      x1, x19
01c7a52c: mov      x2, xzr
01c7a530: bl       #0x1e52e14
01c7a534: mov      x19, x0
01c7a538: adrp     x0, #0x3015000
01c7a53c: ldr      x0, [x0, #0x800]
01c7a540: bl       #0xa5ffc4
01c7a544: bl       #0xa6008c
01c7a548: mov      x1, x19
01c7a54c: mov      x2, xzr
01c7a550: mov      x20, x0
01c7a554: bl       #0x1e0d6e4
01c7a558: adrp     x0, #0x2fe5000
01c7a55c: ldr      x0, [x0, #0xd30]
01c7a560: bl       #0xa5ffc4
01c7a564: mov      x1, x0
01c7a568: mov      x0, x20
01c7a56c: bl       #0xa60060
01c7a570: mov      w0, #8
01c7a574: bl       #0x71cab0
01c7a578: ldr      x8, [x20]
01c7a57c: str      x8, [x0]
01c7a580: adrp     x1, #0x2f81000
01c7a584: add      x1, x1, #0x458
01c7a588: mov      x2, xzr
01c7a58c: bl       #0x71dbf0
01c7a590: mov      x19, x0
01c7a594: bl       #0x71d350
01c7a598: mov      x0, x19
01c7a59c: bl       #0x71d1f0
01c7a5a0: bl       #0x88d17c
01c7a5a4: str      x21, [sp, #-0x30]!
01c7a5a8: stp      x20, x19, [sp, #0x10]
01c7a5ac: stp      x29, x30, [sp, #0x20]
01c7a5b0: add      x29, sp, #0x20
01c7a5b4: adrp     x19, #0x3200000
01c7a5b8: ldrb     w8, [x19, #0x987]
01c7a5bc: tbnz     w8, #0, #0x1c7a5f8
01c7a5c0: adrp     x0, #0x3008000
01c7a5c4: ldr      x0, [x0, #0x160]
01c7a5c8: bl       #0xa5ffc0
01c7a5cc: adrp     x0, #0x303a000
01c7a5d0: ldr      x0, [x0, #0x278]
01c7a5d4: bl       #0xa5ffc0
01c7a5d8: adrp     x0, #0x2fe9000
01c7a5dc: ldr      x0, [x0, #0xcb0]
01c7a5e0: bl       #0xa5ffc0
01c7a5e4: adrp     x0, #0x300c000
01c7a5e8: ldr      x0, [x0, #0xdd8]
01c7a5ec: bl       #0xa5ffc0
01c7a5f0: mov      w8, #1
01c7a5f4: strb     w8, [x19, #0x987]
01c7a5f8: adrp     x20, #0x3008000
01c7a5fc: ldr      x20, [x20, #0x160]
01c7a600: mov      w1, #8
01c7a604: ldr      x0, [x20]
01c7a608: bl       #0xa5ffd4
01c7a60c: adrp     x8, #0x303a000
01c7a610: ldr      x8, [x8, #0x278]
01c7a614: mov      x2, xzr
01c7a618: mov      x19, x0
01c7a61c: ldr      x1, [x8]
01c7a620: bl       #0x1b443ac
01c7a624: adrp     x21, #0x300c000
01c7a628: ldr      x21, [x21, #0xdd8]
01c7a62c: mov      w1, #0x40
01c7a630: ldr      x8, [x21]
01c7a634: ldr      x8, [x8, #0xb8]
01c7a638: str      x19, [x8]
01c7a63c: ldr      x0, [x20]
01c7a640: bl       #0xa5ffd4
01c7a644: adrp     x8, #0x2fe9000
01c7a648: ldr      x8, [x8, #0xcb0]
01c7a64c: mov      x2, xzr
01c7a650: mov      x19, x0
01c7a654: ldr      x1, [x8]
01c7a658: bl       #0x1b443ac
01c7a65c: ldr      x8, [x21]
01c7a660: ldr      x8, [x8, #0xb8]
01c7a664: str      x19, [x8, #8]
01c7a668: ldp      x29, x30, [sp, #0x20]
01c7a66c: ldp      x20, x19, [sp, #0x10]
01c7a670: ldr      x21, [sp], #0x30
01c7a674: ret
01c7a678: stp      x20, x19, [sp, #-0x20]!
01c7a67c: stp      x29, x30, [sp, #0x10]
01c7a680: add      x29, sp, #0x10
01c7a684: adrp     x20, #0x3200000
01c7a688: ldrb     w8, [x20, #0x989]
01c7a68c: mov      x19, x0
01c7a690: tbnz     w8, #0, #0x1c7a6a8
01c7a694: adrp     x0, #0x303c000
01c7a698: ldr      x0, [x0, #0x728]
01c7a69c: bl       #0xa5ffc0
01c7a6a0: mov      w8, #1
01c7a6a4: strb     w8, [x20, #0x989]
01c7a6a8: mov      w0, #0x156c
01c7a6ac: mov      x1, xzr
01c7a6b0: bl       #0xedcd74
01c7a6b4: tbz      w0, #0, #0x1c7a6dc
01c7a6b8: mov      w0, #0x156c
01c7a6bc: mov      x1, xzr
01c7a6c0: bl       #0xedce44
01c7a6c4: cbz      x0, #0x1c7a6fc
01c7a6c8: ldp      x29, x30, [sp, #0x10]
01c7a6cc: mov      x1, x19
01c7a6d0: mov      x2, xzr
01c7a6d4: ldp      x20, x19, [sp], #0x20
01c7a6d8: b        #0xac620c
01c7a6dc: adrp     x8, #0x303c000
01c7a6e0: ldr      x8, [x8, #0x728]
01c7a6e4: ldp      x29, x30, [sp, #0x10]
01c7a6e8: mov      x0, x19
01c7a6ec: mov      x2, xzr
01c7a6f0: ldr      x1, [x8]
01c7a6f4: ldp      x20, x19, [sp], #0x20
01c7a6f8: b        #0x16c0d8c
01c7a6fc: bl       #0xa60094
01c7a700: str      x21, [sp, #-0x30]!
01c7a704: stp      x20, x19, [sp, #0x10]
01c7a708: stp      x29, x30, [sp, #0x20]
01c7a70c: add      x29, sp, #0x20
01c7a710: adrp     x20, #0x3200000
01c7a714: ldrb     w8, [x20, #0x98a]
01c7a718: mov      x19, x0
01c7a71c: tbnz     w8, #0, #0x1c7a740
01c7a720: adrp     x0, #0x300c000
01c7a724: ldr      x0, [x0, #0xdd8]
01c7a728: bl       #0xa5ffc0
01c7a72c: adrp     x0, #0x3010000
01c7a730: ldr      x0, [x0, #0x818]
01c7a734: bl       #0xa5ffc0
01c7a738: mov      w8, #1
01c7a73c: strb     w8, [x20, #0x98a]
01c7a740: mov      w0, #0x156d
01c7a744: mov      x1, xzr
01c7a748: bl       #0xedcd74
01c7a74c: tbz      w0, #0, #0x1c7a778
01c7a750: mov      w0, #0x156d
01c7a754: mov      x1, xzr
01c7a758: bl       #0xedce44
01c7a75c: cbz      x0, #0x1c7a904
01c7a760: mov      x1, x19
01c7a764: ldp      x29, x30, [sp, #0x20]
01c7a768: ldp      x20, x19, [sp, #0x10]
01c7a76c: mov      x2, xzr
01c7a770: ldr      x21, [sp], #0x30
01c7a774: b        #0xac620c
01c7a778: mov      x0, x19
01c7a77c: mov      x1, xzr
01c7a780: bl       #0x16c1a9c
01c7a784: cmp      w0, #1
01c7a788: b.eq     #0x1c7a854
01c7a78c: cmp      w0, #2
01c7a790: b.ne     #0x1c7a8e0
01c7a794: mov      w1, #1
01c7a798: mov      x0, x19
01c7a79c: mov      x2, xzr
01c7a7a0: bl       #0x16c1b1c
01c7a7a4: tbnz     w0, #0, #0x1c7a7c0
01c7a7a8: mov      w1, #1
01c7a7ac: mov      x0, x19
01c7a7b0: mov      x2, xzr
01c7a7b4: bl       #0x16c0bac
01c7a7b8: cmp      w0, #4
01c7a7bc: b.ne     #0x1c7a8e0
01c7a7c0: mov      w1, #2
01c7a7c4: mov      x0, x19
01c7a7c8: mov      x2, xzr
01c7a7cc: bl       #0x16c1b1c
01c7a7d0: tbnz     w0, #0, #0x1c7a7ec
01c7a7d4: mov      w1, #2
01c7a7d8: mov      x0, x19
01c7a7dc: mov      x2, xzr
01c7a7e0: bl       #0x16c0bac
01c7a7e4: cmp      w0, #4
01c7a7e8: b.ne     #0x1c7a8e0
01c7a7ec: mov      w1, #1
01c7a7f0: mov      x0, x19
01c7a7f4: mov      x2, xzr
01c7a7f8: bl       #0x16c2874
01c7a7fc: mov      x20, x0
01c7a800: mov      w1, #2
01c7a804: mov      x0, x19
01c7a808: mov      x2, xzr
01c7a80c: bl       #0x16c2874
01c7a810: adrp     x8, #0x300c000
01c7a814: ldr      x8, [x8, #0xdd8]
01c7a818: mov      x21, x0
01c7a81c: ldr      x0, [x8]
01c7a820: ldrb     w8, [x0, #0x133]
01c7a824: tbz      w8, #1, #0x1c7a834
01c7a828: ldr      w8, [x0, #0xe0]
01c7a82c: cbnz     w8, #0x1c7a834
01c7a830: bl       #0xa60070
01c7a834: mov      x0, x20
01c7a838: mov      x1, x21
01c7a83c: bl       #0x1c79974
01c7a840: mov      x1, x0
01c7a844: mov      x0, x19
01c7a848: mov      x2, xzr
01c7a84c: bl       #0x16c2ce4
01c7a850: b        #0x1c7a8cc
01c7a854: mov      w1, #1
01c7a858: mov      x0, x19
01c7a85c: mov      x2, xzr
01c7a860: bl       #0x16c1b1c
01c7a864: tbnz     w0, #0, #0x1c7a880
01c7a868: mov      w1, #1
01c7a86c: mov      x0, x19

; XXTEAUtil..cctor
; RVA 0x1c7a5a4 file_offset 0x1c7a5a4
; private static void .cctor()
01c7a5a4: str      x21, [sp, #-0x30]!
01c7a5a8: stp      x20, x19, [sp, #0x10]
01c7a5ac: stp      x29, x30, [sp, #0x20]
01c7a5b0: add      x29, sp, #0x20
01c7a5b4: adrp     x19, #0x3200000
01c7a5b8: ldrb     w8, [x19, #0x987]
01c7a5bc: tbnz     w8, #0, #0x1c7a5f8
01c7a5c0: adrp     x0, #0x3008000
01c7a5c4: ldr      x0, [x0, #0x160]
01c7a5c8: bl       #0xa5ffc0
01c7a5cc: adrp     x0, #0x303a000
01c7a5d0: ldr      x0, [x0, #0x278]
01c7a5d4: bl       #0xa5ffc0
01c7a5d8: adrp     x0, #0x2fe9000
01c7a5dc: ldr      x0, [x0, #0xcb0]
01c7a5e0: bl       #0xa5ffc0
01c7a5e4: adrp     x0, #0x300c000
01c7a5e8: ldr      x0, [x0, #0xdd8]
01c7a5ec: bl       #0xa5ffc0
01c7a5f0: mov      w8, #1
01c7a5f4: strb     w8, [x19, #0x987]
01c7a5f8: adrp     x20, #0x3008000
01c7a5fc: ldr      x20, [x20, #0x160]
01c7a600: mov      w1, #8
01c7a604: ldr      x0, [x20]
01c7a608: bl       #0xa5ffd4
01c7a60c: adrp     x8, #0x303a000
01c7a610: ldr      x8, [x8, #0x278]
01c7a614: mov      x2, xzr
01c7a618: mov      x19, x0
01c7a61c: ldr      x1, [x8]
01c7a620: bl       #0x1b443ac
01c7a624: adrp     x21, #0x300c000
01c7a628: ldr      x21, [x21, #0xdd8]
01c7a62c: mov      w1, #0x40
01c7a630: ldr      x8, [x21]
01c7a634: ldr      x8, [x8, #0xb8]
01c7a638: str      x19, [x8]
01c7a63c: ldr      x0, [x20]
01c7a640: bl       #0xa5ffd4
01c7a644: adrp     x8, #0x2fe9000
01c7a648: ldr      x8, [x8, #0xcb0]
01c7a64c: mov      x2, xzr
01c7a650: mov      x19, x0
01c7a654: ldr      x1, [x8]
01c7a658: bl       #0x1b443ac
01c7a65c: ldr      x8, [x21]
01c7a660: ldr      x8, [x8, #0xb8]
01c7a664: str      x19, [x8, #8]
01c7a668: ldp      x29, x30, [sp, #0x20]
01c7a66c: ldp      x20, x19, [sp, #0x10]
01c7a670: ldr      x21, [sp], #0x30
01c7a674: ret
01c7a678: stp      x20, x19, [sp, #-0x20]!
01c7a67c: stp      x29, x30, [sp, #0x10]
01c7a680: add      x29, sp, #0x10
01c7a684: adrp     x20, #0x3200000
01c7a688: ldrb     w8, [x20, #0x989]
01c7a68c: mov      x19, x0
01c7a690: tbnz     w8, #0, #0x1c7a6a8
01c7a694: adrp     x0, #0x303c000
01c7a698: ldr      x0, [x0, #0x728]
01c7a69c: bl       #0xa5ffc0
01c7a6a0: mov      w8, #1
01c7a6a4: strb     w8, [x20, #0x989]
01c7a6a8: mov      w0, #0x156c
01c7a6ac: mov      x1, xzr
01c7a6b0: bl       #0xedcd74
01c7a6b4: tbz      w0, #0, #0x1c7a6dc
01c7a6b8: mov      w0, #0x156c
01c7a6bc: mov      x1, xzr
01c7a6c0: bl       #0xedce44
01c7a6c4: cbz      x0, #0x1c7a6fc
01c7a6c8: ldp      x29, x30, [sp, #0x10]
01c7a6cc: mov      x1, x19
01c7a6d0: mov      x2, xzr
01c7a6d4: ldp      x20, x19, [sp], #0x20
01c7a6d8: b        #0xac620c
01c7a6dc: adrp     x8, #0x303c000
01c7a6e0: ldr      x8, [x8, #0x728]
01c7a6e4: ldp      x29, x30, [sp, #0x10]
01c7a6e8: mov      x0, x19
01c7a6ec: mov      x2, xzr
01c7a6f0: ldr      x1, [x8]
01c7a6f4: ldp      x20, x19, [sp], #0x20
01c7a6f8: b        #0x16c0d8c
01c7a6fc: bl       #0xa60094
01c7a700: str      x21, [sp, #-0x30]!
01c7a704: stp      x20, x19, [sp, #0x10]
01c7a708: stp      x29, x30, [sp, #0x20]
01c7a70c: add      x29, sp, #0x20
01c7a710: adrp     x20, #0x3200000
01c7a714: ldrb     w8, [x20, #0x98a]
01c7a718: mov      x19, x0
01c7a71c: tbnz     w8, #0, #0x1c7a740
01c7a720: adrp     x0, #0x300c000
01c7a724: ldr      x0, [x0, #0xdd8]
01c7a728: bl       #0xa5ffc0
01c7a72c: adrp     x0, #0x3010000
01c7a730: ldr      x0, [x0, #0x818]
01c7a734: bl       #0xa5ffc0
01c7a738: mov      w8, #1
01c7a73c: strb     w8, [x20, #0x98a]
01c7a740: mov      w0, #0x156d
01c7a744: mov      x1, xzr
01c7a748: bl       #0xedcd74
01c7a74c: tbz      w0, #0, #0x1c7a778
01c7a750: mov      w0, #0x156d
01c7a754: mov      x1, xzr
01c7a758: bl       #0xedce44
01c7a75c: cbz      x0, #0x1c7a904
01c7a760: mov      x1, x19
01c7a764: ldp      x29, x30, [sp, #0x20]
01c7a768: ldp      x20, x19, [sp, #0x10]
01c7a76c: mov      x2, xzr
01c7a770: ldr      x21, [sp], #0x30
01c7a774: b        #0xac620c
01c7a778: mov      x0, x19
01c7a77c: mov      x1, xzr
01c7a780: bl       #0x16c1a9c
01c7a784: cmp      w0, #1
01c7a788: b.eq     #0x1c7a854
01c7a78c: cmp      w0, #2
01c7a790: b.ne     #0x1c7a8e0
01c7a794: mov      w1, #1
01c7a798: mov      x0, x19
01c7a79c: mov      x2, xzr
01c7a7a0: bl       #0x16c1b1c
01c7a7a4: tbnz     w0, #0, #0x1c7a7c0
01c7a7a8: mov      w1, #1
01c7a7ac: mov      x0, x19
01c7a7b0: mov      x2, xzr
01c7a7b4: bl       #0x16c0bac
01c7a7b8: cmp      w0, #4
01c7a7bc: b.ne     #0x1c7a8e0
01c7a7c0: mov      w1, #2
01c7a7c4: mov      x0, x19
01c7a7c8: mov      x2, xzr
01c7a7cc: bl       #0x16c1b1c
01c7a7d0: tbnz     w0, #0, #0x1c7a7ec
01c7a7d4: mov      w1, #2
01c7a7d8: mov      x0, x19
01c7a7dc: mov      x2, xzr
01c7a7e0: bl       #0x16c0bac
01c7a7e4: cmp      w0, #4
01c7a7e8: b.ne     #0x1c7a8e0
01c7a7ec: mov      w1, #1
01c7a7f0: mov      x0, x19
01c7a7f4: mov      x2, xzr
01c7a7f8: bl       #0x16c2874
01c7a7fc: mov      x20, x0
01c7a800: mov      w1, #2
01c7a804: mov      x0, x19
01c7a808: mov      x2, xzr
01c7a80c: bl       #0x16c2874
01c7a810: adrp     x8, #0x300c000
01c7a814: ldr      x8, [x8, #0xdd8]
01c7a818: mov      x21, x0
01c7a81c: ldr      x0, [x8]
01c7a820: ldrb     w8, [x0, #0x133]
01c7a824: tbz      w8, #1, #0x1c7a834
01c7a828: ldr      w8, [x0, #0xe0]
01c7a82c: cbnz     w8, #0x1c7a834
01c7a830: bl       #0xa60070
01c7a834: mov      x0, x20
01c7a838: mov      x1, x21
01c7a83c: bl       #0x1c79974
01c7a840: mov      x1, x0
01c7a844: mov      x0, x19
01c7a848: mov      x2, xzr
01c7a84c: bl       #0x16c2ce4
01c7a850: b        #0x1c7a8cc
01c7a854: mov      w1, #1
01c7a858: mov      x0, x19
01c7a85c: mov      x2, xzr
01c7a860: bl       #0x16c1b1c
01c7a864: tbnz     w0, #0, #0x1c7a880
01c7a868: mov      w1, #1
01c7a86c: mov      x0, x19
01c7a870: mov      x2, xzr
01c7a874: bl       #0x16c0bac
01c7a878: cmp      w0, #4
01c7a87c: b.ne     #0x1c7a8e0
01c7a880: mov      w1, #1
01c7a884: mov      x0, x19
01c7a888: mov      x2, xzr
01c7a88c: bl       #0x16c315c
01c7a890: adrp     x8, #0x300c000
01c7a894: ldr      x8, [x8, #0xdd8]
01c7a898: mov      x20, x0
01c7a89c: ldr      x0, [x8]
01c7a8a0: ldrb     w8, [x0, #0x133]
01c7a8a4: tbz      w8, #1, #0x1c7a8b4
01c7a8a8: ldr      w8, [x0, #0xe0]
01c7a8ac: cbnz     w8, #0x1c7a8b4
01c7a8b0: bl       #0xa60070
01c7a8b4: mov      x0, x20
01c7a8b8: bl       #0x1c78d98
01c7a8bc: mov      x1, x0
01c7a8c0: mov      x0, x19
01c7a8c4: mov      x2, xzr
01c7a8c8: bl       #0x16c30e0
01c7a8cc: ldp      x29, x30, [sp, #0x20]
01c7a8d0: ldp      x20, x19, [sp, #0x10]
01c7a8d4: mov      w0, #1
01c7a8d8: ldr      x21, [sp], #0x30
01c7a8dc: ret
01c7a8e0: adrp     x8, #0x3010000
01c7a8e4: ldr      x8, [x8, #0x818]
01c7a8e8: ldr      x1, [x8]
01c7a8ec: mov      x0, x19
01c7a8f0: ldp      x29, x30, [sp, #0x20]
01c7a8f4: ldp      x20, x19, [sp, #0x10]
01c7a8f8: mov      x2, xzr
01c7a8fc: ldr      x21, [sp], #0x30
01c7a900: b        #0x16c0d8c
01c7a904: bl       #0xa60094
01c7a908: b        #0x1c7a940
01c7a90c: b        #0x1c7a940
01c7a910: b        #0x1c7a940
01c7a914: b        #0x1c7a940
01c7a918: b        #0x1c7a940
01c7a91c: b        #0x1c7a940
01c7a920: b        #0x1c7a940
01c7a924: b        #0x1c7a940
01c7a928: b        #0x1c7a940
01c7a92c: b        #0x1c7a940
01c7a930: b        #0x1c7a940
01c7a934: b        #0x1c7a940
01c7a938: b        #0x1c7a940
01c7a93c: b        #0x1c7a940
01c7a940: mov      x20, x0
01c7a944: cmp      w1, #1
01c7a948: b.ne     #0x1c7a9f8
01c7a94c: mov      x0, x20
01c7a950: bl       #0x71de70
01c7a954: ldr      x20, [x0]
01c7a958: mov      x21, x0
01c7a95c: adrp     x0, #0x3015000
01c7a960: ldr      x0, [x0, #0x800]
01c7a964: bl       #0xa5ffc4
01c7a968: ldr      x8, [x21]
01c7a96c: ldr      x1, [x8]
01c7a970: bl       #0xa603fc
01c7a974: tbz      w0, #0, #0x1c7a9d0
01c7a978: bl       #0x71d350
01c7a97c: adrp     x0, #0x2ff1000
01c7a980: ldr      x0, [x0, #0xc60]
01c7a984: bl       #0xa5ffc4
01c7a988: cbz      x20, #0x1c7a9b4
01c7a98c: adrp     x0, #0x2ff1000
01c7a990: ldr      x0, [x0, #0xc60]
01c7a994: bl       #0xa5ffc4
01c7a998: ldr      x8, [x20]
01c7a99c: mov      x21, x0
01c7a9a0: mov      x0, x20
01c7a9a4: ldp      x9, x1, [x8, #0x168]
01c7a9a8: blr      x9
01c7a9ac: mov      x1, x0
01c7a9b0: b        #0x1c7a9bc
01c7a9b4: mov      x21, x0
01c7a9b8: mov      x1, xzr
01c7a9bc: mov      x0, x21
01c7a9c0: mov      x2, xzr
01c7a9c4: bl       #0x1e52e14
01c7a9c8: mov      x1, x0
01c7a9cc: b        #0x1c7a8ec
01c7a9d0: mov      w0, #8
01c7a9d4: bl       #0x71cab0
01c7a9d8: ldr      x8, [x21]
01c7a9dc: str      x8, [x0]
01c7a9e0: adrp     x1, #0x2f81000
01c7a9e4: add      x1, x1, #0x458
01c7a9e8: mov      x2, xzr
01c7a9ec: bl       #0x71dbf0
01c7a9f0: mov      x20, x0
01c7a9f4: bl       #0x71d350
01c7a9f8: mov      x0, x20
01c7a9fc: bl       #0x71d1f0
01c7aa00: bl       #0x88d17c
01c7aa04: str      x21, [sp, #-0x30]!
01c7aa08: stp      x20, x19, [sp, #0x10]
01c7aa0c: stp      x29, x30, [sp, #0x20]
01c7aa10: add      x29, sp, #0x20
01c7aa14: adrp     x20, #0x3200000
01c7aa18: ldrb     w8, [x20, #0x98b]
01c7aa1c: mov      x19, x0
01c7aa20: tbnz     w8, #0, #0x1c7aa44
