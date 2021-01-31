extends TileMap

enum CELL_TYPES {EMPTY = -1, ACTOR, OBJECT, DIGGABLE}

var children
var stale_children = false
var rng = RandomNumberGenerator.new()
var origin_room_data
var room_data

const marking_template = preload("res://Scenes/Objects/Marking.tscn")

func _ready():
	rng.randomize()
	process_actor_spawn_conditions()
	refresh_children()
	randomize_diggable_positions()

func unspawn_marking(world_pos:Vector2):
	var dig_pos = world_to_dig(world_pos)
	var map_pos = world_to_map(world_pos)
	if (!valid_dig_pos(dig_pos)):
		return
	var existing_marking = get_overworld_marking(map_pos)
	if (existing_marking != null):
		remove_child(existing_marking)
	var cell = origin_room_data.room.grid[dig_pos.x][dig_pos.y]
	cell.marking.color = "nocolor"
	cell.marking.shape = "noshape"

func spawn_marking(color, shape, world_pos:Vector2):
	var dig_pos = world_to_dig(world_pos)
	var map_pos = world_to_map(world_pos)
	if (!valid_dig_pos(dig_pos)):
		return
	if (color == "nocolor" and shape == "noshape"):
		return
	var existing_marking = get_overworld_marking(map_pos)
	if (existing_marking != null):
		remove_child(existing_marking)
	var marking = marking_template.instance()
	marking.color = color
	marking.shape = shape
	marking.position = world_pos
	add_child(marking)
	refresh_children()
	var cell = origin_room_data.room.grid[dig_pos.x][dig_pos.y]
	cell.marking.color = color
	cell.marking.shape = shape

func spawn_marking_dig(color, shape, dig_pos:Vector2):
	var world_pos = dig_to_world(dig_pos)
	spawn_marking(color, shape, world_pos)

func _process(delta):
	check_if_won()

# Make sure to call this when necessary
# We don't want to be getting children everytime an actor tries to move.
func refresh_children():
	children = get_children()

func get_overworld_marking(map_pos):
	for node in children:
		# Protects against certain situations where an object is queued to be
		# freed
		if !is_instance_valid(node):
			stale_children = true
			continue
		else:
			if (node.get("is_marking")):
				var node_map_pos = world_to_map(node.position)
				if (node_map_pos == map_pos):
					return(node)
	if stale_children:
		stale_children = false
		refresh_children()

# Iterate through EVERY object in the overworld and find the right one
# Could probably be done better
func get_overworld_obj(coordinates):
	for node in children:
		# Protects against certain situations where an object is queued to be
		# freed
		if !is_instance_valid(node):
			stale_children = true
			continue
		else:
			if world_to_map(node.position) == coordinates && node.obj_type == CELL_TYPES.DIGGABLE:
				return(node)
	if stale_children:
		stale_children = false
		refresh_children()

func request_interaction(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_obj = get_overworld_obj(cell_target)
	if !cell_obj:
		return
	cell_obj.connect("interact", requesting_object, "_on_item_interacted")
	refresh_children()
	cell_obj.interact()


func request_move(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_target_type = get_cellv(cell_target)
	if cell_target_type == CELL_TYPES.EMPTY:
		var cell_obj = get_overworld_obj(cell_target)
		return update_overworld_obj_position(requesting_object,
				cell_start, cell_target)

func update_overworld_obj_position(requesting_object, cell_start, cell_target):
	# The cell the moving object was in is now free
	set_cellv(cell_start, CELL_TYPES.EMPTY)

	# Divide by 2 because location 0,0 starts from the top left of the cell
	# and we want the object to be "in the middle" of the grid cell
	return map_to_world(cell_target) + cell_size / 2


# removes an object from children array. The object should queue_free itself,
# but we want the overworld to immediately know this cell is no longer occupied
func remove_from_active(obj):
	children.erase(obj)
	
func check_if_won():
	if get_tree().get_nodes_in_group("Key").size() <= 0:
		#root.remove_child()
		pass

func randomize_diggable_positions():
	var diggableObjects = get_tree().get_nodes_in_group("Diggable")
	for obj in diggableObjects:
		var desiredGridPosition = Vector2(rng.randi_range(0, cell_size.x), rng.randi_range(0, cell_size.y))
		var generatedPosition = map_to_world(desiredGridPosition) + cell_size / 2
		obj.position = generatedPosition

# By default design, all potential actors are on scene, and those that do not
# meet their conditions to be present are removed
func process_actor_spawn_conditions():
	for obj in get_children():
		if !obj.spawn_condition():
			obj.call_deferred("free")

func dig_to_map(dig_grid_position: Vector2):
	var dig_grid_origin_map_pos = Vector2(4, 4)
	return dig_grid_position + dig_grid_origin_map_pos

func map_to_dig(map_grid_position: Vector2):
	var dig_grid_origin = Vector2(4, 4)
	return map_grid_position - dig_grid_origin

func dig_to_world(dig_grid_position: Vector2):
	var map_grid_position = dig_to_map(dig_grid_position)
	return map_to_world(map_grid_position) + cell_size / 2

func world_to_dig(world_pos: Vector2):
	var map_pos = world_to_map(world_pos)
	return map_to_dig(map_pos)

func load_markings(in_room_data):
	for x_index in range(0, in_room_data.room.grid.size()):
		for y_index in range(0, in_room_data.room.grid[x_index].size()):
			var cell = in_room_data.room.grid[x_index][y_index]
			var dig_grid_position = Vector2(y_index, x_index)
			spawn_marking_dig(cell.marking.color, cell.marking.shape, dig_grid_position)

func valid_dig_pos(dig_pos:Vector2):
	return dig_pos.x >= 0 && dig_pos.y >= 0 && dig_pos.x < room_data.room.grid.size() && dig_pos.y < room_data.room.grid[0].size()

func attempt_dig(player):
	var map_pos = world_to_map(player.position)
#	print("Digging at map_pos: " + str(player.position))
	var dig_pos = map_to_dig(map_pos)
	print("Digging at dig_pos: " + str(dig_pos))
	if (!valid_dig_pos(dig_pos)):
		print("invalid dig position")
		return
	var cell = room_data.room.grid[dig_pos.x][dig_pos.y]
	var color = player.CELL_COLORS.keys()[player.obj_color].to_lower()
	print(cell.digResultByColor[color])
	var item = cell.digResultByColor[color].items.pop_back()
	if (item != null):
		var item_name = item.name
		print("Found item: " + item_name)
		var loadedItem = load("res://Scenes/Objects/" + item_name + ".tscn")
		if !loadedItem:
			return
		var newItem = loadedItem.instance()
		newItem.position = player.position
		newItem.init(item.color)
		add_child(newItem)
		refresh_children()
		return newItem
	else:
		print("no items found")

func get_grid_data_with_color(requesting_object, digResult):
	if requesting_object.obj_color == requesting_object.CELL_COLORS.YELLOW:
		return digResult.yellow
	if requesting_object.obj_color == requesting_object.CELL_COLORS.BLUE:
		return digResult.color2
	if requesting_object.obj_color == requesting_object.CELL_COLORS.PURPLE:
		return digResult.purple

func load_room(in_room_data):
	origin_room_data = in_room_data;
	room_data = origin_room_data.duplicate()
	load_markings(in_room_data)

func _on_BackendControl_room_data_loaded(room_data):
	load_room(room_data)
