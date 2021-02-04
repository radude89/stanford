//
//  EnrouteApp.swift
//  Enroute
//
//  Created by Radu Dan on 02.02.2021.
//

import SwiftUI

@main
struct EnrouteApp: App {
    private let persistenceController = PersistenceController.shared
    
    private var airport: Airport {
        let airport = Airport.withICAO("KSFO", context: persistenceController.container.viewContext)
        airport.fetchIncomingFlights()
        return airport
    }
    
    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: airport))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
