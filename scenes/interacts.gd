extends Area2D
@onready var collision_shape_2d: CollisionShape2D = get_node("CollisionShape2D")
@onready var collision_shape_2d_2: CollisionShape2D = get_node("CollisionShape2D2")
@onready var collision_shape_2d_3: CollisionShape2D = get_node("CollisionShape2D3")
@onready var character_body_2d: CharacterBody2D = get_node("../talePC/CharacterBody2D")

var has_triggered_first := false
var has_triggered_second := false
var has_triggered_third := false
var is_showing_dialogue := false
var player_has_exited := false
var timer_started := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	if not overlaps_body(character_body_2d):
		player_has_exited = true

func _on_body_entered(body: Node2D) -> void:
	if body != character_body_2d or not player_has_exited or is_showing_dialogue:
		return
	
	var player_pos = character_body_2d.global_position
	var shape_1_pos = collision_shape_2d.global_position
	var shape_2_pos = collision_shape_2d_2.global_position
	var shape_3_pos = collision_shape_2d_3.global_position
	
	var dist_to_shape_1 = player_pos.distance_to(shape_1_pos)
	var dist_to_shape_2 = player_pos.distance_to(shape_2_pos)
	var dist_to_shape_3 = player_pos.distance_to(shape_3_pos)
	
	var dialogue_resource = load("res://dialogue/start.dialogue")
	var balloon_scene = load("res://dialogue/Ballons/Tale.tscn")
	is_showing_dialogue = true
	
	var min_dist = min(dist_to_shape_1, min(dist_to_shape_2, dist_to_shape_3))
	
	if min_dist == dist_to_shape_1 and not has_triggered_first:
		has_triggered_first = true
		DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_resource, "tale3n1")
	elif min_dist == dist_to_shape_2 and not has_triggered_second:
		has_triggered_second = true
		DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_resource, "tale3n2")
	elif min_dist == dist_to_shape_3 and not has_triggered_third:
		has_triggered_third = true
		is_showing_dialogue = false
		if not timer_started:
			timer_started = true
			await get_tree().create_timer(10.0).timeout
			start_tale3n3_dialogue()
	else:
		is_showing_dialogue = false

func _on_body_exited(body: Node2D) -> void:
	if body == character_body_2d:
		player_has_exited = true

func _on_dialogue_ended(resource: DialogueResource) -> void:
	is_showing_dialogue = false

func start_tale3n3_dialogue() -> void:
	var dialogue_resource = load("res://dialogue/start.dialogue")
	var balloon_scene = load("res://dialogue/Ballons/bound.tscn")
	is_showing_dialogue = true
	DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_resource, "tale3n3")
