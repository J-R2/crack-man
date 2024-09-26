class_name Enemy
extends PathFollow2D

@export var speed :float = 100.0  ## The enemy's speed
## The size of the viewport
@onready var screen_size = get_viewport_rect().size
## The area that can kill the player if touched
@onready var kill_box: KillBox = $KillBox
var player :Player
var starting_progress_ratio :float = 0.0
@onready var path = get_parent()
var tween :Tween

func _ready() -> void:
	var timer: Timer = $StartTimer
	timer.timeout.connect(timer.queue_free)
	await timer.timeout  # the enemies should pause for 1 second after the level starts before advancing
	starting_progress_ratio = progress_ratio
	advance()
	player = get_tree().get_first_node_in_group("player")
	player.player_hit.connect(_on_player_hit)

func _physics_process(delta: float) -> void:
	# If the enemy leaves the screen bounds, make sure it can't hurt the player (just in case)
	var is_out_of_bounds = (
		position.x < 0 or
		position.y < 0 or
		position.x > screen_size.x or
		position.y > screen_size.y
	)
	kill_box.get_child(0).disabled = is_out_of_bounds
	



func _on_player_hit() -> void :
	tween.kill()
	self.progress_ratio = starting_progress_ratio
	var timer = Timer.new()
	timer.wait_time = 1.0
	add_child(timer)
	timer.start()
	timer.timeout.connect(timer.queue_free)
	await timer.timeout
	advance()



## Start tweening the enemy along the parent path.
func advance() -> void :
	# Get the length of the path and divide by the speed so all enemies move at the same pace.
	var duration :float = (path as Path2D).get_curve().get_baked_length() / speed
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	# Tween the progress_ratio to 1 over the duration time
	# Take the enemies starting progress ratio into account (- (duration*self.progress_ratio))
	tween.tween_property(self, "progress_ratio", 1, duration - (duration * self.progress_ratio))
	# Reset the progress and advance again on tween finished
	tween.finished.connect(func()->void: progress_ratio = 0; advance())
