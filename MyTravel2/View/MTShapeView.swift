//
//  MTShapeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/05/23.
//

import SwiftUI

struct MTListBackgroundModifier: ViewModifier {
	func body(content: Content) -> some View {
			if #available(iOS 15.0, *) {
				content
					.padding()
					.myBackground {
						backgroundView
					}
					.listRowSeparator(.hidden)
			} else {
				content
					.padding()
					.myBackground {
						backgroundView
					}
			}
	}

	private var backgroundView: some View {
		ZStack {
			MTBorderShape(type: .outbound)
				.fill(AppColor.theme)
				.frame(height: 50)
				.offset(y: 0.75)
			MTBorderShape(type: .inbound)
				.fill(AppColor.Text.tertiary)
				.frame(height: 50)
		}
	}
}

extension View {
	func mtListBackgroundStyle() -> some View {
		modifier(MTListBackgroundModifier())
	}
}

struct MTBorderShape: Shape {
	enum ShapeType {
		case inbound
		case outbound
	}
	let type: ShapeType
	func path(in rect: CGRect) -> Path {
		Path { path in
			let halfHeight = rect.size.height / 2.0
			let center1X = rect.minX + halfHeight
			let center1Y = rect.midY
			let center1 = CGPoint(x: center1X, y: center1Y)
			path.addArc(center: center1, radius: halfHeight, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: true)
			let halfWidth = rect.size.width
			switch type {
			case .inbound:
				let center1Y = rect.maxY + (20 * halfWidth) - 0.75
				let point1 = CGPoint(x: rect.midX, y: center1Y)
				path.addArc(center: point1, radius: rect.size.width * 20, startAngle: .degrees(270), endAngle: .degrees(270), clockwise: false)
			case .outbound:
				let center1Y = rect.maxY - (20 * halfWidth) + 0.75
				let point1 = CGPoint(x: rect.midX, y: center1Y)
				path.addArc(center: point1, radius: rect.size.width * 20, startAngle: .degrees(90), endAngle: .degrees(90), clockwise: true)
			}
			let center2X = rect.maxX - halfHeight
			path.addArc(center: CGPoint(x: center2X, y: center1Y), radius: halfHeight, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: true)
		}
	}
}
