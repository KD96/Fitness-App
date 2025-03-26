//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Kem Jian Diaz Mena on 26/3/25.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
