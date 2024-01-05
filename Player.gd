extends KinematicBody;

onready var shapesSpat = self.get_parent().get_node("Shapes")
onready var pegsSpat = self.get_parent().get_node("Pegs")

var shapes = [
	"SQ",
	"D",
	"I1",
	"I2",
	"I3",
	"T",
	"HL",
	"L",
	"S"
]

var newCollSize = Vector3(100, 1, 100)

onready var oldCollSizes = {
	"SQ": shapesSpat.get_node("SQ/SQCollider").scale,
	"D": shapesSpat.get_node("D/DCollider").scale,
	"I1": shapesSpat.get_node("I1/I1Collider").scale,
	"I2": shapesSpat.get_node("I2/I2Collider").scale,
	"I3": shapesSpat.get_node("I3/I3Collider").scale,
	"T1": shapesSpat.get_node("T/T1Collider").scale,
	"T2": shapesSpat.get_node("T/T2Collider").scale,
	"HL1": shapesSpat.get_node("HL/HL1Collider").scale,
	"HL2": shapesSpat.get_node("HL/HL2Collider").scale,
	"L1": shapesSpat.get_node("L/L1Collider").scale,
	"L2": shapesSpat.get_node("L/L2Collider").scale,
	"S1": shapesSpat.get_node("S/S1Collider").scale,
	"S2": shapesSpat.get_node("S/S2Collider").scale,
	"P": pegsSpat.get_node("P1/PCollider").scale
}

var Dice = [
	[ "B1", "B2", "A2", "A3", "C2", "B3" ],
	[ "F2", "A5", "F2", "A5", "B6", "E1" ],
	[ "E5", "E6", "D5", "E4", "F4", "F5" ],
	[ "C6", "A4", "B5", "C5", "D6", "F6" ],
	[ "D2", "A1", "C1", "D1", "E2", "F3" ],
	[ "C4", "D3", "B4", "C3", "D4", "E3" ],
	[ "F1", "A6", "F1", "A6", "A6", "F1" ]
]

onready var audios = get_node("/root/Main/Audio")

onready var drop = audios.get_node("Drop")
onready var rotate = audios.get_node("Rotate")
onready var reset = audios.get_node("Reset")
onready var diceRoll = audios.get_node("DiceRoll")

var curPiece = null

var down = false

onready var ignore = [ self ]

func _physics_process(_dt):
	if Input.is_action_pressed("click"):
		var mousePos = get_tree().root.get_mouse_position()
		
		var state = get_world().direct_space_state
		
		var origin = $Camera.project_ray_origin(mousePos)
		var end = origin + $Camera.project_ray_normal(mousePos) * 100
		
		var ray = state.intersect_ray(origin, end, ignore)
		
		if ray:
			var node = ray.collider
			
			if shapes.find(node.name) != -1:
				if node.name == shapes[0]:
					node.get_node("SQCollider").scale = newCollSize
				elif node.name == shapes[1]:
					node.get_node("DCollider").scale = newCollSize
				elif node.name == shapes[2]:
					node.get_node("I1Collider").scale = newCollSize
				elif node.name == shapes[3]:
					node.get_node("I2Collider").scale = newCollSize
				elif node.name == shapes[4]:
					node.get_node("I3Collider").scale = newCollSize
				elif node.name == shapes[5]:
					node.get_node("T1Collider").scale = newCollSize
					node.get_node("T2Collider").scale = newCollSize
				elif node.name == shapes[6]:
					node.get_node("HL1Collider").scale = newCollSize
					node.get_node("HL2Collider").scale = newCollSize
				elif node.name == shapes[7]:
					node.get_node("L1Collider").scale = newCollSize
					node.get_node("L2Collider").scale = newCollSize
				elif node.name == shapes[8]:
					node.get_node("S1Collider").scale = newCollSize
					node.get_node("S2Collider").scale = newCollSize
				
				node.transform.origin = (Vector3(ray.position.x, 1, ray.position.z))
				
				curPiece = node
				
				for p in shapesSpat.get_children():
					if p.name != curPiece.name:
						ignore.append(p)
				
				for p in pegsSpat.get_children():
					if p.name != curPiece.name:
						ignore.append(p)
				
			elif node.name.left(1) == "P":
				node.transform.origin = (Vector3(ray.position.x, 1, ray.position.z))
				
				curPiece = node
				
				for p in shapesSpat.get_children():
					if p.name != curPiece.name:
						ignore.append(p)
				
				for p in pegsSpat.get_children():
					if p.name != curPiece.name:
						ignore.append(p)
				
				node.get_node("PCollider").scale = newCollSize
	
	if Input.is_action_just_released("click"):
		down = false
		
		if curPiece != null:
			drop.play()
			
			var curPos = curPiece.transform.origin
			
			if curPiece.name == shapes[0]:
				curPiece.get_node("SQCollider").scale = oldCollSizes[shapes[0]]
				
				curPiece.transform.origin = Vector3(round(curPos.x), 1, round(curPos.z))
			elif curPiece.name == shapes[1]:
				curPiece.get_node("DCollider").scale = oldCollSizes[shapes[1]]
				
				curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			elif curPiece.name == shapes[2]:
				curPiece.get_node("I1Collider").scale = oldCollSizes[shapes[2]]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x), 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z))
			elif curPiece.name == shapes[3]:
				curPiece.get_node("I2Collider").scale = oldCollSizes[shapes[3]]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			elif curPiece.name == shapes[4]:
				curPiece.get_node("I3Collider").scale = oldCollSizes[shapes[4]]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x), 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z))
			elif curPiece.name == shapes[5]:
				curPiece.get_node("T1Collider").scale = oldCollSizes[shapes[5] + "1"]
				curPiece.get_node("T2Collider").scale = oldCollSizes[shapes[5] + "2"]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			elif curPiece.name == shapes[6]:
				curPiece.get_node("HL1Collider").scale = oldCollSizes[shapes[6] + "1"]
				curPiece.get_node("HL2Collider").scale = oldCollSizes[shapes[6] + "2"]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			elif curPiece.name == shapes[7]:
				curPiece.get_node("L1Collider").scale = oldCollSizes[shapes[7] + "1"]
				curPiece.get_node("L2Collider").scale = oldCollSizes[shapes[7] + "2"]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
				else:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			elif curPiece.name == shapes[8]:
				curPiece.get_node("S1Collider").scale = oldCollSizes[shapes[8] + "1"]
				curPiece.get_node("S2Collider").scale = oldCollSizes[shapes[8] + "2"]
				
				if round(curPiece.rotation_degrees.y) == 90 or round(curPiece.rotation_degrees.y) == -90:
					curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z))
				else:
					curPiece.transform.origin = Vector3(round(curPos.x), 1, round(curPos.z) + 0.5)
			else:
				curPiece.get_node("PCollider").scale = oldCollSizes["P"]
				
				curPiece.transform.origin = Vector3(round(curPos.x) + 0.5, 1, round(curPos.z) + 0.5)
			
			ignore = [ self ]
			
			curPiece = null
	
	if Input.is_action_just_pressed("rotate") and curPiece != null:
		rotate.play()
		
		curPiece.rotation_degrees.y += 90
	
	if Input.is_action_just_pressed("mirror") and curPiece != null:
		rotate.play()
		
		if curPiece.name == shapes[2] or curPiece.name == shapes[3] or curPiece.name == shapes[4]:
			curPiece.rotation_degrees.y -= 90
		elif curPiece.name == shapes[5]:
			curPiece.rotation_degrees.y -= 180
		else:
			curPiece.rotation_degrees.x -= 180
	
	if Input.is_action_just_pressed("rollDice"):
		diceRoll.play(1)
		
		var d1 = Dice[0][round(rand_range(0, 5))]
		var d2 = Dice[1][round(rand_range(0, 5))]
		var d3 = Dice[2][round(rand_range(0, 5))]
		var d4 = Dice[3][round(rand_range(0, 5))]
		var d5 = Dice[4][round(rand_range(0, 5))]
		var d6 = Dice[5][round(rand_range(0, 5))]
		var d7 = Dice[6][round(rand_range(0, 5))]
		
		var outCome = d1 + " " + d2 + " " + d3 + " " + d4 + " " + d5 + " " + d6 + " " + d7
		
		self.get_parent().get_node("Boards/Dice/Viewport/Label").text = outCome
	
	if Input.is_action_pressed("reset"):
		if Input.is_action_just_pressed("yes"):
			reset.play()
			
			for s in shapesSpat.get_children():
				s.transform.origin = self.get_parent().get_node("ResetPositions/Shapes/" + s.name).transform.origin
				s.rotation_degrees = self.get_parent().get_node("ResetPositions/Shapes/" + s.name).rotation_degrees
			
			for p in pegsSpat.get_children():
				p.transform.origin = self.get_parent().get_node("ResetPositions/Pegs/" + p.name).transform.origin
		
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
