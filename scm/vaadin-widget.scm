;; Widget macro and related helper procedures

(define client-boilerplate
  '(begin (define namespace "com_github_mjvesa_spil_SchemeComponent")
	  (define self (js-eval (string-append namespace ".self")))
	  (define root-element (js-invoke self "getElement"))
	  (define (append-to-root element)
	    (element-append-child! root-element element))))

(define (client-rpc params code)
  (cons 'begin
	(cons client-boilerplate
	      `((js-set! self ,(.toString (car params))
			 (js-closure
			  (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
					      ,code))))))))

(define (handle-widget-section comp section)
  (let ((section? (lambda (section-name) (eq? section-name (car section)))))
    (cond
     ((section? 'client-init)
      (.setComponentCode comp (.toString (cons 'begin (cons client-boilerplate (cdr section))))))
     ((section? 'client-rpc)
      (.setComponentCode comp (.toString (client-rpc (cadr section) (cddr section)))))
     (else (display (string-append ("Unrecognized section: " (car section))))))))

(define-macro  (widget . widget-definition) 
  `(let ((comp (SchemeComponent.)))
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     comp))

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClientRPC comp (.toString func) args))
