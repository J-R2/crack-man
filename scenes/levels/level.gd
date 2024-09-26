class_name Level
extends Node2D

## Emitted once all drugs are consumed.
signal level_finished
## Used in main_menu to show the eplay game message
@export var is_final_level :bool = false


## The position that the player is set to once the level is loaded.
@onready var start_position : Vector2 = $StartPosition.position
## The amount of drugs that start on the map.
@onready var drug_count :int = $Drugs.get_children().size()
## The amount of drugs that have been removed from the map.  Once consumed_amount == drug_count emit level_finished
var consumed_amount :int = 0

## The next level scene, can be empty if final level.
@export var next_level :PackedScene



func _ready() -> void:
	# Add level to the level group.
	add_to_group("level")
	$Drugs.show()
	# Connect the consumed signal if the child is a drug.
	for drug in $Drugs.get_children():
		if drug is Cocaine:
			drug.consumed.connect(_on_drug_consumed)


## Increase the consumed amount and end the level if the consumed == level start drug_count
func _on_drug_consumed() -> void :
	consumed_amount += 1
	if consumed_amount == drug_count:
		level_finished.emit()














