extends Control

var chemical_names = [
	"polyethylene", "acetaminophen", "ibuprofen", "aspirin", "caffeine", "glucose", 
	"fructose", "sucrose", "lactose", "maltose", "galactose", "ribose", "deoxyribose", 
	"adenine", "guanine", "cytosine", "thymine", "uracil", "methane", "ethane", 
	"propane", "butane", "pentane", "hexane", "heptane", "octane", "nonane", 
	"decane", "benzene", "toluene", "xylene", "phenol", "aniline", "pyridine", 
	"quinoline", "naphthalene", "anthracene", "methanol", "ethanol", "propanol", 
	"butanol", "glycerol", "formaldehyde", "acetaldehyde", "acetone", "ethyl", 
	"diethyl", "chloroform", "carbon", "dichloromethane", "trichloroethylene", 
	"perchloroethylene", "vinyl", "styrene", "acrylonitrile", "butadiene", 
	"isoprene", "neoprene", "polystyrene", "polypropylene", "polyvinyl", 
	"polyethylene", "terephthalate", "nylon", "acrylic", "polyurethane", 
	"epoxy", "phenolic", "melamine", "urea", "thiourea", "guanidine", 
	"creatine", "creatinine", "nitrogen", "ammonia", "hydrazine", "hydroxylamine", 
	"nitric", "nitrous", "dioxide", "tetroxide", "sodium", "potassium", 
	"ammonium", "calcium", "barium", "silver", "mercury", "copper", 
	"zinc", "iron", "aluminum", "magnesium", "lithium", "cesium", 
	"rubidium", "strontium", "radium", "uranium", "thorium", "plutonium"
]

var section_headers = ["ACTIVE INGREDIENT", "USES", "WARNINGS", "DIRECTIONS", "DO NOT USE", "INACTIVE INGREDIENTS", "OTHER INFORMATION", "DRUG FACTS"]

var active_ingredients = [
	"acetaminophen 500mg pain reliever fever reducer",
	"ibuprofen 200mg nonsteroidal anti inflammatory drug pain reliever fever reducer", 
	"aspirin 325mg pain reliever fever reducer",
	"diphenhydramine HCl 25mg antihistamine sleep aid",
	"dextromethorphan HBr 15mg cough suppressant"
]

var uses_list = [
	"temporarily relieves minor aches and pains due to the common cold headache backache minor pain of arthritis toothache muscular aches premenstrual and menstrual cramps temporarily reduces fever",
	"temporarily relieves runny nose sneezing itchy watery eyes itchy throat or nose due to hay fever or other upper respiratory allergies",
	"for the temporary relief of occasional sleeplessness reduces time to fall asleep if you have difficulty falling asleep",
	"temporarily relieves cough due to minor throat and bronchial irritation as may occur with a cold"
]

var warnings_list = [
	"liver warning this product contains acetaminophen severe liver damage may occur if you take more than 4000 mg of acetaminophen in 24 hours with other drugs containing acetaminophen 3 or more alcoholic drinks every day while using this product",
	"allergy alert ibuprofen may cause a severe allergic reaction especially in people allergic to aspirin symptoms may include hives facial swelling asthma shock skin reddening rash blisters",
	"do not exceed recommended dosage drowsiness may occur avoid alcoholic beverages while taking this product do not take this product if you are taking sedatives or tranquilizers without first consulting your doctor",
	"stomach bleeding warning this product contains an NSAID which may cause severe stomach bleeding the chance is higher if you are age 60 or older have had stomach ulcers or bleeding problems"
]

var directions_list = [
	"adults and children 12 years and over take 2 caplets every 6 hours while symptoms last children under 12 years ask a doctor do not take more than 6 caplets in 24 hours unless directed by a doctor",
	"adults and children 12 years and over 1 to 2 tablets every 4 to 6 hours while symptoms persist if pain or fever does not respond to 1 tablet 2 tablets may be used do not exceed 6 tablets in 24 hours",
	"adults and children 12 years and over take 1 tablet at bedtime if needed or as directed by a doctor children under 12 years do not use",
	"adults and children 12 years and over 2 teaspoons every 4 hours children 6 to under 12 years 1 teaspoon every 4 hours children under 6 years ask a doctor do not exceed 6 doses per day"
]

var inactive_ingredients_list = [
	"carnauba wax FD&C red no 40 aluminum lake FD&C yellow no 6 aluminum lake hypromellose corn starch magnesium stearate polyethylene glycol polysorbate 80 powdered cellulose pregelatinized starch purified water sodium starch glycolate sucralose titanium dioxide polypropylene capsule coating",
	"croscarmellose sodium FD&C blue no 1 aluminum lake hypromellose magnesium stearate microcrystalline cellulose polyethylene glycol polysorbate 80 povidone pregelatinized starch sodium lauryl sulfate titanium dioxide polypropylene film coating",
	"anhydrous lactose colloidal silicon dioxide corn starch crospovidone magnesium stearate microcrystalline cellulose povidone pregelatinized starch sodium starch glycolate stearic acid polypropylene tablet coating"
]

var scroll_speed = 30.0  
var line_height = 22.0
var font_size = 16
var rotation_angle = -5.0  
var line_width = 1.4  
var word_spacing = " "  

var normal_color = Color(0.5, 0.5, 0.5, 0.8)  
var highlight_color = Color(1.0, 1.0, 1.0, 1.0)  

var scroll_offset = 0.0
var text_lines = []
var font = null

var content_offset = 0.0  
var min_content_buffer = 2000.0  

func _ready():

	mouse_filter = Control.MOUSE_FILTER_IGNORE

	font = load("res://fonts/NewScienceMonoTRIAL-SemiBold.otf")

	if font == null:
		print("Failed to load custom font, using fallback")
		font = ThemeDB.fallback_font
	else:
		print("Custom font loaded successfully")

	generate_text_lines()

func generate_random_prescription_section():
	var section_type = section_headers[randi() % section_headers.size()]
	var content = ""

	match section_type:
		"ACTIVE INGREDIENT":
			content = section_type + " in each caplet " + active_ingredients[randi() % active_ingredients.size()]
		"USES":
			content = section_type + " " + uses_list[randi() % uses_list.size()]
		"WARNINGS":
			content = section_type + " " + warnings_list[randi() % warnings_list.size()]
		"DIRECTIONS":
			content = section_type + " " + directions_list[randi() % directions_list.size()]
		"DO NOT USE":
			content = section_type + " with any other drug containing acetaminophen prescription or nonprescription if you are not sure whether a drug contains acetaminophen ask a doctor or pharmacist if you are allergic to acetaminophen or any of the inactive ingredients in this product"
		"INACTIVE INGREDIENTS":
			content = section_type + " " + inactive_ingredients_list[randi() % inactive_ingredients_list.size()]
		"OTHER INFORMATION":
			content = section_type + " store between 20 25 degrees celsius do not use if neck band or foil inner seal imprinted with product name is broken or missing"
		"DRUG FACTS":
			content = section_type + " " + active_ingredients[randi() % active_ingredients.size()] + " " + uses_list[randi() % uses_list.size()]

	return content

var content_items = []
var floating_boxes = []  

func generate_text_lines():
	content_items.clear()
	text_lines.clear()
	floating_boxes.clear()

	var all_chemical_text = ""
	var chemical_index = 0
	var total_chemicals_needed = 1200  

	for i in range(total_chemicals_needed):
		all_chemical_text += chemical_names[chemical_index % chemical_names.size()]
		if i < total_chemicals_needed - 1:
			all_chemical_text += " "
		chemical_index += 1

	add_text_to_lines(all_chemical_text)
	generate_floating_boxes()

	content_offset = text_lines.size() * line_height

func add_text_to_lines(text_content: String):
	var screen_width = get_viewport().size.x * line_width
	var words = text_content.split(" ")
	var current_line = ""
	var word_index = 0

	while word_index < words.size():
		var test_line = current_line
		if current_line != "":
			test_line += " "
		test_line += words[word_index]

		var text_width = font.get_string_size(test_line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

		if text_width <= screen_width * 0.85 and word_index < words.size() - 1:
			current_line = test_line
			word_index += 1
		else:
			if current_line != "":
				text_lines.append({"type": "text", "content": current_line})
			current_line = words[word_index]
			word_index += 1

	if current_line != "":
		text_lines.append({"type": "text", "content": current_line})

func generate_floating_boxes():
	var screen_width = get_viewport().size.x * line_width
	var current_content_height = text_lines.size() * line_height
	var num_boxes = randi() % 8 + 5  

	for i in range(num_boxes):

		var box_y = randf() * current_content_height  
		var is_vertical = randf() > 0.6  

		var box_width = screen_width * (0.25 + randf() * 0.15)  
		var box_height = line_height * (3 + randi() % 4)  

		if is_vertical:
			box_width = screen_width * (0.15 + randf() * 0.1)  
			box_height = line_height * (6 + randi() % 6)  

		var box_x = randf() * (screen_width - box_width)
		var prescription_text = generate_random_prescription_section()

		floating_boxes.append({
			"x": box_x,
			"y": box_y,
			"width": box_width,
			"height": box_height,
			"content": prescription_text,
			"is_vertical": is_vertical
		})

func _process(delta):
	scroll_offset += scroll_speed * delta

	var current_content_height = text_lines.size() * line_height
	var screen_height = get_viewport().size.y

	var remaining_content = current_content_height - scroll_offset
	if remaining_content < min_content_buffer:
		extend_content()

	cleanup_old_content()

	queue_redraw()

func extend_content():
	print("Extending content. Current lines: ", text_lines.size(), " Scroll offset: ", scroll_offset)

	var additional_chemicals = 600  
	var chemical_index = randi() % chemical_names.size()  
	var additional_text = ""

	for i in range(additional_chemicals):
		additional_text += chemical_names[chemical_index % chemical_names.size()]
		if i < additional_chemicals - 1:
			additional_text += " "
		chemical_index += 1

	add_text_to_lines(additional_text)
	generate_additional_floating_boxes()

	content_offset = text_lines.size() * line_height

func generate_additional_floating_boxes():
	var current_content_height = text_lines.size() * line_height
	var screen_width = get_viewport().size.x * line_width
	var new_content_start = current_content_height - (400 * line_height)  
	var num_new_boxes = randi() % 6 + 3  

	for i in range(num_new_boxes):
		var box_y = new_content_start + randf() * (400 * line_height)  
		var is_vertical = randf() > 0.6  

		var box_width = screen_width * (0.25 + randf() * 0.15)  
		var box_height = line_height * (3 + randi() % 4)  

		if is_vertical:
			box_width = screen_width * (0.15 + randf() * 0.1)  
			box_height = line_height * (6 + randi() % 6)  

		var box_x = randf() * (screen_width - box_width)
		var prescription_text = generate_random_prescription_section()

		floating_boxes.append({
			"x": box_x,
			"y": box_y,
			"content": prescription_text,
			"width": box_width,
			"height": box_height,
			"is_vertical": is_vertical
		})

func cleanup_old_content():

	var screen_height = get_viewport().size.y
	var cleanup_threshold = scroll_offset - (screen_height * 3)  

	if cleanup_threshold <= 0:
		return  

	var lines_to_remove = 0

	for i in range(text_lines.size()):
		var line_y = i * line_height
		if line_y < cleanup_threshold:
			lines_to_remove += 1
		else:
			break

	lines_to_remove = min(lines_to_remove, text_lines.size() / 4)

	if lines_to_remove > 0:
		for i in range(lines_to_remove):
			text_lines.pop_front()

		scroll_offset -= lines_to_remove * line_height

		for box in floating_boxes:
			box.y -= lines_to_remove * line_height

	var boxes_to_remove = []
	for i in range(floating_boxes.size()):
		var box = floating_boxes[i]
		if box.y + box.height < cleanup_threshold:
			boxes_to_remove.append(i)

	for i in range(boxes_to_remove.size() - 1, -1, -1):
		floating_boxes.remove_at(boxes_to_remove[i])

func _draw():
	if text_lines.is_empty():
		return

	var screen_size = get_viewport().size
	var margin = -screen_size.x * (line_width - 1.0) / 2.0  
	var start_y = -scroll_offset
	var center_x = screen_size.x / 2.0
	var center_y = screen_size.y / 2.0

	var transform = Transform2D()
	transform = transform.translated(-Vector2(center_x, center_y))
	transform = transform.rotated(deg_to_rad(rotation_angle))
	transform = transform.translated(Vector2(center_x, center_y))

	draw_set_transform_matrix(transform)

	for box in floating_boxes:
		var box_y_screen = start_y + box.y
		if box_y_screen > -box.height - 100 and box_y_screen < screen_size.y + box.height + 100:
			draw_floating_box(box, margin + box.x, box_y_screen)

	for i in range(text_lines.size()):
		var y_pos = start_y + i * line_height

		if y_pos > -line_height - 100 and y_pos < screen_size.y + line_height + 100:
			if typeof(text_lines[i]) == TYPE_DICTIONARY:
				draw_text_with_wrapping(text_lines[i], y_pos, margin, start_y)
			else:
				draw_simple_line_with_wrapping(str(text_lines[i]), y_pos, margin, start_y)

func draw_text_with_wrapping(line_item: Dictionary, y_pos: float, margin: float, start_y: float):
	var words = line_item.content.split(" ")
	var current_x = margin

	for word in words:
		var word_width = font.get_string_size(word + " ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

		var overlaps_box = false
		for box in floating_boxes:
			var box_y_screen = start_y + box.y
			var box_x_screen = margin + box.x

			if (y_pos >= box_y_screen - line_height and y_pos <= box_y_screen + box.height + line_height and
				current_x + word_width > box_x_screen and current_x < box_x_screen + box.width):
				overlaps_box = true
				current_x = box_x_screen + box.width + 10  
				break

		if not overlaps_box:
			var color = highlight_color if word == "polypropylene" else normal_color
			draw_string(font, Vector2(current_x, y_pos), word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

		current_x += word_width

func draw_simple_line_with_wrapping(line_text: String, y_pos: float, margin: float, start_y: float):
	var words = line_text.split(" ")
	var current_x = margin

	for word in words:
		var word_width = font.get_string_size(word + " ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

		var overlaps_box = false
		for box in floating_boxes:
			var box_y_screen = start_y + box.y
			var box_x_screen = margin + box.x

			if (y_pos >= box_y_screen - line_height and y_pos <= box_y_screen + box.height + line_height and
				current_x + word_width > box_x_screen and current_x < box_x_screen + box.width):
				overlaps_box = true
				current_x = box_x_screen + box.width + 10  
				break

		if not overlaps_box:
			var color = highlight_color if word == "polypropylene" else normal_color
			draw_string(font, Vector2(current_x, y_pos), word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

		current_x += word_width

func draw_floating_box(box: Dictionary, x_pos: float, y_pos: float):
	var box_color = Color(0.2, 0.2, 0.2, 0.95)  
	var border_color = Color(0.8, 0.8, 0.8, 1.0)  
	var box_text_color = Color(0.9, 0.9, 0.9, 1.0)  

	draw_rect(Rect2(x_pos, y_pos, box.width, box.height), box_color)

	var border_width = 2.0
	draw_rect(Rect2(x_pos, y_pos, box.width, border_width), border_color)  
	draw_rect(Rect2(x_pos, y_pos + box.height - border_width, box.width, border_width), border_color)  
	draw_rect(Rect2(x_pos, y_pos, border_width, box.height), border_color)  
	draw_rect(Rect2(x_pos + box.width - border_width, y_pos, border_width, box.height), border_color)  

	var content_words = box.content.split(" ")
	var padding = 8.0
	var text_x = x_pos + padding
	var text_y = y_pos + padding + font_size
	var current_x = text_x
	var current_y = text_y
	var max_width = box.width - (padding * 2)

	for word in content_words:
		var word_width = font.get_string_size(word + " ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

		if current_x + word_width > x_pos + max_width and current_x > text_x:
			current_x = text_x
			current_y += line_height

			if current_y > y_pos + box.height - padding:
				break

		var color = highlight_color if word == "polypropylene" else box_text_color
		draw_string(font, Vector2(current_x, current_y), word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
		current_x += word_width
