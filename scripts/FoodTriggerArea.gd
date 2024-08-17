extends Node

@onready var food_bubble: FoodBubble = $"../FoodBubble"
@onready var fish: Fish = $".."

func _on_body_entered(body: Fish) -> void:
	print("entering")
	if(body.kind == fish.eat):
		food_bubble.hide_bubble()
		# Stop fish movement
	else:
		food_bubble.show_bubble()

func _on_body_exited(_body: Fish) -> void:
	food_bubble.hide_bubble()
