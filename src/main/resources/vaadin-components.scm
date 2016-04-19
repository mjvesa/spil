;;; Shorthand forms for creation of Vaadin component trees

;;;;;;;;;;;
;;; Layouts
;;;;;;;;;;;

(define (fill-layout layout components)
  (for-each (lambda (c) (.addComponent layout c)) components)
  layout)

(define (vertical-layout . components)
  (fill-layout (VerticalLayout.) components))

(define (horizontal-layout . components)
  (fill-layout (HorizontalLayout.) components))

(define (css-layout . components)
  (fill-layout (CssLayout.) components))

;;;;;;;;;;;;;;;;;;;;
;;; Clickable things
;;;;;;;;;;;;;;;;;;;;

(define (button name  listener)
  (let ((b (Button. name)))
    (.addClickListener b listener)
    b))

(define (check-box name listener)
  (let ((b (Button. name)))
    (.addClickListener b listener)
    b))

(define (radio-button name listener)
  (let ((b (Button. name)))
    (.addClickListener b listener)
    b))

;;;;;;;;;;;;;;
;;; Text entry
;;;;;;;;;;;;;;

(define (text-field name . listener)
  (TextField. name))

(define (text-area name . listener)
  (TextArea. name))

