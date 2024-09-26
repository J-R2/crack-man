class_name Enemy
extends PathFollow2D

@export var speed :float = 100.0

@onready var screen_size = get_viewport_rect().size
@onready var kill_box: KillBox = $KillBox


func _ready() -> void:
	advance()


func _physics_process(delta: float) -> void:
	var is_out_of_bounds = (
		position.x < 0 or
		position.y < 0 or
		position.x > screen_size.x or
		position.y > screen_size.y
	)
	kill_box.get_child(0).disabled = is_out_of_bounds

func advance() -> void :
	var path = self.get_parent()
	var duration :float = (path as Path2D).get_curve().get_baked_length() / speed
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "progress_ratio", 1, duration - (duration * self.progress_ratio))
	tween.finished.connect(func()->void: progress_ratio = 0; advance())
