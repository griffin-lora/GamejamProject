class_name LevelData

var objects = []
var path_points = [
	Vector2(32, 960),
	Vector2(640, 960)
]
var theme := 0

func deep_copy(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v

func encode():
	var data = {}
	data.objects = []
	data.path_points = []
	data.theme = theme
	for object in objects:
		var object_data = deep_copy(object)
		var i = 0
		for property in object_data.properties:
			if typeof(property) == TYPE_VECTOR2:
				object_data.properties[i] = ["V2", property.x, property.y]
			i += 1
		data.objects.append(object_data)
	for pp in path_points:
		data.path_points.append([pp.x, pp.y]) # hahaha funny im comedic
	print(data)
	return Marshalls.utf8_to_base64(JSON.print(data))
	
# this is not a contained function
func decode(d_base64):
	objects.clear()
	path_points.clear()
	var data = JSON.parse(Marshalls.base64_to_utf8(d_base64)).result
	for object_data in data.objects:
		var object = {}
		object.id = object_data.id
		object.properties = []
		for property in object_data.properties:
			if typeof(property) == TYPE_ARRAY and property[0] == "V2":
				object.properties.append(Vector2(property[1], property[2]))
			else:
				object.properties.append(property)
		objects.append(object)
	for pp_data in data.path_points:
		path_points.append(Vector2(pp_data[0], pp_data[1]))
	theme = data.theme
