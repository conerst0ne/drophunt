import Foundation
import ComposableArchitecture
import web3swift

struct AirdropService {
    let checkEligibility: (Airdrop, Wallet) -> Effect<Bool, Error>
    let fetchAirdrops: () -> Effect<[Airdrop], Error>
    
    static var live: AirdropService {
        AirdropService(
            checkEligibility: { airdrop, wallet in
                Effect.future { callback in
                    // TODO: Implement actual blockchain interaction
                    // This is a mock implementation
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        callback(.success(true))
                    }
                }
            },
            fetchAirdrops: {
                Effect.future { callback in
                    // TODO: Implement actual airdrop fetching
                    // This is a mock implementation
                    let mockAirdrops = [
                        Airdrop(
                            id: "1",
                            name: "Ethereum Layer 2 Airdrop",
                            chain: .ethereum,
                            status: .active,
                            eligibility: .unknown,
                            deadline: Date().addingTimeInterval(86400 * 7),
                            reward: "100 tokens"
                        ),
                        Airdrop(
                            id: "2",
                            name: "Solana DeFi Airdrop",
                            chain: .solana,
                            status: .upcoming,
                            eligibility: .unknown,
                            deadline: Date().addingTimeInterval(86400 * 14),
                            reward: "50 SOL"
                        )
                    ]
                    callback(.success(mockAirdrops))
                }
            }
        )
    }
}

// MARK: - Error Handling
enum AirdropError: LocalizedError {
    case invalidWallet
    case networkError
    case contractError
    
    var errorDescription: String? {
        switch self {
        case .invalidWallet:
            return "Invalid wallet address"
        case .networkError:
            return "Network connection error"
        case .contractError:
            return "Smart contract interaction error"
        }
    }
} 