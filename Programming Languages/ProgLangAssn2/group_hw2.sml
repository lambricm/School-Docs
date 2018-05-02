(*
	Assignment 2
	Team Members:
		names removed
	Functions
*)

fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* Part 1 *)
	
fun all_except_option(str,lst) = 
	case lst of
		[] => NONE
		| x::xs => if same_string(str,x) then SOME xs
			else case all_except_option(str,xs) of	
				NONE => NONE
				|SOME temp => SOME(x::temp)

fun get_substitutions1(substitutions, s)=
	(case substitutions of
		[] => []
		| x::xs =>
			(case x of
				[] => []
				| str_list => 
					(case all_except_option(s,str_list) of
						(NONE) => []
						| (SOME str_list_obj) => str_list_obj
					)
					@
					get_substitutions1(xs,s)
			)
	)

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

(* End of Part 1 *)

datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* Part 2 *)

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
		| x::y::xye => 
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
	if sum_cards(lst) > goal
	then (if (all_same_color(lst))
			then (sum_cards(lst) - goal)*3 div 2
			else (sum_cards(lst) - goal)*3)
	else (if (all_same_color(lst))
			then (goal - sum_cards(lst)) div 2
			else (goal - sum_cards(lst)))

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
	
(* End of Part 2 *)