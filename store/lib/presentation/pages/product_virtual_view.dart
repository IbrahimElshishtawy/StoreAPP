import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../models/dummy_product.dart';

class ProductVirtualView extends StatefulWidget {
  final DummyProduct product;

  const ProductVirtualView({super.key, required this.product});

  @override
  State<ProductVirtualView> createState() => _ProductVirtualViewState();
}

class _ProductVirtualViewState extends State<ProductVirtualView> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? localObjectNode;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name} AR View"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Point camera at a flat surface and tap 'Place' to see the product",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onAddButtonTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      localObjectNode == null ? "Place Product" : "Remove Product",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          showWorldOrigin: false,
          handleTaps: true,
        );
    this.arObjectManager!.onInitialize();

    // Check for compatibility errors
    arSessionManager.onError = (String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("AR Error: $message")),
      );
    };
  }

  Future<void> onAddButtonTap() async {
    if (localObjectNode != null) {
      arObjectManager!.removeNode(localObjectNode!);
      setState(() {
        localObjectNode = null;
      });
    } else {
      if (widget.product.arModelUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("AR model not available for this product")),
        );
        return;
      }
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: widget.product.arModelUrl!,
        scale: vector.Vector3(0.2, 0.2, 0.2),
        position: vector.Vector3(0, 0, -0.5),
        rotation: vector.Vector4(1, 0, 0, 0),
      );
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      if (didAddWebNode == true) {
        setState(() {
          localObjectNode = newNode;
        });
      }
    }
  }
}
