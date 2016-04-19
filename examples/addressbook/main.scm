;;; Simple addresbook example for Spil
(load "vaadin.scm")

(define (in-memory-crud field-names)
  (letrec
      ((create-text-fields (lambda  (field-names)
                             (if (null? field-names)
                                 '()
                                 (cons
                                  (cons (car field-names)
                                        (TextField. (.toString (car field-names))))
                                  (create-text-fields (cdr field-names))))))
       (fields (create-text-fields field-names))
       (container (create-container-with-fields field-names))
       (contacts (Table. "Contacts" container))
       (add-contact (lambda ()
                      (let ((item (.getItem container (.addItem container))))
                        (set-props-from-fields item fields))))
       (add-button (Button. "Add"
                            (VaadinUtil.buttonClickListener
                             (lambda (event)
                               (add-contact)))))
       (get-components-from-fields (lambda (fields)
                                     (if (null? fields)
                                         '()
                                         (cons (cdr (car fields))
                                               (get-components-from-fields (cdr fields))))))
       (create-fields (lambda ()
                        (let ((vl (VerticalLayout.)))
                          (doto vl	    
                                ((.setMargin #t)
                                 (add-components
                                  (get-components-from-fields fields)))))))
       (layout (VerticalLayout.)))
    (add-components layout (list (create-fields) add-button contacts))
    layout))

(define (main ui)
  (.addComponent ui (in-memory-crud '(name street  zip city))))
