<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>회원가입</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        .bg-gradient-primary {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 0;
        }
        .card {
            max-width: 600px;
            width: 100%;
        }
    </style>
</head>

<body class="bg-gradient-primary">

    <div class="container">

        <div class="card o-hidden border-0 shadow-lg mx-auto">
            <div class="card-body p-0">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4">회원가입</h1>
                            </div>
                            <form action="doJoin" method="post" onsubmit="joinForm_onSubmit(this); return false;">
                                <div class="form-group">
                                    <input type="text" class="form-control form-control-user" name="loginId"
                                           placeholder="아이디" onblur="loginIdDupChk(this);">
                                    <div id="loginIdDupChkMsg" class="mt-2 text-sm h-5"></div>
                                </div>
                                <div class="form-group">
                                    <input type="password" class="form-control form-control-user" name="loginPw"
                                           placeholder="비밀번호">
                                </div>
                                <div class="form-group">
                                    <input type="password" class="form-control form-control-user" name="pwChk"
                                           placeholder="비밀번호 확인">
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control form-control-user" name="name"
                                           placeholder="이름">
                                </div>
                                <button type="submit" class="btn btn-primary btn-user btn-block">가입하기</button>
                            </form>
                            <hr>
                            <div class="text-center">
                                <a class="small" href="/usr/member/login">이미 계정이 있으신가요? 로그인하기</a>
                            </div>
                            <div class="text-center">
                                <a class="small" href="/usr/home/main">메인화면으로</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="/js/sb-admin-2.min.js"></script>

    <script>
       let validLoginId = null;

       const joinForm_onSubmit = function(form) {
          form.loginId.value = form.loginId.value.trim();
          form.loginPw.value = form.loginPw.value.trim();
          form.pwChk.value = form.pwChk.value.trim();
          form.name.value = form.name.value.trim();
          
          if (form.loginId.value.length == 0) {
             alert('아이디를 입력해주세요');
             form.loginId.focus();
             return;
          }
          
          if (form.loginId.value != validLoginId) {
             alert('[ ' + form.loginId.value + ' ] 은(는) 사용할 수 없는 아이디입니다');
             form.loginId.value = '';
             form.loginId.focus();
             return;
          }
          
          if (form.loginPw.value.length == 0) {
             alert('비밀번호를 입력해주세요');
             form.loginPw.focus();
             return;
          }
          
          if (form.name.value.length == 0) {
             alert('이름을 입력해주세요');
             form.name.focus();
             return;
          }
          
          if (form.loginPw.value != form.pwChk.value) {
             alert('비밀번호가 일치하지 않습니다');
             form.loginPw.value = '';
             form.pwChk.value = '';
             form.loginPw.focus();
             return;
          }
          
          form.submit();
       }
       
       const loginIdDupChk = function(el) {
          el.value = el.value.trim();
          
          let loginIdDupChkMsg = $('#loginIdDupChkMsg');
          
          if (el.value.length == 0) {
             loginIdDupChkMsg.removeClass('text-success');
             loginIdDupChkMsg.addClass('text-danger');
             loginIdDupChkMsg.html('<span>아이디는 필수 입력 정보입니다</span>');
             return;
          }
          
          $.ajax({
             url : '/usr/member/loginIdDupChk',
             type : 'GET',
             data : {
                loginId : el.value
             },
             dataType : 'json',
             success : function(data) {
                if (data.success) {
                   loginIdDupChkMsg.removeClass('text-danger');
                   loginIdDupChkMsg.addClass('text-success');
                   loginIdDupChkMsg.html('<span>' + data.resultMsg + '</span>');
                   validLoginId = el.value;
                } else {
                   loginIdDupChkMsg.removeClass('text-success');
                   loginIdDupChkMsg.addClass('text-danger');
                   loginIdDupChkMsg.html('<span>' + data.resultMsg + '</span>');
                   validLoginId = null;
                }
             },
             error : function(xhr, status, error) {
                console.log(error);
             }
          });
       }
    </script>
</body>
</html>