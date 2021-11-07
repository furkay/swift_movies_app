//
//  NetworkManager.swift
//  FirstExample
//
//  Created by Furkan Saffet Olkay on 23.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager{
    
    static let instance = NetworkManager()
    
    public func fetch<T:Codable>(_ method:HTTPMethod, url:String, parameter:[String:String], model:T.Type, completion:@escaping (AFResult<Codable>)->Void ){
        
        AF.request(url, method: method, parameters: parameter).validate().responseJSON{
            response in
            
            switch response.result {
                case .success(let value):
                    do{
                        let responseJsonData = JSON(value)
                        let responseModel = try JSONDecoder().decode(model.self, from: responseJsonData.rawData())
                        completion(.success(responseModel))
                    }catch let parsingError{
                            print("error \(parsingError)")
                    }
                case .failure(let error):
                        completion(.failure(error))

            }
        }
    }
    
 
    
    static func createQueryParameters(param:[String:String]) -> [String:String] {
        //Create Api Key
        let keyQueryParam : [String:String] = [ApiConstants.API_KEY_CASE:ApiConstants.API_KEY]
        //Merge other params
        let queryParameters = keyQueryParam.merging(param){$1}
        return queryParameters
    }

      static func jsonToParameters(from data: Data) -> [String: Any]?
      {
          return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      }
}
