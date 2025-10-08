extends Node2D
@onready var prsenter: Label = $prsenter

func _ready():
	prsenter.modulate = Color(0, 0, 0, 1)  
	start_opening_sequence()

func start_opening_sequence():
	if Global.keepGoing == 0:
		var dialogue_resource = preload("res://dialogue/start.dialogue")
		DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/bal_intro.tscn", dialogue_resource, "intro")
		await DialogueManager.dialogue_ended
		get_tree().change_scene_to_file("res://scenes/intro_2_scene.tscn")
	elif Global.keepGoing == 1:
		var dialogue_resource = preload("res://dialogue/start.dialogue")
		
		var tween = create_tween()
		tween.tween_property(prsenter, "modulate", Color(1, 1, 1, 1), 3.0)  
		DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/bal_intro.tscn", dialogue_resource, "titledrop")

		

		await DialogueManager.dialogue_ended
