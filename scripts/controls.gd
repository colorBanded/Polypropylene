extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var start_button: Button = $start

func _ready() -> void:
	animation_player.play("musFade")
	start_button.add_theme_color_override("font_color", Color.BLACK)

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_method(_update_font_color, Color.BLACK, Color.WHITE, 5.0)

func _process(delta: float) -> void:
	pass

func _update_font_color(color: Color) -> void:
	start_button.add_theme_color_override("font_color", color)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro_scene.tscn")
