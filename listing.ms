objList = #()
for i in objects do (append objList i.name)
rollout a "Copy object around"
(
	dropdownlist itemSelect "Cloning object " items: objList
	dropdownlist itemSelectAround "Central object " items: objList
	group "Cloning parameters"
	(
		spinner copiesNum "Number of clones: " type:#integer align:#center
		label l "Type of Clone" align:#left
		radiobuttons typeCopySelect labels:#("copy", "instance", "reference") align:#center
	)
		spinner angleV "Rotation angle: " type:#float align:#center
	group "Axis"
	(
		radiobuttons axisButt labels:#("X", "Y", "Z") 
	)
	button placeBtn "Copy around"
	
	function moveAndRotate cloneC angleC axisC axisRotateC=
	(
		select cloneC
		pickedAngle = angleC
		q = quat angleC axisC
		about axisRotateC rotate cloneC q
	)
	
	on placeBtn pressed do
	(
		pickedObject = getNodeByName itemSelect.selected
		pickedAround = getNodeByName itemSelectAround.selected
		CenterPivot pickedAround
		axisRotate = pickedAround.pivot
		
		axis = [0,0,0]
		pickedAxis = axisButt.state
		axis[pickedAxis] = 1
		
		pickedNumClones = copiesNum.value
		select pickedObject
		
		for i=1 to pickedNumClones do
		(
			case of
			(
				1: maxOps.cloneNodes selection cloneType:#copy newNodes:&nnl
				2: maxOps.cloneNodes selection cloneType:#instance newNodes:&nnl
				3: maxOps.cloneNodes selection cloneType:#reference newNodes:&nnl
				default: maxOps.cloneNodes selection cloneType:#reference newNodes:&nnl
			)
			moveAndRotate nnl angleV.value axis axisRotate
			pickedObject = getNodeByName nnl[1].name
			select pickedObject
		)
		DestroyDialog a
	)
)
createDialog a 300 300
