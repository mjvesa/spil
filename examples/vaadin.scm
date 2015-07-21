;; Vaadin support for Scheme
(import "com.vaadin.ui.*")
(import "com.vaadin.data.util.*")
(import "com.github.mjvesa.spil.VaadinUtil")

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

(define (add-components cont components)
  (for-each (lambda (c) (.addComponent cont c))
	    components)
  cont)

