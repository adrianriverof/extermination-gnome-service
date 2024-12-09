extends Node2D

var loader = null
var loaded_level = null
var is_loading = true  # Bandera para verificar si la carga ha finalizado.



export var platform_web = false
export var platform_desktop = false


func _ready():
	Engine.time_scale = 1
	iniciar_precarga()
	$lepixeltapar.visible = true
	
	if platform_web:
		$ExitButton.disabled = true
		$elements/Exit.visible = false
	if platform_desktop:
		$ExitButton.disabled = false
		$elements/Exit.visible = true
	

func iniciar_sonido():
	$AudioStreamPlayer.play()

func iniciar_precarga():
	print("Iniciando la precarga del nivel...")
	loader = ResourceLoader.load_interactive("res://levels/level_2.tscn")
	if loader:
		set_process(true)  # Activa el procesamiento para verificar la carga.
	else:
		print("Error al iniciar la precarga del nivel.")

func _process(delta):
	if loader and is_loading:
		var status = loader.poll()
		if status == OK:
			# Opcional: Puedes actualizar una barra de progreso aquí.
			pass
		elif status == ERR_FILE_EOF:
			print("Nivel cargado exitosamente.")
			loaded_level = loader.get_resource()
			loader = null
			is_loading = false  # Marca la carga como finalizada.
			set_process(false)
			
			
			$AnimationPlayer.play("intro")
			$lepixeltapar.visible = false

func go_to_level():
	if is_loading:
		print("El nivel aún no está completamente cargado. Espera...")
	elif loaded_level:
		print("Transicionando al nivel.")
		get_tree().change_scene_to(loaded_level)
	else:
		print("Hubo un problema con la carga. No se puede cambiar al nivel.")

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		go_to_level()

func _on_Button_button_down():
	go_to_level()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro":
		$AnimationPlayer.play("idle")
	if anim_name == "idle":
		$AnimationPlayer.play("idle")


func _on_Button_mouse_entered():
	$elements/Play/playanimation.play("move")




func _on_Button_mouse_exited():
	$elements/Play/playanimation.play_backwards("move")


func _on_ExitButton_button_down():
	get_tree().quit()
	




func _on_ExitButton_mouse_entered():
	$elements/Exit/exitanimation.play("move")

func _on_ExitButton_mouse_exited():
	$elements/Exit/exitanimation.play_backwards("move")





