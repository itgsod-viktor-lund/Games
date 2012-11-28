require 'Chingu'

class Game < Chingu::Window

	def initialize
		super 800, 550
		self.caption = "Dungeon Hunter"
		self.input = {esc: :exit}
		@background_image = Background.create
		@player = Player.create
	end

	def update
		super
		Laser.each_bounding_circle_collision(Wall) do |laser|
      	laser.destroy
     	end
	end
end

class Background < Chingu::GameObject

	def setup
		@x, @y = 800/2, 550/2
		@image = Gosu::Image["background.png"]
	end
end

class Wall < Chingu::GameObject
	has_traits :collision_detection, :bounding_circle

	def setup
		@x, @y = 25/2, 550/2
		@image = Gosu::Image["wall.png"]
	end
end

class Player < Chingu::GameObject
	attr_reader :angle_shot
	has_traits :velocity, :collision_detection, :bounding_circle
	
	def setup
		@lock = false
		@x, @y = 100, 100
		@angle_shot = 0
		@laservelx = 0
		@laservely = 0
		@lock_right_x = false
		@lock_left_x = false
		@lock_up_y = false
		@lock_down_y = false
		@image = Gosu::Image["player.png"]
		@wall_image = Wall.create

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
			@laservely = -10
			@laservelx = 0
			@angle_shot = 0
		end
	end

	def down
		if lock_check
			@y += 5
			@laservely = 10
			@laservelx = 0
			@angle_shot = 180
		end
	end

	def right
		if lock_check
			@x += 5
			@laservelx = 10
			@laservely = 0
			@angle_shot = 90
		end
	end

	def left
		if lock_check
			@x -= 5
			@laservelx = -10
			@laservely = 0
			@angle_shot = 270
		end
	end

	def fire
		Laser.create(x: self.x, y: self.y, velocity_x: @laservelx, velocity_y: @laservely, angle: @angle_shot)
	end
end

class Laser < Chingu::GameObject
	has_traits :velocity, :timer, :collision_detection, :bounding_circle

	def setup
		@image = Gosu::Image["flame_ball.png"]
		after(3000) {self.destroy}
	end
end

Game.new.show