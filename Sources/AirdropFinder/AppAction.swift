import Foundation
import ComposableArchitecture

enum AppAction: Equatable {
    case addWallet
    case removeWallet(Wallet)
    case checkEligibility(Airdrop)
    case airdropsResponse(Result<[Airdrop], Error>)
    case setError(String?)
    case clearError
}

struct AppEnvironment {
    let airdropService: AirdropService
    let mainQueue: AnySchedulerOf<DispatchQueue>
    
    static var live: AppEnvironment {
        AppEnvironment(
            airdropService: .live,
            mainQueue: .main
        )
    }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .addWallet:
        // TODO: Implement wallet addition
        return .none
        
    case .removeWallet(let wallet):
        state.selectedWallet = nil
        return .none
        
    case .checkEligibility(let airdrop):
        guard let wallet = state.selectedWallet else { return .none }
        
        state.airdrops = state.airdrops.map { a in
            if a.id == airdrop.id {
                var updated = a
                updated.eligibility = .checking
                return updated
            }
            return a
        }
        
        return environment.airdropService
            .checkEligibility(airdrop: airdrop, wallet: wallet)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map { result in
                switch result {
                case .success(let isEligible):
                    return .airdropsResponse(.success([airdrop]))
                case .failure(let error):
                    return .setError(error.localizedDescription)
                }
            }
        
    case .airdropsResponse(.success(let airdrops)):
        state.airdrops = airdrops
        return .none
        
    case .airdropsResponse(.failure(let error)):
        return Effect(value: .setError(error.localizedDescription))
        
    case .setError(let error):
        state.error = error
        return .none
        
    case .clearError:
        state.error = nil
        return .none
    }
} 