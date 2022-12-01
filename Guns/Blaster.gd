extends RigidBody

var Pickup = preload("res://Player/Blaster.tscn")




func _on_Area_body_entered(body):
	if body.name == "Player": #if player available
		#it can now pick it up
		pass
