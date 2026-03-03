;; Lottery Contract - Decentralized lottery on Stacks
;; Built with @stacks/transactions

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_LOTTERY_CLOSED (err u101))
(define-constant ERR_INVALID_AMOUNT (err u102))
(define-constant TICKET_PRICE u1000000) ;; 1 STX

;; Data vars
(define-data-var lottery-id uint u0)
(define-data-var current-pot uint u0)
(define-data-var ticket-count uint u0)
(define-data-var is-open bool true)

;; Maps
(define-map tickets uint principal)
(define-map winners uint { winner: principal, prize: uint })

;; Read-only functions
(define-read-only (get-lottery-id)
  (var-get lottery-id))

(define-read-only (get-current-pot)
  (var-get current-pot))

(define-read-only (get-ticket-count)
  (var-get ticket-count))

(define-read-only (is-lottery-open)
  (var-get is-open))

(define-read-only (get-ticket (id uint))
  (map-get? tickets id))

(define-read-only (get-winner (lottery uint))
  (map-get? winners lottery))

;; Public functions
(define-public (buy-ticket)
  (let ((new-ticket-id (+ (var-get ticket-count) u1)))
    (asserts! (var-get is-open) ERR_LOTTERY_CLOSED)
    (try! (stx-transfer? TICKET_PRICE tx-sender (as-contract tx-sender)))
    (map-set tickets new-ticket-id tx-sender)
    (var-set ticket-count new-ticket-id)
    (var-set current-pot (+ (var-get current-pot) TICKET_PRICE))
    (ok new-ticket-id)))

;; Buy multiple tickets at once
(define-public (buy-tickets (quantity uint))
  (let (
    (total-cost (* TICKET_PRICE quantity))
    (start-id (var-get ticket-count))
  )
    (asserts! (var-get is-open) ERR_LOTTERY_CLOSED)
    (asserts! (> quantity u0) ERR_INVALID_AMOUNT)
    (asserts! (<= quantity u10) (err u103)) ;; Max 10 tickets per tx
    (try! (stx-transfer? total-cost tx-sender (as-contract tx-sender)))
    (fold assign-ticket (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10) { count: u0, target: quantity, base: start-id })
    (var-set ticket-count (+ start-id quantity))
    (var-set current-pot (+ (var-get current-pot) total-cost))
    (ok quantity)))

;; Helper for bulk ticket assignment
(define-private (assign-ticket (i uint) (state { count: uint, target: uint, base: uint }))
  (if (< (get count state) (get target state))
    (begin
      (map-set tickets (+ (get base state) (+ (get count state) u1)) tx-sender)
      { count: (+ (get count state) u1), target: (get target state), base: (get base state) })
    state))

;; Get player ticket count
(define-read-only (get-player-tickets (player principal))
  (fold count-player-tickets (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10) { player: player, count: u0 }))

(define-private (count-player-tickets (id uint) (state { player: principal, count: uint }))
  (match (map-get? tickets id)
    owner (if (is-eq owner (get player state))
            { player: (get player state), count: (+ (get count state) u1) }
            state)
    state))

(define-public (draw-winner)
  (let (
    (pot (var-get current-pot))
    (tickets-sold (var-get ticket-count))
    (winner-id (+ (mod block-height tickets-sold) u1))
    (winner (unwrap! (map-get? tickets winner-id) ERR_INVALID_AMOUNT))
    (new-lottery-id (+ (var-get lottery-id) u1))
  )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (try! (as-contract (stx-transfer? pot tx-sender winner)))
    (map-set winners new-lottery-id { winner: winner, prize: pot })
    (var-set lottery-id new-lottery-id)
    (var-set current-pot u0)
    (var-set ticket-count u0)
    (ok { winner: winner, prize: pot })))
