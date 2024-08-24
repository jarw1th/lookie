
import SwiftUI

struct Feed: View {
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
    }
    
    private func makeContent() -> some View {
        VStack {
            makeTopBar()
                .padding(.top, 24)
                .padding(.horizontal, 20)
            Spacer()
        }
    }
    
    private func makeTopBar() -> some View {
        HStack {
            Text("Feed")
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
    
}

#Preview {
    Feed()
}
