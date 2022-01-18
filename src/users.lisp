(in-package :cl-user)
(defpackage shawarma.users
  (:use :cl :shawarma.models :sxql :datafly :shawarma.utils)
  (:export :create-user
           :login-user))

(in-package :shawarma.users)

(defun create-user (name password)
  (handler-case 
      (retrieve-one
       (insert-into :users
         (set= :name name
               :password password               
               :created_at (local-time:now)
               :updated_at (local-time:now))
         (returning :id)))
    (error (e) e)))

;(print (create-user "Никита" "yapidor"))
;(print (create-user "Виктор" "nM0mg2o2L7"))
;(print (create-user "Маша" "cQ4Jj11UGS"))
;(print (create-user "Миша" "oZKWQr37FW"))
;(print (create-user "Ваня" "yID3dhwkO2"))
;(print (create-user "Валя" "N435b56Tcy"))
;(print (create-user "Федя" "ABTq506lEc"))
;(print (create-user "Василий" "9x6iqiCeCX"))
;(print (create-user "Денис" "KTn8uXRE7B"))
;(print (create-user "Илья" "EZ5wDrrRVe"))
;(print (create-user "Артём" "LNO0UqT7QJ"))


(defun login-user (name pass)
  (retrieve-one
   (select :*
     (from :users)
     (where (:and (:= :name name)
                  ;(:= :password pass)
                  )))))
