
import SwiftUI

struct Search: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 20) {
            SearchBar(placeholder: "Outfit of the day", bind: $searchText, action: {
                
            })
            makeRecommendations()
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }
    
    private func makePremiumButton() -> some View {
        Button {
            
        } label: {
            HStack(spacing: 8) {
                VStack(spacing: -4) {
                    Text("buy")
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.goldYellow)
                    Text("pro")
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.goldYellow)
                }
                Image("RightArrow")
                    .renderingMode(.template)
                    .foregroundStyle(.goldYellow)
            }
        }
    }
    
    private func makeRecommendations() -> some View {
        VStack {
            
        }
    }
    
}

#Preview {
    Search()
}
