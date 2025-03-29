import SwiftUI
import FirebaseCore
import FirebaseFirestore

// Clase simple para probar la inicialización de Firebase
class FirebaseTest {
    init() {
        print("Firebase Test: Inicializando...")
        
        // Verificar que podemos acceder a Firestore
        let db = Firestore.firestore()
        print("Firebase Test: Firestore inicializado correctamente: \(db)")
        
        // Una prueba simple para verificar que podemos hacer consultas
        db.collection("test").document("test").getDocument { (document, error) in
            if let error = error {
                print("Firebase Test Error: \(error.localizedDescription)")
            } else {
                print("Firebase Test: Consulta exitosa, documento: \(String(describing: document))")
            }
        }
    }
} 