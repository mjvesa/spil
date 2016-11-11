;; Widget macro and related helper procedures
(import "com.github.mjvesa.spil.SpilUI")

(define-macro (client-eval expr)
  (SpilUI.evalScheme (.toString expr)))

(client-eval
 (define-macro (js-lambda params body)
   `(js-closure (lambda ,params ,body))))

(client-eval
 (define-macro (add-listener target event handler)
   `(js-invoke ,target "addEventListener" (symbol->string ,event) ,handler)))

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

(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClient comp (.toString func) args))

(define (set-widget-state comp state)
  (.setLst (.getState comp) (.toString state)))


