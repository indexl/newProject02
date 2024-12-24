<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<c:set var="pageTitle" value="${board.getName()} 게시판" />

<style>
 body { 
            margin: 0; 
            padding: 20px; 
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
            min-height: 100vh;
        }
</style>

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <h4 class="mb-0">${board.getName()}</h4>
          <small class="text-muted">총 : ${articlesCnt}개</small>
        </div>
        <div class="card-body">
          <div class="mb-3">
            <input type="text" class="form-control" id="searchInput" placeholder="검색어를 입력하세요">
          </div>
          <table class="table table-hover">
            <thead>
              <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
              </tr>
            </thead>
            <tbody id="articleTableBody">
              <c:forEach var="article" items="${articles}">
                <tr>
                  <td>${article.getId()}</td>
                  <td><a href="detail?id=${article.getId()}">${article.getTitle()}</a></td>
                  <td>${article.getLoginId()}</td>
                  <td>${article.getRegDate().substring(2,16)}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <c:if test="${rq.getLoginedMemberId() != -1}">
            <div class="text-end">
              <a class="btn btn-primary btn-sm" href="write">글쓰기</a>
            </div>
          </c:if>
          <nav>
            <ul class="pagination justify-content-center">
              <c:set var="path" value="?boardId=${board.getId()}" />
              <c:if test="${from != 1}">
                <li class="page-item"><a class="page-link" href="${path}&cPage=1"><i class="fas fa-angle-double-left"></i></a></li>
                <li class="page-item"><a class="page-link" href="${path}&cPage=${from - 1}"><i class="fas fa-angle-left"></i></a></li>
              </c:if>
              <c:forEach var="i" begin="${from}" end="${end}">
                <li class="page-item ${cPage == i ? 'active' : ''}"><a class="page-link" href="${path}&cPage=${i}">${i}</a></li>
              </c:forEach>
              <c:if test="${end != totalPagesCnt}">
                <li class="page-item"><a class="page-link" href="${path}&cPage=${end + 1}"><i class="fas fa-angle-right"></i></a></li>
                <li class="page-item"><a class="page-link" href="${path}&cPage=${totalPagesCnt}"><i class="fas fa-angle-double-right"></i></a></li>
              </c:if>
            </ul>
          </nav>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  document.getElementById('searchInput').addEventListener('input', function() {
    var searchText = this.value.toLowerCase();
    var rows = document.getElementById('articleTableBody').getElementsByTagName('tr');
    
    for (var i = 0; i < rows.length; i++) {
      var title = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
      
      if (title.includes(searchText)) {
        rows[i].style.display = '';
      } else {
        rows[i].style.display = 'none';
      }
    }
  });
</script>