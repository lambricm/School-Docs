(* CS 4003, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* you may assume that Num is always used with values 2, 3, ..., 9
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

fun all_except_option(str,lst) = 
	case lst of
		[] => NONE
		| x::xs => if same_string(str,x) then SOME xs
			else case all_except_option(str,xs) of	
				NONE => NONE
				|SOME temp => SOME(x::temp)

fun get_substitutions2_helper(strlstlst,str,appndlst) =
	case strlstlst of
		[] => appndlst
		|x::xe =>
			if SOME x = all_except_option(str,x)
			then get_substitutions2_helper(xe,str,appndlst)
			else 
				case all_except_option(str,x) of
					(NONE) => get_substitutions2_helper(xe,str,appndlst)
					|(SOME lst) => get_substitutions2_helper(xe,str,lst@appndlst)
			
fun get_substitutions2(strlstlst,str) = 
	case strlstlst of
		[] => []
		|_ => get_substitutions2_helper(strlstlst,str,[])
		
fun similar_names_helper(namelist,mid,lst,complist) =
	case namelist of
		[] => complist
		|x::xe => similar_names_helper(xe,mid,lst,complist@[{first = x,middle = mid,last = lst}])

fun similar_names(namelist,name) =
	case name of
		{first = a,middle = b,last = c} => similar_names_helper(get_substitutions2(namelist,a),b,c,[name])

(*fun get_substitutions1(strlstlst,str) =
	case srtlstlst of
		[] => []
		[[]] => []
		|[strlist] => strlist
		|x::xe =>
			if x == all_except_option(str,lst)
			then get_substitutions(xe)
			else 	*)
	
fun card_color(card) =
	case card of
		(Clubs,_) => Black
		|(Spades,_) => Black
		|(Hearts,_) => Red
		|(Diamonds,_) => Red
		
fun card_value(suit,rank) =
	case rank of
		Jack => 10
		|Queen => 10
		|King => 10
		|Ace => 11
		|Num x => x

fun remove_card(crd,lst,e) = 
	case lst of
		[] => raise e
		| x::xs => if crd = x 
			then xs
			else x::remove_card(crd,xs,e)

fun all_same_color(lst) =
	case lst of
		[] => true
		|[x,y] => card_color(x) = card_color(y)
		|x::y::xye => 
			if (card_color(x) = card_color(y))
			then all_same_color(y::xye)
			else false
			
fun sum_cards_helper(sum,lst) = 
	case lst of
		[] => sum
		|x::xe => sum + card_value(x) + sum_cards_helper(sum,xe)
		
fun sum_cards(lst) = 
	case lst of
		[] => 0
		|_ => sum_cards_helper(0,lst)
	
fun score(lst,goal) =
	case sum_cards(lst) of
		> goal =>
			if all_same_color(lst)
			then (sum_cards(lst) - goal)*3 div 2
			else (sum_cards(lst) - goal)*3
		| <= goal =>
			if all_same_color(lst)
			then (goal - sum_cards(lst)) div 2
			else (goal - sum_cards(lst))
			
fun officiate(card_list : card list, move_list : move list, goal : int)=
	let 
		fun game_manager(held_cards : card list, moves_left : move list, unheld_cards : card list)=
			if sum_cards(held_cards) > goal then score(held_cards, goal)
			else
			(case moves_left of
				[] => score(held_cards, goal)
				| x::xs => 
					if x = Draw
					then 
						(case unheld_cards of
							[] => score(held_cards, goal)
							| y::ys => game_manager(y::held_cards, xs, remove_card(y, unheld_cards, IllegalMove))
						)
					else 
						let 
							val unwanted_card = (case x of
													Discard y => y
												)
						in
							game_manager(remove_card(unwanted_card, held_cards, IllegalMove), xs, unheld_cards)
						end
						
						
			)
	in
		game_manager([], move_list, card_list)
	end