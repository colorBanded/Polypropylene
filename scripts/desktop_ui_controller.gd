extends Control
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var loadingtext: Label = $"../SoftBoot/loadingtext"
@onready var storydiag: Label = $"../storydiag"
@onready var soft_boot: Sprite2D = $"../SoftBoot"
var loading_messages = [
	"Initializing workspace...",
	"Loading core modules...",
	"Verifying license...",
	"Loading preferences...",
	"Initializing plugins...",
	"Loading recent files...",
	"Preparing interface...",
	"Loading fonts...",
	"Initializing tools...",
	"Configuring workspace layout...",
	"Loading extensions...",
	"Finalizing startup...",
	"Loading main window..."
]
var current_message_index = 0
var message_timer = 0.0
var message_interval = 0.4
var has_hidden_softboot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.deskFirstboot == 0:
		Global.deskFirstboot = 1
		animation_player.play("sceneIntro")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		loadingtext.text = loading_messages[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.deskFirstboot == 1 and current_message_index < loading_messages.size():
		message_timer += delta
		
		if message_timer >= message_interval:
			message_timer = 0.0
			current_message_index += 1
			
			if current_message_index < loading_messages.size():
				loadingtext.text = loading_messages[current_message_index]
			else:
				# All messages shown, hide the soft_boot
				if not has_hidden_softboot:
					soft_boot.hide()
					has_hidden_softboot = true
