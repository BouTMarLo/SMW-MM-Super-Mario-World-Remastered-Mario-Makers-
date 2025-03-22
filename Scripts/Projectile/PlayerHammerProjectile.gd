class_name PlayerHammer
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite

@export var can_damage_enemies := true
var player: Player = null
var speed := 50
var direction = 1

func _ready() -> void:
	if is_instance_valid(player):
		speed += abs(player.velocity.x * 0.75)
	sprite.scale.x = -direction
	if Input.is_action_pressed(CoopManager.get_player_input_str("move_up", player.player_id)):
		velocity.y = -200
	else:
		velocity.y = -100

func _physics_process(delta: float) -> void:
	sprite.rotation_degrees += (30 * direction) * delta
	velocity.x = speed * direction
	velocity.y += 5
	velocity.y = clamp(velocity.y, -200, 200)
	if global_position.y > 200:
		queue_free()
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	var node = area.owner
	if node is Enemy:
		if node.z_index_dependant:
			if node.z_index != z_index:
				return
		node.die()
		SoundManager.play_sfx(player.get_sfx("kick"), self)
		ParticleManager.summon_particle(ParticleManager.PUFF_SPR, global_position)
