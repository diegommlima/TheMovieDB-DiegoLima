//
//  NetworkProvider.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Foundation
import Reachability

public typealias NetworkCompletion = (() throws -> Data) -> Void
public typealias NetworkRequestProgressCallback = (() -> URLSessionDataTask) -> Void
public typealias NetworkParameters = (bodyParameters: Data?, queryParameters: Data?)

/// Service HTTP Method
///
/// - get: GET Verb
/// - post: POST Verb
/// - head: HEAD Verb
/// - put: PUT Verb
/// - delete: DELETE Verb
/// - patch: PATCH Verb
enum ServiceHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

class NetworkProvider {
    
    private let session: URLSession
    private let baseURL: URL
    
    /// Provider Networking Initializer
    ///
    /// - Parameters:
    ///   - session: URLSession
    ///   - baseURL: URL
    init(session: URLSession, baseURL: URL) {
        self.session = session
        self.baseURL = baseURL
    }
    
    // MARK: - Public methods
    // swiftlint:disable:next function_parameter_count
    func dataTaskFor(httpMethod: ServiceHTTPMethod,
                     endPoint: String,
                     parameters: NetworkParameters?,
                     header: [String: String]?,
                     progressCallback: @escaping NetworkRequestProgressCallback,
                     completion: @escaping NetworkCompletion) -> URLSessionTask? {

        guard Reachability.isConnected else {
            completion { throw ApiError.offlineMode }
            return nil
        }
        
        do {
            let request = try self.request(baseURL.absoluteString + endPoint,
                                           parameters: parameters,
                                           header: header,
                                           httpMethod: httpMethod)
            
            let sessionTask: URLSessionTask = session.dataTask(with: request,
                                                               completionHandler: {(data, response, error) -> Void  in
                                                                self.completionHandler(data: data,
                                                                                       response: response,
                                                                                       error: error,
                                                                                       completion: completion)
            })
            
            sessionTask.resume()
            
            return sessionTask
        } catch let errorRequest {
            DispatchQueue.main.async(execute: {
                completion { throw errorRequest }
            })
        }
        
        return nil
    }
    
    // MARK: - Private methods
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        DispatchQueue.main.async {
            print("progress:\(progress) totalSize:\(totalSize)")
        }
    }
    
    //
    //    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
    //                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
    //                    totalBytesExpectedToWrite: Int64) {
    //        // 1
    //        guard let url = downloadTask.originalRequest?.url,
    //            let download = downloadService.activeDownloads[url]  else { return }
    //        // 2
    //        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    //        // 3
    //        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    //        // 4
    //        DispatchQueue.main.async {
    //            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
    //                                                                       section: 0)) as? TrackCell {
    //                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
    //            }
    //        }
    //    }
    
    private func request(_ urlPath: String,
                         parameters: NetworkParameters?,
                         header: [String: String]?,
                         httpMethod: ServiceHTTPMethod) throws -> URLRequest {
        
        let request = NSMutableURLRequest()
        request.httpMethod = httpMethod.rawValue
        
        guard let completeURL = self.completeURL(urlPath) else {
            throw ApiError.invalidURL
            
        }
        guard var urlComponents: URLComponents = URLComponents(url: completeURL,
                                                               resolvingAgainstBaseURL: false) else {
                                                                throw ApiError.invalidURL
        }
        
        //checking if parameters are needed
        if let params = parameters {
            //adding parameters to body
            if let bodyParameters = params.bodyParameters {
                request.httpBody = bodyParameters
            }
            
            //adding parameters to query string
            if let queryParameters = params.queryParameters {
                
                if let json = try JSONSerialization.jsonObject(with: queryParameters,
                                                               options: .mutableLeaves) as? [String: Any] {
                    let parametersItems: [String] = json.map({ (par) -> String in
                        let value = String(describing: par.1) != "" ? String(describing: par.1) : "null"
                        if value == "null" { return "" }
                        return "\(par.0)=\(value)"
                    })
                    
                    urlComponents.query = parametersItems.joined(separator: "&")
                }
            }
        }
        
        //setting url to request
        request.url = urlComponents.url
        request.cachePolicy = .reloadIgnoringCacheData
        
        //adding HEAD parameters
        if header != nil {
            for parameter in header! {
                request.addValue(parameter.1, forHTTPHeaderField: parameter.0)
            }
        }
        
        return request as URLRequest
    }
    
    private func completeURL(_ componentOrUrl: String) -> URL? {
        if componentOrUrl.contains("http://") ||  componentOrUrl.contains("https://") {
            return URL(string: componentOrUrl)
        } else {
            return baseURL.appendingPathComponent(componentOrUrl)
        }
    }
    
    private func completionHandler(data: Data?,
                                   response: URLResponse?,
                                   error: Error?,
                                   completion: @escaping NetworkCompletion) {
        do {
            //check if there is no error
            if error != nil {
                throw error!
            }
            
            //unwraping httpResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.parse("The NSHTTPURLResponse could not be parsed")
            }
            
            //check if there is an httpStatus code ~= 200...299 (Success)
            if 200 ... 299 ~= httpResponse.statusCode {
                
                //trying to get the data
                guard let responseData = data else {
                    throw ApiError.parse("Error parsing Data from request: \(String(describing: httpResponse.url))")
                }
                
                DispatchQueue.main.async(execute: {
                    //success
                    completion { responseData as Data }
                })
            } else {
                //checking status of http
                throw ApiError.httpError(httpResponse.statusCode)
            }
        } catch let errorCallback {
            DispatchQueue.main.async(execute: {
                completion { throw errorCallback }
            })
        }
    }
    
}
