////
////  DBMoviRepository.swift
////  FirstExample
////
////  Created by Furkan Saffet Olkay on 30.10.2021.
////

import Foundation
class DBMovieRepository{
    static let context =  appDelegate.persistentContainer.viewContext

    public static func getAllFavorites() -> [MovieCoreModel] {
      return  try! context.fetch(MovieCoreModel.fetchRequest())
    }
    
    public static func addFavoriteMovie(movie:Movie?){
        let movieCore = MovieCoreModel(context: context)
        movieCore.poster = movie?.poster
        movieCore.title = movie?.title
        movieCore.imdb_id = movie?.imdbID
        appDelegate.saveContext()
    }
    
    public static func removeFavoriteMovie(movie:Movie?){
       let _movieList: [MovieCoreModel]
        _movieList = try! context.fetch(MovieCoreModel.fetchRequest())
       let results = _movieList.filter{el in el.imdb_id == movie?.imdbID}
       if let tempMovie = results.first {
           context.delete(tempMovie)
          
       }
       appDelegate.saveContext()

    }
    
    public static func isMovieExist(movie:Movie?) -> Bool{
        let _movieList :[MovieCoreModel]
         _movieList = try! context.fetch(MovieCoreModel.fetchRequest())
        let results = _movieList.filter{el in el.imdb_id == movie?.imdbID}
        
        if results.count>0 {
            return true
        }
        return false
        
    }
}

