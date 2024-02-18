extends Node3D

# CAMERA MOVEMENT
@export_range(0,100,1) var camera_move_speed: float = 10.0

# CAMERA ZOOM
var camera_zoom_direction: float = 0
@export_range(0,100,1) var camera_zoom_speed = 45.0
@export_range(0,100,1) var camera_zoom_min = 5.0
@export_range(0,100,1) var camera_zoom_max = 25.0
@export_range(0,2,0.1) var camera_zoom_speed_dampener = 0.90

# CAMERA FLAGS
var camera_can_process:bool = true;
var camera_can_move_base:bool = true
var camera_can_zoom:bool = true
var camera_can_pan: bool = true

# CAMERA PAN MARGIN
@export_range(25,100,5) var camera_pan_margin:int = 35
@export_range(0,15,2.5) var camera_pan_speed: float = 5

# NODES
@onready var camera_socket: Node3D = $camera_socket
@onready var camera: Camera3D = $camera_socket/Camera3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if !camera_can_process: return
	
	camera_base_move(delta)
	camera_zoom_update(delta)
	camera_panning(delta)

func _unhandled_input(event:InputEvent) -> void:
	# Camera zoom
	if event.is_action("camera_zoom_in"):
		camera_zoom_direction = -1
	elif event.is_action("camera_zoom_out"):
		camera_zoom_direction = 1
	else:
		camera_zoom_direction = 0
	
	camera_can_zoom = true

func camera_base_move(delta:float) -> void:
	if !camera_can_move_base: return
	
	var camera_direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_forward"):
		camera_direction -= transform.basis.z # exactly the same when we do Vector3(0,0,1)
		#camera_direction -= Vector3(0,0,1)
	if Input.is_action_pressed("camera_backward"):
		camera_direction += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		camera_direction -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		camera_direction += transform.basis.x
	
	self.position += camera_direction * delta * camera_move_speed

# the Camera3D will move base on the Z-axis of camera_socket
func camera_zoom_update(delta:float) -> void:
	if !camera_can_zoom: return
	
	var new_zoom:float = clamp(self.camera.position.z + camera_zoom_speed * camera_zoom_direction * delta, camera_zoom_min, camera_zoom_max)
	self.camera.position.z = new_zoom
	camera_zoom_direction *= camera_zoom_speed_dampener
	#camera_can_zoom = false

func camera_panning(delta: float) -> void:
	if !camera_can_pan:return

	var current_viewport: Viewport = get_viewport()
	var pan_direction:Vector2 = Vector2(-1,-1)
	var viewport_visible_rect:Rect2i = Rect2i(current_viewport.get_visible_rect())
	var viewport_size:Vector2i = current_viewport.size
	var current_mouse_position: Vector2 = current_viewport.get_mouse_position()
	var zoom_factor: float = self.camera.position.z + 0.1

	# X margin
	if (current_mouse_position.x <= camera_pan_margin or
		current_mouse_position.x >= viewport_size.x - camera_pan_margin):
		if (current_mouse_position.x > viewport_size.x / 2 ):
			pan_direction.x = 1
		self.translate(Vector3(pan_direction.x * delta * camera_pan_speed * zoom_factor, 0,0))

	# Y margin
	if (current_mouse_position.y <= camera_pan_margin or
		current_mouse_position.y >= viewport_size.y - camera_pan_margin):
		if (current_mouse_position.y > viewport_size.y / 2.0 ):
			pan_direction.y = 1
		self.translate(Vector3(0, 0, pan_direction.y * delta * camera_pan_speed * zoom_factor)) # move the Z-axis position



