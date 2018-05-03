;FUNCTIONS
;Authors: Names Removed


#lang racket
(provide (all-defined-out))

(define 5th-power(lambda (x)
                   (* x x x x x)))


(define odd-list(lambda (L)
                 (if(not(null? L))(if (not (null? (cdr L)))
                                      (cons (car L) (odd-list(cdr(cdr L))))
                                      (list(car L))
                                  )
                                  L
                 )
                )
)

(define even-list(lambda (L)
                 (if(not(null? L))(if (not (null? (cdr L)))
                                      (cons (car(cdr L)) (even-list(cdr(cdr L))))
                                      null
                                  )
                                  L
                 )
                )
)
               


(define (sequencer low high stride)
  (sequencer-helper low high stride '()))

(define (sequencer-helper low high stride lst)
  (if(> low high)
     lst
     (sequencer-helper (+ low stride) high stride (append lst (list low)))))

(define duplicator(lambda (L)
                    (if (not (null? L))
                    (cond
                      ((list? L) (cond
                                   ((list? (car L)) (append (cons (duplicator (car(car (list L)))) (duplicator (cdr (car (list L))))) null))
                                   (else (append (duplicator (car L)) (duplicator (cdr L))))
                                        
                                  )
                       )
                      (else (cons L (cons L null)))
                    )
                    null
                    )
                   )
)


(define (dpHelper l1 l2 sum)
  (if (null? l1)
      sum
      (dpHelper (cdr l1) (cdr l2) (+ sum (*(car l1) (car l2))))))

(define (dotProduct l1 l2)
  (if (= (length l1) (length l2))
      (dpHelper l1 l2 0)
      (error "Incompatible Vectors")))

(define (lstnthHelper xs n)
  (if (= n 0)
      (car xs)
      (lstnthHelper (cdr xs) (- n 1))))

(define (list-nth-mod xs n)
  (if (< n 0)
      (error "list-nth-mod: negative number")
      (if (null? xs)
          (error "list-nth-mod: empty list")
          (lstnthHelper xs (remainder n (length xs))))))

(define (string-append-map xs suffix)
  (map (lambda (str)
         (string-append str suffix)) xs))

(define (snHelper s nt nc lst)
  (if (> nc nt)
      lst
      (snHelper (stream-rest s) nt (+ 1 nc) (append lst (list (stream-first s))))))

(define (stream-for-n-steps s n)
  (snHelper s n 1 '()))

(define (funny-negate n)
  (let ((i (add1 n)))
   (cond
     ((= (modulo i 5) 0) (* -1 i))
     ((negative? i) (* -1 (sub1 (sub1 i))))
     (else i)
    )
   )
)

(define funny-number-stream
  (stream-cons 0
    (stream-map funny-negate funny-number-stream)))

(define (cycle-lists-helper xs ys n)
  (stream-cons (cons (list-nth-mod xs n) (list-nth-mod ys n)) (cycle-lists-helper xs ys (+ 1 n))))

(define (cycle-lists xs ys)
  (cycle-lists-helper xs ys 0))



