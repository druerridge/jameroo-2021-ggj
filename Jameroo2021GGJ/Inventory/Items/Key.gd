extends IItem


func _init(color):
	self.i_name = "Key"
	self.i_image = load("res://Sprites/Items/gem.png")
	self.i_description = "You need these to beat the game!"
	self.i_stackable = false
	self.i_consumable = true
	self.i_color = color

func i_use(player):
	.i_use(player)
