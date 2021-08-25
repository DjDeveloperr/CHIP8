import { parse } from "./parser.ts";
import { intoASM } from "./asm.ts";

const file = Deno.readFileSync(Deno.args[0] || "./roms/pong.ch8");
const insts = [...parse(file, false)];
const asm = intoASM(insts, file, true, true).join("\n");
Deno.writeTextFileSync(Deno.args[1] || "./roms/pong.s", asm);
