extends CharacterBody2D

var gravity = 10

var speed:int
var life:int = 2

var _body:Node2D
var izquierda:bool = true
var angryState:bool = false
var inarea: bool = true
var indmg:bool = false

var posInicial: Vector2 

func _ready():
	$movility.play("Walk")
	posInicial.x = position.x

func _process(delta):
	if life ==0 and angryState:
		$movility.play("Hit 2")
		speed = 0
		angryState = false
	elif life == 1 and inarea:
		angryState = true

func _physics_process(delta):
	velocity.y += gravity

	if !angryState and life > 0:
		walk()
	elif angryState and inarea: 
		angry(delta)
	elif angryState and !inarea:
		idle()

func walk():
	speed = 30
	if izquierda and $IdleTimer.get_time_left() == 0:
		$movility.play("Walk")
		velocity.x = - speed
		if position.x <= posInicial.x - 150:
			idle()
			$movility.flip_h = true
			$IdleTimer.start()
			izquierda = false
	elif !izquierda and $IdleTimer.get_time_left() == 0:
		$movility.play("Walk")
		velocity.x = speed
		if position.x >= posInicial.x + 10: 
			idle()
			$movility.flip_h = false
			$IdleTimer.start()
			izquierda = true

	move_and_slide()

func angry(delta):
	if angryState:
		speed = 40
		$movility.play("Run")
		if position.x < Global.positionplayer.x:
			$movility.flip_h = true
			position.x += speed*delta
		elif position.x > Global.positionplayer.x:
			$movility.flip_h = false
			position.x -= speed*delta

func idle():
	$movility.play("Idle")
	velocity.x = 0

func _on_hit_box_area_entered(area):
	if area.is_in_group("hit"):
		life -= 1

func _on_movility_frame_changed():
	if $movility.get_animation() == "Hit 2" and $movility.frame == 6:
		queue_free()       #eliminar enemigo de la scena


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		inarea = true

func _on_area_body_exited(body):
	if body.is_in_group("player"):
		inarea = false

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		_body = body
		indmg = true
		$DmgTimer.start()
		if !angryState:
			var _move_script = _body.get_node("MainCharacterMovement")
			_move_script.hit(2)
		elif angryState:
			var _move_script = _body.get_node("MainCharacterMovement")
			_move_script.hit(4)

func _on_hit_box_body_exited(body):
	if body.is_in_group("player"):
		indmg = false

func _on_dmg_timer_timeout():
	var _move_script = _body.get_node("MainCharacterMovement")
	if indmg and !angryState: 
		_move_script.hit(2)
	elif indmg and angryState: 
		_move_script.hit(4)
