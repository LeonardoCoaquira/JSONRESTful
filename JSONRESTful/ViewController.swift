//
//  ViewController.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 28/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    
    var userCurrent:Users?
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func validarUsuario(ruta:String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error == nil {
                do {
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("Error en JSON")
                }
            }
        }.resume()
    }

    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: crearURL) { [self] in
            
            if self.users.count <= 0 {
                print("Nombre de usuario y/o contraseña es incorrecto")
            } else {
                SessionManager.shared.usuario = self.users.first
                print("Logeo Exitoso")
                self.userCurrent = self.users.first
                self.performSegue(withIdentifier: "segueLogeo", sender: nil)
                for data in self.users {
                    print("id\(data.id),nombre:\(data.nombre),nombre:\(data.email)")
                }
            }
        }
    }
}
