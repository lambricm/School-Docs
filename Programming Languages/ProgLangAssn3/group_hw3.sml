(*
	names removed
*)

use "utility.sml";

fun multiples(m,n) = 
	map((fn (x) => n*x),(1--m))
	
(*note: op+ adds the accumulator and the map element*)
fun sumTo(n) =
	List.foldl op+ (real(0)) (map((fn (x) => (real(1)) / (real(x))),(1--n)))

(*note: op+ adds the accumulator and the map element*)
fun numNegative(lst) =
	List.foldl op+ 0 (map((fn(x) => 1),filter((fn (x) => x < 0),lst)))
	
fun allPairs(m,n) =
	List.foldl (fn (x,y) => y@x) [] (map(fn(x) => map(fn(y) => (x,y),1--n),1--m))

fun capitals_only(lst) = 
	filter((fn (x) => String.sub(x,0) = Char.toUpper(String.sub(x,0))),lst)