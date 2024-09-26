extends Node2D

@onready var player: Player = $Player
@onready var level: Node2D = $Level

func _ready() -> void:
	player.position = level.start_position
	player.rotation = Vector2.UP.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
