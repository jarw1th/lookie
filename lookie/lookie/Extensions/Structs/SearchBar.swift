
import SwiftUI

struct SearchBar: View {
    
    let placeholder: String
    var bind: Binding<String>
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        VStack {
            TextField(placeholder, text: bind)
                .disableAutocorrection(true)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.darkBlue)
        )
    }
    
}
