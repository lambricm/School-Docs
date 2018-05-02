;; PROJECT CODE

;; CS 4003: Programming Languages, Team Project
;; Team Members:
;;   names removed
;; Option # 1

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Part 1 - Warm-up

(define (racketlist->mupllist lst)
  (if (null? lst)
      (aunit)
      (apair (car lst) (racketlist->mupllist (cdr lst)))))

(define (mupllist->racketlist lst)
  (if (aunit? lst)
      null
      (if (apair? lst)
          (cons (apair-e1 lst) (mupllist->racketlist (apair-e2 lst)))
          (error "muppllist->racketlist not given a mupllist"))))

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(int? e)
         e]
        [(closure? e)
          e]
        [(fun? e)
         (closure env e)]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
          (if (and (int? v1) (int? v2) (> (int-num v1) (int-num v2)))
               (eval-under-env (ifgreater-e3 e) env)
               (eval-under-env (ifgreater-e4 e) env)))]
         [(apair? e)
          (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([mucar (eval-under-env (fst-e e) env)])
           (if (apair? mucar)
               (apair-e1 mucar)
               (null)))]
        [(snd? e)
         (let ([mucdr (eval-under-env (snd-e e) env)])
           (if (apair? mucdr)
               (apair-e2 mucdr)
               (null)))]
        [(isaunit? e)
         (if (aunit? (eval-under-env(isaunit-e e)env))
             (int 1)
             (int 0))]
        [(aunit? e)
         e]
        [(mlet? e)
         (let ((mletenv (cons (cons (mlet-var e) (eval-under-env (mlet-e e) env)) env)))
           (eval-under-env (mlet-body e) mletenv))]
        [(call? e)
         (let ([cl (eval-under-env (call-funexp e) env)]
               [cl2 (eval-under-env (call-actual e) env)])
           (if  (closure? cl)
               (let* ([clfun (closure-fun cl)]
                      [clenv (closure-env cl)]
                      [fname (cons(fun-nameopt clfun) cl)]
                      [fformal (cons(fun-formal clfun) cl2)])
                     
                     (let ([clfunbod (fun-body clfun)])
                       (eval-under-env clfunbod (if (eq? (car fname) #f)
                                                    (cons fformal clenv)
                                                    (cons fformal (cons fname clenv))))))

                    
               (error "first subexpression in a MUPL call should evaluate to a closure")))]
        [#t (error "bad MUPL expression" e)]))


;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater
   (isaunit e1)
   (int 0) e2 e3))

(define (mlet* lstlst e2)
  (if (null? (cdr lstlst))
      (mlet (car (car lstlst)) (cdr (car lstlst)) e2) 
      (mlet (car (car lstlst)) (cdr (car lstlst)) (mlet-body (mlet* (cdr lstlst) e2)))))

(define (ifeq e1 e2 e3 e4)
  (if (and (int? e1) (int? e2) (equal? (eval-exp e1) (eval-exp e2)))
      (eval-exp e3)
      (eval-exp e4)))

;; Problem 4

(define mupl-map
  (fun "continue" "funct"
       (fun #f "lst"
            (ifaunit (var "lst") 
             (aunit)
             (apair (call (var "funct") (fst (var "lst")))
                    (call (call (var "continue") (var "funct")) (snd (var "lst"))))))))

(define mupl-mapAddN
  (mlet "map" mupl-map
        (fun #f "i"
             (call (var "map")
                   (fun #f "funct"
                        (add (var "funct") (var "i"))))))) 