require 'Chingu'
require './dungeon_hunter_game2.rb'

class Game < Chingu::Window

	def initialize
		super 800, 550
		switch_game_state(PlayGame)
	end

end

class PlayGame < Chingu::GameState

	def initialize
		super
		$window.caption = "Dungeon Hunter"
		self.input = {esc: :exit}
		@background_image = Background.create
		@left_wall = Wall.create(x: 25/2, y: 550/2, image: "left_wall.png")
		@up_wall = Wall.create(x: 800/2, y: 25/2, image: "wall_up_down.png")
		@down_wall = Wall.create(x: 800/2, y: 550-(25/2), image: "wall_up_down.png")
		@right_wall = Wall.create(x: 800-(25/2), y: (550/2)-50, image: "right_wall.png")
		@enemie1 = EnemieLvL1.create(x: 300, y: 200)
		@enemie2 = EnemieLvL1.create(x: 200, y: 300)
		@enemie3 = EnemieLvL1.create(x: 500, y: 250)
		@enemie4 = EnemieLvL1.create(x: 500, y: 450)
		@enemie5 = EnemieLvL1.create(x: 700, y: 75)
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
		
		if @player.hp <= 0
			@player.destroy
			@background_image.destroy
			@enemie1.destroy
			@enemie2.destroy
			@enemie3.destroy
			@enemie4.destroy
			@enemie5.destroy
			@left_wall.destroy
			@up_wall.destroy
			@down_wall.destroy
			@right_wall.destroy
			
			@background_image = Dead.create
		end

		if @player.x < 0 or @player.x > 800 or @player.y < 0 or @player.y > 550
			push_game_state(LvL2)
		end
	end
end


class Background < Chingu::GameObject

	def setup

		@x, @y = 800/2, 550/2
		@image = Gosu::Image["background.png"]
	end
end

class Dead < Chingu::GameObject

	def setup
		@x, @y = 800/2, 550/2
		@image = Gosu::Image["dead.png"]
	end
end

class Wall < Chingu::GameObject
	has_traits :collision_detection, :bounding_box
end

class Player < Chingu::GameObject
	attr_writer :x, :y
	attr_reader :angle_shot, :hp
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

	end

	def hp_down
		if @hpDown == false
			@hpDown = true
			@hp -= 1
			after(1000) {@hpDown = false}	
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