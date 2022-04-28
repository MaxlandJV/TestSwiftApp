//
//  MovieListView.swift
//  TestSwiftApp
//
//  Created by Jordi Villaró on 14/3/22.
//

import SwiftUI

struct MovieListView: View {
    
    @State var isPresented: Bool = false
    @State var searchMovie: String = ""
    
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var searchResults: [Movie] {
        if searchMovie.isEmpty {
            return movieViewModel.movieList
        } else {
            let lowercaseSearchMovie = searchMovie.lowercased()
            return movieViewModel.movieList.filter { movie -> Bool in
                if let movieName = movie.movieName {
                    return movieName.lowercased().contains(lowercaseSearchMovie)
                }
                return false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            LinearGradient(colors: [Color("TopColorGradient"), Color("BottomColorGradient")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    ZStack {
                        if movieViewModel.movieList.isEmpty {
                            MovieEmptyView()
                                .transition(AnyTransition.opacity.animation(.easeIn))
                        }
                        else {
                            VStack {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(
                                            searchMovie.isEmpty ? Color(UIColor.systemGray2) : Color.primary
                                        )
                                    TextField("Buscar una película...", text: $searchMovie)
                                        .disableAutocorrection(true)
                                        .overlay(
                                            Image(systemName: "xmark.circle.fill")
                                                .opacity(searchMovie.isEmpty ? 0.0 : 1.0)
                                                .onTapGesture {
                                                    searchMovie = ""
                                                }, alignment: .trailing
                                        )
                                }
                                .font(.headline)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color(UIColor.systemGray3))
                                )
                                .padding()
                                
                                List(searchResults) { movie in
                                    NavigationLink(destination: MovieView(movie: movie, update: true)) {
                                        MovieListRowView(movieName: movie.movieName, showDate: movie.showDate, sinopsis: movie.sinopsis, score: movie.score)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            movieViewModel.deleteMovie(movie: movie)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                                    .listRowBackground(Color.white.opacity(0))
                                }
                                .listStyle(PlainListStyle())
                                .searchable(text: $searchMovie)
                            }
                        }
                    }
                        .navigationTitle(Text("Películas"))
                        .navigationBarItems(leading: NavigationLink(destination: MovieSetupView()) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.black)
                        })
                        .navigationBarItems(trailing: Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.black)
                        })
                        .sheet(isPresented: $isPresented) {
                            MovieView()
                        }
                )
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
