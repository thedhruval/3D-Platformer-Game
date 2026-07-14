extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 12

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	#new camera movement
	if event is InputEventMouseMotion:
		$Camera_Controller.rotation_degrees.y -= event.relative.x * 0.5
		$Camera_Controller.rotation_degrees.x -= event.relative.y * 0.5
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	
	# old camera movement
	## Camera movement left / Right
	#if Input.is_action_just_pressed("cam_left"):
		#$Camera_Controller.rotate_y(deg_to_rad(-30))
	#if Input.is_action_just_pressed("cam_right"):
		#$Camera_Controller.rotate_y(deg_to_rad(30))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	# New vector3 direction, taking into account the user movement inputs and the camera rotation
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate player mesh so its oriented towards movement according to the camera
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Make the position of camera controller match my position
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.15)
