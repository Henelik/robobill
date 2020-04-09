extends Sprite

export (int) var rot_speed = 10
export (bool) var active = false
export (Resource) var lit_sprite
export (Resource) var unlit_sprite
export (Color) var lightColor

var light
var lit = false

func _ready():
	light = get_node("light")
	light.set_modulate(lightColor)
	light.get_child(0).set_color(lightColor)
	_unlight()
	if active:
		toggle_loop(1, 1)
	
func _light():
	light.get_child(0).set_visible(true)
	light.set_texture(lit_sprite)
	lit = true
	
func _unlight():
	light.get_child(0).set_visible(false)
	light.set_texture(unlit_sprite)
	lit = false
	
func toggle_loop(lt, ut): # lit time, unlit time
	if lit:
		_unlight()
		yield(get_tree().create_timer(ut), "timeout")
	if not lit:
		_light()
		yield(get_tree().create_timer(lt), "timeout")
	if active:
		toggle_loop(lt, ut)

func _process(delta):
	if lit:
		light.rotate(rot_speed*delta)
		

