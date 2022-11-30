extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Pivot/Camera.current = false
	
func _on_Quit_pressed():
	get_tree().quit()
