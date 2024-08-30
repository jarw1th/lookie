
import SwiftUI
import SDWebImageSwiftUI

struct ImageViewCard: View {
    
    let url: String
    @State var isLiked: Bool
    let likeAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            WebImage(url: URL(string: url), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 240)
                    .clipped()
                    .cornerRadius(16)
            }, placeholder: {
                Color.gray.frame(height: 240)
                    .cornerRadius(16)
            })
            .indicator(.activity)
            .cornerRadius(16)
            
            Button {
                likeAction()
                isLiked.toggle()
            } label: {
                Image("HeartFill")
                    .renderingMode(.template)
                    .foregroundStyle(isLiked ? .darkBlue : .backgroundWhite)
                    .background(
                        Circle()
                            .fill(isLiked ? .backgroundWhite : .darkBlue)
                            .opacity(isLiked ? 1.0 : 0.26)
                            .frame(width: 40, height: 40)
                    )
                    .padding(.trailing, 24)
                    .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 240)
    }
    
}
