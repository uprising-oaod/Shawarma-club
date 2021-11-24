(defsystem "shawarma-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Walpurgisnatch"
  :license ""
  :depends-on ("shawarma"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "shawarma"))))
  :description "Test system for shawarma"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
