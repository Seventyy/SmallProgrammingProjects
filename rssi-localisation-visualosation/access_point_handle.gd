@tool
extends Node2D

@onready var access_point: AccessPoint = owner

func _ready() -> void:
	set_notify_local_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_LOCAL_TRANSFORM_CHANGED:
		access_point.radius = position.length()
