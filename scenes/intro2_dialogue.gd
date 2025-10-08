extends Node2D
var last_keep_going_value = -1
var intro_finished = false
@onready var tile_map_layer_hb: TileMapLayer = $"../TileMapLayerHB"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"
@onready var player: CharacterBody2D = $"../player"
@onready var diag_indicator_2: Area2D = $"../DiagIndicator2"
@onready var diag_indicator_3: Area2D = $"../DiagIndicator3"
@onready var camera_2d: Camera2D = $"../player/Camera2D"
var dialogue_resource = preload("res://dialogue/start.dialogue")

func _ready():
	start_opening_sequence()
	check_keep_going_async()

func check_keep_going_async():
	while true:
		if Global.keepGoing != last_keep_going_value:
			last_keep_going_value = Global.keepGoing
			
			if Global.keepGoing == 1:
				tile_map_layer_2.visible = false
				tile_map_layer_2.enabled = false
				tile_map_layer_hb.visible = true
				tile_map_layer_hb.enabled = true
			else:
				tile_map_layer_2.visible = true
				tile_map_layer_2.enabled = true
				tile_map_layer_hb.visible = false
				tile_map_layer_hb.enabled = false
		
		await get_tree().create_timer(0.1).timeout

func start_opening_sequence():
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/IGB.tscn", dialogue_resource, "intro2")
	await DialogueManager.dialogue_ended
	intro_finished = true

func _on_diag_indicator_2_body_entered(body: Node2D) -> void:
	if body != player or not intro_finished:
		return
	
	camera_2d.reparent(get_parent())
	player.set_physics_process(false)
	player.set_process_input(false)
	
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/IGB.tscn", dialogue_resource, "pretitledrop")
	await DialogueManager.dialogue_ended
	
	var last_camera_pos = camera_2d.global_position
	await get_tree().process_frame
	
	while camera_2d.global_position.distance_to(last_camera_pos) > 0.1:
		last_camera_pos = camera_2d.global_position
		await get_tree().process_frame
	Global.keepGoing = 1
	get_tree().change_scene_to_file("res://scenes/intro_scene.tscn")

func _on_diag_indicator_3_body_entered(body: Node2D) -> void:
	if body != player or not intro_finished:
		return
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/IGB.tscn", dialogue_resource, "passby0")
	await DialogueManager.dialogue_ended
