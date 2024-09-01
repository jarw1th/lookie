
import SwiftUI

struct LoadingScreen: View {
    
    @State private var viewModel: ViewModel = ViewModel()
    
    @StateObject private var requestManager = RequestManager.shared
    @State private var isLoading: Bool = true
    @State private var isShowNext: Bool = false
    @State private var rotation: Double = 0
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .ignoresSafeArea()
    }
    
    private func makeContent() -> some View {
        ZStack {
            VStack {
                Spacer()
                makeLoader()
                Spacer()
            }
            VStack {
                Spacer()
                makeButton()
                    .padding(.bottom, 108)
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
        Image("Refreshing")
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(.softBlue)
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                startRotation()
            }
    }
    
    private func makeButton() -> some View {
        Button {
            isLoading.toggle()
            checkConnectivityAndProceed()
        } label: {
            Text(isLoading ? "Loading..." : "Reload")
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(isLoading ? .softBlue : .white)
                .padding(.vertical, 14)
                .frame(maxHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isLoading ? .backgroundWhite : .rose)
                )
        }
        .disabled(isLoading)
    }
    
    private func checkConnectivityAndProceed() {
        Task {
            if await requestManager.checkInternetConnectivity(withDelay: false) {
                await viewModel.fetchUser()
                isShowNext = true
            } else {
                isLoading = false
            }
        }
    }
    
    private func startRotation() {
        guard isLoading else { return }
        
        withAnimation(
            Animation.linear(duration: 1)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
    }
    
}

#Preview {
    LoadingScreen()
}
