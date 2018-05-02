fun is_older (d1:int*int*int,d2:int*int*int) =
	if #1d1 > #1d2
	then false
	else if #1d1 < #1d2
	then true
	else if #2d1 > #2d2
	then false
	else if #2d1 < #2d2
	then true
	else if #3d1 > #3d2
	then false
	else if #3d1 < #3d2
	then true
	else false
	
fun number_in_month (dates:(int*int*int)list,month:int) =
	let 
		val x = 0
		fun count(dates:(int*int*int)list, month:int,num:int) =
			if null(dates)
			then num
			else if #2(hd dates) = month
			then count(tl(dates),month,num+1)
			else count(tl(dates),month,num)
	in
		count(dates,month,x)
	end

fun number_in_months(date_list : (int*int*int) list, months : int list)=
	if null months then 0
	else if null date_list then 0
	else number_in_month(date_list, hd months) + number_in_months(date_list, tl months)


fun dates_in_month(date_list : (int*int*int) list, month : int)=
	if null date_list then []
	else if (#2 (hd date_list)) = month then (hd date_list)::dates_in_month(tl date_list, month)
	else dates_in_month(tl date_list, month)


fun dates_in_months(date_list : (int*int*int) list, months : int list)=
	if null months then []
	else if null date_list then []
	else dates_in_month(date_list, hd months) @ dates_in_months(date_list, tl months)

fun get_nth(string_list : string list, n : int)=
	let 
		val distance_from_end = ((length string_list) - n)
	in
		let 
			fun check_position(s_list : string list)=
				if null s_list then hd s_list
				else if length s_list = distance_from_end + 1 then hd s_list
				else check_position(tl s_list)
		in
			if null string_list then hd string_list
			else check_position(string_list)
		end
	end

fun date_to_string(date : int*int*int)=
	let 
		val months_string_list = ["January","February","March","April","May","June","July","August","September","October","November","December"]
	in
		get_nth(months_string_list, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
	end


fun number_before_reaching_sum(sum : int, sequence : int list)=
	let 
		fun summer(sub_sequence : int list, partial_sum : int, counter : int)=
		if partial_sum + hd sub_sequence < sum then summer(tl sub_sequence, partial_sum + hd sub_sequence, counter + 1)
		else counter
	in
		if null sequence then 0
		else summer(sequence, 0, 0)
	end


fun what_month(day_of_year : int)=
	let 
		val days_in_months_list = [31,28,31,30,31,30,31,31,30,31,30,31]
	in
		number_before_reaching_sum(day_of_year, days_in_months_list) +1
	end

fun month_range(day1:int, day2:int)= 
	if day1 > day2 then []
	else let 
		fun add_months(d1:int,d2:int)=
			if d1 <= d2 then what_month(d1)::add_months(d1+1, d2)
			else []
		in 
			add_months(day1,day2)
		end
		
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
		val date = (2390,10,5)
	in
		date_to_string(date) = "October 5, 1390"
	end

fun number_before_reaching_sum1() = 
	let
		val sum = 35
		val sequence = [3,15,25,67]
	in
		number_before_reaching_sum(sum,sequence) = 3
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
		val day2 = 364
	in
		month_range(day1,day2) = [1,2,3,4,5,6,7,8,9,10,11,12]
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
		val day1 = 364
		val day2 = 364
	in
		month_range(day1,day2) = [12]
	end


fun test_all() = 
	get_nth1();
	get_nth2();
	get_nth3();
	date_to_string1();
	date_to_string2();
	date_to_string3();
	number_before_reaching_sum1();
	number_before_reaching_sum2();
	number_before_reaching_sum3();
	what_month1();
	what_month2();
	what_month3();
	month_range1();
	month_range2();
	month_range3();