
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
            return AnyView(Search().environmentObject(viewModel))
        case .profile:
            return AnyView(Profile().environmentObject(viewModel))
        }
    }
    
    private func makeTabs() -> some View {
        HStack(spacing: 48) {
            Button {
                tab = .home
            } label: {
                Image("Home")
                    .renderingMode(.template)
                    .foregroundStyle((tab == .home) ? .softRed : .darkBlue)
            }
            
            Button {
                tab = .search
            } label: {
                Image("Magnifier")
                    .renderingMode(.template)
                    .foregroundStyle((tab == .search) ? .softRed : .darkBlue)
            }
            
            Button {
                tab = .profile
            } label: {
                Image("AvatarPlaceholder")
                    .foregroundStyle((tab == .profile) ? .softRed : .darkBlue)
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
