extends KinematicBody

onready var Camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pivot/Camera.current = true
	$Pivot/Camera/Crosshair.hide()

var velocity = Vector3()
var to_pickup = null

onready var Guns = get_node("/root/Game/Guns")

onready var rc = $Pivot/RayCast
onready var flash = $Pivot/Blaster/Flash
onready var Decal = preload("res://Player/Decal.tscn")

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
	if Input.is_action_pressed("pickup"):
		pickup()
	

func shoot(): #new code
	var gun = get_node_or_null("Pivot/Gun") #nerf gun, image will be for later, please check
	if gun != null and gun.has_method("shoot"):
		gun.shoot()
		
func pickup():
	var gun = get_node_or_null("Pivot/Gun")
	if gun != null:
		var to_drop = gun.Pickup.instance()
		Guns.add_child(to_drop)
		to_drop.global_transform.origin = global_transform.origin + Vector3(0, 1.5, 0)
		var throw = Vector3.ZERO
		throw += -Camera.global_transform.basis.z * 8.0
		throw += -Camera.global_transform.basis.y * 0.5
		to_drop.apply_central_impulse(throw)
		gun.queue_free()
		$Pivot/Camera/Crosshair.show()
	elif to_pickup != null:
		gun = to_pickup.Pickup.instance()
		gun.name = "Nerf Gun"
		$Pivot.add_child(gun)
		$Pivot/Camera/Crosshair.show()
		to_pickup.queue_free()


func _on_Area_body_entered(body): 
	if body.is_in_group("Guns"):
		to_pickup = body


func _on_Area_body_exited(body):
	to_pickup = null
