class_name RoomResource extends Resource

@export var name:StringName #room name
@export var steps_min:int #minimum amount of steps requierd to complete the puzzle(/ entire room)
@export var steps_max:int #minimum amount of steps requierd to complete the puzzle(/ entire room)
@export var duration:int #minimum amount of steps requierd to complete the puzzle(/ entire room)
#@export var #total number of steps requierd to complete the puzzle

func _init(_name = "", _steps_min = 0, _steps_max = 0, _duration = 0):
	name = _name
	steps_min = _steps_min
	steps_max = _steps_max 
	duration = _duration
