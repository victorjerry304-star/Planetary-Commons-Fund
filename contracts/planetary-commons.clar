(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PROJECT-NOT-FOUND (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-PROPOSAL-NOT-FOUND (err u104))
(define-constant ERR-ALREADY-VOTED (err u105))
(define-constant ERR-VOTING-ENDED (err u106))
(define-constant ERR-PROPOSAL-NOT-PASSED (err u107))
(define-constant ERR-ALREADY-EXECUTED (err u108))
(define-constant ERR-USER-NOT-FOUND (err u109))
(define-constant ERR-INVALID-STATUS (err u110))

(define-data-var contract-owner principal tx-sender)
(define-data-var total-treasury uint u0)
(define-data-var total-projects-funded uint u0)
(define-data-var total-carbon-sequestered uint u0)
(define-data-var governance-threshold uint u5000)
(define-data-var minimum-proposal-stake uint u1000)

(define-map contributors principal {
    total-contributed: uint,
    voting-power: uint,
    projects-supported: uint,
    reputation-score: uint,
    joined-at: uint
})

(define-map environmental-projects uint {
    creator: principal,
    title: (string-ascii 100),
    description: (string-ascii 500),
    funding-goal: uint,
    current-funding: uint,
    carbon-impact: uint,
    project-type: (string-ascii 50),
    location: (string-ascii 100),
    status: (string-ascii 20),
    created-at: uint,
    funded-at: (optional uint),
    completion-deadline: uint
})

(define-map funding-proposals uint {
    proposer: principal,
    project-id: uint,
    requested-amount: uint,
    votes-for: uint,
    votes-against: uint,
    voting-deadline: uint,
    executed: bool,
    created-at: uint,
    proposal-type: (string-ascii 30)
})

(define-map proposal-votes { proposal-id: uint, voter: principal } {
    vote-weight: uint,
    vote-direction: bool,
    voted-at: uint
})

(define-map project-milestones uint {
    project-id: uint,
    milestone-title: (string-ascii 100),
    milestone-description: (string-ascii 300),
    funding-release: uint,
    completion-status: bool,
    verified-by: (optional principal),
    completed-at: (optional uint)
})

(define-map carbon-credits uint {
    project-id: uint,
    credits-generated: uint,
    verification-standard: (string-ascii 50),
    price-per-credit: uint,
    total-value: uint,
    issued-at: uint,
    retired: bool
})

(define-map impact-assessments uint {
    project-id: uint,
    carbon-sequestered: uint,
    biodiversity-score: uint,
    community-benefit: uint,
    water-conservation: uint,
    soil-restoration: uint,
    assessed-by: principal,
    assessment-date: uint
})

(define-map treasury-transactions uint {
    transaction-type: (string-ascii 20),
    amount: uint,
    from-address: (optional principal),
    to-address: (optional principal),
    project-id: (optional uint),
    timestamp: uint,
    description: (string-ascii 200)
})

(define-data-var next-project-id uint u1)
(define-data-var next-proposal-id uint u1)
(define-data-var next-milestone-id uint u1)
(define-data-var next-credit-id uint u1)
(define-data-var next-assessment-id uint u1)
(define-data-var next-transaction-id uint u1)

(define-public (register-contributor)
    (let ((caller tx-sender))
        (if (is-some (map-get? contributors caller))
            (err u100)
            (begin
                (map-set contributors caller {
                    total-contributed: u0,
                    voting-power: u100,
                    projects-supported: u0,
                    reputation-score: u100,
                    joined-at: stacks-block-height
                })
                (ok true)))))

(define-public (contribute-to-treasury (amount uint))
    (let ((caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND))
          (transaction-id (var-get next-transaction-id)))
        (if (< amount u100)
            ERR-INVALID-AMOUNT
            (begin
                (map-set contributors caller {
                    total-contributed: (+ (get total-contributed contributor-data) amount),
                    voting-power: (+ (get voting-power contributor-data) (/ amount u10)),
                    projects-supported: (get projects-supported contributor-data),
                    reputation-score: (+ (get reputation-score contributor-data) u5),
                    joined-at: (get joined-at contributor-data)
                })
                (map-set treasury-transactions transaction-id {
                    transaction-type: "contribution",
                    amount: amount,
                    from-address: (some caller),
                    to-address: none,
                    project-id: none,
                    timestamp: stacks-block-height,
                    description: "Treasury contribution"
                })
                (var-set total-treasury (+ (var-get total-treasury) amount))
                (var-set next-transaction-id (+ transaction-id u1))
                (ok amount)))))

(define-public (submit-project (title (string-ascii 100)) (description (string-ascii 500)) (funding-goal uint) (carbon-impact uint) (project-type (string-ascii 50)) (location (string-ascii 100)) (completion-deadline uint))
    (let ((project-id (var-get next-project-id))
          (caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND)))
        (if (< funding-goal u1000)
            ERR-INVALID-AMOUNT
            (begin
                (map-set environmental-projects project-id {
                    creator: caller,
                    title: title,
                    description: description,
                    funding-goal: funding-goal,
                    current-funding: u0,
                    carbon-impact: carbon-impact,
                    project-type: project-type,
                    location: location,
                    status: "pending",
                    created-at: stacks-block-height,
                    funded-at: none,
                    completion-deadline: completion-deadline
                })
                (var-set next-project-id (+ project-id u1))
                (ok project-id)))))

(define-public (create-funding-proposal (project-id uint) (requested-amount uint) (proposal-type (string-ascii 30)))
    (let ((proposal-id (var-get next-proposal-id))
          (caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND))
          (project-data (unwrap! (map-get? environmental-projects project-id) ERR-PROJECT-NOT-FOUND)))
        (if (< (get voting-power contributor-data) (var-get minimum-proposal-stake))
            ERR-NOT-AUTHORIZED
            (if (> requested-amount (var-get total-treasury))
                ERR-INSUFFICIENT-FUNDS
                (begin
                    (map-set funding-proposals proposal-id {
                        proposer: caller,
                        project-id: project-id,
                        requested-amount: requested-amount,
                        votes-for: u0,
                        votes-against: u0,
                        voting-deadline: (+ stacks-block-height u1440),
                        executed: false,
                        created-at: stacks-block-height,
                        proposal-type: proposal-type
                    })
                    (var-set next-proposal-id (+ proposal-id u1))
                    (ok proposal-id))))))

(define-public (vote-on-proposal (proposal-id uint) (vote-for bool))
    (let ((caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND))
          (proposal-data (unwrap! (map-get? funding-proposals proposal-id) ERR-PROPOSAL-NOT-FOUND))
          (vote-key { proposal-id: proposal-id, voter: caller })
          (vote-weight (get voting-power contributor-data)))
        (if (is-some (map-get? proposal-votes vote-key))
            ERR-ALREADY-VOTED
            (if (> stacks-block-height (get voting-deadline proposal-data))
                ERR-VOTING-ENDED
                (let ((new-votes-for (if vote-for (+ (get votes-for proposal-data) vote-weight) (get votes-for proposal-data)))
                      (new-votes-against (if vote-for (get votes-against proposal-data) (+ (get votes-against proposal-data) vote-weight))))
                    (map-set proposal-votes vote-key {
                        vote-weight: vote-weight,
                        vote-direction: vote-for,
                        voted-at: stacks-block-height
                    })
                    (map-set funding-proposals proposal-id {
                        proposer: (get proposer proposal-data),
                        project-id: (get project-id proposal-data),
                        requested-amount: (get requested-amount proposal-data),
                        votes-for: new-votes-for,
                        votes-against: new-votes-against,
                        voting-deadline: (get voting-deadline proposal-data),
                        executed: (get executed proposal-data),
                        created-at: (get created-at proposal-data),
                        proposal-type: (get proposal-type proposal-data)
                    })
                    (ok true))))))

(define-public (execute-funding-proposal (proposal-id uint))
    (let ((caller tx-sender)
          (proposal-data (unwrap! (map-get? funding-proposals proposal-id) ERR-PROPOSAL-NOT-FOUND))
          (project-data (unwrap! (map-get? environmental-projects (get project-id proposal-data)) ERR-PROJECT-NOT-FOUND))
          (transaction-id (var-get next-transaction-id)))
        (if (get executed proposal-data)
            ERR-ALREADY-EXECUTED
            (if (< (get votes-for proposal-data) (var-get governance-threshold))
                ERR-PROPOSAL-NOT-PASSED
                (if (> stacks-block-height (get voting-deadline proposal-data))
                    (begin
                        (map-set funding-proposals proposal-id {
                            proposer: (get proposer proposal-data),
                            project-id: (get project-id proposal-data),
                            requested-amount: (get requested-amount proposal-data),
                            votes-for: (get votes-for proposal-data),
                            votes-against: (get votes-against proposal-data),
                            voting-deadline: (get voting-deadline proposal-data),
                            executed: true,
                            created-at: (get created-at proposal-data),
                            proposal-type: (get proposal-type proposal-data)
                        })
                        (map-set environmental-projects (get project-id proposal-data) {
                            creator: (get creator project-data),
                            title: (get title project-data),
                            description: (get description project-data),
                            funding-goal: (get funding-goal project-data),
                            current-funding: (+ (get current-funding project-data) (get requested-amount proposal-data)),
                            carbon-impact: (get carbon-impact project-data),
                            project-type: (get project-type project-data),
                            location: (get location project-data),
                            status: "funded",
                            created-at: (get created-at project-data),
                            funded-at: (some stacks-block-height),
                            completion-deadline: (get completion-deadline project-data)
                        })
                        (map-set treasury-transactions transaction-id {
                            transaction-type: "project-funding",
                            amount: (get requested-amount proposal-data),
                            from-address: none,
                            to-address: (some (get creator project-data)),
                            project-id: (some (get project-id proposal-data)),
                            timestamp: stacks-block-height,
                            description: "Project funding disbursement"
                        })
                        (var-set total-treasury (- (var-get total-treasury) (get requested-amount proposal-data)))
                        (var-set total-projects-funded (+ (var-get total-projects-funded) u1))
                        (var-set next-transaction-id (+ transaction-id u1))
                        (ok (get requested-amount proposal-data)))
                    ERR-VOTING-ENDED)))))

(define-public (create-project-milestone (project-id uint) (milestone-title (string-ascii 100)) (milestone-description (string-ascii 300)) (funding-release uint))
    (let ((milestone-id (var-get next-milestone-id))
          (caller tx-sender)
          (project-data (unwrap! (map-get? environmental-projects project-id) ERR-PROJECT-NOT-FOUND)))
        (if (not (is-eq caller (get creator project-data)))
            ERR-NOT-AUTHORIZED
            (begin
                (map-set project-milestones milestone-id {
                    project-id: project-id,
                    milestone-title: milestone-title,
                    milestone-description: milestone-description,
                    funding-release: funding-release,
                    completion-status: false,
                    verified-by: none,
                    completed-at: none
                })
                (var-set next-milestone-id (+ milestone-id u1))
                (ok milestone-id)))))

(define-public (verify-milestone-completion (milestone-id uint))
    (let ((caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND))
          (milestone-data (unwrap! (map-get? project-milestones milestone-id) ERR-PROPOSAL-NOT-FOUND)))
        (if (< (get voting-power contributor-data) u1000)
            ERR-NOT-AUTHORIZED
            (begin
                (map-set project-milestones milestone-id {
                    project-id: (get project-id milestone-data),
                    milestone-title: (get milestone-title milestone-data),
                    milestone-description: (get milestone-description milestone-data),
                    funding-release: (get funding-release milestone-data),
                    completion-status: true,
                    verified-by: (some caller),
                    completed-at: (some stacks-block-height)
                })
                (ok true)))))

(define-public (issue-carbon-credits (project-id uint) (credits-generated uint) (verification-standard (string-ascii 50)) (price-per-credit uint))
    (let ((credit-id (var-get next-credit-id))
          (caller tx-sender)
          (project-data (unwrap! (map-get? environmental-projects project-id) ERR-PROJECT-NOT-FOUND))
          (total-value (* credits-generated price-per-credit)))
        (if (not (is-eq caller (get creator project-data)))
            ERR-NOT-AUTHORIZED
            (begin
                (map-set carbon-credits credit-id {
                    project-id: project-id,
                    credits-generated: credits-generated,
                    verification-standard: verification-standard,
                    price-per-credit: price-per-credit,
                    total-value: total-value,
                    issued-at: stacks-block-height,
                    retired: false
                })
                (var-set total-carbon-sequestered (+ (var-get total-carbon-sequestered) credits-generated))
                (var-set next-credit-id (+ credit-id u1))
                (ok credit-id)))))

(define-public (submit-impact-assessment (project-id uint) (carbon-sequestered uint) (biodiversity-score uint) (community-benefit uint) (water-conservation uint) (soil-restoration uint))
    (let ((assessment-id (var-get next-assessment-id))
          (caller tx-sender)
          (contributor-data (unwrap! (map-get? contributors caller) ERR-USER-NOT-FOUND))
          (project-data (unwrap! (map-get? environmental-projects project-id) ERR-PROJECT-NOT-FOUND)))
        (if (< (get reputation-score contributor-data) u500)
            ERR-NOT-AUTHORIZED
            (begin
                (map-set impact-assessments assessment-id {
                    project-id: project-id,
                    carbon-sequestered: carbon-sequestered,
                    biodiversity-score: biodiversity-score,
                    community-benefit: community-benefit,
                    water-conservation: water-conservation,
                    soil-restoration: soil-restoration,
                    assessed-by: caller,
                    assessment-date: stacks-block-height
                })
                (var-set next-assessment-id (+ assessment-id u1))
                (ok assessment-id)))))

(define-public (update-governance-threshold (new-threshold uint))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (var-set governance-threshold new-threshold)
        (ok true)))

(define-public (withdraw-treasury-funds (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (asserts! (<= amount (var-get total-treasury)) ERR-INSUFFICIENT-FUNDS)
        (var-set total-treasury (- (var-get total-treasury) amount))
        (ok true)))

(define-read-only (get-contributor-data (contributor principal))
    (map-get? contributors contributor))

(define-read-only (get-project-data (project-id uint))
    (map-get? environmental-projects project-id))

(define-read-only (get-proposal-data (proposal-id uint))
    (map-get? funding-proposals proposal-id))

(define-read-only (get-milestone-data (milestone-id uint))
    (map-get? project-milestones milestone-id))

(define-read-only (get-carbon-credit-data (credit-id uint))
    (map-get? carbon-credits credit-id))

(define-read-only (get-impact-assessment-data (assessment-id uint))
    (map-get? impact-assessments assessment-id))

(define-read-only (get-treasury-stats)
    {
        total-treasury: (var-get total-treasury),
        total-projects-funded: (var-get total-projects-funded),
        total-carbon-sequestered: (var-get total-carbon-sequestered),
        governance-threshold: (var-get governance-threshold),
        minimum-proposal-stake: (var-get minimum-proposal-stake)
    })

(define-read-only (get-project-funding-status (project-id uint))
    (match (map-get? environmental-projects project-id)
        project-data (ok {
            current-funding: (get current-funding project-data),
            funding-goal: (get funding-goal project-data),
            funding-percentage: (/ (* (get current-funding project-data) u10000) (get funding-goal project-data)),
            status: (get status project-data)
        })
        ERR-PROJECT-NOT-FOUND))

(define-read-only (calculate-voting-power (contributor principal))
    (match (map-get? contributors contributor)
        contributor-data (ok (get voting-power contributor-data))
        ERR-USER-NOT-FOUND))

(define-read-only (get-proposal-vote (proposal-id uint) (voter principal))
    (map-get? proposal-votes { proposal-id: proposal-id, voter: voter }))