(defsystem :sm-dsl
  :depends-on (:loops :alexandria :parsing-assembler/use :stack-dsl/use)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")
				     (:file "path" :depends-on ("package"))))))

(defsystem :sm-dsl/generate-stacks
  :depends-on (:sm-dsl)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:static-file "stacks.pasm")
				     (:file "generate-stacks" 
					    :depends-on ("stacks.pasm"))))))

(defsystem :sm-dsl/generate
  :depends-on (:sm-dsl)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:static-file "sm-dsl.pasm")
				     (:file "generate" 
					    :depends-on ("sm-dsl.pasm"))))))

;; don't use during development (see README.org for steps generate-stacks, generate, use)
(defsystem :sm-dsl/use
  :depends-on (:sm-dsl)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "stacks") ;; generated
				     (:file "classes")
				     (:file "macros")
				     (:file "sm-dsl") ;; generated
				     (:file "mechanisms"
					    :depends-on ("stacks" "classes" "macros"))
				     (:file "transpile" 
					    :depends-on ("classes"
							 "macros"
							 "sm-dsl"
							 "mechanisms"))))))
