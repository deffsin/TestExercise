//
//  AsyncImage.swift
//  Wallester
//
//  Created by Denis Sinitsa on 20.05.2024.
//

import Foundation
import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectImage()
            .resizable()
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
            
        case .failure:
            return failure
            
        case .success(let image):
            return Image(uiImage: image)
        }
    }
    
    init (url: URL, loading: Image = Image(systemName: "photo"),
        failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.loading = loading
        self.failure = failure
    }
}

private class ImageLoader: ObservableObject {
    enum LoadState {
        case loading
        case success(UIImage)
        case failure
    }
    
    @Published var state = LoadState.loading
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        load()
    }
    
    private func load() {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            self.state = .success(image)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data, let response = response, let image = UIImage(data: data) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)
                
                DispatchQueue.main.async {
                    self.state = .success(image)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.state = .failure
            }
        }
        .resume()
    }
}
