extends Node2D

func _ready():
	start_opening_sequence()

func start_opening_sequence():
	var dialogue_resource = preload("res://dialogue/start.dialogue")
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/bal_intro.tscn", dialogue_resource, "intro")
	await DialogueManager.dialogue_ended
	get_tree().change_scene_to_file("res://scenes/intro_2_scene.tscn")
