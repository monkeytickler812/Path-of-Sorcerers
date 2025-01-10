extends CharacterBody2D

const GODOT_BOTTOM = preload("res://player/godot_bottom.png")
const GODOT_BOTTOM_RIGHT = preload("res://player/godot_bottom_right.png")
const GODOT_RIGHT = preload("res://player/godot_right.png")
const GODOT_UP = preload("res://player/godot_up.png")
const GODOT_UP_RIGHT = preload("res://player/godot_up_right.png")
const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const UP_LEFT = Vector2.UP + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT

@export var SPEED = 300.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
const JUMP_VELOCITY = -400.0

@onready var _skin: Sprite2D = %Skin

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

	var direction_discrete := direction.sign()
	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			_skin.texture = GODOT_BOTTOM
		Vector2.UP:
			_skin.texture = GODOT_BOTTOM_RIGHT
		Vector2.DOWN:
			_skin.texture = GODOT_RIGHT
		UP_RIGHT, UP_LEFT:
			_skin.texture = GODOT_UP
		DOWN_RIGHT, DOWN_LEFT:
			_skin.texture = GODOT_UP_RIGHT

	if direction_discrete.length() > 0:
		_skin.flip_h = direction.x < 0.0

	move_and_slide()
