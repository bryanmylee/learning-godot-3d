extends RigidBody3D
# This tells us that this script is attached to a RigidBody3D,
# so we can access all of its methods and properties.

# A list of virtual functions provided by Godot can be found here:
# https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html

# := tells Godot to include the variable in static analysis
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# @onready loads the variable when the scene is ready.
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Returns 1.0 if it is pressed, otherwise 0.0.
	# var input = Input.get_action_strength("ui_up")
	# comes from RigidBody3D
	# apply_central_force(input * Vector3.FORWARD * 1200.0 * delta)
	
	var input := Vector3.ZERO
	# get_axis is a helper for the common task of getting axial input.
	# Returns -1.0 or 1.0 if left or right are pressed.
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	# The basis represents the rotation and scale of the node.
	# Multiplying a basis and a vector aligns the vector to the basis.
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _unhandled_input(ev):
	if not ev is InputEventMouseMotion:
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	twist_input = -ev.relative.x * mouse_sensitivity
	pitch_input = -ev.relative.y * mouse_sensitivity
	
	# $ variables expose child nodes of the attached node.
	twist_pivot.rotate_y(twist_input) # rotates by radians
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5)
	twist_input = 0.0
	pitch_input = 0.0
