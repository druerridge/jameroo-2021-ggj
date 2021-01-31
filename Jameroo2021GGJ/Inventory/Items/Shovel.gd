extends IItem


func _init(color):
	self.i_name = "Shovel"
	self.i_image = load("res://Sprites/defaultunused.png")
	self.i_description = "This is a "+color+ "shovel"
	self.i_stackable = false
	self.i_consumable = false
	self.i_color = color

func i_use(player):
	.i_use(player)
