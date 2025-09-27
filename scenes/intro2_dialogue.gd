extends Node2D
func _ready():
	start_opening_sequence()

func start_opening_sequence():
	var dialogue_resource = preload("res://dialogue/start.dialogue")
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/IGB.tscn", dialogue_resource, "intro2")
	await DialogueManager.dialogue_ended
