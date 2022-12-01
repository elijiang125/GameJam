extends Control

func _ready():
	get_tree().paused = true
	$MessageColorRect.show()
	$Message.show()
	$Message/MessageTimer.start()

func _on_MessageTimer_timeout():
	get_tree().paused = false
	$Message.hide()
	$MessageColorRect.hide()
