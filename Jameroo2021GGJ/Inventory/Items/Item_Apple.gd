extends IItem


func _init():
	self.i_name = "bomb"
	self.i_image = load("res://Inventory/Items/Bomb.png")
	self.i_description = "If you pick me up, I will stun you"
	self.i_stackable = true
	self.i_maxstack = 4

func i_pickup(player):
	player.canMove = false
func i_use(player):
	player.health += 10
	.i_use(player)
