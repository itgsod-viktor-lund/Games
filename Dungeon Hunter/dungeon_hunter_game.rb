require 'Chingu'

class Game < Chingu::Window

	def initialize
		super 800, 550
		self.caption = "Dungeon Hunter"
		self.input = {esc: :exit}
		@player = Player.create
	end
end

class Player < Chingu::GameObject
	has_traits :velocity
	
	def setup
		@x, @y = 800/2, 550/2
		@player_image = Gosu::Image["player.png"]

		self.input = {
			holding_up: :up,
			holding_down: :down,
			holding_right: :right,
			holding_left: :left
		}
	end

	def update
		@x = 800
		@y = 550
	end

	def up
		self.velocity_y -= 5
	end

	def down
		self.velocity_y += 5
	end

	def right
		self.velocity_x += 5
	end

	def left
		self.velocity_x -= 5
	end

end

Game.new.show