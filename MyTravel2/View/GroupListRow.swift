//
//  GroupListRow.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 16/05/23.
//

import SwiftUI

struct GroupListRow: View {
	let group: MTGroup

    var body: some View {
		HStack {
			if group.isDefault == 1 {
				Image(R.image.ic_right)
					.resizable()
					.renderingMode(.template)
					.aspectRatio(1, contentMode: .fit)
					.frame(height: 24)
					.foregroundColor(AppColor.theme)
			}
			Text(group.name ?? "")
			Spacer()
			Image(R.image.ic_arrowRight)
		}
    }
}

struct GroupListRow_Previews: PreviewProvider {
    static var previews: some View {
		GroupListRow(group: MTGroup.preview)
    }
}
