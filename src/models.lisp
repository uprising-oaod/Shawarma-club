(in-package :cl-user)
(defpackage shawarma.models
  (:use :cl :sxql :cl-annot.class :datafly))

(in-package :shawarma.models)

(syntax:use-syntax :annot)

@export-accessors
@export
(defmodel (users (:inflate created-at #'datetime-to-timestamp)
                 (:inflate updated-at #'datetime-to-timestamp))
  id
  name
  password
  created-at
  updated-at)

@export-accessors
@export
(defmodel (orders (:inflate created-at #'datetime-to-timestamp)
                  (:inflate updated-at #'datetime-to-timestamp))
  id
  user
  order
  created-at
  updated-at)
