extends Node

# This engine will process all symbol effects in the game.

func process_turn_effects(game_node, slots: Array):
	for i in range(slots.size()):
		var slot = slots[i]
		if not slot.current_symbol:
			continue

		for effect in slot.current_symbol.effects:
			if effect.trigger != "on_turn_end":
				continue

			# For now, we assume all conditions must be met (AND logic)
			var conditions_met = true
			var context = {} # To pass data from conditions to actions

			for condition in effect.conditions:
				match condition.type:
					"nearby":
						var neighbors = game_node.get_neighbor_slots(i)
						var matching_neighbors = []
						for neighbor_slot in neighbors:
							if neighbor_slot.current_symbol and neighbor_slot.current_symbol.name == condition.symbol_name:
								matching_neighbors.append(neighbor_slot)
						
						if matching_neighbors.size() == 0:
							conditions_met = false
							break
						
						if condition.get("for_each", false):
							context["for_each_count"] = matching_neighbors.size()
						
					_: # Unknown condition type
						conditions_met = false
						break
			
			if conditions_met:
				execute_actions(effect.actions, context)

func execute_actions(actions: Array, context: Dictionary):
	for action in actions:
		match action.type:
			"produce":
				var amount = action.amount
				if context.has("for_each_count"):
					amount *= context.for_each_count
				
				match action.resource:
					"food":
						GameManager.current_turn_food_production += amount
					# Add other resource types here later