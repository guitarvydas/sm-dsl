(in-package :state-dsl)

(defclass state-dsl-parser (pasm:parser)
  ())

(defmethod initially ((self state-dsl-parser) token-list)
  (call-next-method))
