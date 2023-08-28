//
//  LocationView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct LocationView: View {
	@ObservedObject var groupViewModel: GroupViewModel
    @Binding var selection: SegmentItem

	init(groupViewModel: GroupViewModel, selection: Binding<SegmentItem>) {
        _selection = selection
		self.groupViewModel = groupViewModel
	}

	var body: some View {
		ZStack {
			PlaceListView(groupViewModel: groupViewModel, provider: PlaceAPIProvider())
				.opacity(selection == .places ? 1.0 : 0.0)
				.transition(.move(edge: .trailing))
			CheckInListView(provider: CheckInAPIProvider())
				.opacity(selection == .checkIns ? 1.0 : 0.0)
				.transition(.move(edge: .leading))
		}
	}
}

#if DEBUG
struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
		LocationView(
			groupViewModel: GroupViewModel(provider: GroupSuccessProvider()),
			selection: .constant(.places))
    }
}
#endif
