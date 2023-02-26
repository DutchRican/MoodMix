//
//  Footer.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/26/23.
//

import SwiftUI

struct Footer: View {
    var body: some View {
        VStack {
            Divider()
            HStack{
                Text("Build with ❤️ by Matthew Stingel")
                    .font(.caption2)
                Spacer()
                Text("Denver, CO 🏔️").font(.caption2)
                Text("©2023").font(.caption2)
                
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: 20)
    }
}

struct Footer_Previews: PreviewProvider {
    static var previews: some View {
        Footer()
    }
}
