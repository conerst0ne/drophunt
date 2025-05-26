import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var airdrops: [Airdrop] = []
    var selectedWallet: Wallet?
    var isLoading: Bool = false
    var error: String?
    var notifications: [Notification] = []
}

struct Airdrop: Equatable, Identifiable {
    let id: String
    let name: String
    let chain: Chain
    let status: AirdropStatus
    let eligibility: EligibilityStatus
    let deadline: Date?
    let reward: String?
}

enum Chain: String, Equatable {
    case ethereum
    case solana
    case polygon
    case arbitrum
    case optimism
}

enum AirdropStatus: String, Equatable {
    case upcoming
    case active
    case ended
}

enum EligibilityStatus: Equatable {
    case checking
    case eligible
    case notEligible
    case unknown
}

struct Wallet: Equatable {
    let address: String
    let chain: Chain
}

struct Notification: Equatable, Identifiable {
    let id: UUID
    let title: String
    let message: String
    let date: Date
    let type: NotificationType
}

enum NotificationType: Equatable {
    case newAirdrop
    case eligibilityUpdate
    case deadlineReminder
} 