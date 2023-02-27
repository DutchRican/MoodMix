//
//  Description.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

struct Description: View {
    var body: some View {
        VStack {
            Text(
                "Moodmix is an AI media recommender using ChatGPT. It suggests films, music, and movies based on the album you're playing.")
            .font(.title3)
            .foregroundColor(Color("offColor"))
            .fontWeight(.medium)
            .padding(.bottom, 3)
            
            Text("Note: It may take up to 60 seconds for the AI model to complete your request")
                .font(.subheadline).fontWeight(.light)
                .foregroundColor(Color("offColor"))
        }
        .padding(.horizontal, 5)
        .frame(height: 150)
    }
}

struct Description_Previews: PreviewProvider {
    static var previews: some View {
        Description()
            .previewLayout(.sizeThatFits )
    }
}
