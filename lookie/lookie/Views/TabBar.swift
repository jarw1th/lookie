
import SwiftUI

struct TabBar: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var tab: TabType = .home
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    private func makeContent() -> some View {
        VStack {
            makeViews()
            makeTabs()
        }
    }
    
    private func makeViews() -> some View {
        switch tab {
        case .home:
            return AnyView(Feed().environmentObject(viewModel))
        case .search:
            return AnyView(Feed())
        case .profile:
            return AnyView(Feed())
        }
    }
    
    private func makeTabs() -> some View {
        HStack(spacing: 48) {
            Button {
                tab = .home
            } label: {
                Image("Home")
                    .renderingMode(.template)
                    .foregroundStyle((tab == .home) ? .goldYellow : .darkBlue)
            }
            
            Button {
                tab = .search
            } label: {
                Image("Magnifier")
                    .renderingMode(.template)
                    .foregroundStyle((tab == .search) ? .goldYellow : .darkBlue)
            }
            
            Button {
                tab = .profile
            } label: {
                Image("AvatarPlaceholder")
                    .foregroundStyle((tab == .profile) ? .goldYellow : .darkBlue)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(.backgroundWhite)
        )
    }
    
}

#Preview {
    TabBar()
}
