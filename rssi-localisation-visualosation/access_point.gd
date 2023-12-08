@tool
class_name AccessPoint extends Node2D

@onready var handle: Node2D = $Handle

@export var calculator:Node2D

@export var strength:float:
	set(val):
		strength = val
		queue_redraw()
		calculator.queue_redraw()

func _draw() -> void:
	draw_arc(Vector2.ZERO, strength, 0, TAU, 48, Color.WHITE)

func _ready() -> void:
	set_notify_transform(true)
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		calculator.queue_redraw()
