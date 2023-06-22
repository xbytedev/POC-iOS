//
//  AdaptsToKeyboard.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 07/06/23.
//

import SwiftUI
import Combine

struct AdaptsToKeyboard: ViewModifier {
	@State var currentHeight: CGFloat = 0

	func body(content: Content) -> some View {
		GeometryReader { geometry in
			content
				.padding(.bottom, currentHeight)
				.onAppear {
					NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
						.merge(with: NotificationCenter.Publisher(
							center: .default, name: UIResponder.keyboardWillChangeFrameNotification))
						.compactMap { notification in
							withAnimation(.easeOut(duration: 0.16)) {
								notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
							}
							/*let userInfo = notification.userInfo
							let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
								.flatMap { $0 as? Double } ?? 0.25
							if duration > 0 {
								let curve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
									.flatMap { $0 as? Int }
									.flatMap {
							 AnimationCurve(rawValue: $0)?.getAnimation(duration: duration)} ?? Animation.easeInOut(duration: duration)
								withAnimation(curve) {
									notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
								}
							} else {
								notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
							}*/
						}
						.map { rect in
							rect.height - geometry.safeAreaInsets.bottom
						}
						.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
				}
		}
	}
}

extension View {
	func adaptsToKeyboard() -> some View {
		return modifier(AdaptsToKeyboard())
	}
}

enum AnimationCurve: Int {
	case easeInOut = 0
	case easeIn = 1
	case easeOut = 2
	case linear = 3

	func getAnimation(duration: Double) -> Animation {
		switch self {
		case .easeInOut: return  .easeInOut(duration: duration)
		case .easeIn: return .easeIn(duration: duration)
		case .easeOut: return .easeOut(duration: duration)
		case .linear: return .linear(duration: duration)
		}
	}
}
