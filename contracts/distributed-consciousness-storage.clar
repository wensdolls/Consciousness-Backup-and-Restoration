;; distributed-consciousness-storage

(use-trait mind-state-encoder-trait .mind-state-encoder.mind-state-encoder-trait)

(define-constant MIN_STORAGE_NODES u3)

(define-map storage-nodes
  { mind-state-id: uint }
  { nodes: (list 20 principal) }
)

(define-public (store-mind-state (mind-state-id uint) (encoder-contract <mind-state-encoder-trait>))
  (let
    (
      (mind-state (contract-call? encoder-contract get-mind-state mind-state-id))
      (nodes (generate-storage-nodes))
    )
    (asserts! (is-some mind-state) (err u1)) ;; Mind state does not exist
    (map-set storage-nodes
      { mind-state-id: mind-state-id }
      { nodes: nodes }
    )
    (ok nodes)
  )
)

(define-private (generate-storage-nodes)
  (list
    tx-sender
    contract-caller
    (as-contract tx-sender)
  )
)

(define-read-only (get-storage-nodes (mind-state-id uint))
  (get nodes (map-get? storage-nodes { mind-state-id: mind-state-id }))
)

