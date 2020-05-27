objList = #()

/* создание массива объектов сцены */
for i in objects do (append objList i.name)
rollout a "Copy object around"
(
	/* выбор объекта для клонирования и выбор объекта, вокруг которого клонируем */
	dropdownlist itemSelect "Cloning object " items: objList
	dropdownlist itemSelectAround "Central object " items: objList
	
	/* выбор параметров клонирования: количество копий, тип копии */
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
		/* инициализируем объекты, получая их по выбранным именам */
		pickedObject = getNodeByName itemSelect.selected
		pickedAround = getNodeByName itemSelectAround.selected
		
		/* централизируем pivot (точку опоры), чтобы вращать копию вокруг нее */
		CenterPivot pickedAround
		axisRotate = pickedAround.pivot
		
		/* инициализируем ось, вокруг которой будут размещаться копии. Например, если выбрана Х, то будет [1, 0, 0] */
		axis = [0,0,0]
		pickedAxis = axisButt.state
		axis[pickedAxis] = 1
		
		/* инициализируем количество копий */
		pickedNumClones = copiesNum.value
		select pickedObject
		
		/* в цикле создается копия в зависимости от выбранного типа, */
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
