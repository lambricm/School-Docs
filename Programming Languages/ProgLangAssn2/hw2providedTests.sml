(* CS 4003, HW2 Provided Tests *)
 
fun all_except_optiontest1() = 
	let 
		val lst = ["bob","fred","georgie"]
		val str = "bob"
	in
		all_except_option(str,lst) = SOME ["fred","georgie"]
	end

fun all_except_optiontest2() =
	let 
		val lst = ["bob","fred","georgie"]
		val str = "donna"
	in
		all_except_option(str,lst) = NONE
	end
 
fun all_except_optiontest3() =
	let 
		val lst = ["bob","fred","georgie","fred"]
		val str = "fred"
	in
		all_except_option(str,lst) = SOME ["bob","georgie","fred"]
	end

fun get_substitutions2test1() =
	let
		val lstlst = [["bob","ted"],["bob","fred"],["tom","fred"]];
		val str = "ted"
	in
		get_substitutions2(lstlst,str) = ["bob"]
	end
 
fun get_substitutions2test2() =
	let
		val lstlst = [["bob","ted"],["bob","fred"],["tom","fred"]];
		val str = "donna"
	in
		get_substitutions2(lstlst,str) = []
	end
  
fun get_substitutions2test3() =
	let
		val lstlst = [["bob","ted"],["bob","fred"],["tom","fred"]];
		val str = "bob"
	in
		get_substitutions2(lstlst,str) = ["fred","ted"]
	end
	
fun card_colortest1() =
	let
		val crd = (Spades,Num 3)
	in
		card_color(crd) = Black
	end

fun card_colortest2() =
	let
		val crd = (Diamonds,King)
	in
		card_color(crd) = Red
	end
	
fun card_colortest3() =
	let
		val crd = (Clubs,Ace)
	in
		card_color(crd) = Black
	end

fun remove_cardtest1() =
	let
		val cs = [(Clubs,Jack),(Spades,King),(Diamonds,Num 2)]
		val c = (Clubs, Jack)
		val e = IllegalMove
	in
		remove_card(c,cs,e) = [(Spades,King),(Diamonds,Num 2)]
	end
	handle IllegalMove => false

fun remove_cardtest2() =
	let
		val cs = [(Clubs, Jack),(Spades,King),(Diamonds,Num 2),(Clubs,Jack)]
		val c = (Clubs,Jack)
		val e = IllegalMove
	in
		remove_card(c,cs,e) = [(Spades,King),(Diamonds,Num 2),(Clubs,Jack)]
	end
	handle IllegalMove => false

fun remove_cardtest3() =
	let
		val cs = [(Clubs,Jack),(Spades,King),(Diamonds,Num 2)]
		val c = (Hearts,Num 2)
		val e = IllegalMove
	in
		case remove_card(c,cs,e) of
			_ => true
	end
	handle IllegalMove => true

fun sum_cardstest1() =
	let
		val cl = [(Clubs,Num 9),(Spades,Jack),(Diamonds,Num 2)]
	in
		sum_cards(cl) = 21
	end

fun sum_cardstest2() =
	let
		val cl = [(Clubs,Ace),(Spades,King)]
	in
		sum_cards(cl) = 21
	end

fun sum_cardstest3() =
	let
		val cl = []
	in
		sum_cards(cl) = 0
	end

fun provided_test1 () = (* correct behavior: raise IllegalMove *)
    let 
		val cards = [(Clubs,Jack),(Spades,Num(8))]
		val moves = [Draw,Discard(Hearts,Jack)]
    in
		officiate(cards,moves,42) = 0
    end
	handle IllegalMove => true

fun provided_test2 () = (* correct behavior: return 3 *)
	let val cards = [(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)]
		val moves = [Draw,Draw,Draw,Draw,Draw]
    in
		officiate(cards,moves,42) = 3
    end
	handle IllegalMove => false

fun run_tests() =
	all_except_optiontest1();
	all_except_optiontest2();
	all_except_optiontest3();
	get_substitutions2test1();
	get_substitutions2test2();
	get_substitutions2test3();
	card_colortest1();
	card_colortest2();
	card_colortest3();
	remove_cardtest1();
	remove_cardtest2();
	remove_cardtest3();
	sum_cardstest1();
	sum_cardstest2();
	sum_cardstest3();
	provided_test1();
	provided_test2();