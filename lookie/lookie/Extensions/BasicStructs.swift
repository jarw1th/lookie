
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
                Color
                    .white
                    .frame(height: 240)
                    .cornerRadius(16)
            })
            .indicator(.activity)
            .cornerRadius(16)
        }
        .frame(maxWidth: .infinity, maxHeight: 240)
    }
    
}

struct GeneratedImageCard: View {
    
    let url: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("image")
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.softRed)
            Button {
               
            } label: {
                VStack {
                    WebImage(url: URL(string: url), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180)
                            .clipped()
                            .cornerRadius(16)
                    }, placeholder: {
                        Color.gray.frame(width: 180, height: 180)
                            .cornerRadius(16)
                    })
                    .indicator(.activity)
                    .cornerRadius(16)
                }
                .frame(width: 200, height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.darkBlue)
                )
            }
        }
    }
    
}
