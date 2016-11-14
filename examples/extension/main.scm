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

(define-extension (size-reporter listener)
  `((client
     (add-resize-listener parent-element
                          (lambda (ev)
                                    (let* ((client-rect (js-invoke parent-element "getBoundingClientRect"))
                                           (get-coord (lambda (coord)  (js-ref client-rect (symbol->string coord)))))                                     
                                      (call-server 'report-size (map get-coord '(top right bottom left)))))))
    (server-rpc (report-size ev)
                (,listener ev))))

(define my-label-extension (bgcolor-changer "blue"))

(define my-size-reporter (size-reporter (lambda (ev) (display (.toString ev)))))

(define (main ui)
  (let ((lbl (Label. "extend me")))
    (.addComponent ui lbl)
    (extend-component my-size-reporter lbl)))
    




