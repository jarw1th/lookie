
import SwiftUI

struct FillField: View {
    
    let name: String
    let placeholder: String
    var bind: Binding<String>
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(name)
                .font(.system(size: 24, weight: .regular))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.darkBlue)
            VStack {
                TextField(placeholder, text: bind)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.softBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            )
        }
    }
    
}

struct AvatarPicker: View {
    
    @State private var image: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        makeContent()
            .sheet(isPresented: $isShowingImagePicker) {
                    UIImagePickerControllerView(image: $image)
                }
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .center) {
            Button {
                isShowingImagePicker.toggle()
            } label: {
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("Plus")
                            .renderingMode(.template)
                            .foregroundStyle(.rose)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .stroke(.rose)
                        .foregroundStyle(.white)
                )
            }
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
