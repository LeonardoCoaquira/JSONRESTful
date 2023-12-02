//
//  viewControllerBuscar.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 28/11/23.
//

import UIKit

class viewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var peliculas = [Peliculas]()
    var user:Users?
    
    @IBOutlet weak var txtBuscar: UITextField!
    
    @IBOutlet weak var tablaPeliculas: UITableView!
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty {
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta) {
                self.tablaPeliculas.reloadData()
            }
        } else {
            cargarPeliculas(ruta: crearURL) {
                if self.peliculas.count <= 0 {
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encron coincidencias para: \(nombre)", accion: "cancel")
                } else {
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
        tablaPeliculas.allowsSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }
    
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error == nil {
                do {
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.sync {
                        completed()
                    }
                } catch {
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero) Duracion:\(peliculas[indexPath.row].duracion)"
        return cell
    }
    
    func mostrarAlerta(titulo: String, mensaje:String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePerfil" {
            let siguienteVC = segue.destination as! viewControllerPerfil
            siguienteVC.user = SessionManager.shared.usuario
        } else if segue.identifier == "seguePerfil" {
            let siguienteVC = segue.destination as! viewControllerPerfil
            siguienteVC.user = sender as? Users
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmMovieDeletion(indexPath: indexPath)
        }
    }

    func confirmMovieDeletion(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.deleteMovie(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func deleteMovie(at indexPath: IndexPath) {
        let movieToDelete = peliculas[indexPath.row]
        peliculas.remove(at: indexPath.row)
        tablaPeliculas.deleteRows(at: [indexPath], with: .fade)

        // Aquí se debe realizar la solicitud HTTP para eliminar la película del servidor
        if let url = URL(string: "http://localhost:3000/peliculas/\(movieToDelete.id)") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error al eliminar la película: \(error)")
                    // Manejar el error, por ejemplo, mostrar una alerta
                } else {
                    // La película se eliminó correctamente del servidor
                }
            }.resume()
        }
    }
}
