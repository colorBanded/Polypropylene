extends Control

@onready var character_body_2d: CharacterBody2D = $"../talePC/CharacterBody2D"

func _ready() -> void:
	DialogueManager.show_dialogue_balloon_scene(load("res://dialogue/Ballons/Tale.tscn"), load("res://dialogue/start.dialogue"), "blank")

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	if body == character_body_2d and Global.tale_2Talked == 0:
		Global.tale_2Talked = 1
		DialogueManager.show_dialogue_balloon_scene(load("res://dialogue/Ballons/Tale.tscn"), load("res://dialogue/start.dialogue"), "tale2")
