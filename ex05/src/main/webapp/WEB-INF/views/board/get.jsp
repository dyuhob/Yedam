<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Board Read Page</div>
			<!--  /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label><input class="form-control" name="bno"
						value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Title</label><input class="form-control" name="title"
						value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" row="3" name="content"
						readonly="readonly">
						<c:out value="${board.content }" /></textarea>
				</div>
				<div class="form-group">
					<label>Writer</label><input class="form-control" name="writer"
						value='<c:out value="${board.writer }"/>' readonly="readonly">
				</div>

				<button data-oper="modify" class="btn btn-default">Modify</button>
				<button data-oper="list" class="btn btn-info">List</button>
				<form id='operForm' action='/board/modify' method='get'>
					<input type="hidden" id="bno" name="bno"
						value='<c:out value="${board.bno }" />'> <input
						type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum }" />'> <input
						type="hidden" name="amount"
						value='<c:out value="${cri.amount }" />'> <input
						type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
					<input type="hidden" name="keyword"
						value='<c:out value="${cri.keyword }"/>'>
				</form>


			</div>
			<!-- end panel-body -->
			</div>
			
		<!-- end panel-body -->

	</div>
	<!-- end panel -->

</div>

<!--  댓글 부분 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New
					Reply</button>
			</div>

			<!-- panel-heading -->
			<div class="panel-heading">
				<ul class="chat">
					<!-- start reply -->
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong> <small
									class="pull-right text-muted">2018-01-01 13:13</small>
							</div>
							<p>Good job!</p>
						</div>
					</li>
					<!-- end reply -->
				</ul>
				<!-- ./ end ul-->
			</div>
			<!-- /.panel .chat-panel-->
			<div class="panel-footer">
				<!--  댓글 페이징 -->
		</div>
		</div>
	</div>
	<!-- ./ end row -->
</div>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label> <input class="form-control" name="reply"
						value="New Reply!!">
				</div>
				<div class="form-group">
					<label>Replyer</label> <input class="form-control" name="replyer"
						value="replyer">
				</div>
				<div class="form-group">
					<label>Reply Date</label> <input class="form-control"
						name="replyDate" value="">
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-default">Register</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default"
					data-dismiss="modal">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
	var bnoVal = '<c:out value="${board.bno}"/>';

	$(document)
			.ready(
					function() {
						var operForm = $('#operForm');

						$('button[data-oper="modify"]').on('click', function() {
							operForm.attr('action', '/board/modify').submit();
						})

						$('button[data-oper="list"]').on('click', function() {
							operForm.find('#bno').remove(); // input 삭제.
							operForm.attr('action', '/board/list').submit();
						})

						showList(1);

						// 댓글 목록
						function showList(page) {
							replyService.getList({
								bno : bnoVal,
								page : page
								},
								function(replyCnt, list) {
										console.log(list)
										console.log(replyCnt)
										// 마지막 페이지를 보고 싶으면 -1을 매개값으로 사용.
										if(page == -1){
											pageNum = Math.ceil(replyCnt/ 10.0);
											showList(pageNum)
											return;
										}
										
										var str = '';
										if(list == null || list.length == 0){
											return;
										}
										for (var i = 0; i < list.length; i++) {
											str += '<li class="left clearfix" data-rno="' + list[i].rno + '">';
											str += ' <div><div class="header"><strong class="primary-font">'
													+ list[i].replyer
													+ '</strong>';
											str += '  <small class="pull-right text-muted">'
													+ replyService
															.displayTime(list[i].replyDate)
													+ '</small></div>';
											str += '   <p>'
													+ list[i].reply
													+ '</p></div></li>'
										}
										$('ul.chat').html(str);
										showReplyPage(replyCnt); // 페이징.
									}, function() {

									})		
						}
						
						// 댓글 등록 & 모달 창
						var modal = $(".modal");
						var modalInputReply = modal.find("input[name='reply']");
						var modalInputReplyer = modal.find("input[name='replyer']");
						var modalInputReplyDate = modal.find("input[name='replyDate']");
						
						var modalModBtn = $('#modalModBtn');
						var modalRemoveBtn = $('#modalRemoveBtn');
						var modalRegisterBtn = $('#modalRegisterBtn');
						
						$("#addReplyBtn").on('click', function(e){
							modal.find('input').val('');
							modalInputReplyDate.closest("div").hide();
							modal.find("button[id !='modalCloseBtn']").hide();
							
							modalRegisterBtn.show();
							
							$(".modal").modal("show");
						})
						
						modalRegisterBtn.on("click", function(e){
							var reply = {
									reply : modalInputReply.val(),
									replyer : modalInputReplyer.val(),
									bno : bnoVal
							};
							replyService.add(reply, function(result){
								
								alert(result);
								
								modal.find("input").val("");
								modal.modal("hide");
								
								showList(1);
							})
						})
						
						//댓글부분을 클릭하면 모달창(수정, 삭제용도);
						// page가 처음 로딩되면서 생성되어진 dom 요소가 추가된 경우엔
						// 상위요소 (ul.chat)
						$('.chat').on('click', 'li', function(){
							var rno = $(this).data('rno'); //data-rno="12"
							
							replyService.get(rno, function(reply){
								// 댓글, 작성자, 댓글작성일시
								modalInputReply.val(reply.reply);
								modalInputReplyer.val(reply.replyer);
								modalInputReplyDate.val(replyService.displayTime(reply.replyDate));
								modalInputReplyDate.attr('readonly', "readonly")
								modal.data('rno', reply.rno);
								
								modalRegisterBtn.hide();
								
								$('#myModal').modal('show');
							}, function() {
								console.log('error occurred')
							})
						})
						
						modalRemoveBtn.on("click", function(e){
							
							replyService.remove(modal.data('rno'), function(result){
								alert(result)
								modal.modal("hide")
								showList(1)
							}, function(){
								
							})
						})
						
						modalModBtn.on("click", function(e){
							
							var replyInfo = {
								reply : modalInputReply.val(),
								rno : modal.data("rno"),
							}
							
							replyService.update(replyInfo, function(result){
								alert(result);
								modal.modal("hide")
								showList(1)
							}, function(){
								
							})
						})
					// 댓글페이징.
					
					var pageNum = 1;
					var replyPageFooter = $('.panel-footer');
					
					// 댓글생성
					
					function showReplyPage(replyCnt){
						
						var endNum = Math.ceil(pageNum / 10.0) * 10; // 마지막 페이지
						var startNum = endNum - 9;
						var prev = startNum != 1;
						var next = false;
						
						if(endNum * 10 > replyCnt ){
							endNum = Math.ceil(replyCnt / 10.0); // 전체건수를 활용한 마지막 페이지
						}
						
						if(endNum * 10 < replyCnt){
							next = true;	
						}
						
						//페이지 생성
						var str = '<ul class="pagination pull-right">';
						if(prev){
							str += '<li class="page-item"><a class="page-link" href="'+(startNum -1)+'">Previous</a></li>';
						}
						for (var i = startNum; i<= endNum; i++){
							var active = pageNum == i ? "active" : "";
							str += '<li class="page-item ' + active + ' "><a class="page-link" href="' + i + '">' + i + '</a></li>';
						}
						if(next){
							str += '<li class="page-item"><a class="page-link" href="' + (endNum + 1) + '">Next</a></li>';
						}
						str += '</ul></div>';
						
						replyPageFooter.html(str);
					}
					// 댓글링크
					replyPageFooter.on('click', "li a", function(e){
						e.preventDefault();
						
						var targetPageNum = $(this).attr("href");

						showList(targetPageNum);
					})
					
					})
</script>
<%@include file="../includes/footer.jsp"%>