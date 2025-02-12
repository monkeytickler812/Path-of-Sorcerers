extends Node2D


@onready var _teleporter: Area2D = %Teleporter
@onready var _end_menu: PanelContainer = %EndMenu

func _ready() -> void:
	_teleporter.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_end_menu.open()
	)
