(*
	Assignment 2
	Test Creator:
		name removed
		
	Tests 2 of 2
*)
use "group_hw2.sml";

fun get_substitutions1_test1()=
	get_substitutions1([["Fred", "Fredrick"], ["Elizabeth", "Betty"], ["Freddie", "Fred", "F"]], "Fred") = ["Fredrick", "Freddie", "F"]

fun get_substitutions1_test2()=
	get_substitutions1([["Fred", "Fredrick"], ["Jeff", "Jeffrey"], ["Geoff", "Jeff", "Jeffrey"]], "Jeff") = ["Jeffrey", "Geoff", "Jeffrey"]

fun similar_names_test1()=
	similar_names(
		[["Fred", "Fredrick"], ["Elizabeth", "Betty"], ["Freddie", "Fred", "F"]],
		{first="Fred", middle="W", last="Smith"}) = 
		[{first="Fred",last="Smith",middle="W"},
		{first="Freddie",last="Smith",middle="W"},
		{first="F",last="Smith",middle="W"},
		{first="Fredrick",last="Smith",middle="W"}]


fun card_value_test1()=
	let 
		val card = (Clubs,Num(2))
	in
		card_value(card) = 2
	end

fun card_value_test2()=
	let
		val card = (Clubs,Num(3))
	in
		card_value(card) = 3
	end

fun card_value_test3()=
	let
		val card = (Clubs,Num(4))
	in	
		card_value(card) = 4
	end

fun card_value_test4()=
	let
		val card = (Clubs,Num(5))
	in
		card_value(card) = 5
	end

fun card_value_test5()=
	let
		val card = (Clubs,Num(6))
	in
		card_value(card) = 6
	end

fun card_value_test6()=
	let
		val card = (Clubs,Num(7))
	in
		card_value(card) = 7
	end

fun card_value_test7()=
	let
		val card = (Clubs,Num(8))
	in
		card_value(card) = 8
	end

fun card_value_test8()=
	let
		val card = (Clubs,Num(9))
	in
		card_value(card) = 9
	end

fun card_value_test9()=
	let
		val card = (Clubs,Jack)
	in
		card_value(card) = 10
	end

fun card_value_test10()=
	let
		val card = (Clubs,Queen)
	in
		card_value(card) = 10
	end

fun card_value_test11()=
	let
		val card = (Clubs,King)
	in
		card_value(card) = 10
	end

fun card_value_test12()=
	let
		val card = (Clubs,Ace)
	in
		card_value(card) = 11
	end

fun all_same_color_test1()=
	all_same_color([(Clubs,Ace),(Clubs,Ace),(Clubs,Ace),(Clubs,Ace)])

fun all_same_color_test2()=
	all_same_color([(Diamonds,Ace),(Hearts,Ace),(Clubs,Ace),(Spades,Ace)]) = false

fun all_same_color_test3()=
	all_same_color([(Diamonds,Ace),(Clubs,Ace),(Hearts,Ace),(Spades,Ace)]) = false

fun all_same_color_test4()=
	all_same_color([(Diamonds,Ace),(Hearts,Ace),(Diamonds,Ace),(Hearts,Ace)])

fun all_same_color_test5()=
	all_same_color([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)])

fun score_test1()=
	score([],0) = 0

fun score_test2()=
	score([(Diamonds,Ace),(Hearts,Ace),(Clubs,Ace),(Spades,Ace)],0) = 132

fun score_test3()=
	score([(Diamonds,King),(Hearts,Queen),(Clubs,Jack),(Spades,Ace)], 0) = 123

fun score_test4()=
	score([(Diamonds,Ace),(Hearts,Ace),(Clubs,Ace),(Spades,Ace)],45) = 1

fun score_test5()=
	score([(Diamonds,Ace),(Hearts,Ace),(Clubs,Ace),(Spades,Ace)],44) = 0

fun gotta_test_em_all_pokemon_gen3()=
	all_except_optiontest1();
	all_except_optiontest2();
	all_except_optiontest3();
	get_substitutions1_test1();
	get_substitutions1_test2();
	similar_names_test1();
	card_value_test1();
	card_value_test2();
	card_value_test3();
	card_value_test4();
	card_value_test5();
	card_value_test6();
	card_value_test7();
	card_value_test8();
	card_value_test9();
	card_value_test10();
	card_value_test11();
	card_value_test12();
	all_same_color_test1();
	all_same_color_test2();
	all_same_color_test3();
	all_same_color_test4();
	all_same_color_test5();
	score_test1();
	score_test2();
	score_test3();
	score_test4();
	score_test5();