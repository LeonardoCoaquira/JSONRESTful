//
//  viewControllerPerfil.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 28/11/23.
//

import UIKit

class viewControllerPerfil: UIViewController {

    var user: Users?
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let usuario = user {
            // Configura los campos de texto con los datos del usuario
            txtNombre.text = usuario.nombre
            txtClave.text = usuario.clave
            txtEmail.text = usuario.email
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActualizar(_ sender: Any) {
        let nombre = txtNombre.text!
        let email = txtEmail.text!
        let clave = txtClave.text!
        let datos = ["nombre": nombre, "clave": clave, "email": email]
        let ruta = "http://localhost:3000/usuarios/\(user!.id)"
        print(datos)
        metodoPUT(ruta: ruta, datos: datos)

        // Después de guardar los cambios, puedes realizar alguna acción como volver atrás
        mostrarAlertaConCierreSesion(titulo: "Cambios Guardados", mensaje: "Vuelve a iniciar sesión con los nuevos datos.")
    }
    
    func metodoPUT(ruta: String, datos: [String: Any]) {
        let url: URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"

        // This is your input parameter dictionary
        let params = datos

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            // Handle any exception here
            print("Error in JSON serialization")
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict)
                } catch {
                    // Handle any exception here
                    print("Error in JSON deserialization")
                }
            }
        }

        task.resume()
    }

    func mostrarAlertaConCierreSesion(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Cerrar sesión y volver al ViewController de inicio de sesión
            self?.dismiss(animated: true, completion: nil)
        }
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }

}
