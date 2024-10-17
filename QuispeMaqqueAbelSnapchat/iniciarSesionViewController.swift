//
//  ViewController.swift
//  QuispeMaqqueAbelSnapchat
//
//  Created by Abel Quispe Maqque on 16/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GIDSignInButton(_ sender: Any) {
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }

           // Crear configuración para Google Sign-In.
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config

           // Iniciar el flujo de inicio de sesión.
           GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
               guard error == nil else {
                   print("Error en Google Sign-In: \(error!.localizedDescription)")
                   return
               }

               guard let user = result?.user,
                     let idToken = user.idToken?.tokenString else {
                   print("No se pudo obtener el usuario o el token de Google.")
                   return
               }

               let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)

               // Iniciar sesión con Firebase usando la credencial de Google.
               Auth.auth().signIn(with: credential) { authResult, error in
                   if let error = error {
                       print("Error al autenticar con Google en Firebase: \(error.localizedDescription)")
                   } else {
                       print("Inicio de sesión exitoso con Google")
                   }
                   
               }
           }
       }
   }

