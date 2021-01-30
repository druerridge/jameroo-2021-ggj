extends IItem


func _init():
	self.i_name = "Key"
	self.i_image = load("res://Inventory/Items/Staff.png")
	self.i_description = "You need these to beat the game!"
	self.i_stackable = false
	print(self.i_image)


func i_use(player):
	player.health -= 10
	.i_use(player)
