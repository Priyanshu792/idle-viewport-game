@tool
extends EditorPlugin

const OUTPUT_DIR := "res://resources/upgrades/"
const UpgradeResource = preload("uid://bfwj1umkaiq4")


func _enter_tree() -> void:
	print("CSV Resource Importer loaded")


func _exit_tree() -> void:
	print("CSV Resource Importer unloaded")


func import_csv(csv_path: String) -> void:
	var file := FileAccess.open(csv_path, FileAccess.READ)

	if file == null:
		push_error("Could not open CSV: " + csv_path)
		return

	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(OUTPUT_DIR)
	)

	var headers := file.get_csv_line()

	while not file.eof_reached():
		var row := file.get_csv_line()

		if row.is_empty():
			continue

		if row.size() < headers.size():
			push_warning("Skipping malformed row: " + str(row))
			continue

		var data := {}

		for i in headers.size():
			data[headers[i]] = row[i]

		create_resource(data)

	file.close()

	print("CSV import complete.")


func create_resource(data: Dictionary) -> void:
	var resource = UpgradeResource.new()

	resource.id = data["id"]
	resource.display_name = data["name"]
	resource.description = data["description"]

	resource.of_type_unlock = (
		data["of_type_unlock"].strip_edges().to_lower() == "yes"
	)

	resource.value = float(data["value"])
	resource.value_display_type = data["value_diplay_type"]

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

	var children_text = data["children"].strip_edges()

	if children_text.is_empty() or children_text == "[empty]":
		resource.children = []
	else:
		resource.children = children_text.split(",")

	var filename = data["resource_name"] + ".tres"
	var output_path = OUTPUT_DIR + filename

	var error := ResourceSaver.save(resource, output_path)

	if error != OK:
		push_error(
			"Failed to save %s. Error: %s"
			% [output_path, error]
		)
	else:
		print("Created: ", output_path)
