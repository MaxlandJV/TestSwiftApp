//
//  FilmViewModel.swift
//  TestSwiftApp
//
//  Created by Jordi Villaró on 30/1/22.
//

import Foundation

final class Films: ObservableObject {
    @Published var filmsList: [Film] = []
    
    init() {
        filmsList = getAllFilms()
    }
    
    func saveFilm(filmName: String, startDate: Date, sinopsis: String, score: Int) {
        let film = Film(filmName: filmName, startDate: startDate, sinopsis: sinopsis, score: score)
        
        filmsList.insert(film, at: 0)
        //filmsList.append(film)
        encodeAndSaveAllFilms()
    }
    
    private func encodeAndSaveAllFilms() {
        if let encoded = try? JSONEncoder().encode(filmsList) {
            UserDefaults.standard.set(encoded, forKey: "films")
        }
    }
    
    func getAllFilms() -> [Film] {
        if let filmsData = UserDefaults.standard.object(forKey: "films") as? Data {
            if let films = try? JSONDecoder().decode([Film].self, from: filmsData) {
                return films
            }
        }
        return []
    }
    
    func deleteFilm(id: String) {
        filmsList.removeAll { film in
            film.id == id
        }
        encodeAndSaveAllFilms()
    }
}
