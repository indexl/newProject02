<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
       body { 
            margin: 0; 
            padding: 20px; 
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
            min-height: 100vh;
        }
        .detail-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 50px;
        }
        .table-detail {
            margin-bottom: 20px;
        }
        .table-detail th {
            background-color: #f8f9fa;
            width: 20%;
        }
        .comment-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        .comment-item {
            border-bottom: 1px solid #e9ecef;
            padding: 10px 0;
        }
        .dropdown-menu {
            min-width: 100px;
        }
        .comment-form {
            margin-top: 20px;
        }
        textarea {
            resize: none;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10 detail-container">
                <!-- 게시글 상세 정보 테이블 -->
                <table class="table table-bordered table-detail">
                    <tr>
                        <th>번호</th>
                        <td>${article.getId()}</td>
                    </tr>
                    <tr>
                        <th>작성일</th>
                        <td>${article.getRegDate().substring(2, 16)}</td>
                    </tr>
                    <tr>
                        <th>수정일</th>
                        <td>${article.getUpdateDate().substring(2, 16)}</td>
                    </tr>
                    <tr>
                        <th>조회수</th>
                        <td>${article.getViews()}</td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td>${article.getLoginId()}</td>
                    </tr>
                    <tr>
                        <th>제목</th>
                        <td>${article.getTitle()}</td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td>${article.getBody()}</td>
                    </tr>
                </table>

                <!-- 버튼 영역 -->
              <!-- 버튼 영역 -->
					<div class="d-flex justify-content-between align-items-center mb-4">
					    <button class="btn btn-secondary" onclick="history.back();">뒤로가기</button>
					    <c:if test="${rq.getLoginedMemberId() == article.getMemberId()}">
					        <div>
					            <a class="btn btn-primary me-2" href="modify?id=${article.getId()}">수정</a>
					            <a class="btn btn-danger me-2" 
					               onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" 
					               href="doDelete?id=${article.getId()}&boardId=${article.getBoardId()}">삭제</a>
					        </div>
					    </c:if>
					</div>


                <!-- 댓글 섹션 -->
                <div class="comment-section">
                    <c:if test="${not empty replies}">
                        <h5 class="fw-semibold mb-4">댓글</h5>
                        <div class="comments-container">
                            <c:forEach var="reply" items="${replies}">
                                <div id="${reply.getId()}" class="comment-item">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="fw-semibold">${reply.getLoginId()}</div>
                                        <c:if test="${rq.getLoginedMemberId() == reply.memberId}">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                        type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><button class="dropdown-item" 
                                                        onclick="replyModifyForm(${reply.getId()}, '${reply.getBody()}');">수정</button></li>
                                                    <li><a class="dropdown-item" 
                                                        onclick="return confirm('정말 삭제하시겠습니까?');" 
                                                        href="/usr/reply/doDelete?id=${reply.getId()}&relId=${article.getId()}">삭제</a></li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="mb-1">${reply.getForPrintBody()}</div>
                                    <small class="text-muted">${reply.getRegDate()}</small>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- 댓글 작성 폼 -->
                    <c:if test="${rq.getLoginedMemberId() != -1}">
                        <form action="/usr/reply/doWrite" method="post" 
                              onsubmit="return replyForm_onSubmit(this);" class="comment-form">
                            <input type="hidden" name="relTypeCode" value="article" />
                            <input type="hidden" name="relId" value="${article.getId()}" />
                            <div class="border rounded-xl p-4">
                                <div id="loginedMemberLoginId" class="mb-2 fw-semibold"></div>
                                <textarea class="form-control" name="body" 
                                          placeholder="댓글을 작성하세요..."></textarea>
                                <div class="d-flex justify-content-end mt-2">
                                    <button class="btn btn-primary">작성</button>
                                </div>
                            </div>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 로그인 사용자 정보 가져오기
        $(document).ready(function() {
            if (${rq.getLoginedMemberId() != -1}) {
                getLoginId();
            }
        });
        
        function getLoginId() {
            $.ajax({
                url: '/usr/member/getLoginId',
                type: 'GET',
                dataType: 'text',
                success: function(data) {
                    $('#loginedMemberLoginId').html(data);
                },
                error: function(xhr, status, error) {
                    console.log(error);
                }
            });
        }
        
        // 댓글 수정 관련 변수와 함수들
        let originalForm = null;
        let originalId = null;
        
        function replyModifyForm(id, body) {
            if (originalForm != null) {
                replyModifyCancle(originalId);
            }
            
            let replyForm = $('#' + id);
            originalForm = replyForm.html();
            originalId = id;
            
            let addHtml = `
                <form action="/usr/reply/doModify" method="post" onsubmit="return replyForm_onSubmit(this);">
                    <input type="hidden" name="id" value="${id}" />
                    <input type="hidden" name="relId" value="${article.getId()}" />
                    <div class="border rounded-xl p-4 mt-2">
                        <div id="loginedMemberLoginId" class="mb-2 fw-semibold"></div>
                        <textarea class="form-control" name="body">${body}</textarea>
                        <div class="d-flex justify-content-end mt-2">
                            <button type="button" class="btn btn-secondary me-2" 
                                    onclick="replyModifyCancle(${id});">취소</button>
                            <button class="btn btn-primary">수정</button>
                        </div>
                    </div>
                </form>`;
            
            replyForm.html(addHtml);
            getLoginId();
        }
        
        function replyModifyCancle(id) {
            let replyForm = $('#' + id);
            replyForm.html(originalForm);
            originalForm = null;
            originalId = null;
        }
        
        function replyForm_onSubmit(form) {
            form.body.value = form.body.value.trim();
            
            if (form.body.value.length == 0) {
                alert('내용이 없는 댓글은 작성할 수 없습니다');
                form.body.focus();
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>