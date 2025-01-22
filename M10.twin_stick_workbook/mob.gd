class_name Mob extends CharacterBody2D


@export var SPEED := 600.0
@export var acceleration := 450.0
@export var drag_factor := 1.5
var _player: Player = null
@onready var _detection: Area2D = %Detection

func _ready() -> void:
	_detection.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	_detection.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)

func _physics_process(delta: float) -> void:
	if _player == null:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		var direction := global_position.direction_to(get_global_player_position())
		var distance := global_position.distance_to(get_global_player_position())
		var speed := SPEED if distance > 110.0 else SPEED * distance / 110.0

		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		move_and_slide()

func get_global_player_position() -> Vector2:
	return get_tree().root.get_node("Test/Player").global_position
