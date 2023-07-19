//
//  CheckInView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct CheckInView: View {
	@State private var searchText: String = ""
	let places: [String] = ["Orion Hotel Bishkek", "Hyatt Regency Bishkek", "Ala-Archa Gorge", "Attraction 4 name", "Attraction 5 name"]
	@Binding var selection: SegmentItem
	
    var body: some View {
		/*VStack(alignment: .leading) {
			Text("Places")
			HStack {
				Image(R.image.ic_avatar)
					.resizable()
					.renderingMode(.template)
					.frame(width: 24.0, height: 24.0)
					.foregroundColor(AppColor.theme)
				TextField("Search", text: $searchText)
				if !searchText.isEmpty {
					Button {
					} label: {
						Image(R.image.ic_delete)
							.renderingMode(.template)
							.foregroundColor(AppColor.theme)
					}

				}
			}*/
			List {
				Section {
					ForEach(places, id: \.self) { place in
						HStack {

						}
						Text(place)

							.mtListBackgroundStyle()
					}
				}
			}
			.listStyle(.plain)
			//		}
		.padding()
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInView(selection: .constant(.places))
    }
}
