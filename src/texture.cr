require "sdl-crystal-bindings"
require "sdl-crystal-bindings/sdl-image-bindings"

class SDLTexture
    getter width : Int32 = 0
    getter height : Int32 = 0

    @texture = Pointer(LibSDL::Texture).null
    @renderer = Pointer(LibSDL::Renderer).null

    def initialize(@renderer : LibSDL::Renderer*)
    end

    def finalize()
        free()
        @renderer = Pointer(LibSDL::Renderer).null
    end

    def free()
        if @texture != nil
            LibSDL.destroy_texture(@texture)
            @texture = Pointer(LibSDL::Texture).null
            @width = 0
            @height = 0
        end
    end

    def load_from_file(path : String)
        free()

        loaded_image_surface = LibSDL.img_load(path)
        if loaded_image_surface == nil
            raise "Could not load image from #{path}!"
        end

        @texture = LibSDL.create_texture_from_surface(@renderer, loaded_image_surface)
        if @texture == nil
            raise "Could not load texture from image surface with file #{path}!"
        end

        @width = loaded_image_surface.value.w
        @height = loaded_image_surface.value.h

        LibSDL.free_surface(loaded_image_surface)
    end

    def render(x : Int, y : Int, source_rect : LibSDL::Rect*? = nil)
        dest_rect = LibSDL::Rect.new(x: x, y: y, w: @width, h: @height)
        if source_rect
            dest_rect.w = source_rect.value.w
            dest_rect.h = source_rect.value.h
        end

        LibSDL.render_copy(@renderer, @texture, source_rect, pointerof(dest_rect))
      end
end