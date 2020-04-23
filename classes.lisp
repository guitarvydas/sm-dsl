(in-package :sm-dsl)

(defclass sm-dsl-parser (pasm:parser)
  ((env :accessor env :initform (make-instance 'environment))))

(defmethod initially ((self sm-dsl-parser) token-list)
  (call-next-method))
