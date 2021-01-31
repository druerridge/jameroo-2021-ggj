extends IItem


func _init():
	self.i_name = "Beer"
	self.i_image = load("res://Inventory/Items/Bomb.png")
	self.i_description = "If you pick me up, I will stun you"
	self.i_stackable = false

func i_pickup(player):
	player.drunkTimer = 10
	InputSystem.randomize_movement_inputs()
	
func i_use(player):
	.i_use(player)
