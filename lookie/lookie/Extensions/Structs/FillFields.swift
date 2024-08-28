
import SwiftUI

struct FillField: View {
    
    let name: String
    let placeholder: String
    var bind: Binding<String>
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.softRed)
                .padding(.leading, 20)
            VStack {
                TextField(placeholder, text: bind)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.darkBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.darkBlue)
            )
        }
    }
    
}

struct ImagePicker: View {
    
    let name: String
    var bind: Binding<UIImage?>
    @State private var isShowingImagePicker = false
    
    var body: some View {
        makeContent()
            .sheet(isPresented: $isShowingImagePicker) {
                    UIImagePickerControllerView(image: bind)
                }
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(name)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.softRed)
            Button {
                isShowingImagePicker.toggle()
            } label: {
                VStack {
                    Image("Plus")
                        .renderingMode(.template)
                        .foregroundStyle(.darkBlue)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.darkBlue)
                )
            }
        }
    }
    
}
