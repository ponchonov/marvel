//
//  API.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import Foundation

class API: NSObject {
    static let shared = API()
    
    var baseURL = "https://gateway.marvel.com/v1/public"
    var apiKey = "fe16d17d76e050d0d8e36ba84c7fdb00"
    override init() {
        super.init()
    }
    
    var currentPage = 0

    private func mutableRequest(url:URL) -> URLRequest {
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Referer":  "https://developer.marvel.com/docs"
        ]
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func apiCallWith(request:URLRequest,parameters:Dictionary<String,String>?, completion: @escaping (_ data:Data?,_ response: URLResponse?, _ error: Error?) -> Void) {
        
        let session = URLSession.shared
        var requestToSend = request;
        
        
        if let parameters = parameters  {
            for (key,value) in parameters {
                if var urlComp = URLComponents(url: requestToSend.url!, resolvingAgainstBaseURL: false)  {
                    let queryItem = URLQueryItem(name: key, value: value)
                    
                    if (urlComp.queryItems == nil) {
                        urlComp.queryItems = [URLQueryItem]()
                    }
                    
                    urlComp.queryItems?.append(queryItem)
                    if let finalurl = urlComp.url {
                        requestToSend.url = finalurl
                    }
                }
            }
        }
        
        let dataTask = session.dataTask(with: requestToSend) { (data, response, error) in
            completion(data,response,error)
        }
        dataTask.resume()
        
    }
    
    public func getHeroes(heroesPerPage:Int, nextPage:Bool = false, completion: @escaping ([Character],_ error: Error?) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/characters")
            else {
                let error = NSError(domain: "", code: -100, userInfo: [:])
                completion([], error)
                return
        }
        
        var request = mutableRequest(url: url)
        request.httpMethod = "GET"
        
        var parameters = [
            "limit":"\(heroesPerPage)",
            "apikey": apiKey,
            "orderBy":"name"
        ]
        
        if nextPage {
            currentPage = currentPage + 1
            parameters["offset"] = "\(currentPage * heroesPerPage)"
            
            print("current page:", currentPage)
        }
        
        apiCallWith(request: request, parameters: parameters) { (data, response, error) in
            
            if (error != nil) {
                print(error ?? " ")
                completion([], error)
            } else {
                do {
                    let decoder = JSONDecoder()
                    guard let data = data else {return}
                    let responseObject =  try decoder.decode(Response.self, from: data)
                    
                    
                    let characters = responseObject.data.results
                    
                    completion(characters, nil)
                } catch let e {
                    completion([], e)
                }
            }
        }
    }
    
    public func getComics(characterId:Int, completion: @escaping ([Comic],_ error: Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/comics")
                  else {
                      let error = NSError(domain: "", code: -100, userInfo: [:])
                      completion([], error)
                      return
              }
              
              var request = mutableRequest(url: url)
              request.httpMethod = "GET"
              
              let parameters = [
                "characters":"\(characterId)",
                  "apikey": apiKey
              ]
              
              apiCallWith(request: request, parameters: parameters) { (data, response, error) in
                  
                  if (error != nil) {
                      print(error ?? " ")
                      completion([], error)
                  } else {
                      do {
                          let decoder = JSONDecoder()
                          guard let data = data else {return}
                          let responseObject =  try decoder.decode(ResponseComics.self, from: data)
                        
                          let characters = responseObject.data.results
                          
                          completion(characters, nil)
                      } catch let e {
                          completion([], e)
                      }
                  }
              }
    }
}
