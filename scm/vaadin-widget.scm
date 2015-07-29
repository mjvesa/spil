;; Widget macro and related helper procedures

(define client-boilerplate
  '(begin (define namespace "com_github_mjvesa_spil_SchemeComponent")
	  (define self (js-eval (string-append namespace ".self")))
	  (define root-element (js-invoke self "getElement"))
	  (define (list-to-string lst)
	    (let ((out (open-output-string)))
		  (write lst out)
		  (get-output-string out)))
	  (define (call-server name params)
	    (js-invoke self (symbol->string name)  (list-to-string params)))
	  (define (get-state)
	    (js-invoke self "getState"))
	  (define (append-to-root element)
	    (element-append-child! root-element element))))

(define (client-function params code)
  (cons 'begin
	(cons client-boilerplate
	      `((js-set! self ,(.toString (car params))
			 (js-closure
			  (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
					      ,code))))))))

(define (client-state-function code)
  (cons 'begin
	(cons client-boilerplate
	      `((js-set! self "onStateChange"
			 (js-closure
			  (lambda () ,@code)))))))

(define (handle-widget-section comp section)
  (let ((param-name (cdadr section))
	(section-code (caddr section)))
    (case (car section)
      ((client-init)
       (.setComponentCode comp (.toString (cons 'begin (cons client-boilerplate (cdr section))))))
      ((client-rpc)
       (.setComponentCode comp (.toString (client-function (cadr section) (cddr section)))))
      ((server-rpc)
       (.registerServerRpc  comp (symbol->string (caadr section)) (eval `(lambda ,param-name ,section-code))))
      ((on-state-change)
       (.setComponentCode comp  (.toString (client-state-function (cdr section)))))
      (else
       (display (string-append "Unrecognized section: " (car section) "\n"))))))

(define-macro  (widget . widget-definition) 
  `(let ((comp (SchemeComponent.)))
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     comp))

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClient comp (.toString func) args))

(define (set-widget-state comp state)
  (.setLst (.getState comp) (.toString state)))
