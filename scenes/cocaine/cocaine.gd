class_name Cocaine
extends Area2D


signal consumed
var is_consumed :bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area :Area2D) -> void :
	if area is CrackBox:
		if !is_consumed:
			is_consumed = true
			consumed.emit()
			queue_free()
