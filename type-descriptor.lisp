(in-package :stack-dsl)


(defparameter *type-table* nil)
(defparameter *type-hash* nil)


#|
example type alist
(((:NAME . "RAWTEXT") (:DESCRIPTOR (:KIND . "string")))
 ((:NAME . "ONNAME") (:DESCRIPTOR (:KIND . "string")))
 ((:NAME . "NAME") (:DESCRIPTOR (:KIND . "string")))
 ((:NAME . "EXPRKIND")
  (:DESCRIPTOR (:KIND . "enum") (:VALUES "dollar" "function" "raw")))
 ((:NAME . "CALLKIND") (:DESCRIPTOR (:KIND . "enum") (:VALUES "send" "call")))
 ((:NAME . "CALLEXPR")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "exprkind") (:FIELD-TYPE . "exprKind"))
    ((:FIELD-NAME . "name") (:FIELD-TYPE . "name"))
    ((:FIELD-NAME . "exprMap") (:FIELD-TYPE . "exprMap")))))
 ((:NAME . "CALLSTATEMENT")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "callkind") (:FIELD-TYPE . "callkind"))
    ((:FIELD-NAME . "exprMap") (:FIELD-TYPE . "exprMap")))))
 ((:NAME . "SENDSTATEMENT")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "callkind") (:FIELD-TYPE . "callKind"))
    ((:FIELD-NAME . "expr") (:FIELD-TYPE . "expr")))))
 ((:NAME . "EVENT")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "onName") (:FIELD-TYPE . "onName"))
    ((:FIELD-NAME . "statementsBag") (:FIELD-TYPE . "statementsBag")))))
 ((:NAME . "MACHINEDESCRIPTO")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "name") (:FIELD-TYPE . "name"))
    ((:FIELD-NAME . "initiallyDescriptor")
     (:FIELD-TYPE . "inititallyDescriptor"))
    ((:FIELD-NAME . "statesBag") (:FIELD-TYPE . "statesBag"))
    ((:FIELD-NAME . "pipeline") (:FIELD-TYPE . "pipeline")))))
 ((:NAME . "STATE")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "name") (:FIELD-TYPE . "name"))
    ((:FIELD-NAME . "eventsBag") (:FIELD-TYPE . "eventsBag")))))
 ((:NAME . "RAWEXPR")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "exprkind") (:FIELD-TYPE . "exprkind"))
    ((:FIELD-NAME . "rawText") (:FIELD-TYPE . "rawText")))))
 ((:NAME . "DOLLAREXPR")
  (:DESCRIPTOR (:KIND . "structure")
   (:FIELDS ((:FIELD-NAME . "exprkind") (:FIELD-TYPE . "exprkind"))
    ((:FIELD-NAME . "name") (:FIELD-TYPE . "name")))))
 ((:NAME . "EXPRMAP") (:DESCRIPTOR (:KIND . "map") (:ELEMENT-TYPE . "expr")))
 ((:NAME . "PIPELINE") (:DESCRIPTOR (:KIND . "map") (:ELEMENT-TYPE . "name")))
 ((:NAME . "STATEMENTSBAG")
  (:DESCRIPTOR (:KIND . "bag") (:ELEMENT-TYPE . "statement")))
 ((:NAME . "EVENTSBAG")
  (:DESCRIPTOR (:KIND . "bag") (:ELEMENT-TYPE . "event")))
 ((:NAME . "STATESBAG")
  (:DESCRIPTOR (:KIND . "bag") (:ELEMENT-TYPE . "state")))
 ((:NAME . "INITIALLYDESCRIPTOR")
  (:DESCRIPTOR (:KIND . "bag") (:ELEMENT-TYPE . "statement")))
 ((:NAME . "STATEMENT")
  (:DESCRIPTOR (:KIND . "compound")
   (:TYPES "rawExpr" "dollarExpr" "callExpr")))
 ((:NAME . "EXPR")
  (:DESCRIPTOR (:KIND . "compound") (:TYPES "sendStatement" "callStatement"))))
|#

(defclass type-descriptor () 
  ((descriptor-alist :accessor descriptor-alist :initarg :descriptor-alist)))

(defclass string-descriptor (type-descriptor)
  ())
(defclass map-descriptor (type-descriptor)
  ((element-type :accessor element-type :initarg :element-type)))
(defclass bag-descriptor (type-descriptor)
  ((element-type :accessor element-type :initarg :element-type)))
(defclass enum-descriptor (type-descriptor)
  ((value-list :accessor value-list :initform nil :initarg :value-list)))
(defclass compound-descriptor (type-descriptor)
  ((types :accessor types :initform nil :initarg :types)))
(defclass structure-descriptor (type-descriptor)
  ((fields :accessor fields :initform nil :initarg :fields)))

(defun create-string-descriptor (adesc)
  (make-instance 'string-descriptor :descriptor-alist adesc))

(defun create-map-descriptor (adesc)
  (let ((eltype (intern (string-upcase (cdr (assoc :element-type adesc))) "KEYWORD")))
    (make-instance 'map-descriptor 
		   :descriptor-alist adesc
		   :element-type eltype)))
  
(defun create-bag-descriptor (adesc)
  (let ((eltype (intern (string-upcase (cdr (assoc :element-type adesc))) "KEYWORD")))
    (make-instance 'map-descriptor 
		   :descriptor-alist adesc
		   :element-type eltype)))
  
(defun create-enum-descriptor (adesc)
  (let ((values-string-list (cdr (assoc :value-list adesc))))
    (let ((values-keyword-list nil))
      (dolist (str values-string-list)
	(push (intern (string-upcase str) "KEYWORD")
	      values-keyword-list))
      (make-instance 'enum-descriptor
		     :descriptor-alist adesc
		     :value-list values-keyword-list))))

(defun create-compound-descriptor (adesc)
  (let ((string-list (cdr (assoc :types adesc))))
    (let ((types-list (make-types-from-string-list string-list)))
      (make-instance 'compound-descriptor
		     :descriptor-alist adesc
		     :types types-list))))

(defun create-structure-descriptor (adesc)
  (let ((alist-name-type-pairs (cdr (assoc :fields adesc))))
    ;; (( (:FIELD-NAME . "exprkind") (:FIELD-TYPE . "exprkind") )...)
    ;; for this DSL, we need only the types, so we cheat...
    (let ((type-list (mapcar #'(lambda (pair)
				 (make-type-from-string (cdr (assoc :field-type pair))))
			     alist-name-type-pairs)))
	(make-instance 'structure-descriptor
		       :descriptor-alist adesc
		       :fields type-list))))
  
(defun initialize-type-hash (type-hash type-table)
  (dolist (a type-table)
    (let ((tyname (make-type-from-string (cdr (assoc :name a))))
	  (adesc (cdr (assoc :descriptor a))))
      (let ((kind-sym (intern (string-upcase (cdr (assoc :kind adesc))) "KEYWORD")))
	(let ((desc
	       (ecase kind-sym
		 (:string (create-string-descriptor adesc))
		 (:enum (create-enum-descriptor adesc))
		 (:structure (create-structure-descriptor adesc))
		 (:compound (create-compound-descriptor adesc))
		 (:map (create-map-descriptor adesc))
		 (:bag (create-bag-descriptor adesc)))))
	  (setf (gethash tyname type-hash) desc)))))
  type-hash)


(defmethod deep-type-equal ((self T) (obj T))
  nil)
(defmethod deep-type-equal ((self string-descriptor) (obj string-descriptor))
  T)
(defmethod deep-type-equal ((self map-descriptor) (obj map-descriptor))
  (eq (element-type self) (element-type obj)))
(defmethod deep-type-equal ((self bag-descriptor) (obj bag-descriptor))
  (eq (element-type self) (element-type obj)))
(defmethod deep-type-equal ((self enum-descriptor) (obj enum-descriptor))
  (let ((self-values (values self))
	(obj-values (values obj)))
    (and (= (length self-values) (length obj-values))
	 (every #'(lambda (x) (string-member x obj-values)) self-values))))
(defmethod deep-type-equal ((self compound-descriptor) (obj compound-descriptor))
  (let ((self-types (ypes self))
	(obj-types (types obj)))
    (and (= (length self-types) (length obj-types))
	 (every #'(lambda (x) (string-member x obj-types)) self-types))))
(defmethod deep-type-equal ((self structure-descriptor) (obj structure-descriptor))
  (let ((self-fields (fields self))
	(obj-fields (fields obj)))
    (and (= (length self-fields) (length obj-fields))
	 (every #'(lambda (x) (string-member x obj-fields)) self-fields))))

(defmethod shallow-type-equal ((self T) (obj T))
  nil)
(defmethod shallow-type-equal ((self type-descriptor) (obj type-descriptor))
  (string= (name self) (name obj)))

(defun string-member (s lis)
  ;; does this need to be more efficient?  (for small dsl's, we don't really care)
  (dolist (str lis)
    (when (string= str s)
      (return-from string-member T)))
  nil)

(defun get-type-or-fail (name)
  (multiple-value-bind (descriptor success)
      (gethash name *type-hash*)
    (if (not success)
	(%type-check-failure "internal error get-type" name)
	descriptor)))

(defun get-field-type-or-fail (type-name field-name)
  (let ((main-desc (get-type-or-fail type-name)))
    (let ((field-type-desc (get-field-type main-desc field-name)))
      (if field-type-desc
	  field-type-desc
	  (%type-check-failure-format "type ~a does not have a field ~a" type-name field-name)))))

(defun make-types-from-string-list (str-list)
  (mapcar #'make-type-from-string str-list))

(defun make-type-from-string (s)
  (string-upcase (format nil "~a-type" s)))
