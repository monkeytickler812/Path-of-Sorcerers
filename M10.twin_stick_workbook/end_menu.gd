extends PanelContainer


@export_group("Confettis", "confettis_")
@export var confettis_amount := 5
@export var confettis_pop_time_delay := 0.5

var _start_time := Time.get_ticks_msec()

@onready var _time_label: Label = %TimeLabel
@onready var _end_menu: PanelContainer = %EndMenu

func animate_progress(amount := 0.0) -> void:
	_end_menu.modulate.a = amount

func open() -> void:
	visible = true
	get_tree().paused = true

	var end_time := Time.get_ticks_msec()
	var total_time_msec := end_time - _start_time
	var total_time_s := snappedf(total_time_msec / 1000.0, 0.1)
	_time_label.text = "Time: " + str(total_time_s) + "s"
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(animate_progress, 0.0, 1.0, 0.5)

	pop_confettis()


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene() 

func _on_button_2_pressed() -> void:
	get_tree().quit()

func pop_confettis() -> void:
	var viewport_size := get_viewport_rect().size
	for _i in confettis_amount:
		await get_tree().create_timer(confettis_pop_time_delay).timeout

		var confettis: GPUParticles2D = preload("confettis.tscn").instantiate()
		add_child(confettis)

		confettis.global_position = Vector2(
			randf_range(0.0, viewport_size.x),
			viewport_size.y
		)
		confettis.emitting = true
