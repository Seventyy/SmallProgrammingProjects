extends OptionButton

const filepath:String = "res://rooms.tres"
var rooms_resource:RoomsResource = preload(filepath)

@onready var room_name_edit: LineEdit = $"../../RoomNameEdit"


func _ready() -> void:
	item_selected.connect(on_item_selected)
	
	refreash_items()


func on_item_selected(index:int) -> void:
	GlobalSignals.room_difficulty_updated.emit( # OLD ????
		get_item_id(index))  
	
	room_name_edit.text = rooms_resource.rooms[selected].name

func refreash_items():
	while item_count > 0:
		remove_item(0)
	
	for room in rooms_resource.rooms:
		add_item(room.name, 0)

func _on_room_add_pressed() -> void:
	rooms_resource.rooms.append(RoomResource.new())
	refreash_items()
	ResourceSaver.save(rooms_resource, filepath)
	selected = item_count - 1

func _on_room_delete_pressed() -> void:
	rooms_resource.rooms.pop_at(selected)
	refreash_items()
	ResourceSaver.save(rooms_resource, filepath)

func _on_room_name_edit_text_submitted(new_text: String) -> void:
	rooms_resource.rooms[selected].name = new_text
	refreash_items()
	ResourceSaver.save(rooms_resource, filepath)
