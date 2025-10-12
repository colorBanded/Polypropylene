extends Control
@onready var info: Label = $"../Control/Label"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var intro: ColorRect = $"../intro"
@onready var mus: AudioStreamPlayer = $"../mus"
@onready var serious: Button = $"../VBoxContainer/serious"
@onready var unserious: Button = $"../VBoxContainer/unserious"
@onready var label_2: Label = $"../Control/Label2"
var animation_time: float = 0.0
var animation_duration: float = 4.0  
var shake_intensity: float = 2.0  
var idle_shake_intensity: float = 0.5  
var animation_complete: bool = false
var animation_started: bool = false
var delay_time: float = 0.0
var delay_duration: float = 5.5
var center_position: Vector2
var idle_shake_time: float = 0.0

func _ready() -> void:
	animation_player.play("question_intro")
	await animation_player.animation_finished
	mus.play()
	intro.hide()

	info.pivot_offset = info.size / 2  
	info.scale = Vector2(0.3, 0.3)  

	var parent_size = info.get_parent().size
	center_position = Vector2(
		(parent_size.x - info.size.x) / 2,
		(parent_size.y - info.size.y) / 2  
	)
	info.position = center_position
	serious.mouse_entered.connect(_on_serious_hover)
	serious.mouse_exited.connect(_on_button_exit)
	unserious.mouse_entered.connect(_on_unserious_hover)
	unserious.mouse_exited.connect(_on_button_exit)
	label_2.text = "This will alter the course of the game."

func _process(delta: float) -> void:
	if not animation_started:
		delay_time += delta
		if delay_time >= delay_duration:
			animation_started = true
		return

	if not animation_complete:
		animation_time += delta
		var progress = clamp(animation_time / animation_duration, 0.0, 1.0)
		var eased_progress = 1.0 - pow(1.0 - progress, 3.0)
		var current_scale = lerp(0.3, 1.0, eased_progress)  
		info.scale = Vector2(current_scale, current_scale)
		var shake_x = randf_range(-shake_intensity, shake_intensity) * (1.0 - eased_progress)
		var shake_y = randf_range(-shake_intensity, shake_intensity) * (1.0 - eased_progress)
		info.position = center_position + Vector2(shake_x, shake_y)
		if progress >= 1.0:
			animation_complete = true
			info.scale = Vector2.ONE
			info.position = center_position  
	else:
		idle_shake_time += delta
		var shake_x = sin(idle_shake_time * 15.0) * idle_shake_intensity + randf_range(-0.2, 0.2)
		var shake_y = cos(idle_shake_time * 12.0) * idle_shake_intensity + randf_range(-0.2, 0.2)
		info.position = center_position + Vector2(shake_x, shake_y)

func _on_serious_hover() -> void:
	label_2.text = "Heads"
	# label_2.text = "Much to be done."

func _on_unserious_hover() -> void:
	label_2.text = "Tails"
	# label_2.text = "Probably really low quality but I'm having a lot of fun with this"

func _on_button_exit() -> void:
	label_2.text = "This will alter the course of the game."
	# label_2.text = "This will alter the course of the game."
	

func _on_serious_pressed() -> void:
	Global.pim = 1
	get_tree().change_scene_to_file("res://scenes/tale_3.tscn")


func _on_unserious_pressed() -> void:
	Global.pim = 0
	get_tree().change_scene_to_file("res://scenes/tale_3.tscn")
