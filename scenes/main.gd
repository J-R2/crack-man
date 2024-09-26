# main.gd
extends Node2D

## The player will remain persistent through each level.
@onready var player: Player = $Player
## Keeps track of the level node
var level :Level

func _ready() -> void:
	_initialize_level()


## Frees the current level and loads the next one into the scene tree, then initializes the next level
func _on_level_finished() -> void :
	player.position = Vector2(-100, -100) # Move the player while the level is changing.
	if level.next_level != null: # Ensure there is a next level to load.
		var next_level_scene = level.next_level.instantiate()
		level.queue_free() # Free the current level
		call_deferred("add_child", next_level_scene) # Add the next level to the scene when able.
		await get_tree().process_frame # Wait to ensure the next level is fully loaded.
		call_deferred("_initialize_level") # Initialize the level once it is on the scene tree.


## Sets the level variable, moves the player to the level's start position marker and resets player rotation.
func _initialize_level() -> void :
	level = get_tree().get_first_node_in_group("level") # Get the current level node.
	level.level_finished.connect(_on_level_finished) # Connect the signal to change levels
	player.position = level.start_position # Reset the player position to the level's start marker
	player.rotation = Vector2.UP.angle() # Reset the player rotation.
		
	
	
