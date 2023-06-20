extends OptionButton

const filepath:String = "res://rooms.tres"
var rooms_resource:RoomsResource = preload(filepath)


@onready var room_name_edit:LineEdit = %RoomNameEdit
@onready var min_steps_edit:SpinBox = %MinStepsEdit
@onready var max_steps_edit:SpinBox = %MaxStepsEdit
@onready var duration_edit:SpinBox = %DurationEdit


func _ready() -> void:
	item_selected.connect(on_item_selected)

func on_item_selected(index:int) -> void:
#	GlobalSignals.room_difficulty_updated.emit( # OLD ????
#		get_item_id(index))  
	
	room_name_edit.text = rooms_resource.rooms[selected].name
	min_steps_edit.value = rooms_resource.rooms[selected].steps_min
	max_steps_edit.value = rooms_resource.rooms[selected].steps_max
	duration_edit.value = rooms_resource.rooms[selected].duration

func save_resource():
	ResourceSaver.save(rooms_resource, filepath)

func _on_room_add_pressed() -> void:
	var new_room:RoomResource = RoomResource.new()
	rooms_resource.rooms.append(new_room)
	add_item(new_room.name, 0)
	save_resource()
	select(item_count - 1)

func _on_room_delete_pressed() -> void:
	remove_item(selected)
	rooms_resource.rooms.pop_at(selected)
	save_resource()


func _on_room_name_edit_text_changed(new_text: String) -> void:
	set_item_text(selected, new_text)
	rooms_resource.rooms[selected].name = new_text
	save_resource()

func _on_min_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_min = value
	save_resource()

func _on_max_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_max = value
	save_resource()

func _on_duration_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].duration = value
	save_resource()
