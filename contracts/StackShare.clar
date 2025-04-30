;; StackShare - File sharing smart contract

(define-constant platform-owner tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-FILE-NOT-FOUND (err u101))
(define-constant ERR-UNAUTHORIZED-ACTION (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-FILE-ALREADY-EXISTS (err u104))
(define-constant ERR-STORAGE-LIMIT-EXCEEDED (err u105))

;; Storage Constants
(define-constant maximum-allowed-file-size u1073741824) ;; 1GB in bytes
(define-constant maximum-files-per-user-limit u100)
(define-constant minimum-file-name-length u1)
(define-constant minimum-description-length u1)

;; Data Maps
(define-map file-registry 
    { file-identifier: uint }
    {
        file-owner: principal,
        file-name: (string-ascii 64),
        file-cryptographic-hash: (string-ascii 64),
        file-byte-size: uint,
        file-upload-timestamp: uint,
        file-last-modified-timestamp: uint,
        file-content-type: (string-ascii 32),
        file-description: (string-ascii 256),
        is-file-private: bool,
        is-file-encrypted: bool,
        file-version-number: uint
    }
)

(define-map file-access-control 
    { file-identifier: uint, accessing-user: principal } 
    { 
        user-can-access: bool,
        user-can-edit: bool,
        access-grant-timestamp: uint,
        access-permission-expiration: (optional uint)
    }
)

(define-map user-storage-metrics
    { storage-user: principal }
    {
        total-user-files: uint,
        total-user-storage-consumed: uint,
        last-user-upload-timestamp: uint
    }
)

(define-map file-version-tracking
    { file-identifier: uint, version-identifier: uint }
    {
        version-file-hash: (string-ascii 64),
        version-file-size: uint,
        version-modified-by: principal,
        version-modification-timestamp: uint,
        version-change-description: (string-ascii 256)
    }
)

(define-map file-tag-index
    { file-identifier: uint }
    { tag-collection: (list 10 (string-ascii 32)) }
)

(define-data-var next-file-identifier uint u0)

;; Private Functions
(define-private (is-current-file-owner (file-identifier uint))
    (match (map-get? file-registry { file-identifier: file-identifier })
        file-record (is-eq (get file-owner file-record) tx-sender)
        false
    )
)

(define-private (validate-file-identifier (file-identifier uint))
    (match (map-get? file-registry { file-identifier: file-identifier })
        file-record (ok true)
        ERR-FILE-NOT-FOUND
    )
)

(define-private (validate-user-principal (user-principal principal))
    (if (is-eq user-principal platform-owner)
        ERR-INVALID-INPUT
        (ok true)
    )
)

(define-private (validate-file-name-length (file-name (string-ascii 64)))
    (if (>= (len file-name) minimum-file-name-length)
        (ok true)
        ERR-INVALID-INPUT
    )
)
