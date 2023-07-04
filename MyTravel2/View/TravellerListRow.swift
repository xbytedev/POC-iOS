//
//  TravellerListRow.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import SwiftUI

struct TravellerListRow: View {
	let traveller: MTTraveller
	var body: some View {
		HStack {
			Text(traveller.name)
			Spacer()
//			Toggle("", isOn: $(traveller.status == 1))
		}
	}
}
#if DEBUG
struct TravellerListRow_Previews: PreviewProvider {
    static var previews: some View {
		TravellerListRow(traveller: .preview)
    }
}
#endif
