//
//  GroupListRow.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 16/05/23.
//

import SwiftUI

struct GroupListRow: View {
	let groupName: String

    var body: some View {
		HStack {
			Text(groupName)
			Spacer()
			Image(R.image.ic_arrowRight)
		}
    }
}

struct GroupListRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupListRow(groupName: "Mrugesh")
    }
}
