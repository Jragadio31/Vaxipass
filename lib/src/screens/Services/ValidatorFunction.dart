
class ValidatorFunction{
  final action;
  ValidatorFunction(this.action);

  String validate(value){
    if(action == 'email') return validateEmail(value);
    if(action == 'password') return validatePassword(value);
    if(action == 'firstname') return validateFirstName(value);
    if(action == 'lastname') return validateLastName(value);
    if(action == 'address') return validateAddress(value);
    if(action == 'brandname') return validateBrandName(value);
    if(action == 'brandnumber') return validateBrandNumber(value);
    if(action == 'physician') return validatePhysician(value);
    if(action == 'placevaccined') return validatePlaceVaccined(value);
    if(action == 'licensenumber') return validateLicenseNumber(value);
    if(action == 'manufacturer') return validateManufacturer(value);
    return null;
  }
  
  String validateEmail(value){
    if (value.isEmpty) return 'Email is Required';
      if (!RegExp( r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
          return 'Please enter a valid email Address';
      }
    return null;
  }

  String validatePassword(value){
      if (value.isEmpty) return 'Password is Required';
      return null;
  }
  
  String validateLastName(value){
    if (value.isEmpty) return 'Last Name is Required';
    if(value.length < 2) return 'Last name should contain atleast 2 letters';
    return null;
  }

  String validateFirstName(value){
    if (value.isEmpty) return 'First Name is Required';
    if(value.length < 4) return 'First name should contain atleast 4 letters';
    return null;
  }

  String validateAddress(value){
    if (value.isEmpty) return 'Address is Required';
    if(value.length < 4) return 'Address should contain atleast 10 letters';
    return null;
  }

  String validateBrandName(value){
    if (value.isEmpty) return 'Brand Name is Required';
    if(value.length < 4) return 'Brand name should contain atleast 4 letters';
    return null;
  }

  String validateBrandNumber(value){
    if (value.isEmpty) return 'Brand No. is Required';
    if(value.length < 4) return 'Brand number should contain atleast 4 digit';
    return null;
  }

  String validatePhysician(value){
    if (value.isEmpty) return 'Physician/Nurse Name is Required';
    if(value.length < 2) return 'Physician name should contain atleast 2 letter';
    return null;
  }

  String validatePlaceVaccined(value){
    if (value.isEmpty) return 'Place of Vaccination is Required';
    if(value.length < 8) return 'Hospital/Health center name should contain atleast 8 letters';
    return null;
  }

  String validateLicenseNumber(value){
    if (value.isEmpty) return 'License No. is Required';
    if(value.length < 5) return 'License number should contain atleast 5 digits';
    return null;
  }

  String validateManufacturer(value){
    if (value.isEmpty) return 'Manufacturer Brand is Required';
    if(value.length < 5) return 'Manufacturer Brand should contain atleast 5 letters';
    return null;
  }
}