import { parse } from "./parser.ts";
import { intoASM } from "./asm.ts";

const file = Deno.readFileSync(Deno.args[0]);
const insts = [...parse(file, false)];
const asm = intoASM(insts, true, file).join("\n");
Deno.writeTextFileSync(Deno.args[1], asm);
