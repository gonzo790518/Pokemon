//
//  AsyncImageView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/30.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(url: String, placeholder: Image = Image(systemName: "pokeball")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: String

    init(url: String) {
        self.url = url
    }

    func load() {
        guard let imageUrl = URL(string: url) else {
            return
        }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil, let loadedImage = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }

        task.resume()
    }
}
