//
//  ContentView.swift
//  PhotoMania
//
//  Created by Marcos Mendes on 21/02/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var image: Image?
    
    func fetchNewImage() {
        let apiUrl = "https://random.imagecdn.app/600/600"
        guard let imageHost = URL(string: apiUrl) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageHost) { data, _, _ in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                self.image = Image(uiImage: uiImage)
            }
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if let image = viewModel.image {
                    ZStack {
                        image
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.pink)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 600)
                    .background(Color.green)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.pink)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.fetchNewImage()
                }, label: {
                    Text("New Image!")
                        .bold()
                        .frame(width: 250, height: 55)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                })

            }
        }
        .navigationTitle("Photo Mania")

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
