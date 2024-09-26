class_name Player
extends CharacterBody2D

const SPEED :int = 250 ## The player's speed.
const STEERING_FORCE :int = 15 ## The player sprites steering force.
const SPRITE_SIZE :int = 90 / 2 ## The size of the sprite, used to make a clean warp to the other side of the screen.

signal player_hit ## emitted every time the player touches a ghost
@onready var lives_label: Label = $LivesLabel ## The lives_count display
var lives_count = 3 ## The number of lives the player has, if 0, the game restarts

## The player sprite.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
## The size of the viewport.
@onready var screen_size = get_viewport_rect().size
## The user input direction vector.
var direction := Vector2.ZERO
## Detects if ghosts hit the player
@onready var hit_box: Area2D = $HitBox
@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer




func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_entered)


func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") # Get the direction, controller input added to input map.
	direction = direction.normalized() # set the direction vector's length to 1
	var desired_velocity :Vector2 = direction * SPEED # the desired velocity, based on input and speed
	var steering_vector :Vector2 = desired_velocity - velocity # difference of the desired velocity vector and current velocity vector
	velocity += steering_vector * STEERING_FORCE * delta # alter current velocity vector's course by the steering vector * STEERING_FORCE
	if desired_velocity.length() > 0.1: # While there is desired movement
		rotation = velocity.angle() # rotate towards the velocity
		animated_sprite_2d.play("move") # play the movement animation
	else: animated_sprite_2d.stop() # stop the animation when the desired velocity is ZERO
	move_and_slide() # the  motion mode is set to floating in inspector for top down movement
	# Warp the player if they enter the warp zones (the only areas not boxed in on a level)
	position.x = wrapf(position.x, -SPRITE_SIZE, screen_size.x + SPRITE_SIZE)
	position.y = wrapf(position.y, -SPRITE_SIZE, screen_size.y + SPRITE_SIZE)


## Logic for if a ghost hits the player
func _on_hit_box_entered(area :Area2D) -> void:
	if area is KillBox:
		if hit_audio_player.playing == false: hit_audio_player.play()
		player_hit.emit()
		lives_count -= 1
		if lives_count == 2:
			lives_label.text = "I I"
		if lives_count == 1:
			lives_label.text = "I"
		if lives_count == 0:
			lives_label.text = "Dead"
			await hit_audio_player.finished
			get_tree().reload_current_scene()
			




