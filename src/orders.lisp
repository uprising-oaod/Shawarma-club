(in-package :cl-user)
(defpackage shawarma.orders
  (:use :cl :shawarma.models :sxql :datafly :shawarma.utils :shawarma.users)
  (:export :create-order
   :clear-orders
   :delete-order
           :make-order))

(in-package :shawarma.orders)

(defun find-order (user)
  (retrieve-one
   (select :*
     (from :orders)
     (where (:= :user user)))
   :as 'orders))

(defun clear-orders (user pass)
  (when (and (equalp user "Маша")
             (login-user user pass))
    (execute
     (delete-from :orders
       (where (:like :user "%%"))))))

(defun delete-order (user pass)
  (if (login-user user pass)
      (execute
       (delete-from :orders
         (where (:= :user user))))
      "Not authorized"))

(defun make-order (user pass order)
  (if (login-user user pass)
      (if (find-order user)
          (change-order user order)
          (create-order user order))
      "Not authorized"))

(defun create-order (user order)
  (handler-case 
      (retrieve-one
       (insert-into :orders
         (set= :user user
               :order order               
               :created_at (local-time:now)
               :updated_at (local-time:now))
         (returning :order)))
    (error (e) e)))

(defun change-order (user order)
  (handler-case
      (retrieve-one
       (update :orders
         (set= :order order
               :updated_at (local-time:now))
         (where (:= :user user))
         (returning :order)))
    (error (e) e)))
