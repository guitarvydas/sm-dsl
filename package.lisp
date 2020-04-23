(defpackage :sm-dsl
  (:use :cl :parsing-assembler)
  (:import-from :stack-dsl
		#:~output
		#:~newscope
		#:~replace-top
		#:~set-field
		#:~append)
  (:export
   #:transpile-sm))

