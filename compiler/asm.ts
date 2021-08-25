import type { Inst } from "./parser.ts";

export class UnknownInstructionTypeError extends Error {
  name = "UnknownInstructionType";

  constructor(inst: Inst) {
    super(`${inst.type} @ 0x${inst.at.toString(16).padStart(4, "0")}`);
  }
}

export function instToASM(inst: Inst): string {
  switch (inst.type) {
    case "ADD":
      return `add V${inst.vx.toString(16)}, #${inst.kk}`;

    case "ADDV":
      return `add V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "ADDIV":
      return `add I, V${inst.vx.toString(16)}`;

    case "AND":
      return `and V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "BAD":
      return `bad 0x${inst.op.toString(16).padStart(4, "0")} @ 0x${
        inst.at.toString(16).padStart(4, "0")
      }`;

    case "CALL":
      return `call ${
        typeof inst.addr === "string"
          ? inst.addr
          : `#0x${inst.addr.toString(16).padStart(4, "0")}`
      }`;

    case "CLS":
      return `cls`;

    case "DAT":
      return `dat 0x${inst.data.toString(16).padStart(4, "0")}`;

    case "DRW":
      return `drw V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "JMP":
      return `jmp #0x${inst.addr.toString(16).padStart(4, "0")}`;

    case "JPV0":
      return `jmp #0x${inst.addr.toString(16).padStart(4, "0")}+V0`;

    case "LD":
      return `ld V${inst.vx.toString(16)}, #${inst.kk}`;

    case "LDBV":
      return `ld I, V${inst.vx.toString(16)}.B`;

    case "LDDTV":
      return `ld DT, V${inst.vx.toString(16)}`;

    case "LDFV":
      return `ld I, V${inst.vx.toString(16)}.F`;

    case "LDI":
      return `ld I, #${inst.nnn}`;

    case "LDIV":
      return `ld I, V${inst.vx.toString(16)}`;

    case "LDSTV":
      return `ld ST, V${inst.vx.toString(16)}`;

    case "LDV":
      return `ld V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "LDVDT":
      return `ld V${inst.vx.toString(16)}, DT`;

    case "LDVI":
      return `ld V${inst.vx.toString(16)}, I`;

    case "LDVK":
      return `ld V${inst.vx.toString(16)}, K`;

    case "OR":
      return `OR V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "RET":
      return `ret`;

    case "RND":
      return `rnd V${inst.vx.toString(16)}, #${inst.kk}`;

    case "SE":
      return `se V${inst.vx.toString(16)}, #${inst.kk}`;

    case "SEV":
      return `se V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SHL":
      return `shl V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SHR":
      return `shr V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SKNP":
      return `sknp V${inst.vx.toString(16)}`;

    case "SKP":
      return `skp V${inst.vx.toString(16)}`;

    case "SNE":
      return `sne V${inst.vx.toString(16)}, #${inst.kk}`;

    case "SNEV":
      return `sne V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SUB":
      return `sub V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SUBN":
      return `subn V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    case "SYS":
      return `sys #0x${inst.nnn.toString(16).padStart(4, "0")}`;

    case "XOR":
      return `xor V${inst.vx.toString(16)}, V${inst.vy.toString(16)}`;

    default:
      throw new UnknownInstructionTypeError(inst);
  }
}

export function sortIntoLabels(insts: Inst[], data: Uint8Array) {
  const labels: {
    [name: string]: Inst[];
  } = {};
  const called = new Map<number, { from: number[]; ends: number }>();
  insts.forEach((inst) => {
    if (inst.type === "CALL" && typeof inst.addr === "number") {
      const addr = inst.addr - 0x200;
      const exists = insts.find((e) => e.at === addr);
      if (!exists) return;
      if (called.has(addr)) {
        const ref = called.get(addr);
        ref?.from.push(inst.at);
      } else {
        let ends = addr;
        for (;;) {
          let next = ends + 2;
          const exists = insts.find((e) => e.at === next);
          if (exists) {
            ends = next;
            if (exists.type === "RET") break;
          } else break;
        }
        called.set(addr, { from: [inst.at], ends });
      }
    }
  });
  called.forEach((e, addr) => {
    const body: Inst[] = [];
    for (let i = addr; i <= e.ends; i += 2) {
      const inst = insts.findIndex((e) => e.at === i);
      if (inst > -1) {
        body.push(insts[inst]);
        insts.splice(inst, 1);
      }
    }
    const name = "fn_" + addr.toString(16).padStart(4, "0");
    labels[name] = body;
    e.from.forEach((e) => {
      const inst = insts.find((x) => e === x.at);
      if (inst && inst.type === "CALL") {
        inst.addr = name;
      }
    });
    labels["main"] = insts;
  });
  const reversed = [...insts].reverse();
  let lastJmp = reversed.findIndex((e) => e.type === "JMP");
  if (lastJmp > -1) {
    const inst = reversed[lastJmp];
    lastJmp = insts.findIndex((e) => e.at === inst.at);
    if (inst.type === "JMP") {
      const instsAfterJmp = insts.slice(lastJmp + 1);
      if (
        insts.length > 0 &&
        instsAfterJmp.every((e) =>
          !insts.find((x) =>
            (x.type === "JMP" || x.type === "CALL") &&
            typeof x.addr === "number" &&
            (x.addr - 0x200) === e.at
          )
        )
      ) {
        insts.splice(lastJmp + 1, instsAfterJmp.length);
        labels["data"] = instsAfterJmp.map((e) => ({
          type: "DAT",
          data: (data[e.at] << 8) | data[e.at + 1],
          at: e.at,
        }));
      }
    }
  }
  return labels;
}

export function intoASM(
  insts: Inst[],
  data: Uint8Array,
  emitAddr = false,
  emitOp = false,
): string[] {
  const result = [];
  const labels = sortIntoLabels(insts, data);
  for (const label in labels) {
    result.push(label + ":");
    const insts = labels[label];
    for (const inst of insts) {
      let asm = "  " + instToASM(inst);
      if (emitAddr || emitOp) {
        asm = asm.padEnd(30, " ");
        let op = emitOp ? (data[inst.at] << 8 | data[inst.at + 1]) : undefined;
        asm += `; ${
          op !== undefined ? `0x${op.toString(16).padStart(4, "0")} ` : ""
        }${
          emitAddr
            ? `@ 0x${(inst.at + 0x200).toString(16).padStart(4, "0")}`
            : ""
        }`;
      }
      result.push(asm);
    }
  }
  return result;
}
