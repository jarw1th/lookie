
import SwiftUI

struct LoadingScreen: View {
    
    @State private var viewModel: ViewModel = ViewModel()
    
    @StateObject private var requestManager = RequestManager.shared
    @State private var isLoading: Bool = true
    @State private var isShowNext: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .ignoresSafeArea()
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
                    .padding(.bottom, 38)
            }
        }
        .fullScreenCover(isPresented: $isShowNext) {
            if viewModel.currentUser != nil {
                TabBar()
                    .environmentObject(viewModel)
            } else {
                Authorization()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            checkConnectivityAndProceed()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func makeLoader() -> some View {
        Text("Lookie")
            .font(.system(size: 88, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundStyle(.darkBlue)
    }
    
    private func makeAlertText() -> some View {
        Text(isLoading ? "fashion is here" : "no internet")
            .font(.system(size: 16, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundStyle(isLoading ? .darkBlue : .softRed)
    }
    
    private func makeAlertButton() -> some View {
        Button {
            isLoading.toggle()
            checkConnectivityAndProceed()
        } label: {
            Text("Reload")
                .underline()
                .font(.system(size: 24, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkBlue)
        }
    }
    
    private func checkConnectivityAndProceed() {
        Task {
            if await requestManager.checkInternetConnectivity(withDelay: true) {
                isShowNext = true
            } else {
                isLoading = false
            }
        }
    }
    
}

#Preview {
    LoadingScreen()
}
