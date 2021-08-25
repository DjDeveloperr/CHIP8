export interface BaseInst {
  type: string;
  at: number;
}

export interface InstCLS extends BaseInst {
  type: "CLS";
}

export interface InstDAT extends BaseInst {
  type: "DAT";
  data: number;
}

export interface InstRET extends BaseInst {
  type: "RET";
}

export interface InstJMP extends BaseInst {
  type: "JMP";
  addr: number;
}

export interface InstCALL extends BaseInst {
  type: "CALL";
  /** Can only be string in case if `sortIntoLabels` is called */
  addr: number | string;
}

export interface InstSE extends BaseInst {
  type: "SE";
  vx: number;
  kk: number;
}

export interface InstSNE extends BaseInst {
  type: "SNE";
  vx: number;
  kk: number;
}

export interface InstSEV extends BaseInst {
  type: "SEV";
  vx: number;
  vy: number;
}

export interface InstLD extends BaseInst {
  type: "LD";
  vx: number;
  kk: number;
}

export interface InstADD extends BaseInst {
  type: "ADD";
  vx: number;
  kk: number;
}

export interface InstLDV extends BaseInst {
  type: "LDV";
  vx: number;
  vy: number;
}

export interface InstOR extends BaseInst {
  type: "OR";
  vx: number;
  vy: number;
}

export interface InstAND extends BaseInst {
  type: "AND";
  vx: number;
  vy: number;
}

export interface InstXOR extends BaseInst {
  type: "XOR";
  vx: number;
  vy: number;
}

export interface InstADDV extends BaseInst {
  type: "ADDV";
  vx: number;
  vy: number;
}

export interface InstSUB extends BaseInst {
  type: "SUB";
  vx: number;
  vy: number;
}

export interface InstSHR extends BaseInst {
  type: "SHR";
  vx: number;
  vy: number;
}

export interface InstSUBN extends BaseInst {
  type: "SUBN";
  vx: number;
  vy: number;
}

export interface InstSHL extends BaseInst {
  type: "SHL";
  vx: number;
  vy: number;
}

export interface InstSNEV extends BaseInst {
  type: "SNEV";
  vx: number;
  vy: number;
}

export interface InstLDI extends BaseInst {
  type: "LDI";
  nnn: number;
}

export interface InstJPV0 extends BaseInst {
  type: "JPV0";
  addr: number;
}

export interface InstRND extends BaseInst {
  type: "RND";
  vx: number;
  kk: number;
}

export interface InstDRW extends BaseInst {
  type: "DRW";
  vx: number;
  vy: number;
}

export interface InstSKP extends BaseInst {
  type: "SKP";
  vx: number;
}

export interface InstSKNP extends BaseInst {
  type: "SKNP";
  vx: number;
}

export interface InstLDVDT extends BaseInst {
  type: "LDVDT";
  vx: number;
}

export interface InstLDVK extends BaseInst {
  type: "LDVK";
  vx: number;
}

export interface InstLDDTV extends BaseInst {
  type: "LDDTV";
  vx: number;
}

export interface InstLDSTV extends BaseInst {
  type: "LDSTV";
  vx: number;
}

export interface InstADDIV extends BaseInst {
  type: "ADDIV";
  vx: number;
}

export interface InstLDFV extends BaseInst {
  type: "LDFV";
  vx: number;
}

export interface InstLDBV extends BaseInst {
  type: "LDBV";
  vx: number;
}

export interface InstLDIV extends BaseInst {
  type: "LDIV";
  vx: number;
}

export interface InstLDVI extends BaseInst {
  type: "LDVI";
  vx: number;
}

export interface InstBAD extends BaseInst {
  type: "BAD";
  op: number;
}

export interface InstSYS extends BaseInst {
  type: "SYS";
  nnn: number;
}

export type Inst =
  | InstCLS
  | InstRET
  | InstJMP
  | InstCALL
  | InstSE
  | InstSNE
  | InstSEV
  | InstLD
  | InstADD
  | InstLDV
  | InstOR
  | InstAND
  | InstXOR
  | InstADDV
  | InstSUB
  | InstSHR
  | InstSUBN
  | InstSHL
  | InstSNEV
  | InstLDI
  | InstJPV0
  | InstRND
  | InstDRW
  | InstSKP
  | InstSKNP
  | InstLDVDT
  | InstLDVK
  | InstLDDTV
  | InstLDSTV
  | InstADDIV
  | InstLDFV
  | InstLDBV
  | InstLDIV
  | InstLDVI
  | InstBAD
  | InstSYS
  | InstDAT;

export class UnknownInstructionError extends Error {
  name = "UnknownInstruction";

  constructor(op: number, at: number) {
    super(
      `0x${op.toString(16).padStart(4, "0")} @ 0x${
        at.toString(16).padStart(4, "0")
      }`,
    );
  }
}

export function* parse(
  data: Uint8Array,
  throwOnUnknown = true,
): IterableIterator<Inst> {
  for (let pc = 0; pc < data.length; pc += 2) {
    const op = data[pc] << 8 | data[pc + 1];
    const [x, y, kk, nnn] = [
      (op & 0x0F00) >> 8,
      (op & 0x00F0) >> 4,
      op & 0xFF,
      op & 0xFFF,
    ];

    switch (op & 0xF000) {
      case 0x0000:
        switch (op) {
          case 0x00E0:
            yield { type: "CLS", at: pc };
            break;

          case 0x00EE:
            yield { type: "RET", at: pc };
            break;

          default:
            yield { type: "SYS", nnn, at: pc };
        }
        break;

      case 0x1000:
        yield {
          type: "JMP",
          addr: nnn,
          at: pc,
        };
        break;

      case 0x2000:
        yield {
          type: "CALL",
          addr: nnn,
          at: pc,
        };
        break;

      case 0x3000:
        yield {
          type: "SE",
          vx: x,
          kk,
          at: pc,
        };
        break;

      case 0x4000:
        yield {
          type: "SNE",
          vx: x,
          kk,
          at: pc,
        };
        break;

      case 0x5000:
        yield {
          type: "SEV",
          vx: x,
          vy: y,
          at: pc,
        };
        break;

      case 0x6000:
        yield {
          type: "LD",
          vx: x,
          kk,
          at: pc,
        };
        break;

      case 0x7000:
        yield {
          type: "ADD",
          vx: x,
          kk,
          at: pc,
        };
        break;

      case 0x8000:
        switch (op & 0xf) {
          case 0x0:
            yield {
              type: "LDV",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x1:
            yield {
              type: "OR",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x2:
            yield {
              type: "AND",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x3:
            yield {
              type: "XOR",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x4:
            yield {
              type: "ADDV",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x5:
            yield {
              type: "SUB",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x6:
            yield {
              type: "SHR",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0x7:
            yield {
              type: "SUBN",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          case 0xe:
            yield {
              type: "SHL",
              vx: x,
              vy: y,
              at: pc,
            };
            break;

          default:
            if (throwOnUnknown) throw new UnknownInstructionError(op, pc);
            else yield { type: "BAD", op, at: pc };
        }
        break;

      case 0x9000:
        yield {
          type: "SNEV",
          vx: x,
          vy: y,
          at: pc,
        };
        break;

      case 0xa000:
        yield {
          type: "LDI",
          nnn,
          at: pc,
        };
        break;

      case 0xb000:
        yield {
          type: "JPV0",
          addr: nnn,
          at: pc,
        };
        break;

      case 0xc000:
        yield {
          type: "RND",
          vx: x,
          kk,
          at: pc,
        };
        break;

      case 0xd000:
        yield {
          type: "DRW",
          vx: x,
          vy: y,
          at: pc,
        };
        break;

      case 0xe000:
        switch (kk) {
          case 0x9e:
            yield {
              type: "SKP",
              vx: x,
              at: pc,
            };
            break;

          case 0xa1:
            yield {
              type: "SKNP",
              vx: x,
              at: pc,
            };
            break;

          default:
            if (throwOnUnknown) throw new UnknownInstructionError(op, pc);
            else yield { type: "BAD", op, at: pc };
        }
        break;

      case 0xf000:
        switch (kk) {
          case 0x07:
            yield {
              type: "LDVDT",
              vx: x,
              at: pc,
            };
            break;

          case 0x0a:
            yield {
              type: "LDVK",
              vx: x,
              at: pc,
            };
            break;

          case 0x15:
            yield {
              type: "LDDTV",
              vx: x,
              at: pc,
            };
            break;

          case 0x18:
            yield {
              type: "LDSTV",
              vx: x,
              at: pc,
            };
            break;

          case 0x1e:
            yield {
              type: "ADDIV",
              vx: x,
              at: pc,
            };
            break;

          case 0x29:
            yield {
              type: "LDFV",
              vx: x,
              at: pc,
            };
            break;

          case 0x33:
            yield {
              type: "LDBV",
              vx: x,
              at: pc,
            };
            break;

          case 0x55:
            yield {
              type: "LDIV",
              vx: x,
              at: pc,
            };
            break;

          case 0x65:
            yield {
              type: "LDVI",
              vx: x,
              at: pc,
            };
            break;

          default:
            if (throwOnUnknown) throw new UnknownInstructionError(op, pc);
            else yield { type: "BAD", op, at: pc };
        }
        break;

      default:
        if (throwOnUnknown) throw new UnknownInstructionError(op, pc);
        else yield { type: "BAD", op, at: pc };
    }
  }
}
