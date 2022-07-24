extends Node2D

onready var accept
onready var select
onready var cancel
onready var not_allowed
onready var hit
onready var swap

onready var fireball
onready var fireblitz
onready var bonfire

onready var natural_remedy
onready var sticky_seeds
onready var bamboo_bash

onready var icicle_drop
onready var healing_pulse
onready var swift_surf

func _ready():
	accept = get_node("Accept")
	select = get_node("Select")
	cancel = get_node("Cancel")
	not_allowed = get_node("NotAllowed")
	hit = get_node("Hit")
	swap = get_node("Swap")
	
	fireball = get_node("Fireball")
	fireblitz = get_node("Fireblitz")
	bonfire = get_node("Bonfire")
	
	natural_remedy = get_node("NaturalRemedy")
	sticky_seeds = get_node("StickySeeds")
	bamboo_bash = get_node("BambooBash")
	
	icicle_drop = get_node("IcicleDrop")
	healing_pulse = get_node("HealingPulse")
	swift_surf = get_node("SwiftSurf")
	
func play_accept():
	accept.play()
	
func play_select():
	select.play()
	
func play_cancel():
	cancel.play()
	
func play_hit():
	hit.play()
	
func play_swap():
	swap.play()
	
func play_fireball():
	fireball.play()
	
func play_fireblitz():
	fireblitz.play()
	
func play_bonfire():
	bonfire.play()
	
func play_natural_remedy():
	natural_remedy.play()
	
func play_sticky_seeds():
	sticky_seeds.play()
	
func play_bamboo_bash():
	bamboo_bash.play()
	
func play_icicle_drop():
	icicle_drop.play()
	
func play_healing_pulse():
	healing_pulse.play()
	
func play_swift_surf():
	swift_surf.play()
	
func play_not_allowed():
	not_allowed.play()
