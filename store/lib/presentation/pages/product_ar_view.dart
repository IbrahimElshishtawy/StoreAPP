import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin_2.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class ARProductView extends StatefulWidget {
  final String modelUrl;
  const ARProductView({super.key, required this.modelUrl});

  @override
  State<ARProductView> createState() => _ARProductViewState();
}

class _ARProductViewState extends State<ARProductView> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR View')),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          showWorldOrigin: true,
          handleTaps: true,
        );
    this.arObjectManager!.onInitialize();
  }

  Future<void> onAddNode() async {
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri: widget.modelUrl,
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0, 0, -1));
    bool? didAddWebNode = await arObjectManager!.addNode(newNode);
  }
}
