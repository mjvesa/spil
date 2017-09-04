;; Widget macro and related helper procedures
(import "com.github.mjvesa.spil.SpilUI")

;;; forms for evaluating things on the client side
(define-macro (client-eval expr)
  (SpilUI.evalScheme (.toString expr)))

(define client-eval-all
  (lambda (exprs)
    (if (null? exprs)
        '()
        (begin
          (client-eval (car exprs))
          (client-eval-all (cdr exprs))))))


;;; React stuff
(client-eval-all
 '((define React
    (js-eval "React"))

  (define DOM
    (js-ref React "DOM"))

  (define ReactDOM
    (js-eval "ReactDOM"))

  (define (react-element el)
    (lambda (props children)
      (js-invoke React "createElement" (symbol->string el) props children)))

  (define (react-whitelist-0 elems)
    (if (null? elems)
        '()
        (cons `(define ,(string->symbol (string-append "$" (symbol->string (car elems)))) (react-element ',(car elems)))
              (react-whitelist-0 (cdr elems)))))

  (define-macro (react-whitelist elems)
    (cons 'begin (react-whitelist-0 elems)))

  (react-whitelist (a abbr address area article aside audio b base bdi bdo big blockquote body br
                      button canvas caption cite code col colgroup data datalist dd del details dfn
                      dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5
                      h6 head header hr html i iframe img input ins kbd keygen label legend li link
                      main map mark menu menuitem meta meter nav noscript object ol optgroup option
                      output p param picture pre progress q rp rt ruby s samp script section select
                      small source span strong style sub summary sup table tbody td textarea tfoot th
                      thead time title tr track u ul var video wbr))

  (define null (js-eval "null"))
  (define no-props null)
  (define no-children null)

  (define-macro (props . values)
    `(js-obj ,@values))

  (define-macro (styles . values)
    (props values))

  (define-macro (children . values)
    `(vector ,@values))

  (define-macro (get-prop prop)
    `(js-ref (js-ref this "props") ,prop))

  (define-macro (render code)
    `(js-set! self "onStateChange"
              (js-closure
               (lambda ()
                 (js-invoke ReactDOM "render" ,code root-element)))))))

;;; Manual DOM stuff
(client-eval-all
 '((define-macro (js-lambda params body)
    `(js-closure (lambda ,params ,body)))

  (define-macro (add-listener target event handler)
    `(js-invoke ,target "addEventListener" (symbol->string ,event) ,handler))

  (define (add-listeners-0 target listeners)
    (if (null? listeners)
        '()       
        (cons `(add-listener ,target ',(caar listeners) ,(cadar listeners))
              (add-listeners-0 target (cdr listeners)))))

  (define-macro (add-listeners target listeners)
    (cons 'begin (add-listeners-0 target listeners)))

  (define-macro (js-lambda params body)
    `(js-closure (lambda ,params ,body)))

  (define-macro (client-rpc params code)
    `(js-set! self ,(symbol->string (car params))
              (js-closure
               (lambda (str) (let ((,@(cdr params) (read (open-input-string str))))
                          ,code)))))
  
  (define-macro (on-state-change code)
    `(js-set! self "onStateChange"
              (js-closure
               (lambda () ,code))))))

;;; Things for the server side
(define (call-client comp func)
  (.callClient comp (.toString func)))

(define (call-client-rpc comp func args)
  (.callClient comp (.toString func) args))

(define (set-widget-state comp state)
  (.setLst (.getState comp) (.toString state)))


