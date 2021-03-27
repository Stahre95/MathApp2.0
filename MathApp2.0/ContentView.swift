//
//  ContentView.swift
//  MathApp
//
//  Created by Johan Stahre on 2021-02-04.
//

import SwiftUI
import Firebase



struct ContentView: View {
    var body: some View{
        Home()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            

            VStack{
                
                if self.status{
                    
                    Homescreen()
                    
                } else {
                    ZStack{
                            
                            NavigationLink(destination: RegisterView(show: self.$show), isActive: self.$show) {
                                
                                Text("")
                            }
                            .hidden()
                            
                            Login(show: self.$show)
                }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}


//login View design
struct Login : View{
    @State var email = ""
    @State var password = ""
    @State var visible =  false
    @State var color = Color.init(red: 0.05, green: 0.29, blue: 0.56)
    //@State var color = Color.black.opacity(0.7)
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        
            ZStack{

                ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack {
                        Image("Math_logo")
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(red: 0.05, green: 0.29, blue: 0.56))
                            .padding(.top, 35)
                        
                        //sets Textfield hint to "email" and saved user input in variable email
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    TextField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }else {
                                    SecureField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                                
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                resetPassword()
                            }){
                                Text("Forgot password")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(red: 0.05, green: 0.29, blue: 0.56))
                            }
                        }.padding(.top, 20)
                        
                        Button(action: {
                            self.verify()
                        }){
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                
                        }
                        .background(Color.init(red: 0.05, green: 0.29, blue: 0.56))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                }
                    
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Register")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(red: 0.05, green: 0.29, blue: 0.56))
                }
                .padding()
            }
                
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    //function to sign in user
    func verify(){
        
        //checks if email and password field is filled out correctly
        if self.email != "" && self.password != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("Success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
            
        }else {
            //display error alert if fields are not filled out correctly
            self.error = "Please fill out all the fields properly"
            self.alert.toggle()
        }
                
    }
    
    //function to reset user password
    func resetPassword(){
        
        //checks if email field is filled out
        if self.email != ""{
        
            Auth.auth().sendPasswordReset(withEmail: self.email) {(err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        } else{
            //displays error alert if the email doesnt exists in DB
            self.error = "that email doesn't exist in our database"
            self.alert.toggle()
        }
    }
}

//register View design
struct RegisterView : View {
    @State var email = ""
    @State var password = ""
    @State var repassword = ""
    @State var visible =  false
    @State var revisible = false
    @State var color = Color.init(red: 0.05, green: 0.29, blue: 0.56)
    @Binding var show : Bool
    @State var error = ""
    @State var alert = false
    
    
    
    var body: some View {
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack {
                      
                        Image("Math_logo")
                        
                        Text("Register your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    TextField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }else {
                                    SecureField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                                
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    TextField("Re-enter", text: self.$repassword)
                                        .autocapitalization(.none)
                                }else {
                                    SecureField("Re-enter", text: self.$repassword)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                                
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            registerUser()
                        }){
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                               
                        }
                        .background(color)
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, -100)
                }
                

                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(color)
                    
                }
                .padding()
            }
                
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
     
    //function to register user
    func registerUser(){
        
            if self.email != "" {
                
                if self.password == self.repassword{
                    
                    Auth.auth().createUser(withEmail: self.email, password: self.password) {(ress, err) in
                        if err != nil{
                            
                            self.error = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
                        print("success")
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }
                } else {
                    
                    self.error = "password doesn't match"
                    self.alert.toggle()
                }
            }else {
                self.error = "Please fill all the fields correctly"
                self.alert.toggle()
            }
        
    }
}

//error alert design
struct ErrorView: View {
    @State var color = Color.init(red: 0.05, green: 0.29, blue: 0.56)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View {
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(color)
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
