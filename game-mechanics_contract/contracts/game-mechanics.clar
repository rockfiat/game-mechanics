
;; title: Game Mechanics IP Registry
;; version: 1.0.0
;; summary: A smart contract for registering and protecting video game mechanics and gameplay innovations
;; description: This contract allows game developers to register their unique mechanics,
;;              establish proof of creation, and manage IP rights for gameplay innovations.

;; traits
;;

;; token definitions
;;

;; constants
;;
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))

;; data vars
;;
(define-data-var next-mechanic-id uint u1)

;; data maps
;;
(define-map mechanics
  { mechanic-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    creator: principal,
    created-at: uint,
    category: (string-ascii 50),
    is-active: bool
  }
)

(define-map mechanic-ownership
  { creator: principal, mechanic-id: uint }
  { owned: bool }
)

(define-map creator-mechanics-count
  { creator: principal }
  { count: uint }
)

;; public functions
;;

;; Register a new game mechanic
(define-public (register-mechanic (title (string-ascii 100))
                                 (description (string-ascii 500))
                                 (category (string-ascii 50)))
  (let ((mechanic-id (var-get next-mechanic-id))
        (creator tx-sender)
        (current-block-height block-height))
    (begin
      ;; Validate inputs
      (asserts! (> (len title) u0) err-invalid-input)
      (asserts! (> (len description) u0) err-invalid-input)
      (asserts! (> (len category) u0) err-invalid-input)

      ;; Store the mechanic
      (map-set mechanics
        { mechanic-id: mechanic-id }
        {
          title: title,
          description: description,
          creator: creator,
          created-at: current-block-height,
          category: category,
          is-active: true
        })

      ;; Set ownership
      (map-set mechanic-ownership
        { creator: creator, mechanic-id: mechanic-id }
        { owned: true })

      ;; Update creator's mechanic count
      (map-set creator-mechanics-count
        { creator: creator }
        { count: (+ (get-creator-mechanic-count creator) u1) })

      ;; Increment the next mechanic ID
      (var-set next-mechanic-id (+ mechanic-id u1))

      (ok mechanic-id))))

;; Update a mechanic (only by creator)
(define-public (update-mechanic (mechanic-id uint)
                               (title (string-ascii 100))
                               (description (string-ascii 500))
                               (category (string-ascii 50)))
  (let ((mechanic (unwrap! (map-get? mechanics { mechanic-id: mechanic-id }) err-not-found))
        (creator tx-sender))
    (begin
      ;; Check if the caller is the creator
      (asserts! (is-eq creator (get creator mechanic)) err-unauthorized)

      ;; Validate inputs
      (asserts! (> (len title) u0) err-invalid-input)
      (asserts! (> (len description) u0) err-invalid-input)
      (asserts! (> (len category) u0) err-invalid-input)

      ;; Update the mechanic
      (map-set mechanics
        { mechanic-id: mechanic-id }
        (merge mechanic {
          title: title,
          description: description,
          category: category
        }))

      (ok true))))

;; Deactivate a mechanic (only by creator)
(define-public (deactivate-mechanic (mechanic-id uint))
  (let ((mechanic (unwrap! (map-get? mechanics { mechanic-id: mechanic-id }) err-not-found))
        (creator tx-sender))
    (begin
      ;; Check if the caller is the creator
      (asserts! (is-eq creator (get creator mechanic)) err-unauthorized)

      ;; Deactivate the mechanic
      (map-set mechanics
        { mechanic-id: mechanic-id }
        (merge mechanic { is-active: false }))

      (ok true))))

;; read only functions
;;

;; Get mechanic details by ID
(define-read-only (get-mechanic (mechanic-id uint))
  (map-get? mechanics { mechanic-id: mechanic-id }))

;; Check if a user owns a specific mechanic
(define-read-only (is-mechanic-owner (creator principal) (mechanic-id uint))
  (default-to false (get owned (map-get? mechanic-ownership { creator: creator, mechanic-id: mechanic-id }))))

;; Get the number of mechanics created by a user
(define-read-only (get-creator-mechanic-count (creator principal))
  (default-to u0 (get count (map-get? creator-mechanics-count { creator: creator }))))

;; Get the next mechanic ID that will be assigned
(define-read-only (get-next-mechanic-id)
  (var-get next-mechanic-id))

;; Get contract owner
(define-read-only (get-contract-owner)
  contract-owner)

;; private functions
;;
