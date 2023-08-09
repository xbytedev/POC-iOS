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
		PlaceListView(groupViewModel: groupViewModel, provider: PlaceAPIProvider())
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
