extends Node2D
@onready var npc_red: Sprite2D = $"../NPC_Red"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _ready():
	wait_for_mv1()

# Waits for Global.diag1mv to become true
func wait_for_mv1():
	while Global.diag1mv == 0:
		await get_tree().create_timer(0.1).timeout
	
	# Run your function once after mv1 is true
	on_mv1_true()

func on_mv1_true():
	animation_player.play("npc_purpleMove");
	
