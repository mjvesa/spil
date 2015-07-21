; Custom component example
(import "com.vaadin.ui.*")
(import "com.vaadin.data.util.*")
(import "com.github.mjvesa.spil.VaadinUtil")
(import "com.github.mjvesa.spil.SchemeComponent")


(define js-code
  '(begin
    (define namespace "com_github_mjvesa_spil_SchemeComponent")
    (define self (string-append namespace ".self"))
    (js-set! (js-eval self) "kaboom" (js-closure (lambda () (alert "KABOOM!"))))))



(define (main ui)
  (let ((comp (SchemeComponent.)))
    (.setComponentCode comp (.toString js-code))
    (.addComponent ui comp)
    (.callClient comp "kaboom")
    (.addComponent ui (Label. (.toString js-code)))))




;; TODO here are some ideas for a procedure for creating client side components

;; (widget name
;;  (client-init
;;    ())
;;  (server-init
;;    ())
;;  (server-to-client  
;;   ())
;;  (client-to-server
;;   ())
;;  (state-change
;;   ()))


