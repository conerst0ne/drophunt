import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Sidebar(store: store)
                
                AirdropListView(store: store)
            }
            .frame(minWidth: 800, minHeight: 500)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                    }) {
                        Image(systemName: "sidebar.left")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewStore.send(.addWallet)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct Sidebar: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                NavigationLink(destination: AirdropListView(store: store)) {
                    Label("All Airdrops", systemImage: "list.bullet")
                }
                
                NavigationLink(destination: AirdropListView(store: store)) {
                    Label("Eligible", systemImage: "checkmark.circle")
                }
                
                NavigationLink(destination: AirdropListView(store: store)) {
                    Label("Upcoming", systemImage: "clock")
                }
                
                Divider()
                
                ForEach(viewStore.airdrops.filter { $0.status == .active }, id: \.id) { airdrop in
                    NavigationLink(destination: AirdropDetailView(store: store, airdrop: airdrop)) {
                        Label(airdrop.name, systemImage: "gift")
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)
        }
    }
}

struct AirdropListView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(viewStore.airdrops) { airdrop in
                AirdropRow(airdrop: airdrop)
            }
            .listStyle(InsetListStyle())
        }
    }
}

struct AirdropRow: View {
    let airdrop: Airdrop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(airdrop.name)
                    .font(.headline)
                Spacer()
                StatusBadge(status: airdrop.status)
            }
            
            HStack {
                ChainBadge(chain: airdrop.chain)
                if let reward = airdrop.reward {
                    Text(reward)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let deadline = airdrop.deadline {
                    Text(deadline, style: .relative)
                        .foregroundColor(.secondary)
                }
            }
            
            EligibilityView(status: airdrop.eligibility)
        }
        .padding(.vertical, 8)
    }
}

struct StatusBadge: View {
    let status: AirdropStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
    
    var backgroundColor: Color {
        switch status {
        case .upcoming: return .blue
        case .active: return .green
        case .ended: return .gray
        }
    }
}

struct ChainBadge: View {
    let chain: Chain
    
    var body: some View {
        Text(chain.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(4)
    }
}

struct EligibilityView: View {
    let status: EligibilityStatus
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(statusText)
                .foregroundColor(.secondary)
        }
    }
    
    var iconName: String {
        switch status {
        case .checking: return "clock"
        case .eligible: return "checkmark.circle"
        case .notEligible: return "xmark.circle"
        case .unknown: return "questionmark.circle"
        }
    }
    
    var iconColor: Color {
        switch status {
        case .checking: return .blue
        case .eligible: return .green
        case .notEligible: return .red
        case .unknown: return .gray
        }
    }
    
    var statusText: String {
        switch status {
        case .checking: return "Checking eligibility..."
        case .eligible: return "You are eligible!"
        case .notEligible: return "Not eligible"
        case .unknown: return "Eligibility unknown"
        }
    }
} 