extends InimigoBase

@export var velocidade_patrulha:int
@export var velocidade_perseguicao:int

var alvo:Node2D = null

@onready var ray_cast_perseguicao: RayCast2D = $RayCastPerseguicao

@onready var timer_duracao_perseguicao: Timer = $TimerDuracaoPerseguicao
@onready var timer_patrulha: Timer = $TimerPatrulha
@onready var timer_esperar: Timer = $TimerEsperar

func _ready() -> void:
	super._ready()
	mudarEstado(estado_atual)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var alvo_raycast = ray_cast_perseguicao.get_collider()
	
	if estado_atual in [Estado.Patrulhando, Estado.Perseguindo] and alvo_raycast is Jogador:
		alvo = alvo_raycast
		mudarEstado(Estado.Perseguindo)

func movimentar():
	if is_instance_valid(alvo) and estado_atual != Estado.Atacando:
		var dist:Vector2 = alvo.position - position
		if abs(dist.x) <= 30:
			mudarEstado(Estado.Atacando)
		else:
			velocidade_movimento = velocidade_perseguicao
			direcao.x = sign(dist.x)
			
		if !ray_cast_chao.is_colliding():
			velocidade_movimento = 0
	elif !ray_cast_chao.is_colliding() or is_on_wall():
		direcao.x *= -1
		scale.x *= -1
	
	velocity.x = direcao.x * velocidade_movimento
	move_and_slide()
	
func mudarEstado(novo_estado:Estado):
	match novo_estado:
		Estado.Esperando:
			timer_esperar.start()
			velocidade_movimento = 0
		Estado.Patrulhando:
			timer_patrulha.start()
			velocidade_movimento = velocidade_patrulha
		Estado.Perseguindo:
			velocidade_movimento = velocidade_perseguicao
			timer_duracao_perseguicao.start()
		Estado.Atacando:
			animation_player.play("Patrulhador/atacar")
			velocidade_movimento = 0
		Estado.Morto:
			velocidade_movimento = 0
	estado_atual = novo_estado

func _on_timer_patrulha_timeout() -> void:
	if estado_atual == Estado.Patrulhando:
		mudarEstado(Estado.Esperando)

func _on_timer_esperar_timeout() -> void:
	if estado_atual == Estado.Esperando:
		mudarEstado(Estado.Patrulhando)

func _on_timer_duracao_perseguicao_timeout() -> void:
	mudarEstado(Estado.Esperando)
	alvo = null
