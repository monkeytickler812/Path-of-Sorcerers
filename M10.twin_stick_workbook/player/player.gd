class_name Player extends CharacterBody2D

@export var speed := 400
@export var acceleration := 3.0
@export var drag_factor := 12.0

const SPRITE_RIGHT := preload("res://player/godot_right.png")
const SPRITE_DOWN := preload("res://player/godot_bottom.png")
const SPRITE_UP := preload("res://player/godot_up.png")
const SPRITE_DOWN_RIGHT := preload("res://player/godot_bottom_right.png")
const SPRITE_UP_RIGHT := preload("res://player/godot_up_right.png")
const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const UP_LEFT = Vector2.UP + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT

@onready var _skin: Sprite2D = %Skin

func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("left", "right", "up", "down")
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * drag_factor * delta
	var direction_discrete := move_direction.sign()
	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			_skin.texture = SPRITE_RIGHT
		Vector2.UP:
			_skin.texture = SPRITE_UP
		Vector2.DOWN:
			_skin.texture = SPRITE_DOWN
		UP_RIGHT, UP_LEFT:
			_skin.texture = SPRITE_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			_skin.texture = SPRITE_DOWN_RIGHT
	if direction_discrete.length() > 0:
		_skin.flip_h = direction_discrete.x < 0.0
	move_and_slide()
