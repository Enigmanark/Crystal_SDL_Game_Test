require "sdl-crystal-bindings"
require "sdl-crystal-bindings/sdl-image-bindings"
require "./game.cr"
require "./config/cfg_window.cr"

def run_engine()
  #--Load SDL2
  if LibSDL.init(LibSDL::INIT_VIDEO) != 0
      raise "SDL could not initialize!"
    end
    
    w_pos_undef = LibSDL::WINDOWPOS_UNDEFINED
    w_show = LibSDL::WindowFlags::WINDOW_SHOWN
    
    g_window = LibSDL.create_window(WINDOW_TITLE, w_pos_undef, w_pos_undef, WINDOW_WIDTH, WINDOW_HEIGHT, w_show)
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
    
    #Make main game object
    game = Game.new()

    #Load game resources
    game.load_resources(g_renderer)

    #--Start main loop
    running = true
    #Main loop
    while running
      #Poll SDL events
      while LibSDL.poll_event(out e) != 0
        if e.type == LibSDL::EventType::QUIT.to_i()
          running = false
        end
      end
    
      #update
      game.update()

      #Draw
      LibSDL.render_clear(g_renderer)
      
      game.render(g_renderer)

      LibSDL.render_present(g_renderer)
    end
    
    #Free resources and exit
    game.free_all()
    LibSDL.destroy_renderer(g_renderer)
    LibSDL.destroy_window(g_window)
    
    LibSDL.img_quit()
    LibSDL.quit()
end