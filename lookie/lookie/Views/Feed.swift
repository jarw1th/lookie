
import SwiftUI

struct Feed: View {
    
    @State private var selectedType: FeedType = .none
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 20) {
            makeTopBar()
                .padding(.top, 24)
                .padding(.horizontal, 20)
            makeFeedTypeBar()
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
    
    private func makeFeedTypeBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 14) {
                ForEach(FeedType.allCases.filter { $0 != .none }, id: \.self) { type in
                    if type.isPremium() {
                        makePremiumTypeButton(type)
                    } else {
                        makeTypeButton(type)
                    }
                }
            }
            .padding()
        }
    }
    
    private func makePremiumTypeButton(_ type: FeedType) -> some View {
        Button {
            if (selectedType == type) {
                selectedType = .none
            } else {
                selectedType = type
            }
        } label: {
            VStack(alignment: .trailing, spacing: 0) {
                Image("Star")
                    .renderingMode(.template)
                    .foregroundStyle(.goldYellow)
                Text(type.text() ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.darkBlue)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.goldYellow)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((selectedType == type) ? .goldYellow : .clear)
                            .rotationEffect(.degrees(1))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((selectedType == type) ? .goldYellow : .clear)
                            .rotationEffect(.degrees(-1))
                    )
            }
        }
    }
    
    private func makeTypeButton(_ type: FeedType) -> some View {
        Button {
            if (selectedType == type) {
                selectedType = .none
            } else {
                selectedType = type
            }
        } label: {
            VStack {
                Text(type.text() ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.darkBlue)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.darkBlue)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((selectedType == type) ? .darkBlue : .clear)
                            .rotationEffect(.degrees(1))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((selectedType == type) ? .darkBlue : .clear)
                            .rotationEffect(.degrees(-1))
                    )
            }
        }
    }
    
}

#Preview {
    Feed()
}
