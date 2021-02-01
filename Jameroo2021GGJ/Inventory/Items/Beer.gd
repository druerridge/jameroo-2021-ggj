extends IItem


func _init(color):
	self.i_name = "Beer"
	self.i_image = load("res://Sprites/Items/potion_beer.png")
	self.i_description = "If you pick me up, I will stun you"
	self.i_stackable = false
	self.i_color = color

func i_pickup(player):
	player.drunkTimer = 5
	InputSystem.randomize_movement_inputs()
	
func i_use(player):
	.i_use(player)
