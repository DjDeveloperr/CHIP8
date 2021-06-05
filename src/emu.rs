use rand::Rng;

/// Offset in CHIP8 RAM where actual ROM (program) starts
pub const ROM_OFFSET: usize = 0x200;
/// Number of pixels horizontally
pub const COLS: usize = 64;
/// Number of pixels vertically
pub const ROWS: usize = 32;
/// Total number of pixels
pub const PIXELS: usize = ROWS * COLS;

/// CHIP-8 Emulator based on http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
pub struct Emulator {
    /// The RAM of Emulator (4kb)
    pub memory: [u8; 0x1000],
    /// 16 16-bit registers
    pub v: [u8; 0x10],
    /// Represents stack. Actually upto `sp`, rest are 0s
    pub stack: [u16; 0x10],
    /// Represents current top-most stack item index/pointer
    pub sp: u8,
    /// Display memory, basically 0s and 1s
    pub display: [u8; PIXELS],
    /// Keys that are currently pressed
    pub keyboard: [bool; 0x10],
    /// Whether emulator is paused or not
    pub paused: bool,
    /// Emulator speed (instructions executed per cycle)
    pub speed: u8,
    /// Whether emulator will be unpaused on next key_down,
    /// if it will, then `pc` will also be set to given value
    pub unpause_next: Option<u8>,
    /// Represents program counter, position to current instruction/opcode in memory.
    pub pc: u16,
    /// Just another register.
    pub i: u16,
    /// Delay timer
    pub dt: u8,
    /// Sound timer
    pub st: u8,
}

impl Emulator {
    /// Create new Emulator instance
    pub fn new() -> Self {
        Self {
            memory: [0; 0x1000],
            v: [0; 0x10],
            // Initialize with all pixels 0, that is black screen
            display: [0; PIXELS],
            stack: [0; 0x10],
            sp: 0,
            // Initialize with all keys up
            keyboard: [false; 0x10],
            unpause_next: None,
            // Execution starts where ROM is loaded
            pc: ROM_OFFSET as u16,
            i: 0,
            paused: false,
            speed: 10,
            dt: 0,
            st: 0,
        }
    }

    /// Load sprites/fontset into RAM
    pub fn load_sprites(&mut self) {
        let sprites: [u8; 0x50] = [
            0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
            0x20, 0x60, 0x20, 0x20, 0x70, // 1
            0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
            0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
            0x90, 0x90, 0xF0, 0x10, 0x10, // 4
            0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
            0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
            0xF0, 0x10, 0x20, 0x40, 0x40, // 7
            0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
            0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
            0xF0, 0x90, 0xF0, 0x90, 0x90, // A
            0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
            0xF0, 0x80, 0x80, 0x80, 0xF0, // C
            0xE0, 0x90, 0x90, 0x90, 0xE0, // D
            0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
            0xF0, 0x80, 0xF0, 0x80, 0x80, // F
        ];

        let mut offset = 0x000;
        for byte in sprites {
            self.memory[offset] = byte;
            offset += 1;
        }
    }

    /// Load ROM into RAM
    pub fn load_rom(&mut self, rom: &[u8]) {
        let mut idx = 0;
        for byte in rom {
            self.memory[ROM_OFFSET + idx] = *byte;
            idx += 1;
        }
    }

    /// Toggle (XOR) pixel at given location. Given location may be changed to keep it in bounds
    fn set_pixel(&mut self, x: isize, y: isize) -> bool {
        let mut x = x;
        let mut y = y;

        while x >= (COLS as isize) {
            x -= COLS as isize;
        }

        if x < 0 {
            x += COLS as isize;
        }

        while y >= (ROWS as isize) {
            y -= ROWS as isize;
        }

        if y < 0 {
            y += ROWS as isize;
        }

        let idx = ((y * (COLS as isize)) + x) as usize;
        self.display[idx] ^= 1;

        self.display[idx] != 0
    }

    /// Clears display memory, i.e. fill it with 0s.
    /// Results in all black* display.
    pub fn clear_display(&mut self) {
        self.display.fill(0);
    }

    /// Checks whether a key is pressed or not
    pub fn is_key_pressed(&self, code: u8) -> bool {
        self.keyboard[code as usize]
    }

    /// Holds down the key if its not pressed, otherwise noop
    pub fn key_down(&mut self, code: u8) {
        if !self.is_key_pressed(code) {
            self.keyboard[code as usize] = true;

            if self.unpause_next.is_some() {
                self.paused = false;
                self.v[self.unpause_next.unwrap() as usize] = code;
                self.unpause_next = None;
            }
        }
    }

    /// Releases the key if it is pressed, otherwise noop
    pub fn key_up(&mut self, code: u8) {
        if self.is_key_pressed(code) {
            self.keyboard[code as usize] = false;
        }
    }

    /// Gets current opcode/instruction. Basically `fetch` part of cycle.
    pub fn opcode(&self) -> u16 {
        ((self.memory[self.pc as usize] as u16) << 8) | self.memory[self.pc as usize + 1] as u16
    }

    /// "Decodes" given opcode value.
    fn decode_opcode(&self, op: u16) -> (u8, u8, u8, u16) {
        (
            ((op & 0x0F00) >> 8) as u8,
            ((op & 0x00F0) >> 4) as u8,
            (op & 0xFF) as u8,
            op & 0xFFF,
        )
    }

    /// Runs a CPU cycle.
    pub fn cycle(&mut self) {
        for _ in 0..self.speed {
            if !self.paused {
                self.execute_instruction();
            }
        }

        if !self.paused {
            self.update_timers();
        }
    }

    /// Updates delay and sound timers
    fn update_timers(&mut self) {
        if self.dt > 0 {
            self.dt -= 1;
        }

        if self.st > 0 {
            self.st -= 1;
        }
    }

    /// Executes current instruction
    fn execute_instruction(&mut self) {
        let op = self.opcode();
        let (x, y, kk, nnn) = self.decode_opcode(op);
        self.pc += 2;

        match op & 0xf000 {
            0x0000 => match op {
                // 00E0 - CLS
                // Clear the display.
                0x00E0 => {
                    self.clear_display();
                }

                // 00EE - RET
                // Return from a subroutine.
                //
                // The interpreter sets the program counter to the address at the top of the stack, then subtracts 1 from the stack pointer.
                0x00EE => {
                    // NOTE: Why did I have to subtract 1 before setting pc?
                    self.sp -= 1;
                    self.pc = self.stack[self.sp as usize];
                    self.stack[self.sp as usize] = 0;
                }

                _ => {}
            },

            // 1nnn - JP addr
            // Jump to location nnn.
            //
            // The interpreter sets the program counter to nnn.
            0x1000 => {
                self.pc = nnn;
            }

            // 2nnn - CALL addr
            // Call subroutine at nnn.
            //
            // The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
            0x2000 => {
                self.stack[self.sp as usize] = self.pc;
                // NOTE: Why did I have to increment it after setting pc?
                self.sp += 1;
                self.pc = nnn;
            }

            // 3xkk - SE Vx, byte
            // Skip next instruction if Vx = kk.
            //
            // The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
            0x3000 => {
                let vx = self.v[x as usize];
                if vx == kk {
                    self.pc += 2;
                }
            }

            // 4xkk - SNE Vx, byte
            // Skip next instruction if Vx != kk.
            //
            // The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
            0x4000 => {
                let vx = self.v[x as usize];
                if vx != kk {
                    self.pc += 2;
                }
            }

            // 5xy0 - SE Vx, Vy
            // Skip next instruction if Vx = Vy.
            //
            // The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
            0x5000 => {
                let vx = self.v[x as usize];
                let vy = self.v[y as usize];

                if vx == vy {
                    self.pc += 2;
                }
            }

            // 6xkk - LD Vx, byte
            // Set Vx = kk.
            //
            // The interpreter puts the value kk into register Vx.
            0x6000 => {
                self.v[x as usize] = kk;
            }

            // 7xkk - ADD Vx, byte
            // Set Vx = Vx + kk.
            //
            // Adds the value kk to the value of register Vx, then stores the result in Vx.
            0x7000 => {
                let mut vx = self.v[x as usize] as u16;
                vx += kk as u16;
                self.v[x as usize] = (vx & 0xFF) as u8; // NOTE: I had to & 0xff to prevent overflow, but spec does not say so
            }

            0x8000 => match op & 0xf {
                // 8xy0 - LD Vx, Vy
                // Set Vx = Vy.
                //
                // Stores the value of register Vy in register Vx.
                0x0 => {
                    self.v[x as usize] = self.v[y as usize];
                }

                // 8xy1 - OR Vx, Vy
                // Set Vx = Vx OR Vy.
                //
                // Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx. A bitwise OR compares the corrseponding bits from two values, and if either bit is 1, then the same bit in the result is also 1. Otherwise, it is 0.
                0x1 => {
                    self.v[x as usize] |= self.v[y as usize];
                }

                // 8xy2 - AND Vx, Vy
                // Set Vx = Vx AND Vy.
                //
                // Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx. A bitwise AND compares the corrseponding bits from two values, and if both bits are 1, then the same bit in the result is also 1. Otherwise, it is 0.
                0x2 => {
                    self.v[x as usize] &= self.v[y as usize];
                }

                // 8xy3 - XOR Vx, Vy
                // Set Vx = Vx XOR Vy.
                //
                // Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx. An exclusive OR compares the corrseponding bits from two values, and if the bits are not both the same, then the corresponding bit in the result is set to 1. Otherwise, it is 0.
                0x3 => {
                    self.v[x as usize] ^= self.v[y as usize];
                }

                // 8xy4 - ADD Vx, Vy
                // Set Vx = Vx + Vy, set VF = carry.
                //
                // The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0. Only the lowest 8 bits of the result are kept, and stored in Vx.
                0x4 => {
                    let vx = self.v[x as usize] as u16;
                    let vy = self.v[y as usize] as u16;
                    let sum = vx + vy;

                    if sum > 0xFF {
                        self.v[0xF] = 1;
                    } else {
                        self.v[0xF] = 0;
                    }

                    self.v[x as usize] = sum as u8 & 0xFF;
                }

                // 8xy5 - SUB Vx, Vy
                // Set Vx = Vx - Vy, set VF = NOT borrow.
                //
                // If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
                0x5 => {
                    let vx = self.v[x as usize] as i16;
                    let vy = self.v[y as usize] as i16;
                    let sub = vx - vy;

                    if vx > vy {
                        self.v[0xF] = 1;
                    } else {
                        self.v[0xF] = 0;
                    }

                    self.v[x as usize] = (sub & 0xFF) as u8;
                }

                // 8xy6 - SHR Vx {, Vy}
                // Set Vx = Vx SHR 1.
                //
                // If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
                0x6 => {
                    let vx = self.v[x as usize];
                    self.v[0xF] = vx & 0xF;

                    self.v[x as usize] >>= 1;
                }

                // 8xy7 - SUBN Vx, Vy
                // Set Vx = Vy - Vx, set VF = NOT borrow.
                //
                // If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
                0x7 => {
                    let vx = self.v[x as usize] as i16;
                    let vy = self.v[y as usize] as i16;

                    if vy > vx {
                        self.v[0xF] = 1;
                    } else {
                        self.v[0xF] = 0;
                    }

                    self.v[x as usize] = ((vy - vx) & 0xFF) as u8;
                }

                // 8xyE - SHL Vx {, Vy}
                // Set Vx = Vx SHL 1.
                //
                // If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
                0xe => {
                    let vx = self.v[x as usize];
                    self.v[0xF] = vx & 0x80;
                    self.v[x as usize] <<= 1;
                }
                _ => {}
            },

            // 9xy0 - SNE Vx, Vy
            // Skip next instruction if Vx != Vy.
            //
            // The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
            0x9000 => {
                let vx = self.v[x as usize];
                let vy = self.v[y as usize];

                if vx != vy {
                    self.pc += 2;
                }
            }

            // Annn - LD I, addr
            // Set I = nnn.
            //
            // The value of register I is set to nnn.
            0xA000 => {
                self.i = nnn;
            }

            // Bnnn - JP V0, addr
            // Jump to location nnn + V0.
            //
            // The program counter is set to nnn plus the value of V0.
            0xB000 => {
                self.pc = nnn + self.v[0] as u16;
            }

            // Cxkk - RND Vx, byte
            // Set Vx = random byte AND kk.
            //
            // The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.
            0xC000 => {
                let rnd = rand::thread_rng().gen_range(0..256) as u8;
                self.v[x as usize] = rnd & kk;
            }

            // Dxyn - DRW Vx, Vy, nibble
            // Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
            //
            // The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display, for more information on the Chip-8 screen and sprites.
            0xD000 => {
                let vx = self.v[x as usize] as isize;
                let vy = self.v[y as usize] as isize;

                let width = 8isize;
                let height = (op & 0xF) as isize;

                self.v[0xF] = 0;

                for row in 0..height {
                    let mut sprite = self.memory[(self.i + (row as u16)) as usize];

                    for col in 0..width {
                        if (sprite & 0x80) > 0 {
                            if self.set_pixel(vx + col, vy + row) {
                                self.v[0xF] = 1;
                            }
                        }

                        sprite <<= 1;
                    }
                }
            }

            0xE000 => match kk {
                // Ex9E - SKP Vx
                // Skip next instruction if key with the value of Vx is pressed.
                //
                // Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.
                0x9E => {
                    let vx = self.v[x as usize];

                    if self.is_key_pressed(vx) {
                        self.pc += 2;
                    }
                }

                // ExA1 - SKNP Vx
                // Skip next instruction if key with the value of Vx is not pressed.
                //
                // Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.
                0xA1 => {
                    let vx = self.v[x as usize];

                    if !self.is_key_pressed(vx) {
                        self.pc += 2;
                    }
                }

                _ => {}
            },
            0xF000 => match kk {
                // Fx07 - LD Vx, DT
                // Set Vx = delay timer value.
                //
                // The value of DT is placed into Vx.
                0x07 => {
                    self.v[x as usize] = self.dt;
                }

                // Fx0A - LD Vx, K
                // Wait for a key press, store the value of the key in Vx.
                //
                // All execution stops until a key is pressed, then the value of that key is stored in Vx.
                0x0A => {
                    self.paused = true;
                    self.unpause_next = Some(x);
                }

                // Fx15 - LD DT, Vx
                // Set delay timer = Vx.
                //
                // DT is set equal to the value of Vx.
                0x15 => {
                    let vx = self.v[x as usize];
                    self.dt = vx;
                }

                // Fx18 - LD ST, Vx
                // Set sound timer = Vx.
                //
                // ST is set equal to the value of Vx.
                0x18 => {
                    let vx = self.v[x as usize];
                    self.st = vx;
                }

                // Fx1E - ADD I, Vx
                // Set I = I + Vx.
                //
                // The values of I and Vx are added, and the results are stored in I.
                0x1E => {
                    let vx = self.v[x as usize];
                    self.i += vx as u16;
                }

                // Fx29 - LD F, Vx
                // Set I = location of sprite for digit Vx.
                //
                // The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.
                0x29 => {
                    let vx = self.v[x as usize];
                    self.i = vx as u16 * 5;
                }

                // Fx33 - LD B, Vx
                // Store BCD representation of Vx in memory locations I, I+1, and I+2.
                //
                // The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.
                0x33 => {
                    let i = self.i as usize;
                    let vx = self.v[x as usize];

                    self.memory[i] = vx / 100;
                    self.memory[i + 1] = (vx / 10) % 10;
                    self.memory[i + 2] = (vx % 100) % 10;
                }

                // Fx55 - LD [I], Vx
                // Store v V0 through Vx in memory starting at location I.
                //
                // The interpreter copies the values of v V0 through Vx into memory, starting at the address in I.
                0x55 => {
                    let vx = self.v[x as usize] as u16 + 1;

                    for idx in 0..vx {
                        self.memory[(self.i + idx) as usize] =
                            if idx > 15 { 0 } else { self.v[idx as usize] };
                    }
                }

                // Fx65 - LD Vx, [I]
                // Read v V0 through Vx from memory starting at location I.
                //
                // The interpreter reads values from memory starting at location I into v V0 through Vx.
                0x65 => {
                    let vx = self.v[x as usize] as u16 + 1;

                    for idx in 0..vx {
                        if idx < 16 {
                            self.v[idx as usize] = self.memory[(self.i + idx) as usize];
                        }
                    }
                }

                _ => {}
            },

            _ => {
                panic!("Unknown instruction: {} at {}", op, self.pc - 2);
            }
        }
    }
}
