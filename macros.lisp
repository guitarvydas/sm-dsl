(in-package :sm-dsl)

;;
;; There is no need to read the actual Lisp macros below.
;; The macros, in effect, rewrite text into other text (over-simplicfication).
;;
;; I list the effect of each macro, in loose terms, below...:

;; there are 2 stacks for every type
;;  [one stack is called "input" and the other is called "output" (corresponding to the input parameter list and return value)]

;; 6 operations on the 2 kinds of stacks:
;;
;; output
;; newscope
;; replace-top
;; append
;; pop-output
;; set-field

;; loosey-goosey meanings...
;;
;; output(type) : return value given by type of stack "input"
;; newscope(type) : push <nothing-ness> onto input stack of type
;; replace-top(x,y) : replace top x item with y
;; append(x,y) : append y to top x
;; pop-output(x) : kill top x item
;; set-field (x f val) : assign val to x.f

;; loosey-goosey semantics...
;;
;; output(type) : move top input item to top of output stack ; move top(type) from input-type to output-type, pop input-type
;; newscope(type) : push <nothing-ness> onto input stack of type
;; replace-top(x,y) : replace top x item with y ; set top(x) to be top(y) (replace, not push), pop top(y), check that replacement type is the same as the replacee
;; append(x,y) : append y to top x ; append top(y) to top(x), check that type of top(y) is append-able to top(x)
;; pop-output(x) : kill top x item ; return top(x), pop x
;; set-field (x f val) : top(x).f <- val where top(x) must have field f, val must be of type compatible with type top(x).f


;; I hard-code the symbols "self" and "env" ...
;; I use ~ and % as name prefixes for names.
;; ~ is used to prefix macro names.
;; % is used to prefix support routines.
;; (I could have used Common Lisp packages to qualify names instead of prefixes, but I thought that prefixes are less scary and show (visually) my design intentions).

(defun ~in(name) `(,(intern (string-upcase (format nil "input-~a" name))) (env self)))
(defun ~out(name) `(,(intern (string-upcase (format nil "output-~a" name))) (env self)))

(defun ~field(fname) (format nil "%field-type-~s" fname))
(defun ~type(fname) (stack-dsl:lisp-sym fname))

(defmacro ~output (ty)
  `(progn 
     (stack-dsl:%output ,(~out ty) ,(~in ty))
     (stack-dsl:%pop ,(~in ty))))

(defmacro ~newscope (ty)
  `(stack-dsl:%push-empty ,(~in ty)))

(defmacro ~append (stack1 stack2)
  `(let ((val (stack-dsl:%top ,(~out stack2))))
     (stack-dsl:%ensure-appendable-type ,(~in stack1))
     (stack-dsl:%ensure-type (stack-dsl:%element-type 
			      (stack-dsl:%top ,(~in stack1))) val)
     (stack-dsl::%append (stack-dsl:%top ,(~in stack1)) val)
     (stack-dsl:%pop ,(~out stack2))))

(defmacro ~set-field (to field-name from)
  ;; set top(input-to).f := output-from, pop from
  `(let ((val (stack-dsl:%top ,(~out from))))
     (stack-dsl:%ensure-field-type
      ,to
      ,field-name
      val)
     (stack-dsl:%set-field (stack-dsl:%top ,(~in to)) ,field-name val)
     (stack-dsl:%pop ,(~out from))))

