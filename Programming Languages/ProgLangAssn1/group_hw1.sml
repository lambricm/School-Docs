(* Names removed *)

(* Returns true if the first date argument is before (less than/older than) the second date argument.*)
fun is_older(date1 : int * int * int, date2 : int * int * int)=
	if (#1 date1) < (#1 date2) then true
	else if (#2 date1) < (#2 date2) then true
	else if (#3 date1) < (#3 date2) then true
	else false


fun number_in_month(date_list : (int * int * int) list, month : int)=
	let fun month_matches_counter(date_list : (int * int * int) list, month : int, counter : int)=
		if null date_list then counter
		else if (#2 (hd date_list)) = month then month_matches_counter(tl date_list, month, counter + 1)
		else month_matches_counter(tl date_list, month, counter)
	in
		month_matches_counter(date_list, month, 0)
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
	if (day_of_year > 365) orelse (day_of_year < 1)
	then 0
	else
		let 
			val days_in_months_list = [31,28,31,30,31,30,31,31,30,31,30,31]
		in
			number_before_reaching_sum(day_of_year, days_in_months_list) + 1
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
