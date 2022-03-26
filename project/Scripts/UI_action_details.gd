extends PanelContainer

onready var labels : Array = get_node('HBoxContainer').get_children()
onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var ai = get_node('/root/Control/AI')
onready var monster_manager = get_node('/root/Control/MonsterManager')

const STATUS_EFFECT =  preload('res://Scripts/Status_effect.gd')

var label_one
var label_two
var label_three
var label_four
var label_five

var type_name = {
	0 : 'Fire',
	1 : 'Water',
	2 : 'Grass'
}

func _ready():
	label_one = labels[0]
	label_two = labels[1]
	label_three = labels[2]
	label_four = labels[3]
	label_five = labels[4]

func _process(delta):
	label_one.visible = false
	label_two.visible = false
	label_three.visible = false
	label_four.visible = false
	label_five.visible = false
	
	_attack_details()
#	_set_ai_action()
	_monster_details()
	
func _monster_details():
	self.visible = false
	if not game_manager.is_team_a_turn():
		return
	
	if control.get_lock_inputs():
		return
		
	self.visible = true
	
	var input_group = control.get_input_group()
	
	if input_group == INPUT_GROUP.TARGETTWO:
		var monster = monster_manager.get_action_swap_target_to()
		_set_details_monster(monster)
		return
		
	if input_group == INPUT_GROUP.TARGET:
		var targets = monster_manager.get_selected_action_targets()
		if targets.all == null:
			return
			
		var monster = monster_manager.get_target()
		_set_details_monster(monster)
		return
		
	if input_group == INPUT_GROUP.ALLY:
		var monster = monster_manager.get_selected_team_a()
		_set_details_monster(monster)
		return
		
func _set_details_monster(var monster):
	label_one.visible = true
	label_two.visible = true
	label_one.text = monster.name
	label_two.text = 'Weakness: ' + type_name[monster.type_weakness]
	
	var bleed = monster.get_status_bleed()
	var paralyze = monster.get_status_paralyze()
	
	if not bleed == 0:
		label_three.visible = true
		label_three.text = 'Bleed (' + str(bleed) +')'
		
	if not paralyze == 0:
		label_four.visible = true
		label_four.text = 'Bleed (' + str(paralyze) +')'
	
func _attack_details():
	if game_manager.is_team_b_turn():
		return
		
	if control.get_input_group() == INPUT_GROUP.ALLY:
		return
		
	if control.input_group == INPUT_GROUP.TARGETTWO:
		return
		
	if control.input_group == INPUT_GROUP.TARGET:
		return
		
		
	var action = action_manager.get_selected_action()
	
	if action.action_name == ACTION_NAMES.Skip:
		return
	
	label_one.visible = true
	label_two.visible = true
	label_three.visible = true
	label_four.visible = true
	
	if not action.damage == null:
		if action.damage >= 0:
			label_one.text = "Damage: " + String(action.damage)
		else:
			label_one.text = "Heal: " + String(action.damage * -1)
		
	label_two.text = "Cost: " + String(action.cost)
	
	if not action.elemental_type == null:
		label_three.visible = true
		label_three.text = "Type: " + type_name[action.elemental_type]
	
	if action.damage == 0:
		label_one.visible = false
		
	if action.elemental_type == null:
		label_three.visible = false
		
	if action.swap == null:
		label_four.visible = false
	elif action.swap == ACTION_RANGE.ALLY:
		label_four.text = "Swap with Ally"
	else:
		label_four.text = "Force Swap Foe"
		
	if action.status_effect == null:
		label_five.visible = false
	elif action.status_effect == STATUS_EFFECT.BLEED:
		label_five.text = "Apply Bleeding"
	else:
		label_five.text = "Apply Paralysis"
		
#func _set_ai_action():
#	if game_manager.get_team_a_turn():
#		return
#
#	label_one.visible = true
#
#	var ai_action_user_target = ai.get_ai_action_user_target()
#
#	var action_name = ai_action_user_target.action.action_name
#	var user_name = ai_action_user_target.user.name
#	var target_name = ai_action_user_target.targets[0].name
#
#	var text = user_name + ' used ' + action_name;
#
#	if ai_action_user_target.targets.size() == 1:
#		text = text + ' on ' + target_name;
#
#	label_one.text = text
