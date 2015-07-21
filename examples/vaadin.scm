;; Vaadin support for Scheme

(define (inner-doto target ops)
  (if (eq? ops '())
      `(,target)
      (cons `(,(car (car ops)) ,target ,(car (cdr (car ops))))
	                   (inner-doto target (cdr ops)))))

(define-macro (doto target ops)
  (cons 'begin (inner-doto target ops)))

(define (list-to-array lst)
  (let ((col (ArrayList.)))
    (begin 
      (for-each (lambda (item) (.add col item)) lst)
      (.toArray col))))

(define (create-container-with-fields lst)
  (let ((cnt (IndexedContainer.))) 
    (begin
      (for-each (lambda (str) 
                  (.addContainerProperty cnt str java.lang.String.class "")) lst)
       cnt)))

(define (set-prop item prop field)
 (.setValue (.getItemProperty item prop) (.getValue field)))

(define (set-props-from-fields item props)
  (if (null? item)
    '()
    (begin 
      (set-prop item (car (car props)) (car (cdr (car props))))
        (set-props-from-fields item (cdr props)))))
