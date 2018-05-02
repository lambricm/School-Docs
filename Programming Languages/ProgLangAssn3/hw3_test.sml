(*
	names removed
*)

use "group_hw3.sml";

fun multiples_test1()=
	multiples(3,5) = [5,10,15]

fun multiples_test2()=
	multiples(0, 5) = []

fun multiples_test3()=
	multiples(5, 0) = [0,0,0,0,0]

fun multiples_test4()=
	multiples(1, 5) = [5]

fun multiples_test5()=
	multiples(5, 1) = [1,2,3,4,5]

fun multiples_test6()=
	multiples(1, ~5) = [~5]


fun sumTo_test1()=
	Real.== (sumTo(2), 1.5)

fun sumTo_test2()=
	Real.== (sumTo(1), 1.0)

fun sumTo_test3()=
	Real.== (sumTo(3), (1.5 + 1.0/3.0))


fun numNegative_test1()=
	numNegative([5, ~7, 31, ~14, 2]) = 2

fun numNegative_test2()=
	numNegative([~5, ~7, ~31, ~14, ~2]) = 5

fun numNegative_test3()=
	numNegative([5, 7, 31, 14, 2]) = 0

fun numNegative_test4()=
	numNegative([~2]) = 1

fun numNegative_test5()=
	numNegative([2]) = 0


fun allPairs_test1()=
	allPairs(3,4) = [(1,1),(1,2),(1,3),(1,4),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4)]

fun allPairs_test2()=
	allPairs(1,1) = [(1,1)]


fun captials_only_test1()=
	capitals_only(["Charles","ted","Penelope"]) = ["Charles", "Penelope"]

fun captials_only_test2()=
	capitals_only(["charles","ted","penelope"]) = []




fun test_all()=
	multiples_test1()
	andalso multiples_test2()
	andalso multiples_test3()
	andalso multiples_test4()
	andalso multiples_test5()
	andalso multiples_test6()
	andalso sumTo_test1()
	andalso sumTo_test2()
	andalso sumTo_test3()
	andalso numNegative_test1()
	andalso numNegative_test2()
	andalso numNegative_test3()
	andalso numNegative_test4()
	andalso numNegative_test5()
	andalso allPairs_test1()
	andalso allPairs_test2()
	andalso captials_only_test1()
	andalso captials_only_test2()
