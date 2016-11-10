;; Widget macro and related helper procedures
(import "com.github.mjvesa.spil.SpilUI")

(define-macro (client-eval expr)
  (SpilUI.evalScheme (.toString expr)))

(define (client-eval-all-0 exprs)
  (if (null? exprs)
      '()
      (cons `(SpilUI.evalScheme (.toString ,(car exprs))) (client-eval-all-0 (cdr exprs)))))

(define-macro (client-eval-all . exprs)
  (cons 'begin (client-eval-all-0 exprs)))

(client-eval-all
 (define-macro (js-lambda params body)
   `(js-closure (lambda ,params ,body))))

(client-eval (define-macro (add-listener target event handler)
               `(js-invoke ,target "addEventListener" (symbol->string ,event) (js-lambda (ev) ,handler))))

(client-eval
 (define (add-listeners-0 target listeners)
   (if (null? listeners)
       '()       
       (cons `(add-listener ,target ',(caar listeners) ,(cadar listeners))
             (add-listeners-0 target (cdr listeners))))))

(client-eval
 (define-macro (add-listeners target listeners)
   (cons 'begin (add-listeners-0 target listeners))))

(client-eval
 (define-macro (js-lambda params body)
   `(js-closure (lambda ,params ,body))))

(client-eval
 (define-macro (client-rpc params code)
   `(js-set! self ,(symbol->string (car params))
             (js-closure
              (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
							  ,code))))))
(client-eval
 (define-macro (on-state-change code)
   `(js-set! self "onStateChange"
             (js-closure
              (lambda () ,code)))))

(define client-boilerplate
  '(let*
       ((namespace "com_github_mjvesa_spil_SchemeComponent")
        (self (js-eval (string-append namespace ".self")))
        (root-element (js-invoke self "getElement"))
        (list-to-string (lambda (lst)
                          (let ((out (open-output-string)))
                            (write lst out)
                            (get-output-string out))))
        (call-server (lambda (name paramz)
                       (js-invoke self (symbol->string name)  (list-to-string paramz))))
        (get-state (lambda ()
                     (js-ref (js-invoke self "getState") "lst")))
        (append-to-root (lambda (element)
                          (element-append-child! root-element element))))))
(define client-code '())

(define (handle-widget-section comp section)
  (let ((param-name (cdadr section))
        (section-code (caddr section)))
    (case (car section)
      ((client)
       (set! client-code (append client-code (cdr section))))
      ((server-rpc)
       (.registerServerRpc  comp (symbol->string (caadr section)) (eval `(lambda ,param-name ,section-code))))
      (else
       (display (string-append "Unrecognized section: " (car section) "\n"))))))

(define-macro  (widget widget-definition) 
  `(let ((comp (SchemeComponent.)))
     (set! client-code client-boilerplate)
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     (.setComponentCode comp (.toString (list (append '(lambda ()) (list client-code)))))
     comp))

(define-macro (define-widget params . widget-definition)
  `(define-macro ,params
     (list 'widget ,@widget-definition)))

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClient comp (.toString func) args))

(define (set-widget-state comp state)
  (.setLst (.getState comp) (.toString state)))


