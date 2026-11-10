extends CharacterBody2D
class_name Jogador

@export var velocidade_movimento:int = 300
@export var forca_pulo:int = 400

@onready var sprite2D:Sprite2D = get_node("Sprite2D")

var moedas:int = 0
#Como é só para exercício vou simplificar as coisas dessa parte
var arma_equipada:bool = false
signal atualizar_arma(textura:Texture2D)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("vui_pulo"):
		pular()
	elif event.is_action_pressed("vui_consumir_item"):
		consumir_item()
	elif event.is_action_pressed("vui_ataque"):
		atacar()
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	movimentar()
	
func movimentar():
	var direction := Input.get_axis("vui_movimento_esquerda",
	 "vui_movimento_direita")
	
	if direction:
		velocity.x = direction * velocidade_movimento
		sprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade_movimento)

	move_and_slide()

func pular():
	if is_on_floor():
		velocity.y = -forca_pulo

func consumir_item():
	print("Item Utilizado")

func atacar():
	if arma_equipada:
		print("Ataque Realizado")
	
func aumentar_moedas(quant:int):
	moedas += quant
	print(moedas)

func equipar_arma(arma:Node2D):
	arma_equipada = true 
	atualizar_arma.emit(arma.get_node("Sprite2D").texture)
