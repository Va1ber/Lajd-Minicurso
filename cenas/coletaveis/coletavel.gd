@abstract
extends Area2D
class_name Coletavel

var jogador:Jogador

func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("Jogador")
	if jogador:
		body_entered.connect(coletar_item)
	else:
		printerr("Erro no node: " + name + " - <Jogador Não Encontrado>")

@abstract
func ativar_efeito()

func coletar_item(_body:Node2D):
	call_deferred("queue_free")
	ativar_efeito()
