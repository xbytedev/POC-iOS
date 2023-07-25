//
//  GroupListRow.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 16/05/23.
//

import SwiftUI

struct GroupListRow: View {
	let group: MTGroup
	let selectedGroup: MTGroup?

    var body: some View {
		HStack {
			if (group.isDefault == 1 && selectedGroup == nil) || (selectedGroup == group) {
				Image(R.image.ic_right)
					.resizable()
					.renderingMode(.template)
					.aspectRatio(1, contentMode: .fit)
					.frame(height: 24)
					.foregroundColor(AppColor.theme)
			}
			Text(group.name ?? "")
				.frame(maxWidth: .infinity, alignment: .leading)
			Image(R.image.ic_arrowRight)
		}
    }
}
#if DEBUG
struct GroupListRow_Previews: PreviewProvider {
    static var previews: some View {
		GroupListRow(group: MTGroup.preview, selectedGroup: nil)
    }
}
#endif
