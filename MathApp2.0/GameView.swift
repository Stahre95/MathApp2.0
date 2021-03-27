//
//  GameView.swift
//  MathApp
//
//  Created by Johan Stahre on 2021-02-25.
//

import SwiftUI
import Firebase

struct GameView: View {
    var db = Firestore.firestore()
    @State private var users : userScore? = nil
    @State var highScores = [HighScore]()
    
    @State var displayName = ""
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
    @State var displayLeaderBoard = false
    @State var veAdditionHighScore = 0
    @State var eAdditionHighScore = 0
    @State var hAdditionHighScore = 0
    @State var vhAdditionHighScore = 0
    @State var veSubtractionHighScore = 0
    @State var eSubtractionHighScore = 0
    @State var hSubtractionHighScore = 0
    @State var vhSubtractionHighScore = 0
    @State var veMultiplyHighScore = 0
    @State var eMultiplyHighScore = 0
    @State var hMultiplyHighScore = 0
    @State var vhMultiplyHighScore = 0
    @State var veDivisionHighScore = 0
    @State var eDivisionHighScore = 0
    @State var hDivisionHighScore = 0
    @State var vhDivisionHighScore = 0
    
    
    
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
                            }else if seconds == 0 {
                                displayLeaderBoard = true
                                getHighScores()
                                loadLeaderBoard()
                            }
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
            
            
            
        }.navigationBarBackButtonHidden(true)
        .sheet(isPresented: $displayLeaderBoard){
            VStack{
                Text(mathOperator).font(.title)
                Text(gameDifficulty).font(.subheadline)
                VStack{
                    Text("GAME OVER").foregroundColor(.red)
                    Text("Your score was: \(correctGuesses)")
                }.padding(.top)
                Spacer()
                Text("HIGHSCORE:")
                //leader board
                List{
                    ForEach(highScores) {highscore in
                        HStack {
                            Text(highscore.name)
                            Spacer()
                            Text(String(highscore.score))
                        }.padding()
                    }
                }
                HStack{
                    Button(action: {
                        //Start game over
                        activeGame()
                        generateMathNumbers()
                    }){
                        Text("Play again")
                    }
                    Button(action: {
                        goBack()
                        
                    }){
                        Text("Back to profile")
                    }
                }
            }.padding(.top)
        }
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
        
        displayLeaderBoard = false
    
    }
    
    func answers(){
        
        if mathOperator == "Addition"{
            if userAnswer == String(firstMathNumber + secondMathNumber) {
                correctGuesses += 1
                seconds += 2
                
                userAnswer = ""
                generateMathNumbers()
            } else{
                userAnswer = ""
                generateMathNumbers()
            }
        }else if mathOperator == "Subtraction"{
            if userAnswer == String(firstMathNumber - secondMathNumber) {
                correctGuesses += 1
                seconds += 2
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
            
        }else if mathOperator == "Multiply" {
            if userAnswer == String(firstMathNumber * secondMathNumber) {
                correctGuesses += 1
                seconds += 2
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
        }else if mathOperator == "Division" {
            if userAnswer == String(firstMathNumber / secondMathNumber) {
                correctGuesses += 1
                seconds += 2
                
                userAnswer = ""
                generateMathNumbers()
            }else {
                userAnswer = ""
                generateMathNumbers()
            }
        }
        
        
    }
    
    func updateHighScore() {
        //getHighScores()
//        print("function running")
        guard let userUID = Auth.auth().currentUser else {
            return
        }
        //Very Easy
        if gameDifficulty == "Very Easy" {
//            print("gameDifficulty: \(gameDifficulty)")
            //addition
            if mathOperator == "Addition" {
//                print("mathOperator: \(mathOperator)")
                if correctGuesses > veAdditionHighScore {
                    print("\(correctGuesses) are greater than \(veAdditionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["veAdditionHighScore" : correctGuesses])
                }
            }
            //Subtraction
            if mathOperator == "Subtraction" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > veSubtractionHighScore {
                    print("\(correctGuesses) are greater than \(veSubtractionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["veSubtractionHighScore" : correctGuesses])
                }
            }
            //Multiply
            if mathOperator == "Multiply" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > veMultiplyHighScore {
                    print("\(correctGuesses) are greater than \(veMultiplyHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["veMultiplyHighScore" : correctGuesses])
                }
            }
            //Division
            if mathOperator == "Division" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > veDivisionHighScore {
                    print("\(correctGuesses) are greater than \(veDivisionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["veDivisionHighScore" : correctGuesses])
                }
            }
        }
        //Easy
        if gameDifficulty == "Easy" {
            print("gameDifficulty: \(gameDifficulty)")
            //addition
            if mathOperator == "Addition" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > eAdditionHighScore {
                    print("\(correctGuesses) are greater than \(eAdditionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["eAdditionHighScore" : correctGuesses])
                }
            }
            //Subtraction
            if mathOperator == "Subtraction" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > eSubtractionHighScore {
                    print("\(correctGuesses) are greater than \(eSubtractionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["eSubtractionHighScore" : correctGuesses])
                }
            }
            //Multiply
            if mathOperator == "Multiply" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > eMultiplyHighScore {
                    print("\(correctGuesses) are greater than \(eMultiplyHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["eMultiplyHighScore" : correctGuesses])
                }
            }
            //Division
            if mathOperator == "Division" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > eDivisionHighScore {
                    print("\(correctGuesses) are greater than \(eDivisionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["eDivisionHighScore" : correctGuesses])
                }
            }
        }
        //Hard
        if gameDifficulty == "Hard" {
            print("gameDifficulty: \(gameDifficulty)")
            //addition
            if mathOperator == "Addition" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > hAdditionHighScore {
                    print("\(correctGuesses) are greater than \(hAdditionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["hAdditionHighScore" : correctGuesses])
                }
            }
            //Subtraction
            if mathOperator == "Subtraction" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > hSubtractionHighScore {
                    print("\(correctGuesses) are greater than \(hSubtractionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["hSubtractionHighScore" : correctGuesses])
                }
            }
            //Multiply
            if mathOperator == "Multiply" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > hMultiplyHighScore {
                    print("\(correctGuesses) are greater than \(hMultiplyHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["hMultiplyHighScore" : correctGuesses])
                }
            }
            //Division
            if mathOperator == "Division" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > hDivisionHighScore {
                    print("\(correctGuesses) are greater than \(hDivisionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["hDivisionHighScore" : correctGuesses])
                }
            }
        }
        //Very Hard
        if gameDifficulty == "Very Hard" {
            print("gameDifficulty: \(gameDifficulty)")
            //addition
            if mathOperator == "Addition" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > vhAdditionHighScore {
                    print("\(correctGuesses) are greater than \(vhAdditionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["vhAdditionHighScore" : correctGuesses])
                }
            }
            //Subtraction
            if mathOperator == "Subtraction" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > vhSubtractionHighScore {
                    print("\(correctGuesses) are greater than \(vhSubtractionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["vhSubtractionHighScore" : correctGuesses])
                }
            }
            //Multiply
            if mathOperator == "Multiply" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > vhMultiplyHighScore {
                    print("\(correctGuesses) are greater than \(vhMultiplyHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["vhMultiplyHighScore" : correctGuesses])
                }
            }
            //Division
            if mathOperator == "Division" {
                print("mathOperator: \(mathOperator)")
                if correctGuesses > vhDivisionHighScore {
                    print("\(correctGuesses) are greater than \(vhDivisionHighScore)")
                    db.collection("users").document(userUID.uid).updateData(["vhDivisionHighScore" : correctGuesses])
                }
            }
        }
    }
    
    func getHighScores() {
       
        guard let userUID = Auth.auth().currentUser else {
            return
        }
        
        db.collection("users").document(userUID.uid).getDocument() { (document, error) in
            if let error = error {
                print("No documents")
                
                return
            }
            
            let data = document?.data()
            let name = data?["displayName"] as? String ?? ""
            //addition
            let veryeasyadditionHighScore = data?["veAdditionHighScore"] as? Int ?? 0
            let easyadditionHighScore = data?["eAdditionHighScore"] as? Int ?? 0
            let hardadditionHighScore = data?["hAdditionHighScore"] as? Int ?? 0
            let veryhardadditionHighScore = data?["vhAdditionHighScore"] as? Int ?? 0
            //subtraction
            let veryeasysubtractionHighScore = data?["veSubtractionHighScore"] as? Int ?? 0
            let easysubtractionHighScore = data?["eSubtractionHighScore"] as? Int ?? 0
            let hardsubtractionHighScore = data?["hSubtractionHighScore"] as? Int ?? 0
            let veryhardsubtractionHighScore = data?["vhSubtractionHighScore"] as? Int ?? 0
            //multiply
            let veryeasymultiplyHighScore = data?["veMultiplyHighScore"] as? Int ?? 0
            let easymultiplyHighScore = data?["eMultiplyHighScore"] as? Int ?? 0
            let hardmultiplyHighScore = data?["hMultiplyHighScore"] as? Int ?? 0
            let veryhardmultiplyHighScore = data?["vhMultiplyHighScore"] as? Int ?? 0
            //division
            let veryeasydivisionHighScore = data?["veDivisionHighScore"] as? Int ?? 0
            let easydivisionHighScore = data?["eDivisionHighScore"] as? Int ?? 0
            let harddivisionHighScore = data?["hDivisionHighScore"] as? Int ?? 0
            let veryharddivisionHighScore = data?["vhDivisionHighScore"] as? Int ?? 0
            
            
            veAdditionHighScore = veryeasyadditionHighScore
            eAdditionHighScore = easyadditionHighScore
            hAdditionHighScore = hardadditionHighScore
            vhAdditionHighScore = veryhardadditionHighScore
            veSubtractionHighScore = veryeasysubtractionHighScore
            eSubtractionHighScore = easysubtractionHighScore
            hSubtractionHighScore = hardsubtractionHighScore
            veSubtractionHighScore = veryhardsubtractionHighScore
            veMultiplyHighScore = veryeasymultiplyHighScore
            eMultiplyHighScore = easymultiplyHighScore
            hMultiplyHighScore = hardmultiplyHighScore
            vhMultiplyHighScore = veryhardmultiplyHighScore
            veDivisionHighScore = veryeasydivisionHighScore
            eDivisionHighScore = easydivisionHighScore
            hDivisionHighScore = harddivisionHighScore
            vhDivisionHighScore = veryharddivisionHighScore
            
                
            self.users = userScore(displayName: name, veAdditionHighScore: veAdditionHighScore, eAdditionHighScore: eAdditionHighScore, hAdditionHighScore: hAdditionHighScore, vhAdditionHighScore: vhAdditionHighScore, veSubtractionHighScore: veSubtractionHighScore, eSubtractionHighScore: eSubtractionHighScore, hSubtractionHighScore: hSubtractionHighScore, vhSubtractionHighScore: vhSubtractionHighScore, veMultiplyHighScore: veMultiplyHighScore, eMultiplyHighScore: eMultiplyHighScore, hMultiplyHighScore: hMultiplyHighScore, vhMultiplyHighScore: vhMultiplyHighScore, veDivisionHighScore: veDivisionHighScore, eDivisionHighScore: eDivisionHighScore, hDivisionHighScore: hDivisionHighScore, vhDivisionHighScore: vhDivisionHighScore)
        
            //}
        }
        updateHighScore()
    }
    
    func loadLeaderBoard() {
        highScores.removeAll()
        if gameDifficulty == "Very Easy"{
            if mathOperator == "Addition"{
                db.collection("users").order(by: "veAdditionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["veAdditionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Subtraction"{
                db.collection("users").order(by: "veSubtractionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["veSubtractionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Multiply"{
                db.collection("users").order(by: "veMultiplyHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["veMultiplyHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Division"{
                db.collection("users").order(by: "veDivisionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["veDivisionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
        }
        if gameDifficulty == "Easy"{
            if mathOperator == "Addition"{
                db.collection("users").order(by: "eAdditionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["eAdditionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Subtraction"{
                db.collection("users").order(by: "eSubtractionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["eSubtractionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Multiply"{
                db.collection("users").order(by: "eMultiplyHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["eMultiplyHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Division"{
                db.collection("users").order(by: "eDivisionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["eDivisionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
        }
        if gameDifficulty == "Hard"{
            if mathOperator == "Addition"{
                db.collection("users").order(by: "hAdditionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["hAdditionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Subtraction"{
                db.collection("users").order(by: "hSubtractionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["hSubtractionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Multiply"{
                db.collection("users").order(by: "hMultiplyHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["hMultiplyHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Division"{
                db.collection("users").order(by: "hDivisionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["hDivisionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
        }
        if gameDifficulty == "Very Hard"{
            if mathOperator == "Addition"{
                db.collection("users").order(by: "vhAdditionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["vhAdditionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Subtraction"{
                db.collection("users").order(by: "vhSubtractionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["vhSubtractionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Multiply"{
                db.collection("users").order(by: "vhMultiplyHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["vhMultiplyHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
            if mathOperator == "Division"{
                db.collection("users").order(by: "vhDivisionHighScore", descending: true).limit(to: 10).getDocuments() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in document!.documents {
                            let highScore = HighScore(name: document["displayName"] as! String, score: document["vhDivisionHighScore"] as! Int)
                            highScores.append(highScore)
                            print(highScore.name, highScore.score)
                        }
                    }
                }
            }
        }
      
    }
    
    func goBack() {
    
    }
    
    struct HighScore : Identifiable{
        var id = UUID()
        
        var name : String
        var score : Int
    }
    
    
}

/*struct GameView_Previews: PreviewProvider {
 static var previews: some View {
 GameView()
 }
 }*/
