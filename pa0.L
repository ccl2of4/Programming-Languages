fun sumList with l,sum = 
		if isNil #l 
			then sum
		else
			let newSum = sum+!l in
			(sumList #l newSum) in
let x = (print "Please enter the number of assignments") + readInt in
	fun main with n,l = 
		if n=0 
			then let sum = (sumList l 0) in
			if sum <> 100
				then (print "Weights do not add up to 100")
			else
			l	 
			else
				let prompt = (print "Please enter a weight") in
				let newlist = readInt@l in
				(main(n-1) newlist) in
		(main x "")