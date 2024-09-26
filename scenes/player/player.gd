class_name Player
extends CharacterBody2D

const SPEED :int = 200
const STEERING_FORCE :int = 8
const SPRITE_SIZE :int = 90 / 2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var screen_size = get_viewport_rect().size
var direction := Vector2.ZERO


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	#direction.x = Input.get_axis("move_left", "move_right")
	#direction.y = Input.get_axis("move_up", "move_down")
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	var desired_velocity :Vector2 = direction * SPEED
	var steering_vector :Vector2 = desired_velocity - velocity
	velocity += steering_vector * STEERING_FORCE * delta
	if desired_velocity.length() > 0.1:
		rotation = velocity.angle()
		animated_sprite_2d.play("move")
	else: animated_sprite_2d.stop()
	move_and_slide()
	position.x = wrapf(position.x, -SPRITE_SIZE, screen_size.x + SPRITE_SIZE)
	position.y = wrapf(position.y, -SPRITE_SIZE, screen_size.y + SPRITE_SIZE)
