;; Widget macro and related helper procedures

(define client-boilerplate
  '(let*
	 ((namespace "com_github_mjvesa_spil_SchemeComponent")
	  (self (js-eval (string-append namespace ".self")))
	  (root-element (js-invoke self "getElement"))
	  (list-to-string (lambda (lst)
	    (let ((out (open-output-string)))
		  (write lst out)
		  (get-output-string out))))
	  (call-server (lambda name params)
	    (js-invoke self (symbol->string name)  (list-to-string params)))
	  (get-state (lambda ()
	    (js-invoke self "getState")))
	  (append-to-root (lambda (element)
			    (element-append-child! root-element element))))))

(define (client-function params code)
  `((js-set! self ,(.toString (car params))
	     (js-closure
	      (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
			      ,code))))))

(define (client-state-function code)
  `((js-set! self "onStateChange"
	     (js-closure
	      (lambda () ,@code)))))

(define client-code '())

(define (handle-widget-section comp section)
  (let ((param-name (cdadr section))
	(section-code (caddr section)))
    (case (car section)
      ((client-init)
       (set! client-code (append client-code (cdr section))))
      ((client-rpc)
       (set! client-code (append client-code (client-function (cadr section) (cddr section)))))
      ((on-state-change)
       (set! client-code (append client-code (client-state-function (cdr section)))))
      ((server-rpc)
       (.registerServerRpc  comp (symbol->string (caadr section)) (eval `(lambda ,param-name ,section-code))))
      (else
       (display (string-append "Unrecognized section: " (car section) "\n"))))))

(define (upload-macros comp)
  (.setComponentCode comp (.toString

			   
			   '(define-macro (client-rpc params code)
			      `(js-set! self ,(symbol->string (car params))
					 (js-closure
					  (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
							  ,code)))))))
  (.setComponentCode comp (.toString

			   '(define-macro (on-state-change code)
			      `(js-set! self "onStateChange"
					 (js-closure
					  (lambda () ,@code)))))))

(define-macro  (widget . widget-definition) 
  `(let ((comp (SchemeComponent.)))
     (upload-macros comp)
     (set! client-code client-boilerplate)
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     (display (string-append "Client code:\n" (list (append '(lambda ()) (list client-code))) "\n"))
     (.setComponentCode comp (.toString (list (append '(lambda ()) (list client-code)))))
     comp))

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClient comp (.toString func) args))

(define (set-widget-state comp state)
  (.setLst (.getState comp) (.toString state)))


