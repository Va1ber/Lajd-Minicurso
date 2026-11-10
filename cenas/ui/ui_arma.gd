extends HBoxContainer

func _on_jogador_atualizar_arma(textura: Texture2D) -> void:
	visible = textura != null
	get_node("TextureRect").texture = textura
	
