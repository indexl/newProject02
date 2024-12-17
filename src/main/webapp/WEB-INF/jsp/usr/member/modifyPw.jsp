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

    <title>비밀번호 확인</title>

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
                                <h1 class="h4 text-gray-900 mb-4">비밀번호 확인</h1>
                            </div>
                            <form action="doModifyPw" method="post" onsubmit="modifyPwForm_onSubmit(this); return false;">
                                <div class="form-group">
                                    <input class="form-control form-control-user" type="password" name="loginPw" placeholder="변경할 비밀번호를 입력해주세요">
                                </div>
                                <div class="form-group">
                                    <input class="form-control form-control-user" type="password" name="loginPwChk" placeholder="비밀번호 확인을 입력해주세요">
                                </div>
                                <button type="submit" class="btn btn-primary btn-user btn-block">확인</button>
                            </form>
                            <div class="mt-4 text-center">
                                <button class="btn btn-secondary btn-sm" onclick="history.back();">뒤로가기</button>
                                <a class="btn btn-primary btn-sm" href="/usr/home/main">메인화면으로</a>
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
        const modifyPwForm_onSubmit = async function(form) {
            form.loginPw.value = form.loginPw.value.trim();
            form.loginPwChk.value = form.loginPwChk.value.trim();

            if (form.loginPw.value.length == 0) {
                alert('변경할 비밀번호를 입력해주세요');
                form.loginPw.focus();
                return;
            }

            if (form.loginPw.value != form.loginPwChk.value) {
                alert('비밀번호가 일치하지 않습니다');
                form.loginPw.value = '';
                form.loginPw.focus();
                return;
            }

            form.submit();
        }
    </script>

</body>
</html>