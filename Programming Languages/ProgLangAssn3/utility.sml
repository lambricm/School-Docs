(* CS 4003 *)
(* Assignement #3 *)
(* Collection of utility functions - you may not need all of these functions *)

(* simple version of map; returns the result of mapping a function over *)
(* every element of a list                                              *)
fun map(f, []) = []
|   map(f, x::xs) = f(x)::map(f, xs);

(* simple version of filter; returns a list of all values from the list *)
(* that satisfy the given predicate function                            *)
fun filter(f, []) = []
|   filter(f, x::xs) =
        if f(x) then x::filter(f, xs)
        else filter(f, xs);

(* simple version of reduce; reduces a list given a binary function; *)
(* assumes list is nonempty                                          *)
exception illegal_reduce;
fun reduce(f, []) = raise illegal_reduce
|   reduce(f, [x]) = x
|   reduce(f, x::xs) = f(x, reduce(f, xs));

(* sorts a list with the quicksort algorithm given a comparison function *)
(* and a list of values                                                  *)
fun qsort(f, []) = []
|   qsort(f, pivot::rest) =
        let fun split([], ys, zs) = qsort(f, ys) @ [pivot] @ qsort(f, zs)
            |   split(x::xs, ys, zs) =
                    if f(x, pivot) then split(xs, x::ys, zs)
                    else split(xs, ys, x::zs)
        in split(rest, [], [])
        end;

(* a random number generator initialized using the current time *)
val utilityRandom =
    let val time = IntInf.toInt(Time.toSeconds(Time.now()) mod 
                                Int.toLarge(valOf(Int.maxInt)))
    in Random.rand(time, 42)
    end;

(* returns a random int value *)
fun randomInt() = Random.randInt(utilityRandom);

(* returns a list of random ints of given length; assumes n >= 0 *)
fun randList(n) =
        let fun build(0) = []
            |   build(m) = Random.randInt(utilityRandom)::build(m - 1)
        in build(n)
        end;

(* returns a list of the values m through n *)
infix --;
fun m--n =
        if m > n then []
        else m::(m + 1--n);

(* returns whether or not a number is prime *)
fun prime(2) = true
|   prime(n) =
        let fun noFactors(m) =
                if m * m > n then true
                else n mod m <> 0 andalso noFactors(m + 2)
        in n > 1 andalso n mod 2 = 1 andalso noFactors(3)
        end;
