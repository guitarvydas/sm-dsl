(defsystem :state-dsl
  :depends-on (:loops :alexandria :parsing-assembler/use)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")))))

(defsystem :state-dsl/generate
  :depends-on (:state-dsl)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:static-file "state-dsl.pasm")
				     (:file "generate" :depends-on ("state-dsl.pasm"))))))

(defsystem :state-dsl/use
  :depends-on (:state-dsl)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "state-dsl")
				     (:file "classes")
				     (:file "transpile" :depends-on ("classes"))))))
