extends CharacterBody2D

var gravity = 10

var speed:int
var life:int = 2

var izquierda:bool = true
var angryState:bool = false


var posInicial: Vector2 

func _ready():
	$movility.play("Walk")
	posInicial.x = position.x
	speed=30
	velocity.x = - speed

func _process(delta):
	if life ==0 and angryState:
		$movility.play("Hit 2")
		speed = 0
		angryState = false
	elif life == 1:
		angryState = true

func _physics_process(delta):
	velocity.y += gravity

	if !angryState and life > 0:
		walk()
	else: 
		angry(delta)

func walk():
	speed = 30
	if izquierda and position.x <= posInicial.x - 150:
		idle()
		$movility.flip_h = true
		$IdleTimer.start()
		izquierda = false
	elif !izquierda and position.x >= posInicial.x + 10: 
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


func _on_idle_timer_timeout():
	if izquierda:
		$movility.play("Walk")
		velocity.x = - speed
	else:
		$movility.play("Walk")
		velocity.x =  speed


func _on_hit_box_area_entered(area):
	if area.is_in_group("hit"):
		life -= 1

#
func _on_movility_frame_changed():
	if $movility.get_animation() == "Hit 2" and $movility.frame == 6:
		queue_free()
