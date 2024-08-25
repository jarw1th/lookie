
import SwiftUI

struct Authorization: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var mail: String = ""
    @State private var password: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isShowNext: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 64) {
            makeLogotype()
                .padding(.top, 100)
            VStack(spacing: 24) {
                makeFillField(name: "e-mail", placeholder: "lookie@gmail.com", bind: $mail)
                makeFillField(name: "password", placeholder: "********", bind: $password)
                makeNextButton()
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .fullScreenCover(isPresented: $isShowNext) {
            TabBar()
                .environmentObject(viewModel)
        }
    }
    
    private func makeLogotype() -> some View {
        Text("Lookie")
            .font(.system(size: 88, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundStyle(.softRed)
    }
    
    private func makeFillField(name: String, placeholder: String, bind: Binding<String>) -> some View {
        VStack(alignment: .leading) {
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
    
    private func makeNextButton() -> some View {
        VStack(alignment: .leading) {
            Text("failed*")
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.softRed)
                .hidden()
            Button {
                Task {
                    isLoading.toggle()
                    try await viewModel.signIn(with: mail, password: password)
                    if viewModel.currentUser != nil {
                        isShowNext.toggle()
                    }
                    print(viewModel.currentUser)
                    isLoading.toggle()
                }
            } label: {
                VStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.backgroundWhite)
                    } else {
                        Text("Next")
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.backgroundWhite)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.softRed)
                )
            }
            .disabled(isLoading)
        }
    }
    
}

#Preview {
    Authorization()
        .environmentObject(ViewModel())
}
