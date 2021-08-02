class Validators {

  static validate(value, type) {
    print(type);
    if (type == 'Email') {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value)) ? null : 'Enter a valid Email';
    } else if (type == 'Mobile Number') {
      String pattern = r'^([0|\+[0-9]{1,5})?([7-9][0-9]{9})$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value)) ? null : 'Enter a valid mobile Number';
    } else if (type == 'OTP') {
      String pattern = r'^[0-9]+$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value))
          ? (value.length < 4)
              ? 'Enter a valid OTP'
              : null
          : 'Enter a valid OTP';
    } else if (type == 'Flat Id') {
      return (value.length < 3) ? 'Enter a valid Flat Id' : null;
    } else if (type == 'CORE_LOGIN_USERNAMEs') {
      String pattern = r'^[A-Za-z ]+$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value))
          ? (value.length < 3)
              ? 'Enter a valid Name'
              : null
          : 'Enter a valid Name';
    }  else if (type == 'Password') {
      return (value.length < 8) ? 'Please provide  8 characters' : null;
    } else if (type == 'Old Password' ||
        type == 'New Password' ||
        type == 'Confirm Password')
      return (value.length < 8) ? 'Please provide  8 characters' : null;
  }

  static String? mobileNumberValidator(String? v) {
    if (v!.trim().isEmpty) {
      return 'Please enter Mobile number';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
      return 'Please enter Numbers only';
    } else if (v.trim().length != 10) {
      return 'Mobile number should be 10 digits';
    }
    return null;
  }

  static String? passwordComparision(String? val, String label, [String? val1]){
    if(val!.trim().isEmpty){
      return '$label';
    }else if(!(RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$').hasMatch(val))){
      return 'Invalid format';
    }else if(val1 != null && val.trim() != val1.trim()){
      return 'New Password and Confirm password should be same';
    }
    return null;
  }
}
