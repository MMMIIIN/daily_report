String setErrorMessage(String error) {
  var errorMessage;
  switch(error){
    case 'user-not-found':
      errorMessage = '해당 유저가 없습니다.';
      break;
    case 'wrong-password':
      errorMessage = '비밀번호가 틀립니다.';
      break;
    case 'email-already-in-use':
      errorMessage = '이미 존재하는 계정입니다.';
      break;
    case 'weak-password':
      errorMessage = '비밀번호가 너무 짧습니다.';
      break;
    case 'invalid-email':
      errorMessage = '이메일 형식이 아닙니다.';
      break;
    default:
      errorMessage = 'ERROR';
  }
  return errorMessage;
}