import SwiftUI
import ComposableArchitecture

struct AirdropDetailView: View {
    let store: Store<AppState, AppAction>
    let airdrop: Airdrop
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    eligibilitySection
                    detailsSection
                    actionButtons
                }
                .padding()
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(airdrop.name)
                    .font(.title)
                    .bold()
                Spacer()
                StatusBadge(status: airdrop.status)
            }
            
            HStack {
                ChainBadge(chain: airdrop.chain)
                if let reward = airdrop.reward {
                    Text(reward)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var eligibilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Eligibility")
                .font(.headline)
            
            EligibilityView(status: airdrop.eligibility)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                if let deadline = airdrop.deadline {
                    DetailRow(title: "Deadline", value: deadline.formatted())
                }
                
                DetailRow(title: "Chain", value: airdrop.chain.rawValue.capitalized)
                DetailRow(title: "Status", value: airdrop.status.rawValue.capitalized)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private var actionButtons: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 12) {
                Button(action: {
                    viewStore.send(.checkEligibility(airdrop))
                }) {
                    Text("Check Eligibility")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    // TODO: Implement claim action
                }) {
                    Text("Claim Airdrop")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(airdrop.eligibility != .eligible)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
} 