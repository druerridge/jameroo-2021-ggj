extends IItem


func _init():
	self.i_name = "Shovel"
	self.i_image = load("res://Sprites/defaultunused.png")
	self.i_description = "This is a shovel"
	self.i_stackable = false
	self.i_consumable = false

func i_use(player):
	.i_use(player)
