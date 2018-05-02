(* names removed *)
use "group_hw1.sml";

fun get_nth1 () =
	let 
		val nth_test = ["one","two","three","four","five","six","seven"]
	in
		get_nth(nth_test,1) = "one"
	end


fun get_nth2 () =
	let 
		val nth_test = ["one","two","three","four","five","six","seven"]
	in
		get_nth(nth_test,5) = "five"
	end

	
fun get_nth3 () =
	let 
		val nth_test = ["one","two","three","four","five","six","seven"]
	in
		get_nth(nth_test,7) = "seven"
	end

fun date_to_string1() =
	let 
		val date = (3894,1,1)
	in
		date_to_string(date) = "January 1, 3894"
	end

fun date_to_string2() =
	let 
		val date = (2903,12,12)
	in
		date_to_string(date) = "December 12, 2903"
	end

fun date_to_string3() =
	let 
		val date = (1390,10,5)
	in
		date_to_string(date) = "October 5, 1390"
	end

fun number_before_reaching_sum1() = 
	let
		val sum = 35
		val sequence = [3,15,25,67]
	in
		number_before_reaching_sum(sum,sequence) = 2
	end

fun number_before_reaching_sum2() = 
	let
		val sum = 27
		val sequence = [1,390]
	in
		number_before_reaching_sum(sum,sequence) = 1
	end

fun number_before_reaching_sum3() = 
	let
		val sum = 35
		val sequence = []
	in
		number_before_reaching_sum(sum,sequence) = 0
	end

fun what_month1() = 
	let
		val day = 1
	in
		what_month(day) = 1
	end

fun what_month2() = 
	let
		val day = 362
	in
		what_month(day) = 12
	end

fun what_month3() = 
	let
		val day = 23454352
	in
		what_month(day) = 0
	end

fun month_range1() = 
	let
		val day1 = 1
		val day2 = 365
	in
		length (month_range(day1,day2)) = 365
	end

fun month_range2() = 
	let
		val day1 = 1
		val day2 = 1
	in
		month_range(day1,day2) = [1]

	end

fun month_range3() = 
	let
		val day1 = 365
		val day2 = 365
	in
		month_range(day1,day2) = [12]
	end

fun month_range4() = 
	let
		val day1 = 365
		val day2 = 364
	in
		length (month_range(day1,day2)) = 0
	end

fun test_all() = 
	get_nth1()
	andalso get_nth2()
	andalso get_nth3()
	andalso date_to_string1()
	andalso date_to_string2()
	andalso date_to_string3()
	andalso number_before_reaching_sum1()
	andalso number_before_reaching_sum2()
	andalso number_before_reaching_sum3()
	andalso what_month1()
	andalso what_month2()
	andalso what_month3()
	andalso month_range1()
	andalso month_range2()
	andalso month_range3()
	andalso month_range4()
