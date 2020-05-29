extends Node2D

func is_path_index(index: int):
	return has_node(str(index))

func get_path_pos(index: int):
	return get_node(str(index)).position
