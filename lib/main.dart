import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ArCoreController arCoreController;
  ArCoreNode? node;

  @override
  void dispose() {
    super.dispose();
    arCoreController.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneDetected = _handleOnPlaneDetected;
  }

  _handleOnPlaneDetected(ArCorePlane plane) {
    if (node != null ){
      arCoreController.removeNode(nodeName: node!.name);
    }
    _addSphere(arCoreController, plane);
  }
  _addSphere(ArCoreController controller, ArCorePlane plane) {
    final ArCoreMaterial material = ArCoreMaterial(color:  Colors.red);
    final ArCoreSphere sphere = ArCoreSphere(materials: [material], radius: 0.1);
    node = ArCoreNode(
      name: 'sphere',
      shape: sphere,
      position: plane.centerPose?.translation,
      rotation: plane.centerPose?.rotation
    );
    controller.addArCoreNode(node!);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableUpdateListener: true,
        ),
      ),
    );
  }
}
