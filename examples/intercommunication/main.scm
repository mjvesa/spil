;; Example of one way of perming component intercommunication on the client side
(load "vaadin.scm")

;; Naive gensym implementation
(define *sym-count* 0)
(define (gensym)
  (set! *sym-count* (+ *sym-count* 1))
  (string->symbol (string-append "gensym" (number->string *sym-count*))))

;; A macro which defines a label and a slider. The label
;; is updated directly on the client side and RPC is used to
;; transmit the value to the server simultaneously.
(define-macro (slide-label min max listener)
  (let ((lblsym (symbol->string (gensym))))
    `(let* ((lbl (widget
                  (client
                   (let ((text-div (element-new '(div "default"))))
                     (append-to-root text-div)
                     (js-set! (js-eval "window") ,lblsym (lambda (value) (js-set! text-div "innerHTML" value)))))))
            (sldr  (widget
                    (client
                     (let ((slider (element-new
                                    '(input type "range" min ,(number->string min) max ,(number->string max)))))
                       (append-to-root slider)
                       (js-set! slider "oninput"
                                (js-closure (lambda ()
                                              (let ((value (js-ref slider "value")))
                                                (if (not (null? (js-ref (js-eval "window") ,lblsym)))
                                                    ((js-ref (js-eval "window") ,lblsym) (string-append "client: " value)))
                                                (call-server 'value-change value)))))))                                         
                    (server-rpc (value-change value)
                                (,listener value)))))
       (lambda (op)
         (case op
           ((get-slider) sldr)
           ((get-label) lbl))))))

(define *ui* '())

(define *lbl* (Label. "some label"))

(define (main ui)
  (set! *ui* ui)
  (let ((sldr (slide-label 10 200 (lambda (value) 
                                    ( .setValue *lbl* (string-append "server: " value)))))
        (hl (HorizontalLayout.)))
    (.setSpacing hl #t)
    (.addComponent hl *lbl*)
    (.addComponent hl (sldr 'get-label))
    (.addComponent ui hl)
    (.addComponent ui (sldr 'get-slider))))

