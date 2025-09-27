extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 300.0
const DASH_DURATION = 0.2

var dash_timer = 0.0
var is_dashing = false
var dialogue_active = false

func _ready():
	# Connect to dialogue signals
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_dialogue_resource):
	# Set flag to disable movement during dialogue
	dialogue_active = true

func _on_dialogue_ended(_dialogue_resource):
	# Resume movement after dialogue
	dialogue_active = false

func _physics_process(delta: float) -> void:
	# If dialogue is active, stop all input processing but still apply physics
	if dialogue_active:
		# Gradually stop horizontal movement
		velocity.x = move_toward(velocity.x, 0, SPEED * 2)
		# Still apply gravity
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	# Handle dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	
	# Add gravity (only if not dashing)
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta
	
	# Handle jump (Space key)
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dashing:
		velocity.y = JUMP_VELOCITY
	
	# Handle dash (Shift key)
	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_timer = DASH_DURATION
		# Dash in the direction the player is facing or moving
		var dash_direction = 0
		if Input.is_action_pressed("move_left"):
			dash_direction = -1
		elif Input.is_action_pressed("move_right"):
			dash_direction = 1
		else:
			# If no direction is pressed, dash in the last movement direction
			dash_direction = sign(velocity.x) if velocity.x != 0 else 1
		
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  # Reset vertical velocity during dash
	
	# Handle horizontal movement (only if not dashing)
	if not is_dashing:
		var direction := 0
		if Input.is_action_pressed("move_left"):
			direction -= 1
		if Input.is_action_pressed("move_right"):
			direction += 1
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
