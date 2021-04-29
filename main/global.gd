extends Node


func to_snake_case(s:String) -> String:
	return s.to_lower().replace(" ", "_")
