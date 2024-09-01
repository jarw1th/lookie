
import SwiftUI

struct Notifications: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowNext: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 64) {
            TopBar(buttonContent: {
                Image("LeftArrow")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.darkBlue)
            }, buttonAction: {
                dismiss()
            })
            VStack(alignment: .center, spacing: 108) {
                Text("Turn on\nnotifications")
                    .font(.system(size: 24, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.darkBlue)
                    .frame(maxWidth: .infinity)
            }
            Spacer()
            HStack(spacing: 7) {
                makeNotNowButton()
                makeTurnOnButton()
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 108)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .onAppear {
            PagesManager.shared.currentAuthorizationPage = .notifications
        }
        .fullScreenCover(isPresented: $isShowNext) {
            TabBar()
                .environmentObject(viewModel)
        }
    }
    
    private func makeNotNowButton() -> some View {
        Button {
            isShowNext.toggle()
        } label: {
            VStack {
                Text("Not now")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.softBlue)
            )
        }
    }
    
    private func makeTurnOnButton() -> some View {
        Button {
            isShowNext.toggle()
        } label: {
            VStack {
                Text("Turn on")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.rose)
            )
        }
    }
    
}

#Preview {
    Notifications()
        .environmentObject(ViewModel())
}
