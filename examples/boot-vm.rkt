#lang reader "../lang.rkt"

;; Prelude
(class Unit) (class String) (class Boolean) (class Token) (class Image)

(class Keystone
  ;; Get a token
  (def (get-token [name : String]
                  [passwd : String]
                  -> Token)
    ???)

  ;; Check a token
  (def (check-token [app-token : Token]
                    [user-token : Token]
                    -> Boolean)
    ???))

(class Glance
  (field [k : Keystone])
  (field [glance-token : Token])

  (def (init [_k : Keystone] -> Θ/Glance)
    (set-field! this k _k)
    (set-field! this glance-token
                (send k get-token "glance" "glance-passwd"))
    this)

  (def (get-image [user-token : Token]
                  [image-name : String]
                  -> Image)
    ;; 1. Check token validity (keystone middleware)
    ;;;; TODO: implement unless and error
    ;;;; (unless
           (send k check-token glance-token user-token)
      ;;;; (error "You are not authorized to boot a VM"))

    ;; 2. Get and return the Blob of the image
    ???))

(class Nova
  (field [k : Keystone])
  (field [g : Glance])
  (field [nova-token : Token])

  ;; Initialize a nova instance with
  (def (init [_k : Keystone]     ;; ^ its keystone client
             [_g : Glance]       ;; ^ its glance client
             -> Θ/Nova)
    (set-field! this k _k)
    (set-field! this g _g)
    (set-field! this nova-token
                (send k get-token "nova" "nova-passwd"))
    this)

  ;; Boot a VM
  (def (boot-vm [user-token : Token]
                [image-name : String]
                -> Unit)
    ;; 1. Check token validity (keystone middleware)
    ;;;; TODO: implement unless and error
    ;;;; (unless
           (send k check-token nova-token user-token)
      ;;;; (error "You are not authorized to boot a VM"))

    ;; 2. Get image
    (let ([img : Image (send g get-image user-token "debian")])
      ;; 3. Boot the VM
      ???)))

;; OpenStack initialization (i.e., start of the services)
(let ([k : Keystone (new Keystone)]
      [g : Glance   (send (new Glance) init k)]
      [n : Nova     (send (new Nova) init k g)])

  ;; Main program
  (let ([alice-token : Token (send k get-token "alice" "alice-passwd")])
    (send n boot-vm alice-token "debian" )))

; Trace
; ⊢p = #<syntax:desugar.rkt:71:22 ((import) (class Unit ()) (class String ()) (class Boolean ()) (class Token ()) (class Image ()) (class Keystone () (def (get-token (name (String world ())) (passwd (String world ())) (Token world ())) ???) (def (check-token (app-token (Token world ()))...>

; ⊢d = #<syntax:examples/boot-vm.rkt:4:0 (class Unit ())>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:4:13 (class String ())>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:4:28 (class Boolean ())>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:4:44 (class Token ())>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:4:58 (class Image ())>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:6:0 (class Keystone () (def (get-token (name (String world ())) (passwd (String world ())) (Token world ())) ???) (def (check-token (app-token (Token world ())) (user-token (Token world ())) (Boolean world ())) ???))>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:8:2 (def (get-token (name (String world ())) (passwd (String world ())) (Token world ())) ???)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:10:21 (Token world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:8:26 (String world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:9:28 (String world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:11:4 ???>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:14:2 (def (check-token (app-token (Token world ())) (user-token (Token world ())) (Boolean world ())) ???)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:16:23 (Boolean world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:14:33 (Token world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:15:34 (Token world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:17:4 ???>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:19:0 (class Glance () (field k (Keystone world ())) (field glance-token (Token world ())) (def (init (_k (Keystone world ())) (Glance Θ ())) (set-field! this k _k) (set-field! this glance-token (send (get-field this k) get-token "glance" "glance-passwd")) t...>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:20:14 (Keystone world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:21:25 (Token world ())>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:23:2 (def (init (_k (Keystone world ())) (Glance Θ ())) (set-field! this k _k) (set-field! this glance-token (send (get-field this k) get-token "glance" "glance-passwd")) this)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:23:32 (Glance Θ ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:23:19 (Keystone world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:24:4 (set-field! this k _k)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:24:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:24:23 _k>
;
; is-this? = #<syntax:examples/boot-vm.rkt:24:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:25:4 (set-field! this glance-token (send (get-field this k) get-token "glance" "glance-passwd"))>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:25:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:26:16 (send (get-field this k) get-token "glance" "glance-passwd")>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:26:22 (get-field this k)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:26:34 "glance">
;
; ⊢e = #<syntax:examples/boot-vm.rkt:26:43 "glance-passwd">
;
; is-this? = #<syntax:examples/boot-vm.rkt:26:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:26:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:26:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:25:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:27:4 this>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:29:2 (def (get-image (user-token (Token world ())) (image-name (String world ())) (Image world ())) (send (get-field this k) check-token (get-field this glance-token) user-token) ???)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:31:21 (Image world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:29:32 (Token world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:30:32 (String world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:35:11 (send (get-field this k) check-token (get-field this glance-token) user-token)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:35:17 (get-field this k)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:35:31 (get-field this glance-token)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:35:44 user-token>
;
; is-this? = #<syntax:examples/boot-vm.rkt:35:17 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:35:17 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:35:17 (get-field this k)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:39:4 ???>
;
; ⊢d = #<syntax:examples/boot-vm.rkt:41:0 (class Nova () (field k (Keystone world ())) (field g (Glance world ())) (field nova-token (Token world ())) (def (init (_k (Keystone world ())) (_g (Glance world ())) (Nova Θ ())) (set-field! this k _k) (set-field! this g _g) (set-field! this nova-tok...>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:42:14 (Keystone world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:43:14 (Glance world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:44:23 (Token world ())>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:47:2 (def (init (_k (Keystone world ())) (_g (Glance world ())) (Nova Θ ())) (set-field! this k _k) (set-field! this g _g) (set-field! this nova-token (send (get-field this k) get-token "nova" "nova-passwd")) this)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:49:16 (Nova Θ ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:47:19 (Keystone world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:48:19 (Glance world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:50:4 (set-field! this k _k)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:50:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:50:23 _k>
;
; is-this? = #<syntax:examples/boot-vm.rkt:50:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:51:4 (set-field! this g _g)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:51:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:51:23 _g>
;
; is-this? = #<syntax:examples/boot-vm.rkt:51:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:52:4 (set-field! this nova-token (send (get-field this k) get-token "nova" "nova-passwd"))>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:52:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:53:16 (send (get-field this k) get-token "nova" "nova-passwd")>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:53:22 (get-field this k)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:53:34 "nova">
;
; ⊢e = #<syntax:examples/boot-vm.rkt:53:41 "nova-passwd">
;
; is-this? = #<syntax:examples/boot-vm.rkt:53:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:53:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:53:22 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:52:16 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:54:4 this>
;
; ⊢m = #<syntax:examples/boot-vm.rkt:57:2 (def (boot-vm (user-token (Token world ())) (image-name (String world ())) (Unit world ())) (send (get-field this k) check-token (get-field this nova-token) user-token) (let (img (Image world ()) (send (get-field this g) get-image user-token "debian")) ...>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:59:19 (Unit world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:57:30 (Token world ())>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:58:30 (String world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:63:11 (send (get-field this k) check-token (get-field this nova-token) user-token)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:63:17 (get-field this k)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:63:31 (get-field this nova-token)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:63:42 user-token>
;
; is-this? = #<syntax:examples/boot-vm.rkt:63:17 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:63:17 (get-field this k)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:63:17 (get-field this k)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:67:4 (let (img (Image world ()) (send (get-field this g) get-image user-token "debian")) ???)>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:67:17 (Image world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:67:23 (send (get-field this g) get-image user-token "debian")>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:67:29 (get-field this g)>
;
; ⊢e = #<syntax:desugar.rkt:262:34 this>
;
; is-this? = #<syntax:desugar.rkt:262:34 this>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:67:41 user-token>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:67:52 "debian">
;
; is-this? = #<syntax:examples/boot-vm.rkt:67:29 (get-field this g)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:67:29 (get-field this g)>
;
; is-this? = #<syntax:examples/boot-vm.rkt:67:29 (get-field this g)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:69:6 ???>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:72:0 (let (k (Keystone world ()) (new (Keystone world ()))) (let (g (Glance world ()) (send (new (Glance world ())) init k)) (let (n (Nova world ()) (send (new (Nova world ())) init k g)) (let (alice-token (Token world ()) (send k get-token "alice" "alice-pa...>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:72:11 (Keystone world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:72:20 (new (Keystone world ()))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:72:25 (Keystone world ())>
;
; ⊢e = #<syntax:desugar.rkt:195:32 (let (g (Glance world ()) (send (new (Glance world ())) init k)) (let (n (Nova world ()) (send (new (Nova world ())) init k g)) (let (alice-token (Token world ()) (send k get-token "alice" "alice-passwd")) (send n boot-vm alice-token "debian"))))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:73:11 (Glance world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:73:20 (send (new (Glance world ())) init k)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:73:26 (new (Glance world ()))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:73:31 (Glance world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:73:44 k>
;
; is-this? = #<syntax:examples/boot-vm.rkt:73:26 (new (Glance world ()))>
;
; is-this? = #<syntax:examples/boot-vm.rkt:73:26 (new (Glance world ()))>
;
; ⊢e = #<syntax:desugar.rkt:195:32 (let (n (Nova world ()) (send (new (Nova world ())) init k g)) (let (alice-token (Token world ()) (send k get-token "alice" "alice-passwd")) (send n boot-vm alice-token "debian")))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:74:11 (Nova world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:74:20 (send (new (Nova world ())) init k g)>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:74:26 (new (Nova world ()))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:74:31 (Nova world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:74:42 k>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:74:44 g>
;
; is-this? = #<syntax:examples/boot-vm.rkt:74:26 (new (Nova world ()))>
;
; is-this? = #<syntax:examples/boot-vm.rkt:74:26 (new (Nova world ()))>
;
; is-this? = #<syntax:examples/boot-vm.rkt:74:26 (new (Nova world ()))>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:77:2 (let (alice-token (Token world ()) (send k get-token "alice" "alice-passwd")) (send n boot-vm alice-token "debian"))>
;
; ⊢τ = #<syntax:examples/boot-vm.rkt:77:23 (Token world ())>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:77:29 (send k get-token "alice" "alice-passwd")>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:77:35 k>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:77:47 "alice">
;
; ⊢e = #<syntax:examples/boot-vm.rkt:77:55 "alice-passwd">
;
; is-this? = #<syntax:examples/boot-vm.rkt:77:35 k>
;
; is-this? = #<syntax:examples/boot-vm.rkt:77:35 k>
;
; is-this? = #<syntax:examples/boot-vm.rkt:77:35 k>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:78:4 (send n boot-vm alice-token "debian")>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:78:10 n>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:78:20 alice-token>
;
; ⊢e = #<syntax:examples/boot-vm.rkt:78:32 "debian">
;
; is-this? = #<syntax:examples/boot-vm.rkt:78:10 n>
;
; is-this? = #<syntax:examples/boot-vm.rkt:78:10 n>
;
; is-this? = #<syntax:examples/boot-vm.rkt:78:10 n>

;;
