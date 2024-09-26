# main.gd
extends Node2D

@onready var player: Player = $Player
var level :Level

func _ready() -> void:
	_initialize_level()




func _on_level_finished() -> void :
	player.position = Vector2(-100, -100)
	if level.next_level != null:
		var next_level_scene = level.next_level.instantiate()
		level.queue_free()
		call_deferred("add_child", next_level_scene)
		await get_tree().process_frame
		call_deferred("_initialize_level")


func _initialize_level() -> void :
	level = get_tree().get_first_node_in_group("level")
	level.level_finished.connect(_on_level_finished)
	player.position = level.start_position
	player.rotation = Vector2.UP.angle()
		
	
	
