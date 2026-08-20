@tool
extends EditorPlugin

const OUTPUT_DIR := "res://resources/upgrades/"
const UpgradeResource = preload("uid://bfwj1umkaiq4")
const UPGRADE_TREE = preload("uid://jfst705qhd8s")
const UPGRADE_TREE_NODE = preload("uid://bgxgqpb6bvmuc")

var import_button: Button

func _enter_tree() -> void:
	import_button = Button.new()
	import_button.text = "Import CSV"
	import_button.tooltip_text = "Import upgrades from a CSV file"
	import_button.pressed.connect(_on_import_pressed)
	add_control_to_container(CONTAINER_TOOLBAR,import_button)

func _exit_tree() -> void:
	if import_button:
		remove_control_from_container(CONTAINER_TOOLBAR,import_button)
		import_button.queue_free()
		

func _on_import_pressed() -> void:
	var dialog := EditorFileDialog.new()
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	dialog.access = EditorFileDialog.ACCESS_RESOURCES
	dialog.add_filter("*.csv", "CSV Files")
	dialog.title = "Select Upgrade CSV"
	dialog.file_selected.connect(_csv_selected)
	add_child(dialog)
	dialog.popup_centered_ratio(0.7)

func _csv_selected(path: String) -> void:
	import_csv(path)

func import_csv(csv_path: String) -> void:
	var file := FileAccess.open(csv_path, FileAccess.READ)

	if file == null:
		push_error("Could not open CSV: " + csv_path)
		return

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://resources/upgrades/"))

	var headers := file.get_csv_line()

	while not file.eof_reached():
		var row := file.get_csv_line()
		if row.is_empty():
			continue
		if row.size() < headers.size():
			push_warning("Skipping invalid row")
			continue

		var data := {}

		for i in headers.size():
			data[headers[i]] = row[i]

		create_upgrade(data)
		
	file.close()

	print("CSV import finished!")

	EditorInterface.get_resource_filesystem().scan()
	create_nodes()


func create_upgrade(data: Dictionary) -> void:
	var resource := UpgradeResource.new()

	resource.id = data["id"]
	resource.display_name = data["name"]
	resource.description = data["description"]

	resource.of_type_unlock = (
		data["of_type_unlock"].strip_edges().to_lower() == "yes"
	)

	resource.value = float(data["value"])

	resource.value_display_type = (
		data["value_diplay_type"]
	)

	resource.orb_cost = int(data["orb_cost"])

	resource.increment_update = (
		data["increment_update"].strip_edges().to_lower() == "yes"
	)

	resource.increment_max_value = float(
		data["increment_max_value"]
	)

	resource.current_increment = float(
		data["current_increment"]
	)

	var children = data["children"].strip_edges()

	if children.is_empty() or children == "[empty]":
		resource.children = []
	else:
		resource.children = children.split(",")

	var resource_name = data["resource_name"]

	var path = (
		"res://resources/upgrades/"
		+ resource_name
		+ ".tres"
	)

	var error := ResourceSaver.save(resource, path)

	if error != OK:
		push_error(
			"Failed to create: " + path
		)
	else:
		print("Created: " + path)


func create_nodes():
	var resources = DirAccess.get_files_at(OUTPUT_DIR)
	
	# Instantiate the UpgradeTree scene
	var upgrade_tree = UPGRADE_TREE.instantiate()
	
	# Find the "Nodes" child
	var nodes_parent = upgrade_tree.get_node("Nodes")
	
	for resource_file in resources:
		var node = UPGRADE_TREE_NODE.instantiate()
		
		node.name = resource_file.get_basename()
		node.upgrade_data = load(OUTPUT_DIR + "/" + resource_file)
		
		nodes_parent.add_child(node)
		node.owner = upgrade_tree
	
	# Add UpgradeTree to the currently edited scene
	var edited_scene = EditorInterface.get_edited_scene_root()
	
	if edited_scene:
		edited_scene.add_child(upgrade_tree)
		upgrade_tree.owner = edited_scene
