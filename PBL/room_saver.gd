class_name RoomSaver extends Node

var rooms:Array[RoomResource]

@onready var room_save:Button = $RoomSave
@onready var room_load:Button = $RoomLoad

func _ready() -> void:
	room_save.pressed.connect(on_room_save)
	room_load.pressed.connect(on_room_load)

func on_room_save() -> void:
	pass

func on_room_load() -> void:
	pass
