class_name Mob extends CharacterBody2D

@export var health := 3
@export var SPEED := 600.0
@export var acceleration := 450.0
@export var drag_factor := 1.5
@onready var _detection: Area2D = %Detection
@onready var _hit_box: Area2D = %HitBox
@onready var _damage_timer: Timer = %DamageTimer

var _player: Player = null

func _ready() -> void:
	const damage = 1.0
	_detection.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	_detection.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)
	_hit_box.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.health -= damage
			_damage_timer.start()
	)
	_hit_box.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_damage_timer.stop()
	)
	_damage_timer.timeout.connect(func () -> void:
		_player.health -= damage
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
	return get_tree().root.get_node("Game/Player").global_position

func take_damage():
	health -= 1
	if health == 0:
		queue_free()
