extends Control

@onready var area_2d: Area2D = get_node("../Area2D")
@onready var character_body_2d: CharacterBody2D = get_node("../talePC/CharacterBody2D")
@onready var t1: CollisionShape2D = get_node("../Area2D/t1")
@onready var t2: CollisionShape2D = get_node("../Area2D/t2")

const IGB = preload("res://dialogue/Ballons/IGB.tscn")
const TALE_BALLOON = preload("res://dialogue/Ballons/Tale.tscn")

var player_has_exited: bool = false
var is_showing_dialogue: bool = false
var t1_talked: bool = false
var t2_talked: bool = false

func _ready() -> void:
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	if not area_2d.overlaps_body(character_body_2d):
		player_has_exited = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != character_body_2d or not player_has_exited or is_showing_dialogue:
		return
	
	var player_pos = character_body_2d.global_position
	var t1_pos = t1.global_position
	var t2_pos = t2.global_position
	
	var dist_to_t1 = player_pos.distance_to(t1_pos)
	var dist_to_t2 = player_pos.distance_to(t2_pos)

	
	var dialogue_resource = load("res://dialogue/start.dialogue")
	is_showing_dialogue = true
	
	if dist_to_t1 < dist_to_t2 and not t1_talked:

		t1_talked = true
		DialogueManager.show_dialogue_balloon_scene(TALE_BALLOON, dialogue_resource, "tale2")
	elif dist_to_t2 < dist_to_t1 and not t2_talked:
		t2_talked = true
		await show_mixed_dialogue("tale2n1")
		is_showing_dialogue = false
		get_tree().change_scene_to_file("res://scenes/question.tscn")
	else:
		is_showing_dialogue = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == character_body_2d:
		player_has_exited = true

func _on_dialogue_ended(resource) -> void:
	is_showing_dialogue = false

func show_mixed_dialogue(start_line: String) -> void:

	var dialogue_resource = load("res://dialogue/start.dialogue")
	var current_line = start_line
	
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
		
	
	var loop_count = 0
	while current_line != "END":
		loop_count += 1
		
		var is_dev_line = is_dev_speaker(current_line)
		var balloon = IGB if is_dev_line else TALE_BALLOON
		
		
		DialogueManager.show_dialogue_balloon_scene(balloon, dialogue_resource, current_line)
	
		await DialogueManager.dialogue_ended
	
		
		current_line = get_next_line(current_line)
	
	
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func is_dev_speaker(line_id: String) -> bool:
	var dev_lines = ["tale2n2", "tale2n4", "tale2n6", "tale2n8"]
	return line_id in dev_lines

func get_next_line(current: String) -> String:
	if not current.begins_with("tale2n"):
		return "END"
	
	var num = int(current.substr(6))
	if num >= 9:
		return "END"
	
	return "tale2n" + str(num + 1)
