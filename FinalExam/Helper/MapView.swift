
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    typealias Location = Assignment.Location

    @Binding var selectedLocation: Location
    var isEnableUserSelection: Bool = true

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self) { lat, long in
            selectedLocation = .init(lat: lat, long: long)
        }
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(
            center: .init(latitude: selectedLocation.lat, longitude: selectedLocation.long),
            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        if isEnableUserSelection {
            let tapGesture = UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(MapViewCoordinator.addAnnotation(gesture:))
            )
            mapView.addGestureRecognizer(tapGesture)
        }
        mapView.delegate = context.coordinator
        
        let currentAnotaion = MKPointAnnotation()
        currentAnotaion.coordinate = .init(latitude: selectedLocation.lat, longitude: selectedLocation.long)
        mapView.addAnnotation(currentAnotaion)
        
        return mapView
    }

}

final class MapViewCoordinator: NSObject, MKMapViewDelegate {

    private var currentAnotaion = MKPointAnnotation()
    private let mapView: MapView
    private let selectedLocation: (_ lat: Double, _ long: Double) -> Void

    init(
        _ mapView: MapView,
        selectedLocation: @escaping (_ lat: Double, _ long: Double) -> Void
    ) {
        self.mapView = mapView
        self.selectedLocation = selectedLocation
    }

    @objc
    func addAnnotation(gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                mapView.removeAnnotations(mapView.annotations)
                currentAnotaion = MKPointAnnotation()
                currentAnotaion.coordinate = coordinate
                mapView.addAnnotation(currentAnotaion)
                selectedLocation(coordinate.latitude, coordinate.longitude)
            }
        }
    }
}
