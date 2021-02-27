//
//  MathApp2_0App.swift
//  MathApp2.0
//
//  Created by Johan Stahre on 2021-02-27.
//

import SwiftUI
import Firebase

@main
struct MathApp2_0App: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
