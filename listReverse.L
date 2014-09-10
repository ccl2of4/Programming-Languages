fun list_concat with l1,l2 =
	if isNil l1 then
		l2
	else
		!l1@(cat #l1 l2)
in

fun list_reverse with l,m =
	if isNil l then
		m
	else
		let new_m = !l@m in
		let new_l = #l in
		(list_reverse new_l new_m)
in

let _ = (print 1@2@3@4@5) in
(list_reverse 1@2@3@4@5 nil)