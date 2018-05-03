#lang racket
(provide (all-defined-out))
(require "hw4.rkt")
;TESTS
;Authors: Names Removed
(define (test)
  (and
  (5th-power1)
  (5th-power2)
  (5th-power3)
  (5th-power4)
  (odd-list1)
  (odd-list2)
  (even-list1)
  (even-list2)
  (sequencer1)
  (sequencer2)
  (sequencer3)
  (duplicator1)
  (duplicator2)
  (dotProduct1)
  (dotProduct2)
 

  (funny-numbers1)
  (funny-numbers2)

  )
)


(define (5th-power1)
  (= (5th-power 3) 243))

(define (5th-power2)
  (= (5th-power 7) 16807))

(define (5th-power3)
  (= (5th-power 0) 0))

(define (5th-power4)
  (= (5th-power 1) 1))


(define (odd-list1)
  (equal? (odd-list '(a b c d)) '(a c)))

(define (odd-list2)
  (equal? (odd-list '(a)) '(a)))

(define (even-list1)
  (equal? (even-list '(a b c d)) '(b d)))

(define (even-list2)
  (equal? (even-list '(a)) '()))


(define (sequencer1)
  (equal? (sequencer 3 11 2) '(3 5 7 9 11)))

(define (sequencer2)
  (equal? (sequencer 3 8 3) '(3 6)))

(define (sequencer3)
  (equal? (sequencer 3 2 1) '()))


(define (duplicator1)
  (equal? (duplicator '(a 1 b 2 c 3)) '(a a 1 1 b b 2 2 c c 3 3)))

(define (duplicator2)
  (equal? (duplicator '((a 1) b ((c)) 2)) '((a a 1 1) b b ((c c)) 2 2)))


(define (dotProduct1)
  (equal? (dotProduct '(1 2) '(3 4)) 11))

(define (dotProduct2)
  (equal? (dotProduct '(1 2 3) '(4 5 6)) 32))

(define (funny-numbers1)
  (equal? (stream-for-n-steps funny-number-stream 6) '(0 1 2 3 4 -5)))

(define (funny-numbers2)
  (equal? (stream-for-n-steps funny-number-stream 12) '(0 1 2 3 4 -5 6 7 8 9 -10 11)))





