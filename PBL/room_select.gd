extends OptionButton

const filepath:String = "res://rooms.tres"
var rooms_resource:RoomsResource = preload(filepath)

@onready var room_name_edit:LineEdit = %RoomNameEdit
@onready var min_steps_edit:SpinBox = %MinStepsEdit
@onready var max_steps_edit:SpinBox = %MaxStepsEdit
@onready var duration_edit:SpinBox = %DurationEdit

func _ready() -> void:
	item_selected.connect(on_item_selected)
	load_resource()
	update()
	on_item_selected(selected)

func on_item_selected(index:int) -> void:
	room_name_edit.text = rooms_resource.rooms[selected].name
	min_steps_edit.value = rooms_resource.rooms[selected].steps_min
	max_steps_edit.value = rooms_resource.rooms[selected].steps_max
	duration_edit.value = rooms_resource.rooms[selected].duration

func load_resource() -> void:
	for room in rooms_resource.rooms:
		add_item(room.name, 0)

func update() -> void:
	ResourceSaver.save(rooms_resource, filepath)
	calculate_difficuly()

func _on_room_add_pressed() -> void:
	var new_room:RoomResource = RoomResource.new()
	rooms_resource.rooms.append(new_room)
	add_item(new_room.name, 0)
	select(item_count - 1)
	update()
	on_item_selected(selected)

func _on_room_delete_pressed() -> void:
	var prev_selected = selected
	remove_item(selected)
	rooms_resource.rooms.pop_at(selected)
	if prev_selected - 1 >= 0:
		select(prev_selected - 1)
	else:
		select(item_count - 1)
	update()
	on_item_selected(selected)


func _on_room_name_edit_text_changed(new_text: String) -> void:
	set_item_text(selected, new_text)
	rooms_resource.rooms[selected].name = new_text
	update()

func _on_min_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_min = value
	update()

func _on_max_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_max = value
	update()

func _on_duration_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].duration = value
	update()


func calculate_difficuly() -> void:
	var difficulty_score:float = (
		rooms_resource.rooms[selected].duration *
		rooms_resource.rooms[selected].steps_max *
		abs(rooms_resource.rooms[selected].steps_max -
		rooms_resource.rooms[selected].steps_min + 1)
	)
	
	var id:int
	if difficulty_score < 5_000:
		id = 250
	elif difficulty_score < 10_000:
		id = 375
	else:
		id = 500
	
	set_item_id(selected, id)
	GlobalSignals.room_difficulty_updated.emit(id)
