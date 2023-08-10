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
        NavigationStack {
            ZStack {
                if movieViewModel.movieList.isEmpty {
                    LinearGradient(colors: [Color("TopColorGradient"), Color("BottomColorGradient")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        .overlay (
                            MovieEmptyView()
                                .transition(AnyTransition.opacity.animation(.easeIn)))
                }
                else {
                    ScrollView {
                        LazyVStack {
                            ForEach(searchResults) { movie in
                                NavigationLink(value: movie) {
                                    MovieListRowView(movieName: movie.movieName, showDate: movie.showDate, sinopsis: movie.sinopsis, score: movie.score, isSerie: movie.isSerie, caratula: movie.caratula)
                                        .contextMenu {
                                            Button {
                                                movieViewModel.deleteMovie(movie: movie)
                                            } label: {
                                                Label("movie-confirm-delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .searchable(text: $searchMovie, prompt: "navigation-list-search")
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .navigationDestination(for: Movie.self) { movie in
                        MovieView(movie: movie, update: true)
                    }
                }
            }
            .background(LinearGradient(colors: [Color("TopColorGradient"), Color("BottomColorGradient")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationTitle(Text("navigation-list-title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: MovieSetupView()) {
                        Image(systemName: "gearshape").foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if (movieViewModel.movieList.count > 0) {
                        NavigationLink(destination: MovieStatsView()) {
                            Image(systemName: "chart.bar.xaxis").foregroundColor(.black)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle").foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    MovieView()
                        .interactiveDismissDisabled()
                }
                .presentationBackground(.thinMaterial)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .environmentObject(MovieViewModel())
    }
}
