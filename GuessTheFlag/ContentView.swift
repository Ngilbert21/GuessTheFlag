//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nicholas Gilbert on 5/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var alertMessage = Text("")
    @State private var questionNumber = 0
    @State private var gameOverText = "The Game is Over"
    @State private var selectedFlag = -1
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                        .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .animation(.default, value: selectedFlag)
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.5 )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(questionNumber < 8 ? scoreTitle : gameOverText, isPresented: $showingScore) {
             questionNumber < 7 ? Button("Continue", action: askQuestion) : Button("Restart Game", action: restartGame)
        } message: {
            alertMessage
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            alertMessage = Text("Your score is \(userScore)")
        } else {
            scoreTitle = "Wrong"
            alertMessage = Text("That's the flag of \(countries[number])")
        }
        
        if questionNumber == 7 {
            alertMessage = Text("The game is over, your final score is \(userScore)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
        questionNumber += 1
    }
    
    func restartGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber = 0
        userScore = 0
    }
}

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct customModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(customModifier())
    }
}
