<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>버스정류장 시스템</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        /* 사이드바와 본문 영역이 겹치지 않게 하기 위한 스타일 */
        #wrapper {
            display: flex;
        }

        #accordionSidebar {
            position: fixed;
            width: 250px;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 1050;
        }

        .content-wrapper {
            margin-left: 250px; /* 사이드바 크기만큼 왼쪽 여백 추가 */
            width: 100%;
            padding: 20px;
        }
    </style>
</head>

<body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

            <!-- Sidebar - Brand -->
            <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/usr/home/main">
                <div class="sidebar-brand-icon rotate-n-15">
                    <i class="fas fa-laugh-wink"></i>
                </div>
                <div class="sidebar-brand-text mx-3">정류장 <sup> 시스템</sup></div>
            </a>

            <!-- Divider -->
            <hr class="sidebar-divider my-0">

            <!-- Nav Item - Dashboard -->
            <li class="nav-item active">
                <a class="nav-link" href="">
                    <i class="fas fa-fw fa-tachometer-alt"></i>
                    <span>정류장 시스템이란?</span></a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Heading -->
            <div class="sidebar-heading">
                관련게시판
            </div>

            <!-- Nav Item - Pages Collapse Menu -->
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTwo"
                    aria-expanded="true" aria-controls="collapseTwo">
                    <i class="fas fa-fw fa-cog"></i>
                    <span>게시판</span>
                </a>
                <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">게시판</h6>
                        <a class="collapse-item" href="/usr/article/list?boardId=1">공지사항</a>
                        <a class="collapse-item" href="/usr/article/list?boardId=2">문의하기</a>
                    </div>
                </div>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">
            
      
            <!-- Heading -->
            <div class="sidebar-heading">
                승차장 시스템
            </div>

       

            <!-- Nav Item - Charts -->
            <li class="nav-item">
                <a class="nav-link" href="/usr/api/map1">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>map1 위도,경도search(개발용)</span></a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="/usr/api/map2">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>주소 뷰</span></a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="/usr/api/map3">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>QR코드 위치확인</span></a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="/usr/api/map4">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>대전버스</span></a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="/usr/api/map5">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>메세지 전송</span></a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link" href="/usr/api/capture">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>캡쳐모드</span></a>
            </li>

            <!-- Nav Item - Tables -->
            <c:if test="${rq.getLoginedMemberId() == -1 }">
                <!-- If the user is not logged in, show JOIN and LOGIN links -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/usr/member/join">
                        <i class="fas fa-fw fa-table"></i>
                        <span>회원가입</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/usr/member/login">
                        <i class="fas fa-fw fa-table"></i>
                        <span>로그인</span>
                    </a>
                </li>

            </c:if>

            <c:if test="${rq.getLoginedMemberId() != -1 }">
                <!-- If the user is logged in, show MYPAGE and LOGOUT links -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/usr/member/myPage">
                        <i class="fas fa-fw fa-table"></i>
                        <span>마이페이지</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/usr/member/doLogout">
                        <i class="fas fa-fw fa-table"></i>
                        <span>로그아웃</span>
                    </a>
                </li>
            </c:if>

            <!-- Divider -->
            <hr class="sidebar-divider d-none d-md-block">

			 <!-- Sidebar Toggler (Sidebar) -->
            <div class="text-center d-none d-md-inline">
                <button class="rounded-circle border-0" id="sidebarToggle"></button>
            </div>
           
        </ul>
        
        <!-- Main Content Wrapper -->
        <div class="content-wrapper">
            <!-- 여기에 다른 페이지 내용이 들어갑니다. -->
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