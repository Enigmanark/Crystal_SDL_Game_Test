require "./game_object.cr"

class Game
    def initialize()
        @player = GameObject.new(0, 0, 32, 32, "res/graphics/actors/hero/hero_test.png")
    end

    def load_resources(renderer : LibSDL::Renderer*)
        @player.load(renderer)
        @player.create_source_rect(0, 0, 32, 32)
    end

    def update()

    end

    def render(renderer : LibSDL::Renderer*)
        @player.draw(renderer)
    end

    def free_all()
        @player.free()
    end
end