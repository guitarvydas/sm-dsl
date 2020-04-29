(in-package :stack-dsl)

(defun read-json-types (filename)
  (alexandria:read-file-into-string
   (asdf:system-relative-pathname :sm-dsl "types.json")))

(defun types-as-alist (filename)
  (let ((str (read-json-types filename)))
    (with-input-from-string (s str)
      (json:decode-json s))))

(defun initialize-types ()
  (setf *type-table* (types-as-alist "types.json"))
  (setf *type-hash* (make-hash-table :test 'equal))
  (initialize-type-hash *type-hash* *type-table*))
 
    
(defmethod %ensure-type (expected-type (obj %typed-value))
  ;; return T if type checks out, else %type-check-failure
  (let ((expected-type-desc (get-type-or-fail expected-type)))
    (let ((obj-desc (get-type-or-fail (%type obj))))
      (shallow-type-equal expected-type-desc obj-desc))))

(defmethod %ensure-field-type ((self T) field-name (obj T))
  (%type-check-failure (format nil "~a has no field called ~a" self field-name) obj))

(defmethod %ensure-field-type (expected-type field-name (obj %typed-value))
  (let ((expected-type-desc (get-type-or-fail expected-type)))
    (unless expected-type-desc 
      (%type-check-failure "not a structure" expected-type))
    (let ((obj-type-desc (get-type-or-fail (%type obj))))
      (unless obj-type-desc 
	(%type-check-failure "not a structure" obj))
      (let ((field-type-desc (get-field-type-or-fail expected-type field-name)))
	(shallow-type-equal field-type-desc obj-type-desc)))))
