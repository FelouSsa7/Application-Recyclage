import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nadif/screens/liste_des_annonces.dart';
import 'package:provider/provider.dart';
import '../controller/location_controller.dart';
import '../modal/annonce_model.dart';
import '../provider/provider_auth.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';

class Annonce extends StatefulWidget {
  const Annonce({Key? key}) : super(key: key);

  @override
  State<Annonce> createState() => _AnnonceState();
}

class _AnnonceState extends State<Annonce> {
  LocationController currentlocationController = LocationController();
  File? image;
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  String? valueChoose;
  List ListItem = ['Plastique', 'Métal', 'Bois', 'Carton'];

  String? dropDownValue;
  AnnonceModel annonceModel = AnnonceModel(annonceId: '');

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vous pouver créer votre annoce ici",
            style: TextStyle(fontSize: 15.0),
          ),
          backgroundColor: Colors.greenAccent,
        ),
        body: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                backgroundImage: NetworkImage(
                                  ap.userModal.profilePic,
                                ),
                                radius: 50.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              children: [
                                Text(
                                  ap.userModal.name!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Text(
                                  'Annonce sur notre Marketplace',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.tealAccent),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      selectImage();
                                    },
                                    child: image == null
                                        ? const CircleAvatar(
                                            radius: 30.0,
                                            backgroundColor: Colors.greenAccent,
                                            child: Icon(
                                              Icons.add_shopping_cart,
                                              size: 50.00,
                                              color: Colors.white,
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: FileImage(image!),
                                            radius: 50.0,
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const Text("Ajouter une photo"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            DropdownButton(
                              hint:
                                  const Text('Choisir votre type de déchets :'),
                              value: valueChoose,
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoose = newValue! as String?;
                                  annonceModel.dechetType = newValue
                                      as String?; // update the selected Option field
                                });
                              },
                              items: ListItem.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            textField(
                                hintText: 'Description',
                                icon: Icons.description,
                                inputType: TextInputType.name,
                                controller: descriptionController),
                            textField(
                                hintText: 'Localisation',
                                icon: Icons.location_on,
                                inputType: TextInputType.name,
                                controller: locationController),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width,
                                child: CustomButton(
                                    text: 'Créer Annonce',
                                    onPressed: () {
                                      storeData();
                                    })),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget textField(
      {required String hintText,
      required IconData icon,
      required TextInputType inputType,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        cursorColor: Colors.greenAccent,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.greenAccent.shade100,
          filled: true,
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final currentLocation =
        await currentlocationController.getProviderLocation();
    print('Current Location: ${currentlocationController.currentLocation}');
    AnnonceModel annonceModel = AnnonceModel(
        description: descriptionController.text.trim(),
        currentLocation: currentLocation,
        location: locationController.text.trim(),
        dechetType: valueChoose,
        annonceId: "",
        productPic: "");

    if (annonceModel.dechetType == null) {
      // show error message or set default value for selectedOption
      return print("error submit");
    }

    if (image != null) {
      ap.saveAnnonceDataToFirebase(
        context: context,
        locationController: currentlocationController,
        annonceModel: annonceModel,
        productPic: image!,
        onSuccess: () {
          ap.saveAnnonceDataToSP().then(
                (value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnnonceListe(
                              annonce: annonceModel,
                            )),
                    (route) => false),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your product pic");
    }
  }
}
