require "./texture.cr"
require "sdl-crystal-bindings"

class GameObject
    property x_pixel : Int32
    property y_pixel : Int32
    property x_tile : Int32
    property y_tile : Int32
    property width : Int32
    property height : Int32
    @texture : SDLTexture?
    @srcRect : LibSDL::Rect?
    def initialize(x : Int32, y : Int32, spr_width : Int32, spr_height : Int32, texture_path : String)
        @x_pixel = 0
        @y_pixel = 0
        @x_tile = 0
        @y_tile = 0
        @width = spr_width
        @height = spr_width
        @texture = SDLTexture.new()
        @texture_path = texture_path
    end

    def free()
        if !@texture.nil?
            @texture.not_nil!.free()
        else
            puts "Nothing to free"
        end
    end

    def create_source_rect(x : Int32, y : Int32, w : Int32, h : Int32)
        @srcRect = LibSDL::Rect.new(x: x, y: y, w: w, h: h)
    end

    def load(renderer : LibSDL::Renderer*)
        @texture.not_nil!.load_from_file(renderer, @texture_path)
    end

    def draw(renderer : LibSDL::Renderer*)
        destRect = LibSDL::Rect.new(x: @x_pixel, y: @y_pixel, w: @width, h: @height)
        if !@texture.nil? && !@srcRect.nil?
            rect = @srcRect.not_nil!
            LibSDL.render_copy(renderer, @texture.not_nil!.get_texture(), pointerof(rect), pointerof(destRect))
        elsif !@texture.nil?
            LibSDL.render_copy(renderer, @texture.not_nil!.get_texture(), nil, pointerof(destRect))
        end
    end
end