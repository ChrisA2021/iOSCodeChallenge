//
//  PreRequestView.swift
//  BlinqCodeChallenge
//
//  Created by Chrishane Amarasekara on 2/1/2023.
//

import SwiftUI

struct PreRequestView: View {
    
    @State var showSheet: Bool = false
    @State private var fullName = ""
    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var formValid: Bool = false
    
    @State private var fullNameError = "Please enter your full name"
    @State private var emailError = "Please enter your email"
    @State private var confirmEmailError = "Please confirm your email"
    @State private var requestMessage = ""
    
    
    var body: some View {
        ZStack{
            VStack{
                Text("Broccoli & Co.")
                    .font(.title).padding(20)
                
                Text("Please click below to get an invite")
                Button(action: {showSheet.toggle()}, label: {Text("Request an Invite")})
            }
            .sheet(isPresented: $showSheet, content: {
                Form {
                    Section(header: Text("User Details"), footer: Text("* denotes a required field")) {
                        TextField("Full Name *", text: $fullName)
                        Text(fullNameError).foregroundColor(Color.red)
                        TextField("Email *", text: $email)
                        Text(emailError)
                            .foregroundColor(Color.red)
                        TextField("Confirm Email *", text: $confirmEmail)
                        Text(confirmEmailError)
                            .foregroundColor(Color.red)
                        
                    }
                    Button("Send") {
                        if (fullName.count < 3) {
                            fullNameError = "Please enter at least 3 characters"
                        }
                        else if (fullName.count >= 3) {
                            fullNameError = ""
                        }
                        
                        if (email.isEmpty || !isEmailValid(emailStr: email)) {
                            emailError = "Please enter a valid email"
                        }
                        else if (!email.isEmpty) {
                            emailError = ""
                        }
                        
                        if (email != confirmEmail) {
                            confirmEmailError = "The emails do not match, please try again"
                        }
                        else if (email == confirmEmail) {
                            confirmEmailError = ""
                        }
                        
                        
                        if (fullName.count >= 3 && !email.isEmpty && email == confirmEmail) {
                            requestMessage = "Your request is being sent"
                            requestMessage = saveToServer(userName: fullName, userEmail: email)
                        }
                    }
                    Text(requestMessage)
                        .foregroundColor(Color.purple)
                    
                    
                    
                }
                
                
                
            })
            
        }
    }
    
    
    func isEmailValid(emailStr: String) -> Bool {
        let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegx)
        
        return emailTest.evaluate(with: emailStr)
    }
    
}


struct PreRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PreRequestView()
    }
}

let DomainURL = "https://us-central1-blinkapp-684c1.cloudfunctions.net/fakeAuth"

class API : Codable{
    
    static func fetch(withID id : Int, completionHandler: @escaping (API)->Void) {
        let urlString = DomainURL + "name/id"
        
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ??
                      "no data")
                
            })
            task.resume()
        }
    }
    
    
}
