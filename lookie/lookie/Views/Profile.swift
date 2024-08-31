
import SwiftUI

struct Profile: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 20) {
                makeTopBar()
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                makeProfileBar()
                makeCardsGrid()
                Spacer()
            }
        }
    }
    
    private func makeTopBar() -> some View {
        HStack {
            Text("Profile")
                .font(.system(size: 72, weight: .bold))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.darkBlue)
            Spacer()
            makePremiumButton()
        }
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
    
    private func makeProfileBar() -> some View {
        VStack {
            
        }
    }
    
    private func makeCardsGrid() -> some View {
        VStack {
            
        }
    }
    
}

#Preview {
    Profile()
}
