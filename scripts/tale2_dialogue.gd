extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.show_dialogue_balloon_scene(load("res://dialogue/Ballons/Tale.tscn"), load("res://dialogue/start.dialogue"), "blank")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
