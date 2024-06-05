//
//  NetworkingManager.swift
//  Wallester
//
//  Created by Denis Sinitsa on 20.05.2024.
//

import Combine
import Foundation

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "Bad response from URL: \(url)"
                
            case .unknown:
                return "Unknown error occurred"
            }
        }
    }
    
    private static let cache = URLCache(
        memoryCapacity: 500 * 1024 * 1024, diskCapacity: 1 * 1024 * 1024 * 1024,
        diskPath: "coinGeckoCache")
    
    static func download(url: URL, forceUpdate: Bool = false) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.cachePolicy =
        forceUpdate ? .reloadIgnoringLocalAndRemoteCacheData : .returnCacheDataElseLoad
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> (Data, URLResponse) in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200 && httpResponse.statusCode < 300
                else {
                    throw NetworkingError.badURLResponse(url: url)
                }
                return (output.data, output.response)
            }
            .handleEvents(receiveOutput: { (data, response) in
                if !forceUpdate {
                    let cachedResponse = CachedURLResponse(
                        response: response, data: data, storagePolicy: .allowed)
                    cache.storeCachedResponse(cachedResponse, for: request)
                }
            })
            .map {
                $0.0
            }
            .retry(3)
            .eraseToAnyPublisher()
    }
}
