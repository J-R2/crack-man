class_name Cocaine
extends Area2D

# Emitted once the cocaine is consumed by the player's CrackBox area2d
signal consumed
# to ensure the signal is only emitted once
var is_consumed :bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Change is_consumed to true, emit the consumed signal, and free the cocaine if it was touched by the player's CrackBox.
func _on_area_entered(area :Area2D) -> void :
	if area is CrackBox:
		if !is_consumed:
			is_consumed = true
			consumed.emit()
			queue_free()
