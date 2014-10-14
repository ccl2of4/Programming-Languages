let a = (("this" "2") "is" "list") in
let b = lambda x.x|15 in
(b a) + 3 + 5*2 + 3/2*4+3-6

---

fun foo with a,b,c,d,e,f,g = 0 in
(foo (1) (2) ((3)) (4) (5) 6 !!a@b@!!c@d)

---

(lambda a,b,c,d,e. a+b+c+d+e lambda a.lambda b.lambda c.a@b@c 2 3 4 5)

---

if isNil 0 * !!isNil 5 then #1@2 = isNil 1@2 <> 1 < 2 > 4 * 5 >= 7 - 3 + print 5 + 1@2 & 3 | 3+5+6 else 0

---

let a = if 5 then 2 else 0 in
let b = if let x = 5 in x then 0 else 1 in
let c = let w = if 5 then 0 else 3 in 0 in
let d = a + b + c in
let x = (if if 5 + 2 then 0 - 1 else !4 then if 0 then 2 else 1 else if 1 then 2 else 3 + 15) | 7
in d + x