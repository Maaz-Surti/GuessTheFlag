//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maaz on 10/03/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameEnded = false
    @State private var numberOfTries = 0
    @State private var maxAttempts = 3
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            //flag was tapped
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                        } .padding(.vertical, 5)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    
                    Button("Reset"){
                        score = 0
                        numberOfTries = 0
                        askQuestion()
                        
                    } .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(.red)
                        .clipShape(Capsule())
                        .padding(.vertical, 20)
                        .font(.title3)
                    
                } .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                HStack(spacing: 45){
                    Text("Score : \(score)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .alert("Game Over", isPresented: $gameEnded) {
                            Button("Restart", action: restart)
                        } message: {
                            Text("Your final score is \(score)")
                        }
                    
                    Text("Number of tries left: \(maxAttempts-numberOfTries)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                
                
                
                Spacer()
                
            }
            .padding()
            
        } .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        
    }
    func flagTapped(_ number: Int) {
        
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong. Thats the flag of \(countries[number])"
            score -= 1
        }
        
        numberOfTries += 1
        
        if numberOfTries == maxAttempts {
            gameEnded = true
            return
        }
        
        showingScore = true
        
    }
    
    func askQuestion(){
        if maxAttempts != numberOfTries {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func restart(){
        
        numberOfTries = 0
        score = 0
        countries.shuffle()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
