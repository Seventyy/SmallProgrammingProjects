extends Node2D

@export var size:Vector2
@export var tiles:Array

var rng := RandomNumberGenerator.new()
var tile_size:int = 64;
var map:Array

var tile_variant:int
var tile_instance:Sprite2D

func _ready() -> void:

	initiate()
	collapse(int(size.x/2), int(size.y/2))
	#collapse(8, 5)
	#filnalize()

func initiate() -> void:
	var column:Array
	var cell:Array
	for i in 17:
		cell.append(i)
	for y in size.y:
		column.append(cell.duplicate(true))
	for x in size.x:
		map.append(column.duplicate(true))

	rng.randomize()

	# var tile_variant:int = rng.randi_range(0,15)
	# map[int(size.x/2)][int(size.y/2)] = tiles[tile_variant].instance() 

func propagate(x:int, y:int) -> void:
	

	if x+1 < size.x and map[x+1][y] == null:
		propagate(x+1, y)
	if y+1 < size.y and map[x][y+1] == null:
		propagate(x, y+1)
	if x-1 >= 0 and map[x-1][y] == null:
		propagate(x-1, y)
	if y-1 >= 0 and map[x][y-1] == null:
		propagate(x, y-1)

func collapse(x:int, y:int) -> void:

	

	# to chyba jebnie, jednak chyba nie ale może, teraz już nie powinno ale nadal jest szansa na szympansa
	if x+1 < size.x and map[x+1][y] == null:
		collapse(x+1, y)
	if y+1 < size.y and map[x][y+1] == null:
		collapse(x, y+1)
	if x-1 >= 0 and map[x-1][y] == null:
		collapse(x-1, y)
	if y-1 >= 0 and map[x][y-1] == null:
		collapse(x, y-1)

#stupid ass code:

# func filnalize() -> void:
# 	for x in size.x:
# 		for y in size.y:
# 			if map[x][y] == null:
# 				continue
# 			map[x][y].position = Vector2(x*tile_size, y*tile_size)
# 			add_child(map[x][y])


# var tiles_copy = tiles.duplicate()
# while true:
# 	if tiles_copy.empty():
# 		map[x][y] = tiles[16].instance()
# 		break
# 	tiles_copy.shuffle()
# 	tile_instance = tiles_copy.pop_at(rng.randi_range(0, tiles_copy.size()-1)).instance() 
# 	if	(
# 			(x+1 < size.x and map[x+1][y] == null) or \
# 			(tile_instance.grass_right and x+1 < size.x and map[x+1][y].air) or \
# 			(!tile_instance.grass_right and x+1 < size.x and !map[x+1][y].grass_left)
# 		) \
# 		and \
# 		(
# 			(y+1 < size.y and map[x][y+1] == null) or \
# 			(tile_instance.grass_down and y+1 < size.y and map[x][y+1].air) or \
# 			(!tile_instance.grass_down and y+1 < size.y and !map[x][y+1].grass_up) 
# 		) \
# 		and \
# 		(
# 			(x-1 >= 0 and map[x-1][y] == null) or \
# 			(tile_instance.grass_left and x-1 >= 0 and map[x-1][y].air) or \
# 			(!tile_instance.grass_left and x-1 >= 0 and !map[x-1][y].grass_right) 
# 		) \
# 		and \
# 		(
# 			(y-1 >= 0 and map[x][y-1] == null) or \
# 			(tile_instance.grass_up and y-1 >= 0 and map[x][y-1].air) or \
# 			(!tile_instance.grass_up and y-1 >= 0 and !map[x][y-1].grass_down)
# 		):
