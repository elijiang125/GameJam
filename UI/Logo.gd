extends Control

var hour_speed = 0.1
var minute_speed = 1

func _ready():
	$Pizza/Clock_center/Clock_minute.rect_rotation = -32

func _physics_process(_delta):
	$Pizza/Clock_center/Clock_hour.rect_rotation += hour_speed
	$Pizza/Clock_center/Clock_minute.rect_rotation += minute_speed
