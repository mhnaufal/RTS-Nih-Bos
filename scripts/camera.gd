extends Camera2D

var mouse_pos = Vector2()
var mouse_pos_global = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging = false

signal area_selected
signal start_move_selected

func _process(_delta):
	if Input.is_action_just_pressed("LeftClick"):
		start = mouse_pos_global
		startV = mouse_pos
		is_dragging = true
	
	if is_dragging:
		end = mouse_pos_global
		endV = mouse_pos
		draw_area()
		
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mouse_pos) > 10:
			end = mouse_pos_global
			endV = mouse_pos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false
			draw_area(false)

func _input(event):
	if event is InputEventMouse:
		mouse_pos = event.position
		mouse_pos_global = get_global_mouse_position()

func draw_area(is_drawing = true):
	get_node("../Panel").size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	get_node("../Panel").position.x = min(startV.x, end.x)
	get_node("../Panel").position.y = min(startV.y, endV.y)
	get_node("../Panel").size *= int(is_drawing)
