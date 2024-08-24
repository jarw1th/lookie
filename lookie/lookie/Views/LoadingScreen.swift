
import SwiftUI

struct LoadingScreen: View {
    
    @StateObject private var requestManager = RequestManager.shared
    @State private var isLoading: Bool = true
    @State private var isShowNext: Bool = false
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                if isLoading {
                    makeLoader()
                } else {
                    makeAlertButton()
                }
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                makeAlertText()
                    .padding(.bottom, 0)
            }
        }
        .fullScreenCover(isPresented: $isShowNext) {
            
        }
        .onChange(of: isLoading) { value in
            guard (value == true) else { return }
            if requestManager.checkInternetConnectivity(withDelay: true) {
                isShowNext.toggle()
            } else {
                isLoading.toggle()
            }
        }
    }
    
    private func makeLoader() -> some View {
        Text("Lookie")
            .font(.system(size: 88, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundStyle(.darkBlue)
    }
    
    private func makeAlertText() -> some View {
        Text("fashion is here")
            .font(.system(size: 16, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundStyle(.darkBlue)
    }
    
    private func makeAlertButton() -> some View {
        Button {
            isLoading.toggle()
        } label: {
            Text("Reload")
                .underline()
                .font(.system(size: 24, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkBlue)
        }
    }
    
}

#Preview {
    LoadingScreen()
}
