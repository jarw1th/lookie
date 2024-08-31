
import SwiftUI

struct GenerateImage: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var text: String = ""
    @State private var imageUrl: String = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 20) {
                makeTopBar()
                    .padding(.top, 24)
                FillField(name: "text", placeholder: "Hoodie Woodie", bind: $text)
                GeneratedImageCard(url: imageUrl)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    makeGenerateButton()
                    makeCompleteButton()
                }
                makeCloseButton()
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
    
    private func makeTopBar() -> some View {
        HStack {
            Spacer()
            Text("Generate")
                .font(.system(size: 72, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkBlue)
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
            dismiss()
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
    
    private func makeGenerateButton() -> some View {
        Button {
            Task {
                isLoading = true
                imageUrl = await viewModel.generateImage(text)
                isLoading = false
            }
        } label: {
            VStack {
                Text(isLoading ? "Generating..." : "Generate")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.darkBlue)
            }
            .padding(.horizontal, 20)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.goldYellow)
            )
        }
    }
    
}

#Preview {
    GenerateImage()
}
