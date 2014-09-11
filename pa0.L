fun printGrades with students = 
	let _ = (print students) in
	if isNil #students then
		print "what am i"
	else
		(printHighest students 0)
	in

fun PrintAndRemoveFromList with temp, students, max, orderedPair =
	let newTemp = temp in
	let newStudents = students in
	if isNil students then 
		let _ = print !orderedPair in
		let _ = print !#orderedPair in
		let _ = print temp in
		(printGrades temp)
	else
		if(!!students=max) then
			let newOrderedPair = !students in
			(PrintAndRemoveFromList newTemp #newStudents 101 newOrderedPair)
		else
			let newTemp = !students@newTemp in
			(PrintAndRemoveFromList newTemp #newStudents max orderedPair)
in

fun printHighest with students = 
	let currentMax = (getHighest students 0) in
	(PrintAndRemoveFromList "" students currentMax "")
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

fun addStudent with students, student, l, r =
	if isNil #student then
		students
	else
		if (isNil #r) then
			if isNil #l then
				let newL = student@"" in
				(addStudent newL "" "" "")
			else
				let newL = l@student@"" in
				(addStudent newL "" "" "")
		else
			if !student > !!r then
				if isNil #l then
					let newL = student@r in
					(addStudent newL "" "" "")
				else 
					let newL = l@student@r in
					(addStudent newL "" "" "")
			else
				if isNil #l then
					let newL = !r in
					let newR = #r in
					(addStudent students student newL newR)
				else
					let _ = print l@!r in
					let newL = l@!r in
					let newR = #r in
					(addStudent students student newL newR)
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
			(main(n-1) newlist) in
let _ = (print "Please enter the number of assignments:") in
let x = readInt in
	(main x "")
