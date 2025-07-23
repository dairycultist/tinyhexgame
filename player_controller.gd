extends CharacterBody3D

@export var mouse_sensitivity := 0.3
@export var drag := 8
@export var accel := 50
@export var jump_speed := 10
@export var gravity := 30

var camera_pitch := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	
	# failsafe
	if (position.y < -1):
		position = Vector3.ZERO
		velocity = Vector3.ZERO
	
	# movement
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x += direction.x * accel * delta
		velocity.z += direction.z * accel * delta
	
	velocity.x = lerp(velocity.x, 0.0, delta * drag)
	velocity.y -= gravity * delta
	velocity.z = lerp(velocity.z, 0.0, delta * drag)
	
	move_and_slide()

func _input(event):
	
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	
	if event.is_action_pressed("pause"):
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		
		rotation.y += deg_to_rad(-event.relative.x * mouse_sensitivity)
		
		camera_pitch = clampf(camera_pitch - event.relative.y * mouse_sensitivity, -90, 90)
		
		$Camera.rotation.x = deg_to_rad(camera_pitch)
