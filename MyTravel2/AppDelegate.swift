//
//  AppDelegate.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 08/05/23.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
			FirebaseApp.configure()
			return true
		}
}
