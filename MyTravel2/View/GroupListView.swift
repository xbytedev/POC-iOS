//
//  GroupListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/05/23.
//

import SwiftUI

struct GroupListView: View {
    var body: some View {
		List {
			HStack {
				Text("Mrugesh")
				Spacer()
				Image(systemName: "arrowtriangle.right.fill")
			}
			.mtListBackgroundStyle()
			HStack {
				Text("Swati")
				Spacer()
				Image(systemName: "arrowtriangle.right.fill")
			}
			.mtListBackgroundStyle()
			HStack {
				Text("Umang")
				Spacer()
				Image(systemName: "arrowtriangle.right.fill")
			}
			.mtListBackgroundStyle()
			HStack {
				Text("Siddharth")
				Spacer()
				Image(systemName: "arrowtriangle.right.fill")
			}
			.mtListBackgroundStyle()
			HStack {
				Text("Yash")
				Spacer()
				Image(systemName: "arrowtriangle.right.fill")
			}
			.mtListBackgroundStyle()
		}.listStyle(.plain)
    }
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
		GroupListView()
    }
}
