extends Area2D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var player: CharacterBody2D = $"../talePC/CharacterBody2D"
const NEXT_SCENE = "res://scenes/tale_2.tscn"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_transitioning = false

func _ready():
	await get_tree().process_frame
	anim_player.play_backwards("fadeOut")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if is_transitioning:
		return
	if body == player:
		transition_to_next_scene()

func transition_to_next_scene():
	is_transitioning = true
	player.set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	anim_player.play("fadeOut")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(NEXT_SCENE)
