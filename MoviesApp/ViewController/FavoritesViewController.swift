//
//  FavoritesViewController.swift
//  FirstExample
//
//  Created by Furkan Saffet Olkay on 31.10.2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    let context =  appDelegate.persistentContainer.viewContext
    var movies: [MovieCoreModel]!

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        
        tblView.delegate = self
        tblView.dataSource = self
        getData()
       
    }
    
  func getData(){
      movies =  DBMovieRepository.getAllFavorites()
    }
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.movies.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell:TableViewCellController = self.tblView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCellController
            
           let movie = self.movies[indexPath.row]
           cell.customLabel.text = movie.title
           
           if movie.poster != nil{
               let imageUrl:URL = URL(string: movie.poster!)!
               if let imageData:NSData = NSData(contentsOf:imageUrl){
                   cell.customImage.image = UIImage(data: imageData as Data)
               }
           }
             
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let movieModel = self.movies[indexPath.row]
           let tempMovie = Movie(title: movieModel.title!, year: "", imdbID: movieModel.imdb_id!, type: "", poster: movieModel.poster!)
           performSegue(withIdentifier: "detailsPageSegue", sender:tempMovie)
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "detailsPageSegue" {
         let movie  = sender as! Movie
           if segue.destination is DetailsViewController {
                let detailsViewController = segue.destination as? DetailsViewController
               detailsViewController?.movie = movie
            }
        }
    }
    
    
}
