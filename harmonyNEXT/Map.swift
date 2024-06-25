import SwiftUI
import MapKit
import Network

struct MapView: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }


    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 22.88345, longitude: 113.88059),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            

        )
    }
}


#Preview {
    MapView()
}
