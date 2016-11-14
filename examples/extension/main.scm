;;; Extension definition example
(load "vaadin.scm")
;;;;;;;;;
;; MAIN
;;;;;;;;;

(define ext
  (extension
   ((client
     (js-set!  (js-ref parent-element "style") "backgroundColor" "red")))))

(define-extension (bgcolor-changer bgcolor)
 `((client
   (js-set! (js-ref parent-element "style") "backgroundColor" ,bgcolor))))

(define my-label-extension (bgcolor-changer "blue"))

(define (main ui)
  (let ((lbl (Label. "extend me")))
    (.addComponent ui lbl)
    (.extendTarget my-label-extension lbl)))




