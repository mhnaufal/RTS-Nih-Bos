extends Node3D

@export_range(0,100,1) var camera_move_speed: float = 10.0

var camera_zoom_direction: float = 0
@export_range(0,100,1) var camera_zoom_speed = 45.0
@export_range(0,100,1) var camera_zoom_min = 5.0
@export_range(0,100,1) var camera_zoom_max = 25.0
@export_range(0,2,0.1) var camera_zoom_speed_dampener = 0.90

var camera_can_process:bool = true;
var camera_can_move_base:bool = true
var camera_can_zoom:bool = true

# NODES
@onready var camera_socket: Node3D = $camera_socket
@onready var camera: Camera3D = $camera_socket/Camera3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if !camera_can_process: return
	
	camera_base_move(delta)
	camera_zoom_update(delta)

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
	camera_can_zoom = false





