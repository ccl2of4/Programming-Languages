fun collectGrades with student,weights,average =

		if isNil #student then
			let _ = (print "Please enter the name of the student:") in
			let studentName = readString@student in
			(collectGrades studentName weights average)
		else
			if isNil #weights then
				average/100
			else
				let _ = (print "Please enter a grade of the student:") in
				let currentGrade = readInt in
				let currentWeight = !weights in
				let currentAverage = average + currentGrade*currentWeight in
				(collectGrades student #weights currentAverage)

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
		if n=0 
			then let sum = (sumList l 0) in
			if sum <> 100
				then (print "Weights do not add up to 100")
			else
				(collectGrades "" l 0)
			else
				let _ = (print "Please enter a weight:") in
				let newlist = readInt@l in
				(main(n-1) newlist) in
		(main x "")