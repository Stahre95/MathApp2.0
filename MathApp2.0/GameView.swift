//
//  GameView.swift
//  MathApp
//
//  Created by Johan Stahre on 2021-02-25.
//

import SwiftUI
import Firebase

struct GameView: View {
    @State var currentUser = "currentUser"
    @State var mathOperator: String
    @State var gameDifficulty: String
    //declares first math number
    @State var firstMathNumber: Int = 0
    //declares second math number
    @State var secondMathNumber: Int = 0
    //variable that stores user answer
    @State var userAnswer: String = ""
    //declares seconds for timer
    @State var seconds: Int = 60
    //creates a timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //correct guesses
    @State var correctGuesses: Int = 0
    @State var mathOperatorSign: String = "+"
    @State var gameIsActive = true
    @State var showingGameAlert = false
    var alert: Alert {
        Alert(
            title: Text("GAME OVER!"),
            message: Text("Your Score was: \(correctGuesses)"),
            primaryButton: .default(Text("Play Again")){
                //Start game over
                activeGame()
                generateMathNumbers()
            },
            secondaryButton: .default(Text("Back to Profile")){
            //go back to profile page
            }
    )}
    
    
    
    var body: some View {
        ZStack {
            Color.init(red: 0.05, green: 0.29, blue: 0.56)
                .ignoresSafeArea()
            VStack {
                VStack{
                    //text that shows what calculation user chose
                    Text(mathOperator)
                        .font(.title)
                    //text that shows what difficulty user chose
                    Text(gameDifficulty)
                        .font(.subheadline)
                }.foregroundColor(.white)
                Spacer()
                //text that shows the timer
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 75, height: 100)
                    Text("\(seconds)")
                        .font(.title)
                        .onReceive(timer, perform: { _ in
                            if self.seconds > 0 {
                                self.seconds -= 1
                            } else if self.seconds == 0{
                                //Alert dialog that shows score
                                showingGameAlert = true
                            }
                        }).alert(isPresented: $showingGameAlert, content: {
                            alert
                        })
                        
                }
                
                //text that shows correct guesses
                Text("Score: \(correctGuesses)")
                    .font(.title3)
                    .foregroundColor(.white)
                //text that shows the math question
                Text("\(firstMathNumber) \(mathOperatorSign) \(secondMathNumber)")
                    .frame(width: 275, height: 100, alignment: .center)
                    .background(Color.white)
                    .font(.largeTitle)
                    .padding()
                //button to submit users guess
                Button(action: {
                    answers()
                    
                            
                }){
                    Text("Guess")
                        .frame(width: 100, height: 25, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        }
                //textfield where user puts in their answer
                TextField("Your answer...", text: $userAnswer)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .keyboardType(.numbersAndPunctuation)
                Spacer()
            }
            
        }
        .onAppear(){
            activeGame()
            generateMathNumbers()
            
        }
        .navigationBarBackButtonHidden(true)
    }
    func generateMathNumbers() {
        
        
        if mathOperator == "Addition"{
            mathOperatorSign = "+"
            
            if gameDifficulty == "Very Easy" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...10)
            }else if gameDifficulty == "Easy" {
                firstMathNumber = Int.random(in: 1...50)
                secondMathNumber = Int.random(in: 1...50)
            }else if gameDifficulty == "Hard" {
                firstMathNumber = Int.random(in: 1...100)
                secondMathNumber = Int.random(in: 1...100)
            }else if gameDifficulty == "Very Hard" {
                firstMathNumber = Int.random(in: 1...1000)
                secondMathNumber = Int.random(in: 1...1000)
            }
        }else if mathOperator == "Subtraction" {
            mathOperatorSign = "-"
            if gameDifficulty == "Very Easy" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...10)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...10)
                }
            }else if gameDifficulty == "Easy" {
                firstMathNumber = Int.random(in: 1...50)
                secondMathNumber = Int.random(in: 1...50)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...50)
                }
            }else if gameDifficulty == "Hard" {
                firstMathNumber = Int.random(in: 1...100)
                secondMathNumber = Int.random(in: 1...100)
            }else if gameDifficulty == "Very Hard" {
                firstMathNumber = Int.random(in: 1...1000)
                secondMathNumber = Int.random(in: 1...1000)
            }
        }else if mathOperator == "Multiply"{
            mathOperatorSign = "*"
            
            if gameDifficulty == "Very Easy" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...10)
                
            }else if gameDifficulty == "Easy" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...50)
                
            }else if gameDifficulty == "Hard" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...100)
            }else if gameDifficulty == "Very Hard" {
                firstMathNumber = Int.random(in: 1...100)
                secondMathNumber = Int.random(in: 1...100)
            }
        }else if mathOperator == "Division" {
            mathOperatorSign = "/"
            
            if gameDifficulty == "Very Easy" {
                firstMathNumber = Int.random(in: 1...10)
                secondMathNumber = Int.random(in: 1...10)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...10)
                }
            }else if gameDifficulty == "Easy" {
                firstMathNumber = Int.random(in: 1...50)
                secondMathNumber = Int.random(in: 1...50)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...50)
                }
            }else if gameDifficulty == "Hard" {
                firstMathNumber = Int.random(in: 1...100)
                secondMathNumber = Int.random(in: 1...100)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...100)
                }
            }else if gameDifficulty == "Very Hard" {
                firstMathNumber = Int.random(in: 1...1000)
                secondMathNumber = Int.random(in: 1...1000)
                
                while firstMathNumber < secondMathNumber {
                    firstMathNumber = Int.random(in: 1...1000)
                }
            }
        }
        
    }
    
    func activeGame(){
        correctGuesses = 0
        seconds = 60
        gameIsActive = true
        
        if seconds == 0 {
            gameIsActive = false
           
        }
    }
    
    func answers(){
        
        if mathOperator == "Addition"{
            if userAnswer == String(firstMathNumber + secondMathNumber) {
                correctGuesses += 1
                
                userAnswer = ""
                generateMathNumbers()
            } else{
                userAnswer = ""
                generateMathNumbers()
            }
        }else if mathOperator == "Subtraction"{
            if userAnswer == String(firstMathNumber - secondMathNumber) {
                correctGuesses += 1
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
            
        }else if mathOperator == "Multiply" {
            if userAnswer == String(firstMathNumber * secondMathNumber) {
                correctGuesses += 1
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
        }else if mathOperator == "Division" {
            if userAnswer == String(firstMathNumber / secondMathNumber) {
                correctGuesses += 1
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
        }
        
        
    }
    
    
}

/*struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}*/
