extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the body_entered signal to our function
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This function is called when a body enters the Area2D
func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	
	# Check if it's the player (adjust condition as needed)
	if body.name == "player":
		start_dialogue()

# Function to start the dialogue
func start_dialogue() -> void:
	DialogueManager.show_dialogue_balloon_scene("res://dialogue/Ballons/IGB.tscn",preload("res://dialogue/start.dialogue"), "facade")
