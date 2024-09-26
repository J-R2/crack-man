class_name Level
extends Node2D

signal level_finished

## The position that the player is set to once the level is loaded.
@onready var start_position : Vector2 = $StartPosition.position
@onready var drug_count :int = $Drugs.get_children().size()
var consumed_amount :int = 0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

@export var next_level :PackedScene


func _ready() -> void:
	add_to_group("level")
	timer.timeout.connect(audio_stream_player.stop)
	for drug in $Drugs.get_children():
		if drug is Cocaine:
			drug.consumed.connect(_on_drug_consumed)

func _on_drug_consumed() -> void :
	consumed_amount += 1
	if consumed_amount == drug_count:
		level_finished.emit()
