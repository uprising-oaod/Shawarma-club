(in-package :cl-user)
(defpackage :shawarma.utils
  (:use :cl
        :sxql
        :cl-annot.class
        :datafly)
  (:export :from-token
           :key
           :wildcard
           :model-update
           :find-where
           :select-where
           :create-model
           :delete-model))

(in-package :shawarma.utils)

(defun from-token (var token)
  (handler-case 
      (cdr (assoc (string var) (jose:inspect-token token) :test #'equalp))
    (error nil)))

(defun key (arg)
  (intern (string arg) :keyword))

(defun wildcard (string)
  (concatenate 'string "%" string "%"))
  
;;;; CRUD

(defmacro model-update (table where &rest cols)
  "update users (:= :id 1) :name john :sname doe"
  `(execute
    (update ,(key table)
      (set= ,@(loop for i in cols by #'cddr
                    for j in (cdr cols) by #'cddr
                    unless (null j)
                      collect i and collect j)
            :updated_at (local-time:now))
      (where (,@where)))))

(defmacro find-where (table where &key (order-by `(:desc :created_at)))
  `(let ((data (retrieve-all
                (select :*
                  (from ,(key table))
                  (where ,where)
                  (order-by ,order-by))
                :as ',table)))
     data))

(defmacro select-where (table where &rest cols)
  `(retrieve-one
    (select ,cols
      (from ,(key table))
      (where ,where))))

(defmacro create-model (table returning &rest cols)
  `(handler-case
       (execute
        (insert-into ,(key table)
          (set= ,@(loop for i in cols by #'cddr
                        for j in (cdr cols) by #'cddr
                        unless (null j)
                          collect i and collect j)
                :created_at (local-time:now)
                :updated_at (local-time:now))
          (returning ,(key returning))))
     (error () nil)))

(defmacro delete-model (table where)
  `(execute
    (delete-from ,(key table)
      (where ,where))))
