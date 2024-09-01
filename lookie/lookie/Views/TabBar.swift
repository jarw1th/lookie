
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
        HStack(spacing: 32) {
            Button {
                tab = .home
            } label: {
                Image("Home")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle((tab == .home) ? .rose : .softBlue)
                    .frame(width: 24, height: 24)
            }
            
            Button {
                tab = .search
            } label: {
                Image("Magnifier")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle((tab == .search) ? .rose : .softBlue)
                    .frame(width: 24, height: 24)
            }
            
            Button {
                tab = .profile
            } label: {
                Image("Profile")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle((tab == .profile) ? .rose : .softBlue)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(.white)
        )
    }
    
}

#Preview {
    TabBar()
}
