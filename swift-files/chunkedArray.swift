extension Array {
    func chunked(into size:Int) -> [[Element]] {
        
        var chunkedArray = [[Element]]()
        
        for index in 0...self.count {
            if index % size == 0 && index != 0 {
                chunkedArray.append(Array(self[(index - size)..<index]))
            } else if(index == self.count) {
                chunkedArray.append(Array(self[index - 1..<index]))
            }
        }
        
        return chunkedArray
    }
}

var body: some View {
        
        let chunkedDishes = dishes.chunked(into: 2)
        
        return NavigationView {
         List {
            
            ForEach(0..<chunkedDishes.count) { index in
                HStack {
                ForEach(chunkedDishes[index]) { dish in
                    
                        Image(dish.imageURL)
                            .resizable()
                            .scaledToFit()
                }
            }
                
            }
            
        }.edgesIgnoringSafeArea([.leading, .trailing])
        .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
        
        }.navigationBarTitle(Text("Dishes"))