//
//  SuggestionCard.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/26/23.
//

import SwiftUI

struct SuggestionCard: View {
    var sub: any SuggestionItem
    var idx: Int
    var body: some View {
        VStack (alignment: .leading){
            VStack (alignment: .center) {
                Text("\(sub.title ?? "No title provided")")
                    .font(.title2)
                    .padding(.bottom, 5)
                HStack {
                    Spacer()
                    Text("\(sub.owner ?? "")")
                        .font(.footnote)
                    .padding(.bottom, 5)
                }
            }
            HStack {
                AsyncImage(url: URL(string: sub.imageUrl ?? "")) { phase in
                    switch phase {
                    case .empty:
                        if idx < 2 {
                            ProgressView()
                        } else {
                            Image(systemName: "recordingtape")
                        }
                        
                    case .success(let image):
                        image .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.black, lineWidth: 1))
                        
                        
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                
                .frame(maxWidth: 100)
                .padding(.trailing, 10)
                .shadow(radius: 10.0)
                
                VStack (alignment: .leading) {
                    Text("\(sub.description ?? "")")
                    
                }
            }
        }
            .padding()
        .frame(maxHeight: 300)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SuggestionCard_Previews: PreviewProvider {
    static var previews: some View {
        let film: Films = Films(title: "The Rocky Horror Picture show", owner: "Jim Sharman", description: "This film is a cult classic that is a mix of horror, science fiction, and comedy, with a memorable soundtrack and a theatrical, over-the-top atmosphere.", imageUrl: "https://image.tmdb.org/t/p/w342/rsNbxonO8gtylIXwiv7JeqwJ4Kb.jpg")
        SuggestionCard(sub: film as (any SuggestionItem), idx: 0)
    }
}
