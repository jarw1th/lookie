
import SwiftUI

struct Authorization: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var mail: String = ""
    @State private var password: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isShowNext: Bool = false
    @State private var error: AuthorizationErrorType?
    
    @available(iOS 16.0, *)
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 64) {
            TopBar(buttonContent: {}, buttonAction: nil)
            VStack(spacing: 24) {
                FillField(name: "Your e-mail", placeholder: "lookie@gmail.com", bind: $mail)
                FillField(name: "Password", placeholder: "********", bind: $password)
            }
            Spacer()
            makeNextButton()
        }
        .padding(.top, 24)
        .padding(.bottom, 108)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .onAppear {
            PagesManager.shared.currentAuthorizationPage = .fields
        }
        .navigationDestination(isPresented: $isShowNext) {
            AuthorizationAvatar()
                .environmentObject(viewModel)
        }
    }
    
    private func makeNextButton() -> some View {
        VStack(alignment: .leading) {
            Button {
                Task {
                    if isValidEmail(mail) && isValidPassword(password) {
                        isLoading.toggle()
                        try await viewModel.signIn(with: mail, password: password)
                        if viewModel.currentUser != nil {
                            isShowNext.toggle()
                        } else {
                            error = .email
                        }
                        isLoading.toggle()
                    }
                }
            } label: {
                VStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("Next")
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(error != nil ? .softBlue : .rose)
                )
            }
            .disabled(isLoading)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let result = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        error = (result ? nil : .email)
        return result
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let result = password.count >= 6
        error = (result ? nil : .password)
        return result
    }
    
}

#Preview {
    Authorization()
        .environmentObject(ViewModel())
}
