
import SwiftUI

struct Feed: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var isShowNewlook: Bool = false
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .task {
                await viewModel.fetchShortLook()
            }
            .fullScreenCover(isPresented: $isShowNewlook) {
                NewLook()
                    .environmentObject(viewModel)
            }
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 20) {
                makeTopBar()
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                makeFeedTypeBar()
                makeFeed()
                Spacer()
            }
            
            Button {
                isShowNewlook.toggle()
            } label: {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(.darkBlue)
                        .frame(width: 48, height: 48)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.backgroundWhite)
                        .frame(width: 20, height: 2)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.backgroundWhite)
                        .frame(width: 2, height: 20)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    private func makeTopBar() -> some View {
        HStack {
            Text("Feed")
                .font(.system(size: 72, weight: .bold))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.darkBlue)
            Spacer()
            makePremiumButton()
        }
    }
    
    private func makePremiumButton() -> some View {
        Button {
            
        } label: {
            HStack(spacing: 8) {
                VStack(spacing: -4) {
                    Text("buy")
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.goldYellow)
                    Text("pro")
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.goldYellow)
                }
                Image("RightArrow")
                    .renderingMode(.template)
                    .foregroundStyle(.goldYellow)
            }
        }
    }
    
    private func makeFeedTypeBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 14) {
                ForEach(FeedType.allCases.filter { $0 != .none }, id: \.self) { type in
                    if type.isPremium() {
                        makePremiumTypeButton(type)
                    } else {
                        makeTypeButton(type)
                    }
                }
            }
            .padding()
        }
    }
    
    private func makePremiumTypeButton(_ type: FeedType) -> some View {
        Button {
            if (viewModel.selectedFeedType == type) {
                viewModel.selectedFeedType = .none
            } else {
                viewModel.selectedFeedType = type
            }
        } label: {
            VStack(alignment: .trailing, spacing: 0) {
                Image("Star")
                    .renderingMode(.template)
                    .foregroundStyle(.goldYellow)
                Text(type.text() ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.darkBlue)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.goldYellow)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((viewModel.selectedFeedType == type) ? .goldYellow : .clear)
                            .rotationEffect(.degrees(1))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((viewModel.selectedFeedType == type) ? .goldYellow : .clear)
                            .rotationEffect(.degrees(-1))
                    )
            }
        }
    }
    
    private func makeTypeButton(_ type: FeedType) -> some View {
        Button {
            if (viewModel.selectedFeedType == type) {
                viewModel.selectedFeedType = .none
            } else {
                viewModel.selectedFeedType = type
            }
        } label: {
            VStack {
                Text(type.text() ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.darkBlue)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.darkBlue)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((viewModel.selectedFeedType == type) ? .darkBlue : .clear)
                            .rotationEffect(.degrees(1))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((viewModel.selectedFeedType == type) ? .darkBlue : .clear)
                            .rotationEffect(.degrees(-1))
                    )
            }
        }
    }
    
    private func makeFeed() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                ForEach(viewModel.shortLooks) { lookShort in
                    ImageViewCard(url: lookShort.imageUrls.first ?? "", isLiked: lookShort.isLiked)
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
            .padding(.horizontal, 20)
        }
    }
    
}

#Preview {
    Feed()
}
