String getGenderFromKey(String genderKey) {
  if(genderKey!=null){
    if (genderKey.toLowerCase() == 'male') {
      return 'Male';
    } else if (genderKey.toLowerCase() == 'female') {
      return 'Female';
    } else {
      return '';
    }
  }
}
