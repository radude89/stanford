//
//  EnrouteApp.swift
//  Enroute
//
//  Created by Radu Dan on 02.02.2021.
//

import SwiftUI

@main
struct EnrouteApp: App {
    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
        }
    }
}
