(in-package :cl-user)
(defpackage shawarma.schema
  (:use :cl :sxql :cl-annot.class :mito))

(in-package :shawarma.schema)

(mito:connect-toplevel :postgres :database-name "shawarma" :username "shawarma" :password "shawarma")

(defun ensure-tables ()
  (mapcar #'ensure-table-exists '(users orders)))

(defun migrate-tables ()
  (mapcar #'migrate-table '(users orders)))

(deftable users ()
  ((name        :col-type (:varchar 32))
   (password    :col-type (:varchar 32))))

(deftable orders ()
  ((user          :col-type (:varchar 24))
   (order         :col-type (:varchar 128))))

(ensure-tables)
(migrate-tables)
