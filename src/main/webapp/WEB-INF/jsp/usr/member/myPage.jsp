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

    <title>회원 정보</title>

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
                                <h1 class="h4 text-gray-900 mb-4">회원 정보</h1>
                            </div>
                            <table class="table table-striped">
                                <tr>
                                    <th>가입날짜</th>
                                    <td>${member.getRegDate().substring(0, 16)}</td>
                                </tr>
                                <tr>
                                    <th>수정날짜</th>
                                    <td>${member.getUpdateDate().substring(0, 16)}</td>
                                </tr>
                                <tr>
                                    <th>ID</th>
                                    <td>${member.getLoginId()}</td>
                                </tr>
                                <tr>
                                    <th>성명</th>
                                    <td>${member.getName()}</td>
                                </tr>
                            </table>
                            <div class="mt-4 text-center">
                                <button class="btn btn-secondary btn-sm" onclick="history.back();">뒤로가기</button>
           						<a class="btn btn-primary btn-sm" href="/usr/home/main">메인화면으로</a>    						
                                <a class="btn btn-primary btn-sm" href="checkPw">회원정보수정</a>
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

</body>
</html>