fun printGrades with students = 
	if isNil #students then
		0
	else
		let currentMax = (getHighest students 0) in
		let newStudents = (PrintAndRemoveFromList currentMax "" students "") in
		(printGrades newStudents)
in
fun PrintAndRemoveFromList with max, temp, students, orderedPair =
	if isNil #students then
		let _ = print !orderedPair in
		let _ = print !#orderedPair in
		temp
	else
		if(!!students=max) then
			let newOrderedPair = !students in
			let newStudents = #students in
			(PrintAndRemoveFromList 101 temp newStudents newOrderedPair)
		else
			let newTemp = !students@temp in
			let newStudents = #students in
			(PrintAndRemoveFromList max newTemp newStudents orderedPair)
in
fun getHighest with students,currentMax =
	if isNil #students then
		currentMax
	else
		let newMax =
		if !!students>currentMax then
			!!students
		else
			currentMax
			in
		(getHighest #students newMax)
in
fun getStudents with weights,students =
		let _ = (print "Do you want to add another student?") in
		let add = readInt in
		if add=1 then
			(collectGrades "" weights 0 weights students)
		else
			(printGrades students)
in
fun collectGrades with student,weights,average,finalWeights,finalStudents =
		if isNil #student then
			let _ = (print "Please enter the name of the student:") in
			let studentName = readString@student in
			(collectGrades studentName weights average finalWeights finalStudents)
		else
			if isNil #weights then
				let newStudents = ((average/100)@student)@finalStudents in

				(getStudents finalWeights newStudents)
			else
				let _ = (print "Please enter a grade of the student:") in
				let currentGrade = readInt in
				if currentGrade < 0 then
					let _ = (print "input out of range") in
					(collectGrades student weights average finalWeights finalStudents)
				else if currentGrade > 100 then
					let _ = (print "input out of range") in
					(collectGrades student weights average finalWeights finalStudents)
				else
				let currentWeight = !weights in
				let currentAverage = average + currentGrade*currentWeight in
				(collectGrades student #weights currentAverage finalWeights finalStudents)
in
fun sumList with l,sum = 
		if isNil #l 
			then sum
		else
			let newSum = sum+!l in
			(sumList #l newSum)
in
fun main with n,l = 
	if n=0 then 
		let sum = (sumList l 0) in
		if sum <> 100
			then (print "Weights do not add up to 100")
		else
			(collectGrades "" l 0 l "")
	else
		let _ = (print "Please enter a weight:") in
		let currentWeight = readInt in
		if currentWeight < 0 then
			let _ = (print "input out of range") in
			(main n l)
		else if currentWeight > 100 then
			let _ = (print "input out of range") in
			(main n l)
		else
		let newlist = currentWeight@l in
		(main(n-1) newlist) 
in
let _ = (print "Please enter the number of assignments:") in
let x = readInt in (main x "")
