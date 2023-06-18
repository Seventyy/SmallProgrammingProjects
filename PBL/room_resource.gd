class_name RoomResource extends Resource

@export var name:StringName
@export var steps_min:int 
@export var steps_max:int 
@export var duration:int


func _init(_name = "New Room", _steps_min = 0, _steps_max = 0, _duration = 0):
	name = _name
	steps_min = _steps_min
	steps_max = _steps_max 
	duration = _duration
