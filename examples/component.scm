; Custom component example
(import "com.vaadin.ui.*")
(import "com.vaadin.data.util.*")
(import "com.github.mjvesa.spil.VaadinUtil")
(import "com.github.mjvesa.spil.SchemeComponent")


;; (define js-code
;;   '(begin
;;     (define namespace "com_github_mjvesa_spil_SchemeComponent")
;;     (define self (string-append namespace ".self"))
;;     (js-set! (js-eval self) "kaboom" (js-closure (lambda () (console-warn "KABOOM!"))))))


(define client-boilerplate
  '(begin (define namespace "com_github_mjvesa_spil_SchemeComponent")
	  (define self (js-eval (string-append namespace ".self")))))
 
(define (client-rpc name code)
  (cons 'begin
	(cons client-boilerplate
	      `((js-set! self ,name (js-closure (lambda () ,@code)))))))

(define (handle-widget-section comp section)
  (let ((section? (lambda (section-name) (eq? section-name (car section)))))
    (cond
     ((section? 'client-init)
      (.setComponentCode comp (.toString (cadr section))))
     ((section? 'client-rpc)
      (.setComponentCode comp (.toString (client-rpc (.toString (cadr section)) (cddr section)))))
     (else (display (string-append ("Unrecognized section: " (car section))))))))



(define-macro  (widget widget-definition) 
  `(let ((comp (SchemeComponent.)))
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     comp))

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (main ui)
  (let ((comp (widget
	       ((client-init
		 (console-warn "Hello world"))
		(client-rpc poks
			    (console-warn "I was called"))))))
    (.addComponent ui comp)
    (call-client  comp 'poks)))

