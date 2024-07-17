require "sdl-crystal-bindings"
require "sdl-crystal-bindings/sdl-image-bindings"
require "./texture.cr"

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

if LibSDL.init(LibSDL::INIT_VIDEO) != 0
  raise "SDL could not initialize!"
end

w_pos_undef = LibSDL::WINDOWPOS_UNDEFINED
w_show = LibSDL::WindowFlags::WINDOW_SHOWN

g_window = LibSDL.create_window("SDL Tutorial", w_pos_undef, w_pos_undef, SCREEN_WIDTH, SCREEN_HEIGHT, w_show)
if g_window == nil
  raise "Could not create SDL Window!"
end

img_flags = LibSDL::IMGInitFlags::IMG_INIT_PNG
if (LibSDL.img_init(img_flags) | img_flags.to_i) == 0
  raise "Could not initialize SDL Image."
end

g_renderer = LibSDL.create_renderer(g_window, -1, LibSDL::RendererFlags::RENDERER_ACCELERATED)
if g_renderer == nil
  raise "Could not create SDL Renderer!"
end

LibSDL.set_render_draw_color(g_renderer, 0xFF, 0xFF, 0xFF, 0xFF)

my_tex = SDLTexture.new(g_renderer)
my_tex.load_from_file("res/graphics/actors/hero/hero_test.png")

running = true

src_rect = LibSDL::Rect.new(x: 0, y: 0, w: 32, h: 32)
dest_rect = LibSDL::Rect.new(x: 0, y: 0, w: 32, h: 32)

#Main loop
while running
  #Poll SDL events
  while LibSDL.poll_event(out e) != 0
    if e.type == LibSDL::EventType::QUIT.to_i()
      running = false
    end
  end

  #Draw
  LibSDL.render_clear(g_renderer)
  my_tex.render(0, 0, pointerof(src_rect))
  LibSDL.render_present(g_renderer)
end

#Free resources and exit
my_tex.free()
LibSDL.destroy_renderer(g_renderer)
LibSDL.destroy_window(g_window)

LibSDL.img_quit()
LibSDL.quit()