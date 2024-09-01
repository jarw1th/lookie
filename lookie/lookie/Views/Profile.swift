
import SwiftUI
import SDWebImageSwiftUI

struct Profile: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var isShowNewlook: Bool = false
    @State private var isShowGenerateImage: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .fullScreenCover(isPresented: $isShowNewlook) {
                NewLook()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $isShowGenerateImage) {
                GenerateImage()
                    .environmentObject(viewModel)
            }
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 24) {
                ProfileBar(buttonAction: {
                    
                })
                makeCardsGrid()
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            
            AddButton(newAction: {
                isShowNewlook.toggle()
            }, generateAction: {
                isShowGenerateImage.toggle()
            })
        }
    }
    
    private func makeCardsGrid() -> some View {
        VStack {
            
        }
    }
    
}

#Preview {
    Profile()
}
