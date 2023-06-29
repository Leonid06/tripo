//
//  ContentView.swift
//  Tripo
//
//  Created by Leonid on 07.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        AuthenticationView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
