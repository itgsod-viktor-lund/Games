require 'Chingu'

class Game < Chingu::Window

	def initialize
		super 800, 550
		self.caption = "Dungeon Hunter"
		self.input = {esc: :exit}
		@background_image = Background.create
		Wall.create(x: 25/2, y: 550/2, image: "left_wall.png")
		Wall.create(x: 800/2, y: 25/2, image: "wall_up_down.png")
		Wall.create(x: 800/2, y: 550-(25/2), image: "wall_up_down.png")
		Wall.create(x: 800-(25/2), y: (550/2)-50, image: "right_wall.png")
		@enemie1 = EnemieLvL1.create(x: 300, y: 200)
		@enemie1 = EnemieLvL1.create(x: 200, y: 300)
		@enemie1 = EnemieLvL1.create(x: 500, y: 250)
		@enemie1 = EnemieLvL1.create(x: 500, y: 450)
		@enemie1 = EnemieLvL1.create(x: 700, y: 75)
		@player = Player.create
	end

	def update
		super
		Laser.each_collision(Wall) do |laser|
			laser.destroy
		end

		Laser.each_collision(EnemieLvL1) do |laser, enemie|
			laser.destroy
			enemie.destroy
		end

		Player.each_collision(EnemieLvL1) do |hp, player|
			hp.hp_down
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
	has_traits :collision_detection, :bounding_box
end

class Player < Chingu::GameObject
	attr_writer :x, :y
	attr_reader :angle_shot
	has_traits :velocity, :collision_detection, :bounding_box, :timer
	
	def setup
		@cantmove = ""
		@lock = false
		@hpDown = false
		@x, @y = 100, 100
		@angle_shot = 90
		@laservelx = 10
		@laservely = 0
		@lock_right_x = false
		@lock_left_x = false
		@lock_up_y = false
		@lock_down_y = false
		@hp = 5
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
		self.each_collision(Wall) do 
			if @angle_shot == 0
				@cantmove = "up"
				self.y += 5
			
			elsif @angle_shot == 180
				@cantmove = "down"
				self.y -= 5
			
			elsif @angle_shot == 90
				@cantmove = "right"
				self.x -= 5
			
			elsif @angle_shot == 270
				@cantmove = "left"
				self.x += 5
			end
		end

		if @x < 0 or @x > 800 or @y < 0 or @y > 550

		end	
	end

	def hp_down
		if @hpDown == false
			@hpDown = true
			@hp -= 1
			after(1000) {@hpDown = false}	
		end
		
		if @hp <= 0
			self.destroy
		end
	end

	def lock_check
		if @lock == false
			@lock = true
		end
	end

	def up
		if @cantmove.include?("up") == false
			if lock_check
				@y -= 5
				@laservely = -10
				@laservelx = 0
				@angle_shot = 0
				@cantmove = ""
			end
		end
	end

	def down
		if @cantmove.include?("down") == false
			if lock_check
				@y += 5
				@laservely = 10
				@laservelx = 0
				@angle_shot = 180
				@cantmove = ""
			end
		end
	end

	def right
		if @cantmove.include?("right") == false
			if lock_check
				@x += 5
				@laservelx = 10
				@laservely = 0
				@angle_shot = 90
				@cantmove = ""
			end
		end
	end

	def left
		if @cantmove.include?("left") == false
			if lock_check
				@x -= 5
				@laservelx = -10
				@laservely = 0
				@angle_shot = 270
				@cantmove = ""
			end
		end
	end

	def fire
		Laser.create(x: self.x, y: self.y, velocity_x: @laservelx, velocity_y: @laservely, angle: @angle_shot)
	end
end

class Laser < Chingu::GameObject
	has_traits :velocity, :timer, :collision_detection, :bounding_box

	def setup
		@image = Gosu::Image["flame_ball.png"]
		after(3000) {self.destroy}
	end
end

class EnemieLvL1 < Chingu::GameObject
	has_traits :velocity, :collision_detection, :bounding_box

	def setup
		@image = Gosu::Image["enemies.png"]
	end
end

Game.new.show