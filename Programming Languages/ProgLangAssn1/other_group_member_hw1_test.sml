(*names removed*)
use "group_hw1.sml";

(*test for one day older than*)
fun is_older1()=
	let
		val older_test1 = (1234,12,11)
		val older_test2 = (1234,12,12)
	in
		is_older(older_test1,older_test2) = true
	end


fun is_older2()=
	let
		val older_test1 = (1234,12,12)
		val older_test2 = (1234,12,12)
	in
		is_older(older_test1, older_test2) = false
	end

fun is_older3()=
	let
		val older_test1 = (1234,12,12)
		val older_test2 = (1234,12,11)
	in
		is_older(older_test1, older_test2) = false
	end

fun is_older4()=
	let
		val older_test1 = (1234,11,12)
		val older_test2 = (1234,12,12)
	in
		is_older(older_test1,older_test2) = true
	end


fun is_older5()=
	let
		val older_test1 = (1234,12,12)
		val older_test2 = (1234,11,12)
	in
		is_older(older_test1, older_test2) = false
	end

fun is_older6()=
	let
		val older_test1 = (1233,12,12)
		val older_test2 = (1234,12,12)
	in
		is_older(older_test1,older_test2) = true
	end


fun is_older7()=
	let
		val older_test1 = (1234,12,12)
		val older_test2 = (1233,12,12)
	in
		is_older(older_test1, older_test2) = false
	end



fun number_in_month1()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 1
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month2()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 2
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month3()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 3
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month4()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 4
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month5()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 5
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month6()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 6
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month7()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 7
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month8()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 8
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month9()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 9
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month10()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 10
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month11()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 11
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month12()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 12
	in
		number_in_month(number_in_test1, number_in_test2) = 1
	end

fun number_in_month13()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 13
	in
		number_in_month(number_in_test1, number_in_test2) = 0
	end

fun number_in_month14()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 0
	in
		number_in_month(number_in_test1, number_in_test2) = 0
	end

fun number_in_month15()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,1,12),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = 1
	in
		number_in_month(number_in_test1, number_in_test2) = 2
	end


fun number_in_months1()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1234,3,13),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val number_in_test2 = [1,2,3,4,5,6,7,8,9,10,11,12] : int list
	in
		number_in_months(number_in_test1, number_in_test2) = 12
	end

fun number_in_months2()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1235,2,13),(1236,2,13),(1237,2,13),(1238,2,13), (1239,2,13),(1240,2,13),(1241,2,13),(1242,2,13),(1243,2,13),(1244,2,13)] : (int * int * int) list
		val number_in_test2 = [1,3,4,5,6,7,8,9,10,11,12] : int list
	in
		number_in_months(number_in_test1, number_in_test2) = 1
	end

fun number_in_months3()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1235,2,13),(1236,2,13),(1237,2,13),(1238,2,13), (1239,2,13),(1240,2,13),(1241,2,13),(1242,2,13),(1243,2,13),(1244,2,13)] : (int * int * int) list
		val number_in_test2 = [2,3,4,5,6,7,8,9,10,11,12] : int list
	in
		number_in_months(number_in_test1, number_in_test2) = 11
	end

fun number_in_months4()=
	let 
		val number_in_test1 = [(1234,1,13),(1234,2,13),(1235,2,13),(1236,2,13),(1237,2,13),(1238,2,13), (1239,2,13),(1240,2,13),(1241,2,13),(1242,2,13),(1243,2,13),(1244,2,13)] : (int * int * int) list
		val number_in_test2 = [3,4,5,6,7,8,9,10,11,12] : int list
	in
		number_in_months(number_in_test1, number_in_test2) = 0
	end

fun number_in_months5()=
	let 
		val number_in_test1 = [(1233,2,13),(1234,2,13),(1235,2,13),(1236,2,13),(1237,2,13),(1238,2,13), (1239,2,13),(1240,2,13),(1241,2,13),(1242,2,13),(1243,2,13),(1244,2,13)] : (int * int * int) list
		val number_in_test2 = [2,3,4,5,6,7,8,9,10,11,12] : int list
	in
		number_in_months(number_in_test1, number_in_test2) = 12
	end


fun dates_in_month1()=
	let 
		val dates_in_test1 = [(1234,1,13),(1234,1,12),(1234,1,14),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val dates_in_test2 = 1
	in
		dates_in_month(dates_in_test1, dates_in_test2) = [(hd dates_in_test1)]@[hd(tl dates_in_test1)]@[hd(tl(tl dates_in_test1))]
	end

fun dates_in_month2()=
	let 
		val dates_in_test1 = [(1234,1,13),(1234,1,12),(1234,1,14),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val dates_in_test2 = 1
	in
		dates_in_month(rev dates_in_test1, dates_in_test2) = rev ([(hd dates_in_test1)]@[hd(tl dates_in_test1)]@[hd(tl(tl dates_in_test1))])
	end


fun dates_in_months1()=
	let 
		val dates_in_test1 = [(1234,1,13),(1234,1,12),(1234,1,14),(1234,4,13),(1234,5,13),(1234,6,13), (1234,7,13),(1234,8,13),(1234,9,13),(1234,10,13),(1234,11,13),(1234,12,13)] : (int * int * int) list
		val dates_in_test2 = [1,4]
	in
		dates_in_months(dates_in_test1, dates_in_test2) = [(hd dates_in_test1)]@[hd(tl dates_in_test1)]@[hd(tl(tl dates_in_test1))]@[hd(tl(tl(tl dates_in_test1)))]
	end


fun test_is_older()=
	is_older1() 
	andalso is_older2() 
	andalso is_older3()
	andalso is_older4() 
	andalso is_older5()
	andalso is_older6() 
	andalso is_older7()

fun test_number_in_month()=
	number_in_month1()
	andalso number_in_month2()
	andalso number_in_month3()
	andalso number_in_month4()
	andalso number_in_month5()
	andalso number_in_month6()
	andalso number_in_month7()
	andalso number_in_month8()
	andalso number_in_month9()
	andalso number_in_month10()
	andalso number_in_month11()
	andalso number_in_month12()
	andalso number_in_month13()
	andalso number_in_month14()
	andalso number_in_month15()

fun test_number_in_months()=
	number_in_months1()
	andalso number_in_months2()
	andalso number_in_months3()
	andalso number_in_months4()
	andalso number_in_months5()

fun test_dates_in_month()=
	dates_in_month1()
	andalso dates_in_month2()

fun test_dates_in_months()=
	dates_in_months1()
	

fun test_all()=
	test_is_older()
	andalso test_number_in_month()
	andalso test_number_in_months()
	andalso test_dates_in_month()
	andalso test_dates_in_months()
