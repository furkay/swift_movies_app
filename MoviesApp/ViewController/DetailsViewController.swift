//
//  DetailsViewController.swift
//  FirstExample
//
//  Created by Furkan Saffet Olkay on 28.10.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class DetailsViewController: UIViewController {
    var movie:Movie?
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var DetailsMovieImage: UIImageView!
  
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let isExist = DBMovieRepository.isMovieExist(movie: movie)
        if isExist {
            favButton.image = UIImage(systemName: "star.fill")
        }
        self.DetailsMovieImage.layer.cornerRadius = 20
        self.DetailsMovieImage.clipsToBounds = true
        self.content.numberOfLines = 0
        if let temp = movie {
            navigationBar.title = temp.title
            if movie?.imdbID != nil {
                fillDetails(imdbID: movie!.imdbID)
            }
            
        }
    
    }

    func fillDetails(imdbID:String){
        getDetails(imdbID: imdbID) { details in
            if let movieDetails = details {
                    let imageUrl:URL = URL(string: movieDetails.poster)!
                    if let imageData:NSData = NSData(contentsOf:imageUrl){
                        self.DetailsMovieImage.image = UIImage(data: imageData as Data)
                        self.content.text = movieDetails.plot
                        self.year.text = movieDetails.year
                    }
            }
        }
    }
    
    
    func getDetails(imdbID: String, completion: @escaping (_ movieDetails:MovieDetails?) -> Void ){
        let query = NetworkManager.createQueryParameters(param: [ApiConstants.DETAILS_CASE:imdbID])
        NetworkManager.instance.fetch(HTTPMethod.get, url: ApiConstants.BASE_URL, parameter: query, model: MovieDetails.self){
            response in
            switch response {
                case .success(let model):
                let movieDetails = model as! MovieDetails
                completion(movieDetails)
                case .failure(_):
                completion(nil)
                break
            }
        }
    }
    
    
    @IBAction func favAction(_ sender: Any) {
        let isExist = DBMovieRepository.isMovieExist(movie: movie)
        if !isExist{
            DBMovieRepository.addFavoriteMovie(movie: movie)
            favButton.image = UIImage(systemName: "star.fill")
        }else{
            DBMovieRepository.removeFavoriteMovie(movie: movie)
            favButton.image = UIImage(systemName: "star")
            
        }
        
     
    }
    
    
    
    
}
