extends Control

@onready var tale_pc: Control = $"."
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var sprite_2d: Sprite2D = $CharacterBody2D/Sprite2D
@onready var camera_2d: Camera2D = $CharacterBody2D/Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

const SPEED = 100.0  
const DIAGONAL_SPEED_MULTIPLIER = 0.707  

func _ready() -> void:
	animation_player.play_backwards("fadeOut")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta: float) -> void:
	handle_movement()

func _on_dialogue_started(resource: DialogueResource) -> void:
	tale_pc.process_mode = Node.PROCESS_MODE_DISABLED

func _on_dialogue_ended(resource: DialogueResource) -> void:
	tale_pc.process_mode = Node.PROCESS_MODE_INHERIT

func handle_movement() -> void:
	var input_x = Input.get_axis("pm_moveleft", "pm_moveright")
	var input_y = Input.get_axis("pm_moveup", "pm_movedown")
	var velocity = Vector2(input_x, input_y)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	character_body_2d.velocity = velocity
	character_body_2d.move_and_slide()
