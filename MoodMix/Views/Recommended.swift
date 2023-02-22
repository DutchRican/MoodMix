//
//  Recommendations.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/20/23.
//

import SwiftUI

struct Recommended: View {
    @EnvironmentObject private var aiSuggestions: AiSuggestions
    var titles: [String] = ["Movies", "Series", "Albums"]
    var body: some View {
        GeometryReader { geometryProxy in
            if aiSuggestions.recommendations == nil {EmptyView()} else {
             VStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(0...2, id: \.self) {idx in
                                VStack{
                                    Text(titles[idx]).font(.title)
                                    List((aiSuggestions.recommendations?.lists[idx]) ?? [], id: \.id) { sub in
                                        VStack (alignment: .leading) {
                                            Text("Title: \(sub.title ?? "Failed to parse")")
                                            Text("By: \(sub.owner ?? "Failed to parse")")
                                            Text("Description: \(sub.description ?? "")")
                                            AsyncImage(url: URL(string: sub.imageUrl ?? "")).frame(width: 200, height: 200)
                                        }
                                    }
                                }
                                .frame(width:  geometryProxy.size.width)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Recommended_Previews: PreviewProvider {
    static var previews: some View {
        Recommended().environmentObject({ () -> AiSuggestions in
            let aiSuggestions = AiSuggestions()
            aiSuggestions.recommendations = Recommendations(films: [Films(title: "The Rocky Horror Picture show", owner: "Jim Sharman", description: "This film is a cult classic that is a mix of horror, science fiction, and comedy, with a memorable soundtrack and a theatrical, over-the-top atmosphere.")], albums: [Albums(title: "test title album", owner: "test owner album", description: "test description album")], series: [Series(title: "test title series", owner: "test owner series", description: "test description series")])
            return aiSuggestions
        }())
    }
}
