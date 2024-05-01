class AppValidator {
    //contoh masukin email dak tau tepake ato ndk
  String? validateEmail(value){
    if(value!.isEmpty){
      return 'Isi email';
    }
    RegExp emailRegExp = RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegExp.hasMatch(value)){
      return 'Please enter a valid email';
    }
    return null;
  }

//contoh validasi phone number dk tau tepake ato ndk
  String? validatePhoneNumber(value){
    if(value!.isEmpty){
      return 'Isi phone number';
    }
    if(value.length != 10){
      return 'Please enter a 10-digit phone number';
    }
    return null;
  }

  String? validateUsename(value){
    if(value!.isEmpty){
      return 'Harus ada isi';
    }
    return null;
  }

  String? isEmptyCheck(value){
    if(value!.isEmpty){
      return 'Harus ada data';
    }
    return null;
  }
}