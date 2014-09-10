fun printGrades with students = 
	if isNil #students then
		0
	else
		let student = !students in
		let average = !student in
		let name = !#student in
		let _ = print name in
		let _ = print average in
		(printGrades #students)
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

let x = (print "Please enter the number of assignments:") + readInt in
	fun main with n,l = 
		if n=0 then 
			let sum = (sumList l 0) in
			if sum <> 100
				then (print "Weights do not add up to 100")
			else
				(collectGrades "" l 0 l "")
		else
			let _ = (print "Please enter a weight:") in
			let newlist = readInt@l in
			(main(n-1) newlist) in
	(main x "")