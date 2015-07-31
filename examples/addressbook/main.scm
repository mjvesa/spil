; Simple addresbook example for Spil
(load "vaadin.scm")

(define (main ui)
  (.addComponent ui (in-memory-crud '(name street  zip city))))
