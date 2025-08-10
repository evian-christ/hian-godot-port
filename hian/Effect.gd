extends Resource
class_name Effect

# Trigger: When to check this effect
# e.g., "on_turn_end", "on_placement"
@export var trigger: String = "on_turn_end"

# Conditions: What needs to be true for the effect to fire
# An array of dictionaries, e.g.:
# {"type": "nearby", "symbol_id": "Woods", "count": 1}
# {"type": "every_x_turns", "value": 4}
@export var conditions: Array[Dictionary] = []

# Actions: What happens when the conditions are met
# An array of dictionaries, e.g.:
# {"type": "produce", "resource": "food", "amount": 5}
# {"type": "self_destruct"}
@export var actions: Array[Dictionary] = []
