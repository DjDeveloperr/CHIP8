pub mod emu;

use winit::{
    dpi::{LogicalSize, Size},
    event::{ElementState, Event, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};

use pixels::{Pixels, SurfaceTexture};

use crate::emu::{COLS, ROWS};

fn unix() -> u64 {
    std::time::UNIX_EPOCH.elapsed().unwrap().as_millis() as u64
}

fn main() {
    let mut emu = emu::Emulator::new();
    let rom = include_bytes!("../roms/game.ch8");

    let scale = 10f64;
    let width = COLS as f64 * scale;
    let height = ROWS as f64 * scale;

    let event_loop = EventLoop::new();
    let window = WindowBuilder::new()
        .with_title("CHIP-8 Emulator")
        .with_inner_size(Size::Logical(LogicalSize { width, height }))
        .build(&event_loop)
        .unwrap();

    let window_size = window.inner_size();
    let surface_texture = SurfaceTexture::new(window_size.width, window_size.height, &window);
    let mut pixels = Pixels::new(COLS as u32, ROWS as u32, surface_texture).unwrap();

    emu.load_sprites();
    emu.load_rom(rom);

    let fps = 60u64;
    let fps_interval = 1000 / fps;
    let mut then = unix();

    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        match event {
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                window_id,
            } if window_id == window.id() => *control_flow = ControlFlow::Exit,
            Event::MainEventsCleared => {
                window.request_redraw();
            }
            Event::WindowEvent {
                event:
                    WindowEvent::KeyboardInput {
                        input,
                        device_id: _,
                        is_synthetic: _,
                    },
                window_id,
            } if window_id == window.id() => {
                if input.virtual_keycode.is_none() {
                    return;
                }
                let key: Option<u8> = match input.virtual_keycode.unwrap() {
                    winit::event::VirtualKeyCode::A => Some(0xa),
                    winit::event::VirtualKeyCode::B => Some(0xb),
                    winit::event::VirtualKeyCode::C => Some(0xc),
                    winit::event::VirtualKeyCode::D => Some(0xd),
                    winit::event::VirtualKeyCode::E => Some(0xe),
                    winit::event::VirtualKeyCode::F => Some(0xf),
                    winit::event::VirtualKeyCode::Key0 => Some(0x0),
                    winit::event::VirtualKeyCode::Key1 => Some(0x1),
                    winit::event::VirtualKeyCode::Key2 => Some(0x2),
                    winit::event::VirtualKeyCode::Key3 => Some(0x3),
                    winit::event::VirtualKeyCode::Key4 => Some(0x4),
                    winit::event::VirtualKeyCode::Key5 => Some(0x5),
                    winit::event::VirtualKeyCode::Key6 => Some(0x6),
                    winit::event::VirtualKeyCode::Key7 => Some(0x7),
                    winit::event::VirtualKeyCode::Key8 => Some(0x8),
                    winit::event::VirtualKeyCode::Key9 => Some(0x9),
                    _ => None,
                };

                if key.is_some() {
                    if input.state == ElementState::Pressed {
                        emu.key_down(key.unwrap());
                    } else {
                        emu.key_up(key.unwrap());
                    }
                }
            }
            Event::RedrawRequested(wid) if wid == window.id() => {
                let elasped = unix() - then;

                if elasped > fps_interval {
                    emu.cycle();

                    let frame = pixels.get_frame();
                    let mut idx = 0;
                    for px in emu.display {
                        let fi = idx * 4;
                        let rgb = if px == 0 { 0 } else { 255 };
                        frame[fi] = rgb;
                        frame[fi + 1] = rgb;
                        frame[fi + 2] = rgb;
                        frame[fi + 3] = 255;
                        idx += 1;
                    }

                    if pixels.render().is_err() {
                        *control_flow = ControlFlow::Exit;
                        return;
                    }

                    then = unix();
                }
            }
            _ => (),
        }
    });
}
