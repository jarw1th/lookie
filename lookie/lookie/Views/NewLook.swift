
import SwiftUI

struct NewLook: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var feedType: String = "Outfit"
    @State private var images: [Image] = []
    @State private var image: UIImage? = nil
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .onChange(of: image) { value in
                if let image = image {
                    images.append(Image(uiImage: image))
                }
            }
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 20) {
                makeTopBar()
                    .padding(.top, 24)
                FillField(name: "name", placeholder: "Hoodie Woodie", bind: $name)
                FillField(name: "feed-type", placeholder: "Outfit", bind: $feedType)
                makeImagesBar()
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 10) {
                makeCompleteButton()
                makeCloseButton()
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
    
    private func makeTopBar() -> some View {
        HStack {
            Spacer()
            Text("New look")
                .font(.system(size: 72, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkBlue)
            Spacer()
        }
    }
    
    private func makeImagesBar() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            ImagePicker(name: "image", bind: $image)
            ForEach(images.indices, id: \.self) { index in
                Button {
                    images.remove(at: index)
                } label: {
                    images[index]
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                }
            }
            Spacer()
        }
    }
    
    private func makeCloseButton() -> some View {
        Button {
            dismiss()
        } label: {
            ZStack(alignment: .center) {
                Circle()
                    .fill(.softRed)
                    .frame(width: 48, height: 48)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(.backgroundWhite)
                    .frame(width: 20, height: 2)
                    .rotationEffect(.degrees(45))
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(.backgroundWhite)
                    .frame(width: 20, height: 2)
                    .rotationEffect(.degrees(135))
            }
        }
    }
    
    private func makeCompleteButton() -> some View {
        Button {
            if !isLoading {
                completeAction()
            }
        } label: {
            ZStack(alignment: .center) {
                Circle()
                    .fill(.softGreen)
                    .frame(width: 48, height: 48)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.backgroundWhite)
                } else {
                    Image("Check")
                        .renderingMode(.template)
                        .foregroundStyle(.backgroundWhite)
                }
            }
        }
    }
    
    private func completeAction() {
        guard name.count > 4 else { return }
        let uiImages: [UIImage?] = images.map { $0.toUIImage() }
        Task {
            isLoading = true
            await viewModel.createShortLook(images: uiImages, feedType: feedType)
            isLoading = false
            dismiss()
        }
    }
    
}

#Preview {
    Feed()
}
