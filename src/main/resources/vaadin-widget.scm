;; Widget and extension definition
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

(define client-boilerplate-extension
  '(let*
       ((namespace "com_github_mjvesa_spil_SchemeExtension")
        (self (js-eval (string-append namespace ".self")))
        (root-element (js-invoke self "getElement"))
        (parent-element (js-invoke self "getElement" (js-invoke self "getParentId")))
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

;;; Widgets
(define-macro  (widget widget-definition) 
  `(let ((comp (SchemeComponent.))
     (set! client-code client-boilerplate)
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     (.setComponentCode comp (.toString (list (append '(lambda ()) (list client-code)))))
     comp)))

(define-macro (define-widget params . widget-definition)
  `(define-macro ,params
     (list 'widget ,@widget-definition)))

;;; Extensions
(define-macro  (extension widget-definition) 
  `(let ((comp (SchemeExtension.)))
     (set! client-code client-boilerplate-extension)
     (for-each (lambda (def) (handle-widget-section comp  def)) ',widget-definition)
     (.setComponentCode comp (.toString (list (append '(lambda ()) (list client-code)))))
     comp))

(define-macro (define-extension params . extension-definition)
  `(define-macro ,params
     (list 'extension ,@extension-definition)))
