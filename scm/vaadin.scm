;; Vaadin support for Scheme
(import "com.vaadin.ui.*")
(import "com.vaadin.data.util.*")
(import "com.github.mjvesa.spil.VaadinUtil")
(import "com.github.mjvesa.spil.SchemeComponent")

(load "vaadin-widget.scm")


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
  (if (null? props)
    '()
    (begin 
      (set-prop item (car (car props)) (cdr (car  props)))
      (set-props-from-fields item (cdr props)))))

(define (add-components cont components)
  (for-each (lambda (c) (.addComponent cont c))
	    components)
  cont)

(define (in-memory-crud field-names)
  (begin
    (define (create-text-fields field-names)
      (if (eq? field-names '())
     	  '()
     	  (cons
     	   (cons (car field-names)
     		 (TextField. (.toString (car field-names))))
     	   (create-text-fields (cdr field-names)))))
    (define fields (create-text-fields field-names))
    (define container (create-container-with-fields field-names))
    (define contacts (Table. "Contacts" container))
    (define (add-contact) 
      (let ((item (.getItem container (.addItem container))))
	(begin 
	  (set-props-from-fields item fields))))
    (define add-button (Button. "Add"
				(VaadinUtil.buttonClickListener (lambda (event) (add-contact)))))
    (define (get-components-from-fields fields)
      (if (eq? fields '())
	  '()
	  (cons (cdr (car fields)) (get-components-from-fields (cdr fields)))))
    (define (create-fields)
      (let ((vl (VerticalLayout.)))
	(begin
	  (doto vl	    
		((.setMargin #t)
		 (add-components
		  (get-components-from-fields fields)))))))
    (define layout (VerticalLayout.))
    (add-components layout (list (create-fields) add-button contacts))
    layout))
  
