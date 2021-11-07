//
//  TableViewController.swift
//  FirstExample
//
//  Created by Furkan Saffet Olkay on 23.10.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class TableViewController:UIViewController{
   
    var movies: [Movie] = []
    var searchText:String?
  
    @IBOutlet weak var tfield: UITextField!
    
    @IBOutlet weak var tblView: UITableView!
    

    @IBAction func textFieldChange(_ sender: UITextField) {
        if let temp = sender.text {
            self.searchText = temp
        }

    }
    
    func startIndi(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func searchAction(_ sender: Any) {
       
      startIndi()
        if let temp = self.searchText {
            search(searchText:temp)
        }
        dismiss(animated: false, completion: nil)

    }

    @IBAction func favoritesAction(_ sender: Any) {
        performSegue(withIdentifier: "favoritesPageSegue", sender: nil)
    }
    
    func search(searchText: String){
        let query = NetworkManager.createQueryParameters(param: [ApiConstants.SEARCH_CASE:searchText])
        NetworkManager.instance.fetch(HTTPMethod.get, url: ApiConstants.BASE_URL, parameter: query, model: AllMovies.self){
            response in
            
            switch response {
                case .success(let model):
                    let allMovies = model as! AllMovies
                    self.movies = allMovies.movies
                    if self.movies.count > 0 {
                        self.tblView.reloadData()
                    }

                case .failure(_): break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tblView.delegate = self
        tblView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
    }

}

extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.movies.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell:TableViewCellController = self.tblView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCellController
           let movie = self.movies[indexPath.row]
           cell.customLabel.text = movie.title
    
               let imageUrl:URL = URL(string: movie.poster)!
               if let imageData:NSData = NSData(contentsOf:imageUrl){
                   cell.customImage.image = UIImage(data: imageData as Data)
               }
             
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("You tapped cell number \(indexPath.row).")
           
           performSegue(withIdentifier: "detailsPageSegue", sender:self.movies[indexPath.row])
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
