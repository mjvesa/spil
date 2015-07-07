; Simple addresbook example for Spil
(import "com.vaadin.ui.*")
(import "com.vaadin.data.util.*")
(import "com.github.mjvesa.spil.VaadinUtil")

(define name-field (TextField. "Name"))
(define street-field (TextField. "Street"))
(define zip-field (TextField. "Zipcode"))
(define city-field (TextField. "City"))
(define contacts (Table. "Contacts"))

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

(define container (create-container-with-fields (list "name" "street" "zip" "city")))

(define (set-prop item prop field)
 (.setValue (.getItemProperty item prop) (.getValue field)))

(define (set-props-from-fields item props)
  (if (null? item)
    '()
    (begin 
      (set-prop item (car (car props)) (car (cdr (car props))))
        (set-props-from-fields item (cdr props)))))

(define (add-contact) 
  (let ((item (.getItem container (.addItem container))))
    (begin 
      (set-props-from-fields item (list (list "name" name-field)
                                  (list "street" street-field)
                                  (list "zip" zip-field)
                                  (list "city" city-field))))))

(define add-button (Button. "Add"
  (VaadinUtil.buttonClickListener (lambda (event) (add-contact)))))

(define (setup-contacts-table)
  (begin
    (.setContainerDataSource contacts container)))
;;    (.setVisibleColumns contacts 
;;      (list-to-array (list "jee" "jaa")))))

(define (create-fields)
  (let ((vl (VerticalLayout.)))
    (begin 
      (.setMargin vl #t)
      (.addComponent vl name-field)
      (.addComponent vl street-field)
      (.addComponent vl zip-field)
      (.addComponent vl city-field)
       vl)))

(define (main ui)
  (begin 
    (setup-contacts-table)
      (for-each (lambda (c) (.addComponent ui c))
        (list (create-fields) add-button contacts))))
