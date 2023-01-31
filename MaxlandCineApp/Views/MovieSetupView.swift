//
//  MovieSetupView.swift
//  TestSwiftApp
//
//  Created by Jordi Villaró on 14/3/22.
//

import SwiftUI
import QuickLook

struct MovieSetupView: View {
    
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var body: some View {
        Form {
            Section(header: Text("setup-about") + Text(" - 1.2.3")) {
                VStack(alignment: .leading) {
                    Image("MaxlandWorld")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("setup-details")

                }
                .padding(.vertical)
            }
            
            Section(header: Text("setup-links")) {
                VStack(alignment: .leading) {
                    Link("setup-code", destination: URL(string: "https://github.com/MaxlandJV/MaxlandCineApp")!)
                }
                VStack(alignment: .leading) {
                    Link("setup-about-me", destination: URL(string: "https://www.linkedin.com/in/jordivilaro")!)
                }
            }
            
            if movieViewModel.biometricAuthUtil.biometricAuthActive() {
                Section {
                    Toggle("setup-auth", isOn: $movieViewModel.biometricAuth)
                } header: {
                    Text("setup-bioauth")
                } footer: {
                    Text("setup-auth-details")
                }
            }
            
            if !movieViewModel.movieList.isEmpty {
                Section(header: Text("setup-copias-seguridad")) {
                    VStack(alignment: .leading) {
                        NavigationLink {
                            MovieExportDataView()
                        } label: {
                            Text("setup-exportar-datos")
                        }
                    }
                    VStack(alignment: .leading) {
                        NavigationLink {
                            MovieImportDataView()
                        } label: {
                            Text("setup-importar-datos")
                        }
                        
                    }
                }
            }
        }
       .navigationBarTitle("setup-title")
    }
}

struct MovieSetup_Previews: PreviewProvider {
    static var previews: some View {
        MovieSetupView()
    }
}
