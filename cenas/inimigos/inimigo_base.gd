extends CharacterBody2D
class_name InimigoBase

enum Estado{
	Esperando,
	Patrulhando,
	Perseguindo,
	Atacando,
	Morto
}

@export var velocidade_movimento:int = 30
@export var direcao:Vector2 = Vector2(1, 0)
@export var vida_maxima:int

var estado_atual:Estado = Estado.Esperando
var vida_atual:int

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	vida_atual = vida_maxima
	if direcao.x < 0: ray_cast_2d.scale.x = -1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if estado_atual == Estado.Morto: return
	movimentar()
	
func movimentar():	
	velocity.x = direcao.x * velocidade_movimento
	move_and_slide()
	
	if !ray_cast_2d.is_colliding() or is_on_wall():
		direcao.x *= -1
		ray_cast_2d.scale.x *= -1
