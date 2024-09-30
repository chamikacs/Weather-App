//
//  DescriptivePlace.swift
//  CWK2Template
//
//  Created by Chamika Sakalasuriya on 2024-01-07.
//

import SwiftUI

struct DescriptivePlace: View {
    
    @State var place: SubLocationDTO
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Spacer()
            Image(place.imageNames)
                .resizable()
                .frame(width: width * 0.8, height: 200)
                .scaledToFit()
                .cornerRadius(20)
            Spacer()
            Text(place.name)
                .font(Constants.normalText)
                .bold()
            Text(place.description)
                .multilineTextAlignment(.center)
                .font(Constants.descriptiveText)
            Link(place.link, destination: URL(string: place.link)!)
            Spacer()
        }
    }
}

#Preview {
    DescriptivePlace(place: SubLocationDTO(name: "London", cityName: "London", latitude: 0.0, longitude: 0.0, description: "The Tower of London is a historic castle on the north bank of the River Thames...", imageNames: "london-tower-1", link: ""))
}
