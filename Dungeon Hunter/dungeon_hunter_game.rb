require 'Chingu'

class Game < Chingu::Window

	def initialize
		super 800, 550
		self.caption = "Dungeon Hunter"
		self.input = {esc: :exit}
		@background_image = Background.create
		@wall_image = Wall.create
		@player = Player.create
	end
end

class Background < Chingu::GameObject

	def setup
		@x, @y = 800/2, 550/2
		@image = Gosu::Image["background.png"]
	end
end

class Wall < Chingu::GameObject

	def setup
		@x, @y = 800/2, 550/2
		@image = Gosu::Image["wall.png"]
	end
end

class Player < Chingu::GameObject
	has_traits :velocity
	
	def setup
		@lock = false
		@x, @y = 100, 100
		@angle_shot = 0
		@image = Gosu::Image["player.png"]

		self.input = {
			holding_up: :up,
			holding_down: :down,
			holding_right: :right,
			holding_left: :left,
			space: :fire
		}
	end

	def update
		@lock = false
	end

	def lock_check
		if @lock == false
			@lock = true
		end
	end

	def up
		if lock_check
			@y -= 5
			@angle_shot = 0
		end
	end

	def down
		if lock_check
			@y += 5
			@angle_shot = 180
		end
	end

	def right
		if lock_check
			@x += 5
			@angle_shot = 90
		end
	end

	def left
		if lock_check
			@x -= 5
			@angle_shot = 270
		end
	end

	def fire
		Laser.create(x: self.x, y: self.y, angle: @angle_shot)
	end
end

class Laser < Chingu::GameObject
	has_traits :velocity, :timer, :collision_detection, :bounding_circle

	def setup
		@image = Gosu::Image["flame_ball.png"]
		self.velocity_x = Gosu::offset_y(angle, 10)
		self.velocity_y = Gosu::offset_y(angle, 10)
		after(3000) {self.destroy}
	end
end

Game.new.show