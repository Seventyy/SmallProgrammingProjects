extends Node

signal room_difficulty_updated(new_difficulty:int)

signal player_skill_updated(instance_id:int, new_skill:int)
signal player_age_updated(instance_id:int, new_age:int)

signal player_deleted(instance_id:int)
