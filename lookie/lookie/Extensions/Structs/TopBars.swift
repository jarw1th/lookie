
import SwiftUI
import SDWebImageSwiftUI

struct TopBar<Content: View>: View {
    
    @ViewBuilder let buttonContent: (() -> Content)
    let buttonAction: (() -> Void)?
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        HStack {
            if let buttonAction = buttonAction {
                Button {
                    buttonAction()
                } label: {
                    buttonContent()
                }
            }
            Spacer()
            Text("\(PagesManager.shared.currentAuthorizationPageIndex + 1)/\(AuthorizationPages.allCases.count)")
                .font(.system(size: 20, weight: .regular))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.rose)
                .frame(height: 32)
        }
    }
    
}

struct ProfileBar: View {
    
    let buttonAction: () -> Void
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        HStack(spacing: 16) {
            WebImage(url: URL(string: ""), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
            }, placeholder: {
                Color
                    .white
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
            })
            .indicator(.activity)
            .background(
                Circle()
                    .stroke(.darkBlue)
                    .frame(width: 60, height: 60)
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text("User")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.darkBlue)
                
                Text("no subscription")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.goldYellow)
            }
            
            Spacer()
            
            Button {
                buttonAction()
            } label: {
                Image("Settings")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.darkBlue)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
}
