
import SwiftUI

struct Feed: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .task {
                await viewModel.fetchShortLook()
            }
    }
    
    private func makeContent() -> some View {
        VStack(spacing: 24) {
            makeFeedTypeBar()
            makeFeed()
            Spacer()
        }
        .padding(.top, 24)
    }
    
    private func makeFeedTypeBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 7) {
                ForEach(FeedType.allCases.filter { $0 != .none }, id: \.self) { type in
                    if type.isPremium() {
                        PremiumTypeButton(type: type, selectedType: $viewModel.selectedFeedType)
                    } else {
                        TypeButton(type: type, selectedType: $viewModel.selectedFeedType)
                    }
                }
            }
            .padding()
        }
    }
    
    private func makeFeed() -> some View {
        ScrollView {
            HStack(alignment: .top, spacing: 15) {
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.shortLooks.indices, id: \.self) { index in
                        if index % 2 == 0 {
                            var shortLook = viewModel.shortLooks[index]
                            ImageViewCard(url: shortLook.imageUrls.first ?? "", isLiked: shortLook.isLiked, likeAction: {
                                Task {
                                    await viewModel.update(shortLook)
                                    shortLook.isLiked.toggle()
                                }
                            })
                        }
                    }
                    
                    if viewModel.lastShortLookDocument != nil {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await viewModel.fetchShortLook()
                                }
                            }
                    }
                }
                
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.shortLooks.indices, id: \.self) { index in
                        if index % 2 != 0 {
                            var shortLook = viewModel.shortLooks[index]
                            ImageViewCard(url: shortLook.imageUrls.first ?? "", isLiked: shortLook.isLiked, likeAction: {
                                Task {
                                    await viewModel.update(shortLook)
                                    shortLook.isLiked.toggle()
                                }
                            })
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
}

#Preview {
    Feed()
}
