extends CharacterBody2D

var _speed=30
var _gravity=10
var _moving_left=true
var _initial_position:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = - _speed
	_initial_position.x=position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move_character(delta)

func _move_character(_delta):
	velocity.y += _gravity
	$movility.play("Walk")
	if position.x <=_initial_position.x-100:
		$IdleTimer.start()
		$movility.play("Idle")
		velocity.x=0
		$movility.flip_h=true
	elif position.x >= _initial_position.x+10:
		$IdleTimer.start()
		velocity.x=0
		$movility.play("Idle")
		$movility.flip_h=false

	# Iniciamos el movimiento
	move_and_slide()


func _on_idle_timer_timeout():
	velocity.x=_speed
	#if position.x <=_initial_position.x-100:
		#velocity.x=_speed
	#elif position.x >= _initial_position.x:
		#velocity.x = - _speed
