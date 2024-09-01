
import SwiftUI

struct SearchBar: View {
    
    let placeholder: String
    var bind: Binding<String>
    let action: () -> Void
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        HStack(spacing: 7) {
            VStack {
                TextField(placeholder, text: bind)
                    .disableAutocorrection(true)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.softBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxHeight: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            )
            Button {
                action()
            } label: {
                Text("Search")
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxHeight: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.softBlue)
                    )
            }
        }
    }
    
}
