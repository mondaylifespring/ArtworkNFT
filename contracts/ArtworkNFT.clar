;; ArtworkNFT - Digital artwork pieces as NFTs
(define-non-fungible-token artwork-nft uint)

;; Storage
(define-map token-metadata uint {artist: principal, name: (string-utf8 64), description: (string-utf8 256), image-uri: (string-utf8 256), price: uint})
(define-data-var token-id-nonce uint u0)

;; Error codes
(define-constant err-not-authorized (err u100))
(define-constant err-token-not-found (err u101))
(define-constant err-insufficient-funds (err u102))
(define-constant err-invalid-name (err u103))
(define-constant err-invalid-description (err u104))
(define-constant err-invalid-image-uri (err u105))
(define-constant err-invalid-price (err u106))
(define-constant err-invalid-token-id (err u107))

;; Mint a new artwork NFT
(define-public (mint (name (string-utf8 64)) (description (string-utf8 256)) (image-uri (string-utf8 256)) (price uint))
  (begin
    ;; Validate inputs
    (asserts! (> (len name) u0) err-invalid-name)
    (asserts! (> (len description) u0) err-invalid-description)
    (asserts! (> (len image-uri) u0) err-invalid-image-uri)
    (asserts! (> price u0) err-invalid-price)
    
    (let
      ((token-id (var-get token-id-nonce))
       (artist tx-sender))
      
      ;; Mint the token
      (try! (nft-mint? artwork-nft token-id artist))
      
      ;; Store the metadata
      (map-set token-metadata token-id {artist: artist, name: name, description: description, image-uri: image-uri, price: price})
      
      ;; Increment the token ID counter
      (var-set token-id-nonce (+ token-id u1))
      
      (ok token-id))))

;; Purchase an artwork NFT
(define-public (purchase (token-id uint))
  (begin
    ;; Validate token ID
    (asserts! (< token-id (var-get token-id-nonce)) err-invalid-token-id)
    
    (let
      ((metadata (unwrap! (map-get? token-metadata token-id) err-token-not-found))
       (price (get price metadata))
       (artist (get artist metadata))
       (current-owner (unwrap! (nft-get-owner? artwork-nft token-id) err-token-not-found)))
      
      ;; Check if buyer has enough funds
      (asserts! (>= (stx-get-balance tx-sender) price) err-insufficient-funds)
      
      ;; Transfer STX to artist
      (try! (stx-transfer? price tx-sender artist))
      
      ;; Transfer NFT to buyer
      (try! (nft-transfer? artwork-nft token-id current-owner tx-sender))
      
      (ok true))))

;; Get token metadata
(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id))

;; Check if token is owned by address
(define-read-only (is-token-owned-by (token-id uint) (address principal))
  (is-eq (some address) (nft-get-owner? artwork-nft token-id)))

;; Get the owner of a token
(define-read-only (get-token-owner (token-id uint))
  (nft-get-owner? artwork-nft token-id))