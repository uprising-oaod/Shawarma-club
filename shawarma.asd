(defsystem "shawarma"
  :version "0.1.0"
  :author "Walpurgisnatch"
  :license ""
  :depends-on ("clack"
               "lack"
               "caveman2"
               "envy"
               "cl-ppcre"
               "uiop"

               ;; for @route annotation
               "cl-syntax-annot"

               ;; HTML Template
               "djula"

               ;; for DB
               "jose"
               "local-time"
               "mito"
               "datafly"
               "sxql")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "utils")
                 (:file "users" :depends-on ("models"))
                 (:file "orders" :depends-on ("models" "users"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "models" :depends-on ("config" "db" "utils"))
                 (:file "config")))
               (:module "db"
                :components
                ((:file "schema"))))
  :description ""
  :in-order-to ((test-op (test-op "shawarma-test"))))
