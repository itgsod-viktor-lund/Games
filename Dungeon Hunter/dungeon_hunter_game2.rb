class LvL2 < Chingu::GameState

	def setup
		super
		self.input = {esc: :exit}

		@background_image = Background.create
		@left_wall = Wall.create(x: 25/2, y: 550/2, image: "left_wall.png")
		@up_wall = Wall.create(x: 800/2, y: 25/2, image: "wall_up_down.png")
		@down_wall = Wall.create(x: 800/2, y: 550-(25/2), image: "wall_up_down.png")
		@right_wall = Wall.create(x: 800-(25/2), y: (550/2)-50, image: "right_wall.png")
		@enemie1 = EnemieLvL1.create(x: 500, y:500)
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
		@left_wall.destroy
		@up_wall.destroy
		@down_wall.destroy
		@right_wall.destroy
		
		@background_image = Dead.create
	end

	if @player.x < 0 or @player.x > 800 or @player.y < 0 or @player.y > 550
		#switch_game_state(LvL3)
	end
end
end

