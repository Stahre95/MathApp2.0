//
//  Homescreen.swift
//  MathApp
//
//  Created by Johan Stahre on 2021-02-22.
//

import SwiftUI
import Firebase



struct Homescreen: View {
    var db = Firestore.firestore()
    @State private var users : userScore? = nil
    
    @State var color = Color.init(red: 0.05, green: 0.29, blue: 0.56)
    @State var changeGameView = false
    @State var showActionSheetMath = false
    @State var showActionSheetDifficulty = false
    @State var mathReply = "Choose Math"
    @State var difficultyReply = "Choose Difficulty"
    @State var showAlert = false
    @State var toggleSheet = false
    @State var displayName = ""
    @State var displayNameInput = ""
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                color.ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .center){
                        Text(displayName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            try! Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                        }){
                            Text("Log Out")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading, 125)
                            
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width - 0)
                    .padding(.bottom)
                    Spacer()
                    
                }
                ZStack{
                    VStack{
                        Text("CHOOSE AN MATH OPERATOR AND GAME DIFFICULTY AND START THE GAME")
                            .foregroundColor(color)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 200)
                        Spacer()
                        HStack{
                            
                            Button(action: {
                                self.showActionSheetMath.toggle()
                            }){
                                Text(mathReply)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: 175)
                                    .background(color)
                                    .cornerRadius(20)
                                
                                
                            }.padding(.horizontal)
                            .actionSheet(isPresented: $showActionSheetDifficulty) {
                                ActionSheet(title: Text("Difficulty"), message: Text("Choose what difficulty you'd like to play"), buttons: [
                                    .default(Text("Very Easy")) { difficultyReply = "Very Easy"},
                                    .default(Text("Easy")) { difficultyReply = "Easy"},
                                    .default(Text("Hard")) { difficultyReply = "Hard"},
                                    .default(Text("Very Hard")) { difficultyReply = "Very Hard"}
                                ])
                            }
                            Button(action: {
                                self.showActionSheetDifficulty.toggle()
                            }){
                                Text(difficultyReply)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: 175)
                                    .background(color)
                                    .cornerRadius(20)
                                
                            }.padding(.horizontal)
                            .actionSheet(isPresented: $showActionSheetMath) {
                                ActionSheet(title: Text("Math"), message: Text("Choose which math operation you'd like to play"), buttons: [
                                    .default(Text("Addition")) { mathReply = "Addition"},
                                    .default(Text("Subtraction")) { mathReply = "Subtraction"},
                                    .default(Text("Multiply")) { mathReply = "Multiply"},
                                    .default(Text("Division")) { mathReply = "Division"}
                                ])
                            }
                            
                            
                            
                        }
                        NavigationLink(destination: GameView(mathOperator: mathReply, gameDifficulty: difficultyReply), isActive: $changeGameView) {
                            Button(action: {
                                
                                if mathReply != "Choose Math" && difficultyReply != "Choose Difficulty"{
                                    self.changeGameView.toggle()
                                }else {
                                    self.showAlert.toggle()
                                }
                                
                                
                            }){
                                Text("Start game")
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 0)
                                    .padding(.bottom, 10)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 0, height: 85)
                            .background(color)
                            .padding(.bottom, 10)
                        }.alert(isPresented: $showAlert) {() -> Alert in
                            Alert(title: Text("Error"), message: Text("Please choose an math operator and a difficulty and try again"))
                        }
                        
                        
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 0, height: UIScreen.main.bounds.height - 150)
                    .background(Color(.white))
                    .padding(.bottom, -75)
                    
                }
            }.onAppear(){
                loadDisplayName()
            }.sheet(isPresented: $toggleSheet){
                Text("Choose a display Name")
                TextField("Display name", text: self.$displayNameInput)
                
                Button(action: {
                    if displayNameInput != ""{
                        self.toggleSheet = false
                        saveDisplayName()
                    }
                }){
                    Text("Save")
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
    func saveDisplayName() {
        guard let placeholder = Auth.auth().currentUser else {
            return
        }
        let user = userScore(displayName: displayNameInput)
        
        do {
            _ = try db.collection("users").document(placeholder.uid).setData(from: user)
        } catch {
            print("Print error saving to DB")
        }
    }
    //    func getUID() -> String {
    //
    //        if let user = user {
    //          return user.uid
    //        }
    //        return "Can't fetch user data."
    //    }
    
    
    func loadDisplayName() {
        guard let placeholder = Auth.auth().currentUser else {
            return
        }
        
        db.collection("users").document(placeholder.uid).addSnapshotListener { (document, error) in
            if let error = error {
                print("No documents")
                
                return
            }
            
            
            //self.users = documents.map { queryDocumentSnapshot -> userScore in
            let data = document?.data()
            let name = data?["displayName"] as? String ?? ""
                
                displayName = name
                print("displayName: \(displayName)")
                if displayName == "" {
                    toggleSheet = true
                }
            self.users = userScore(displayName: displayName)
        
            //}
        }
        
    }
}

/*func getUID() -> String {
 let user = Auth.auth().currentUser
 if let user = user {
 return user.uid
 }
 return "Can't fetch user data."
 }*/

//struct Homescreen_Previews: PreviewProvider {
//    static var previews: some View {
//        Homescreen()
//    }
//
//}
