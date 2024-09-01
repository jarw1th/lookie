
import SwiftUI

struct PremiumTypeButton: View {
    
    let type: FeedType
    @Binding var selectedType: FeedType
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        Button {
            if selectedType == type {
                selectedType = .none
            } else {
                selectedType = type
            }
        } label: {
            Text(type.text() ?? "")
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedType == type ? .softBlue : .goldYellow)
                )
        }
    }
    
}

struct TypeButton: View {
    
    let type: FeedType
    @Binding var selectedType: FeedType
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        Button {
            if selectedType == type {
                selectedType = .none
            } else {
                selectedType = type
            }
        } label: {
            Text(type.text() ?? "")
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(selectedType == type ? .white : .softBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedType == type ? .softBlue : .white)
                )
        }
    }
    
}
