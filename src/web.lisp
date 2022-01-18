(in-package :cl-user)
(defpackage shawarma.web
  (:use :cl
        :caveman2
        :shawarma.config
        :shawarma.view
        :shawarma.db
        :datafly
        :sxql
   :shawarma.utils
   :shawarma.orders
   :shawarma.models)
  (:export :*web*))
(in-package :shawarma.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

;(datafly:connect-toplevel :postgres :database-name "shawarma" :username "shawarma" :password "shawarma")
;(setf datafly:*connection* nil)

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(defmethod lack.component:call :around ((app <web>) env)
  (let ((datafly:*connection*
          (apply #'datafly:connect-cached (cdr (assoc :maindb (config :databases))))))
    (prog1
        (call-next-method))))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/api/*" ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :POST) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :DELETE) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :PUT) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/*" :method :OPTIONS) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Headers) "*")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Methods) "*")  
  (next-route))

(defroute ("/api/login" :method :POST) (&key |name| |password|)
  (render-json (login-user |name| |password|)))

(defroute "/api/orders" ()
  (render-json (find-where orders (:like :order "%%"))))

(defroute ("/api/orders" :method :POST) (&key |user| |pass| |order|)
  (render-json (make-order |user| |pass| |order|)))

(defroute ("/api/orders" :method :DELETE) (&key |user| |pass|)
  (render-json (delete-order |user| |pass|)))

(defroute ("/api/day" :method :POST) (&key |user| |pass|)
  (render-json (clear-orders |user| |pass|)))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
