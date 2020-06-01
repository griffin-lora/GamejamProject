class_name LevelData

var objects = []
var path_points = []

func encode():
	var data = {}
	data.objects = []
	data.path_points = []
	for object in objects:
		data.objects.append(object)
	for pp in path_points:
		data.path_points.append(pp) # hahaha funny im comedic
	return Marshalls.utf8_to_base64(JSON.print(data))
	
# this is not a contained function
func decode():
	pass
