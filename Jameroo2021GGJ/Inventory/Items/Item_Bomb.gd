extends IItem


func _init():
	self.i_name = "Bomb"
	self.i_image = load("res://Inventory/Items/Bomb.png")
	self.i_description = "If you pick me up, I will stun you"
	self.i_stackable = false

func i_pickup(player):
	player.stunnedTimer = 10
	InputSystem.randomize_movement_inputs()
	
func i_use(player):
	player.health += 10
	.i_use(player)
