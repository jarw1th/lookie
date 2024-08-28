
import SwiftUI

struct ImageViewCard: View {
    
    let url: String
    let isLiked: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 240)
                    .clipped()
            } placeholder: {
                Color.gray.frame(height: 150)
            }
            .cornerRadius(16)
            
            Image("HeartFill")
                .renderingMode(.template)
                .foregroundStyle(.backgroundWhite)
                .background(
                    Circle()
                        .fill(.black)
                        .opacity(0.26)
                        .frame(width: 40, height: 40)
                )
                .padding(.trailing, 24)
                .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: 240)
    }
    
}
